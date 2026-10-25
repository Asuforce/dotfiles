"""Add missing Codex defaults without rewriting machine-owned settings."""

import copy
import json
import re
import shlex
import shutil
import sys
import tomllib
from pathlib import Path


def value_toml(value):
    # Manifest values are JSON strings, booleans and arrays, also valid TOML.
    return json.dumps(value, ensure_ascii=True)


def tables(data, path=()):
    scalars = {key: value for key, value in data.items() if not isinstance(value, dict)}
    if scalars:
        yield path, scalars
    for key, value in data.items():
        if isinstance(value, dict):
            yield from tables(value, (*path, key))


def add_defaults(destination, defaults):
    original = destination.read_text() if destination.exists() else ""
    text = original
    expected = copy.deepcopy(tomllib.loads(original))
    defaults = copy.deepcopy(defaults)
    # A locally configured server may use another transport or credentials.
    for name in expected.get("mcp_servers", {}):
        defaults.get("mcp_servers", {}).pop(name, None)
    # Custom permission profiles replace legacy sandbox settings.
    if "default_permissions" in expected:
        defaults.pop("sandbox_mode", None)
        defaults.pop("sandbox_workspace_write", None)
    for path, values in tables(defaults):
        current = expected
        for part in path:
            current = current.setdefault(part, {})
        missing = {key: value for key, value in values.items() if key not in current}
        if not missing:
            continue
        assignments = "".join(f"{value_toml(key)} = {value_toml(value)}\n" for key, value in missing.items())
        if not path:
            text = assignments + text
        else:
            # Compare parsed table paths, accepting both quoted and bare keys.
            position = None
            for header in re.finditer(r"(?m)^\s*(\[[^\[\n][^\n]*\])[^\n]*\n?", text):
                try:
                    table = tomllib.loads(header.group(1))
                    for part in path:
                        table = table[part]
                    if table == {}:
                        position = header.end()
                        break
                except (KeyError, TypeError, tomllib.TOMLDecodeError):
                    continue
            if position is None:
                section = ".".join(value_toml(part) for part in path)
                text = text.rstrip() + f"\n\n[{section}]\n" + assignments
            else:
                text = text[:position] + "\n" + assignments + text[position:]
        current.update(missing)
    # Unusual TOML layouts fail before writing rather than risking lost settings.
    if tomllib.loads(text) != expected:
        raise ValueError(f"Could not preserve existing TOML in {destination}")
    if text != original:
        backup = destination.with_name(destination.name + ".pre-dotfiles.bak")
        if destination.exists() and not backup.exists():
            shutil.copy2(destination, backup)
        destination.write_text(text)
        print(f"Updated {destination}")


def mcp_defaults(manifest):
    servers = {}
    for name, server in json.loads(manifest.read_text())["mcpServers"].items():
        converted = {key: server[key] for key in ("command", "args", "env", "url") if server.get(key)}
        if server.get("disabled"):
            converted["enabled"] = False
        servers[name] = converted
    return {"mcp_servers": servers}


def install_title_hook(source, destination):
    hook_dir = destination / "hooks"
    hook_dir.mkdir(exist_ok=True)
    target = hook_dir / "codex-herdr-tab-title.py"
    if not target.exists() and not target.is_symlink():
        target.symlink_to((source / "hooks" / target.name).resolve())
    command = "python3 " + shlex.quote(str(target))
    path = destination / "hooks.json"
    original = path.read_text() if path.exists() else "{}"
    data = json.loads(original)
    hooks = data.setdefault("hooks", {})
    changed = False
    for event in ("SessionStart", "UserPromptSubmit", "Stop"):
        groups = hooks.setdefault(event, [])
        if any(h.get("command") == command for group in groups for h in group.get("hooks", [])):
            continue
        handler = {"type": "command", "command": command, "timeout": 60 if event == "Stop" else 10}
        group = {"hooks": [handler]}
        if event == "Stop":
            handler["async"] = True
        if event == "SessionStart":
            group["matcher"] = "^(startup|clear|fork)$"
        groups.append(group)
        changed = True
    if changed:
        backup = path.with_name(path.name + ".pre-dotfiles.bak")
        if path.exists() and not backup.exists():
            shutil.copy2(path, backup)
        path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n")
        print(f"Updated {path}")


def main():
    source, destination = map(Path, sys.argv[1:])
    defaults = tomllib.loads((source / "codex.toml").read_text())
    defaults.update(mcp_defaults(source / "mcps/default.json"))
    add_defaults(destination / "config.toml", defaults)
    for name in ("coding", "browser", "infra"):
        add_defaults(destination / f"{name}.config.toml", mcp_defaults(source / f"mcps/{name}.json"))
    install_title_hook(source, destination)


if __name__ == "__main__":
    main()
