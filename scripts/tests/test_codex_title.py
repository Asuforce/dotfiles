"""Exercise hook ownership, async races and non-destructive installation."""

import importlib.util
import io
import json
import os
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch


ROOT = Path(__file__).resolve().parents[2]


def load(name, path):
    spec = importlib.util.spec_from_file_location(name, ROOT / path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


title = load("title", "llm/hooks/codex-herdr-tab-title.py")
config = load("config", "scripts/codex-config.py")


class HookTest(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        env = patch.dict(os.environ, {
            "HERDR_ENV": "1", "HERDR_TAB_ID": "w1:t1", "HERDR_PANE_ID": "w1:p1",
            "XDG_STATE_HOME": self.temp.name, "HERDR_TITLE_GENERATING": "",
        })
        env.start()
        self.addCleanup(env.stop)
        self.label = "1"
        self.renames = []
        self.generator = patch.object(title, "generate", return_value="Codexのタブ名自動生成").start()
        patch.object(title, "herdr", side_effect=self.herdr).start()
        patch.object(title.shutil, "which", return_value="/bin/mock").start()
        self.addCleanup(patch.stopall)

    def herdr(self, command, tab, *args):
        if command == "get":
            return {"result": {"tab": {"label": self.label, "number": 1}}}
        self.label = args[0]
        self.renames.append(self.label)

    def event(self, kind, **kwargs):
        event = {"hook_event_name": kind, "session_id": "s1", "turn_id": "t1", **kwargs}
        with patch.object(title.sys, "stdin", io.StringIO(json.dumps(event))):
            title.main()

    def prompt(self, **kwargs):
        self.event("UserPromptSubmit", prompt="タブ名を会話から生成して", **kwargs)

    def stop(self, **kwargs):
        self.event("Stop", last_assistant_message="実装しました", **kwargs)

    def test_rename_and_duplicate_stop(self):
        self.prompt()
        self.stop()
        self.stop()
        self.assertEqual(self.renames, ["Codexのタブ名自動生成"])
        messages = self.generator.call_args.args[0]
        self.assertEqual([m["role"] for m in messages], ["user", "assistant"])

    def test_manual_and_other_pane_titles_are_kept(self):
        self.label = "手動タイトル"
        self.prompt()
        self.stop()
        self.generator.assert_not_called()
        self.label = "1"
        self.stop()
        self.prompt(turn_id="t2")
        with patch.dict(os.environ, {"HERDR_PANE_ID": "w1:p2"}):
            self.prompt(turn_id="t3")
            self.stop(turn_id="t3")
        self.assertEqual(len(self.renames), 1)

    def test_manual_rename_during_generation(self):
        def generate(*args):
            self.label = "手動で変更"
            return "生成タイトル"
        self.generator.side_effect = generate
        self.prompt()
        self.stop()
        self.assertEqual(self.renames, [])

    def test_new_turn_discards_inflight_generation(self):
        def generate(*args):
            self.prompt(turn_id="t2")
            return "古いタイトル"
        self.generator.side_effect = generate
        self.prompt()
        self.stop()
        self.assertEqual(self.renames, [])

    def test_clear_discards_inflight_generation(self):
        def generate(*args):
            self.event("SessionStart", source="clear", session_id="s2")
            return "古いタイトル"
        self.generator.side_effect = generate
        self.prompt()
        self.stop()
        self.assertEqual(self.renames, [])

    def test_clear_restores_number_but_protects_manual_title(self):
        self.prompt()
        self.stop()
        self.event("SessionStart", source="clear", session_id="s2")
        self.assertEqual(self.label, "1")
        self.label = "手動タイトル"
        self.event("SessionStart", source="clear", session_id="s3")
        self.assertEqual(self.label, "手動タイトル")

    def test_empty_result_and_foreign_session_do_not_rename(self):
        self.generator.return_value = ""
        self.prompt()
        self.stop(session_id="other")
        self.generator.assert_not_called()
        self.stop()
        self.assertEqual(self.renames, [])

    def test_recursive_call_is_ignored(self):
        with patch.dict(os.environ, {"HERDR_TITLE_GENERATING": "1"}):
            self.prompt()
            self.stop()
        self.generator.assert_not_called()


class InstallTest(unittest.TestCase):
    def test_install_preserves_existing_hooks_and_is_idempotent(self):
        with tempfile.TemporaryDirectory() as directory:
            destination = Path(directory)
            path = destination / "hooks.json"
            original = {"hooks": {"Stop": [{"hooks": [{"command": "existing-hook"}]}]}, "extra": 42}
            path.write_text(json.dumps(original))
            config.install_title_hook(ROOT / "llm", destination)
            once = path.read_text()
            config.install_title_hook(ROOT / "llm", destination)
            self.assertEqual(path.read_text(), once)
            data = json.loads(once)
            self.assertEqual(data["extra"], 42)
            self.assertEqual(data["hooks"]["Stop"][0], original["hooks"]["Stop"][0])
            self.assertTrue(data["hooks"]["Stop"][1]["hooks"][0]["async"])
            self.assertEqual(json.loads(path.with_name("hooks.json.pre-dotfiles.bak").read_text()), original)
            self.assertTrue((destination / "hooks/codex-herdr-tab-title.py").is_symlink())

    def test_generation_flags_and_title_limit(self):
        output = type("Result", (), {"stdout": '「' + 'あ' * 30 + '」'})()
        with patch.object(title.subprocess, "run", return_value=output) as run:
            label = title.generate([], "")
        self.assertEqual(label, 'あ' * 23 + '…')
        args = run.call_args.args[0]
        self.assertIn("--ignore-user-config", args)
        self.assertIn("hooks", args)
        self.assertEqual(run.call_args.kwargs["env"]["HERDR_TITLE_GENERATING"], "1")


if __name__ == "__main__":
    unittest.main()
