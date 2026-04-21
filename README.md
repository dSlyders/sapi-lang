# Sapi Language

> **Sapi** (Slyders API) is a high-level language created by **dSlyders** to build modern REST APIs with minimal code. The compiler generates Rust (Axum + Tokio) from `.sapi` files.

Online documentation: https://dslyders.github.io/sapi-lang/

---

## Table of Contents

- [Why Sapi?](#why-sapi)
- [Windows Installation](#windows-installation)
- [Linux Installation](#linux-installation)
- [Create a Project](#create-a-project)
- [Basic Syntax](#basic-syntax)
- [Database](#database)
- [JWT Authentication](#jwt-authentication)
- [VS Code Extension](#vs-code-extension)
- [Build and Run](#build-and-run)
- [Documentation and GitHub Pages](#documentation-and-github-pages)
- [Project Governance](#project-governance)
- [Repository Structure](#repository-structure)

---

## Why Sapi?

Building a Rust API directly means handling Axum, Tokio, Serde, JSON typing, DB connections, and error handling. Sapi abstracts this into a simple and expressive language.

```sapi
service MyApi {
  port:    3000
  swagger: true
}

MyApi get "/hello" {
  return "Hello, World!"
}

MyApi post "/echo" {
  body json { string message }
  return { string echo = message }
}
```

This generates a complete Rust API with Swagger documentation without writing Rust manually.

---

## Windows Installation

### Requirements
- Windows 10 / 11
- [VS Code](https://code.visualstudio.com/) (recommended)

### Steps

1. Download the latest release from `V[n]/Install/windows/`
2. Run the installer: `sapi-install.exe`
3. Open a new terminal and verify:

```powershell
sapi --version
```

### Portable/manual fallback

If you only have `sapi.exe`, run:

```powershell
sapi install sapi --path "path\to\sapi.exe"
```

If `sapi` is not installed globally yet, run the downloaded binary directly:

```powershell
.\sapi.exe install sapi --path .\sapi.exe
```

### What the installer does
- Installs `sapi.exe` in `%LOCALAPPDATA%\Sapi\bin\`
- Adds `%LOCALAPPDATA%\Sapi\bin\` to the user **PATH**

### Verify installation (new terminal)

```powershell
sapi --version
```

---

## Linux Installation

### Requirements
- Ubuntu 20.04+ / Debian / any x86_64 distro

### Steps

1. Download the latest release from `V[n]/Install/linux/`
2. Run:

```bash
sapi install sapi --path /path/to/sapi
```

If `sapi` is not installed globally yet, run the downloaded binary directly:

```bash
./sapi install sapi --path ./sapi
```

### What the installer does
- Copies `sapi` to `~/.local/bin/sapi`
- Adds it to **PATH** in `.bashrc` / `.zshrc`

### Verify installation

```bash
source ~/.bashrc   # or open a new terminal
sapi --version
```

---

## Create a Project

```bash
sapi new my-api
cd my-api
```

This creates:

```
my-api/
├── main.sapi          ← your source
└── .vscode/
    ├── settings.json
    └── sapi.code-snippets
```

---

## Basic Syntax

### Service (HTTP server)

```sapi
service MyApi {
  port:    3000
  swagger: true
  cors:    true
  logging: "info"
}
```

### Routes

```sapi
// GET — returns text
MyApi get "/ping" {
  return "pong"
}

// POST — reads JSON body
MyApi post "/user" {
  body json { string name, int age }
  return 201: { string message = "Created", string user = name }
}

// Route parameter
MyApi get "/user/{id}" {
  route { int id }
  return { int userId = id }
}
```

### Available Types

| Type | Example |
|------|---------|
| `string` | `string name = "Alice"` |
| `int` | `int age = 30` |
| `float` | `float price = 9.99` |
| `bool` | `bool active = true` |
| `list:string` | `list:string tags = ["a", "b"]` |

### Variables and Interpolation

```sapi
string name = "Alice"
string msg = "Hello, {name}!"
return msg
```

### If / else

```sapi
MyApi get "/check/{value}" {
  route { int value }
  if value > 100 {
    return "high"
  } else if value > 50 {
    return "medium"
  } else {
    return "low"
  }
}
```

### Functions

```sapi
fn double(int n) {
  int result = n * 2
  return result
}

MyApi get "/double/{n}" {
  route { int n }
  int result = double(n)
  return result
}
```

---

## Database

```sapi
database DB {
  type: "postgres"
  host: env("DB_HOST")
  port: env("DB_PORT")
  user: env("DB_USER")
  pass: env("DB_PASS")
  name: "mydb"
}

sql getUser = `SELECT id, name FROM users WHERE id = {id}` : { int:id, string:name } use DB

MyApi get "/user/{id}" {
  route { int id }
  await User row = getUser({ id: id }).one()
  return { int id = row.id, string name = row.name }
}
```

---

## JWT Authentication

```sapi
auth Auth {
  secret:    env("JWT_SECRET")
  algorithm: "HS256"
  expiry:    3600
  claims:    { int userId, string role }
}

MyApi get "/profile" {
  guard Auth
  return "Authorized"
}

MyApi delete "/admin/user/{id}" {
  guard Auth "admin"
  route { int id }
  return { string message = "Deleted" }
}
```

---

## VS Code Extension

The **sapi-lang** extension provides:
- Full syntax highlighting (keywords, types, SQL, routes, interpolation)
- 38 completion snippets (`service`, `get`, `post`, `sql`, `await`, `guard`, `if`, `for`, ...)
- `//` and `///` comments
- Auto-closing braces, brackets, and parentheses

Files are in `Editor/`.

Reload VS Code:

```
Ctrl+Shift+P  →  Developer: Reload Window
```

---

## Build and Run

> Important (local dev): `sapi build`, `sapi run`, and `sapi watch` compile generated Rust code locally. Rust/Cargo is required on development machines.
>
> Quick install: https://rustup.rs
>
> In production, only the final `sapi_server` binary is required (not Rust, not Sapi).

```bash
# Create a project
sapi new my-api

# Build .sapi file
sapi build main.sapi

# Build to a specific folder
sapi build main.sapi my-output

# Run directly (build + run)
sapi run main.sapi

# Watch mode (auto rebuild/restart)
sapi watch main.sapi

# Install Rust/Cargo + C++ Build Tools + sqlx-cli (Windows)
sapi install rust

# Install everything in one command (CLI + Rust/C++)
sapi install all
sapi install all --path "path\\to\\sapi.exe"

# Add Linux cross-build prerequisites (zig, cargo-zigbuild, musl)
sapi install rust --linux
sapi install all --linux

# Generate HTML docs in ./docs
sapi doc main.sapi --html

# Generate docs into a custom folder
sapi doc main.sapi --html --output api-docs

# Create migration files (.up.sql + .down.sql)
sapi migrate add -r init_schema

# Run migrations
sapi migrate run

# Show migration status
sapi migrate info

# Revert last migration
sapi migrate revert

# Install VS Code extension from CLI assets
sapi plugin install

# Install Copilot instructions + skills
sapi plugin install-ai

# Install AI files into target dir and overwrite existing
sapi plugin install-ai --dir my-api --force

# Reinstall extension cleanly
sapi plugin reinstall

# Diagnose extension install
sapi plugin doctor

# Diagnose + auto-fix
sapi plugin doctor --fix
```

---

## Documentation and GitHub Pages

Language documentation source:

- `C:\SAPI\LANGUAGE.html`

Published in this repository:

- `V[n]/Documentation/sapi.html` for active release docs
- `docs/index.html` for GitHub Pages

Expected GitHub Pages URL:

- https://dslyders.github.io/sapi-lang/

Automatic workflow:

- `.github/workflows/deploy-docs-pages.yml`
- Triggered on every push to `main` that changes `docs/**`

Quick manual update (Windows PowerShell):

```powershell
$distRoot = "C:\SAPI\Distribution"
$latestV  = Get-ChildItem $distRoot -Directory -Filter "V*" |
            Where-Object { $_.Name -match '^V(\d+)$' } |
            Sort-Object { [int]($_.Name -replace 'V','') } |
            Select-Object -Last 1

Copy-Item -Force "C:\SAPI\LANGUAGE.html" "$($latestV.FullName)\Documentation\sapi.html"
Copy-Item -Force "C:\SAPI\LANGUAGE.html" "C:\SAPI\Distribution\docs\index.html"
```

---

## Project Governance

- License: `LICENSE` (MIT)
- Security: `SECURITY.md`
- Contributing: `CONTRIBUTING.md`
- Code of Conduct: `CODE_OF_CONDUCT.md`
- Global history: `CHANGELOG.md`

---

## Repository Structure

```
Distribution/
├── README.md            ← this file
├── Editor/              ← optional VS Code support
│   ├── Plugin/          ← syntax/color extension
│   └── vscode/          ← settings.json + snippets
└── V[n]/                ← release versions
    ├── CHANGE.md        ← changelog for this version
    ├── Documentation/
    │   └── sapi.html    ← full language reference
    └── Install/
        ├── windows/
        │   └── sapi.exe
        └── linux/
            └── sapi
```

---

## License

MIT. See `LICENSE`.

## VS Code Support (optional)

Copy `Editor/Plugin/sapi-lang` into `~/.vscode/extensions/` for syntax highlighting and snippets.
