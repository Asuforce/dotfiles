import { realpathSync } from "node:fs";
import { dirname, join } from "node:path";
import { pathToFileURL } from "node:url";

const modulePath = join(dirname(realpathSync(process.argv[2])), "auth.js");
const { getValidCredentials } = await import(pathToFileURL(modulePath));
const auth = await getValidCredentials();
if (!auth?.credentials?.refresh_token) {
  console.error("Authentication failed: no refresh token received.");
  process.exit(1);
}
console.error("Authentication complete.");
process.exit(0);
