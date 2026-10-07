Hello from GitHub — a minimal cococo IaC module

Creates and publishes one custom app with a greeting and a click counter.
The Lua server API reads and increments an app-owned data container.
The count survives reloads and is shared by users of this app installation.
No integrations, external services, credentials, or build step are required.
This deliberately simple example uses read/modify/write: simultaneous clicks
from separate sessions can overwrite each other; it is not an atomic counter.

Inputs: name (default "Hello from GitHub"), handle (default "hello-github").
Output: app_id. Use a distinct handle for each installation in the same tenant.

After publishing this repository publicly, add this block to a consuming stack:

module "hello_github" {
  source = "github:wearecococo/iac-test-module"
  ref = "main"
  inputs = {}
}

Run from the consuming project, using its usual target and endpoint:

  cococo modules install .
  cococo check . --offline
  cococo plan .
  cococo apply .

Commit the generated cococo.modules.lock.json in the consuming project.
It pins the fetched commit; use `cococo modules update .` to pick up changes.
The installer currently fetches public HTTPS repositories only.
Unset COCOCO_TLS_NO_VERIFY and COCOCO_CA_CERT for module download; those
settings may still be needed separately for a local platform plan/apply.

The repository root is a module, not a deployable root stack. Install it
through a module block in another project. Keep published app versions
immutable; add a new custom_app_version and move publishedVersionId for updates.

The serverApi.test attachment runs with `cococo test` against the consuming
project schema and Lua test contracts. Four offline tests cover initial state,
persistence across API instances, read failures and write failures.
