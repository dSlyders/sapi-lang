# Sapi V1 - Changelog

## 1.0.7

- Replaced the previous migration interface with strict SQLx commands: `sapi migrate ...`.
- Available commands: `sapi migrate add`, `sapi migrate run`, `sapi migrate revert`, `sapi migrate info`.
- SQLx-aligned migration options: `--dry-run`, `--ignore-missing`, `--target-version`, `-r/--reversible`.
- Intentionally removed the `migration` alias to keep a single canonical command (`migrate`).
- Updated CLI help with SQLx documentation links and usage examples.
- Updated language documentation and Distribution README for the `migrate` workflow.

## 1.0.6

- Updated the public release while staying on `V1` (no `V2` creation for this patch).
- Added plugin commands to CLI:
  - `sapi plugin install`
  - `sapi plugin install-ai`
  - `sapi plugin reinstall`
  - `sapi plugin doctor`
  - `sapi plugin doctor --fix`
- Made VS Code plugin installation autonomous: plugin assets embedded in `sapi` binary.
- Expanded Copilot AI pack for Sapi: installation of 19 `.github` files (instructions + prompts) for development, architecture, security, runtime, SQL, testing, and production.
- Aligned binaries and documentation to version `1.0.6`.

## 1.0.5

- Kept public release on `V1` (removed `V2` from Distribution repository).
- Bumped CLI version to `1.0.5` (compiler source and related artifacts).
- Aligned editor/plugin version files to `1.0.5`.

## New Features

- **`sapi build --linux`** cross-compiles a static Linux musl x86_64 binary from Windows (requires `zig`, `cargo-zigbuild`, and target `x86_64-unknown-linux-musl`). Includes automatic preflight checks and clear error messages if prerequisites are missing.
- **`sapi build --win`** forces Windows build target (useful on Linux).
- **`sapi build`** now always compiles in release mode and outputs a deploy-ready standalone binary.
- **`sapi build --log <folder>`** copies the binary and creates `build.log` in the specified folder.
- **Optional file argument** - `sapi run`, `sapi watch`, `sapi build`, and `sapi doc` auto-detect `main.sapi` in the current directory if no file is specified.
- **`sapi watch`** writes artifacts into `%TEMP%` (invisible in workspace, like `sapi run`).
- **`sapi new <name>`** creates a new Sapi project with structure and example file.
- **Visible runtime process** - `sapi run` and `sapi watch` now start `sapi_server.exe` directly (instead of `cargo`), visible as-is in Task Manager.
- **if / else / else if** - conditional branches with operators `==`, `!=`, `>`, `<`, `>=`, `<=`.
- **SQL JSON errors** - query failures return `{"error":"sql_error","message":"..."}` and also log via `eprintln` on server side.
- **Hierarchical guard in `auth`** - support for inline `guard { key, guard_op/op, roles }` block in JWT Auth config.
- **Dynamic role priorities** - ranking key is configurable (`rank`, `weight`, `priority`, ...), compared via `guard_op` (`>=`, `>`, `==`, `<=`, `<`).
- **Super-role** - support for `super: true` to bypass level checks.
- **Short route syntax** - support for `guard "role"` in addition to `guard Auth "role"`.
- **New multi-role guard tests** - dedicated scenario validating hierarchy, super-role behavior, short syntax, and 401/403 compatibility.

## Fixes

- **CLI version aligned to SemVer** - `sapi -V` now reports `1.0.0` (official baseline).
- **No more hardcoded `0.1.0`** - OpenAPI version (`info.version`) and generated `Cargo.toml` version (`sapi_server`) now automatically follow `env!("CARGO_PKG_VERSION")`.
- **Version bump policy clarified** - standard updates use patch increments (`1.0.1`, `1.0.2`, ...).
- `sapi watch` no longer creates visible `.sapi_watch/` folder next to source file.
- Variables never reassigned are no longer emitted as `let mut` in generated code.
- Multi-return structs with camelCase fields no longer trigger Rust warnings.
- SQL results (MariaDB/MySQL) now decode VARCHAR columns correctly via `try_get_unchecked`.
- Tests now use `TRUNCATE TABLE` instead of `DELETE FROM` to reset AUTO_INCREMENT.
