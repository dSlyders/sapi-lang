# Sapi Language

> **Sapi** (Slyders API) est un langage de haut niveau conçu par **dSlyders** pour créer des APIs REST modernes en écrivant un minimum de code. Le compilateur génère automatiquement du Rust (Axum + Tokio) à partir de vos fichiers `.sapi`.

Documentation en ligne: https://dslyders.github.io/sapi-lang/

---

## Table des matières

- [Pourquoi Sapi ?](#pourquoi-sapi-)
- [Installation Windows](#installation-windows)
- [Installation Linux](#installation-linux)
- [Créer un projet](#créer-un-projet)
- [Syntax de base](#syntax-de-base)
- [Base de données](#base-de-données)
- [Authentification JWT](#authentification-jwt)
- [Extension VS Code](#extension-vs-code)
- [Compiler et lancer](#compiler-et-lancer)
- [Documentation et GitHub Pages](#documentation-et-github-pages)
- [Structure du dépôt](#structure-du-dépôt)

---

## Pourquoi Sapi ?

Écrire une API REST en Rust demande de gérer Axum, Tokio, Serde, les types JSON, les connexions DB, la gestion d'erreurs... Sapi abstrait tout ça dans un langage simple et expressif.

```sapi
service MonApi {
  port:    3000
  swagger: true
}

MonApi get "/hello" {
  return "Hello, World!"
}

MonApi post "/echo" {
  body json { string message }
  return { string echo = message }
}
```

Ce code génère une API Rust complète avec documentation Swagger — sans écrire une seule ligne de Rust.

---

## Installation Windows

### Prérequis
- Windows 10 / 11
- [VS Code](https://code.visualstudio.com/) (recommandé)

### Étapes

1. Télécharger la dernière version dans `V[n]/Install/windows/`
2. Exécuter :

```powershell
powershell -ExecutionPolicy Bypass -File "chemin\vers\install.ps1"
```

Ou double-cliquer sur `install.ps1` → *Exécuter avec PowerShell*.

### Ce que l'installateur fait
- Copie `sapi.exe` → `%LOCALAPPDATA%\sapi\bin\` et l'ajoute au **PATH** utilisateur

### Vérifier l'installation (nouveau terminal)

```powershell
sapi --version
```

---

## Installation Linux

### Prérequis
- Ubuntu 20.04+ / Debian / toute distro x86_64

### Étapes

1. Télécharger la dernière version dans `V[n]/Install/linux/`
2. Exécuter :

```bash
bash /chemin/vers/install.sh
```

### Ce que l'installateur fait
- Copie `sapi` → `~/.local/bin/sapi` et l'ajoute au **PATH** dans `.bashrc` / `.zshrc`

### Vérifier l'installation

```bash
source ~/.bashrc   # ou ouvrir un nouveau terminal
sapi --version
```

---

## Créer un projet

```bash
sapi new mon-api
cd mon-api
```

Cela crée :
```
mon-api/
├── main.sapi          ← votre code
└── .vscode/
    ├── settings.json
    └── sapi.code-snippets
```

---

## Syntax de base

### Service (serveur HTTP)

```sapi
service MonApi {
  port:    3000
  swagger: true
  cors:    true
  logging: "info"
}
```

### Routes

```sapi
// GET — retourne une chaîne
MonApi get "/ping" {
  return "pong"
}

// POST — lit un body JSON
MonApi post "/user" {
  body json { string name, int age }
  return 201: { string message = "Créé", string user = name }
}

// Route avec paramètre
MonApi get "/user/{id}" {
  route { int id }
  return { int userId = id }
}
```

### Types disponibles

| Type | Exemple |
|------|---------|
| `string` | `string name = "Alice"` |
| `int` | `int age = 30` |
| `float` | `float price = 9.99` |
| `bool` | `bool active = true` |
| `list:string` | `list:string tags = ["a", "b"]` |

### Variables et interpolation

```sapi
string nom = "Alice"
string msg = "Bonjour, {nom}!"
return msg
```

### If / else

```sapi
MonApi get "/check/{value}" {
  route { int value }
  if value > 100 {
    return "grand"
  } else if value > 50 {
    return "moyen"
  } else {
    return "petit"
  }
}
```

### Fonctions

```sapi
fn double(int n) {
  int result = n * 2
  return result
}

MonApi get "/double/{n}" {
  route { int n }
  int result = double(n)
  return result
}
```

---

## Base de données

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

MonApi get "/user/{id}" {
  route { int id }
  await User row = getUser({ id: id }).one()
  return { int id = row.id, string name = row.name }
}
```

---

## Authentification JWT

```sapi
auth Auth {
  secret:    env("JWT_SECRET")
  algorithm: "HS256"
  expiry:    3600
  claims:    { int userId, string role }
}

// Route protégée
MonApi get "/profile" {
  guard Auth
  return "Accès autorisé"
}

// Route avec rôle requis
MonApi delete "/admin/user/{id}" {
  guard Auth "admin"
  route { int id }
  return { string message = "Supprimé" }
}
```

---

## Extension VS Code

L'extension **sapi-lang** apporte :
- Coloration syntaxique complète (mots-clés, types, SQL, routes, interpolations...)
- 38 snippets d'autocomplétion (`service`, `get`, `post`, `sql`, `await`, `guard`, `if`, `for`...)
- Commentaires `//` et `///`
- Auto-fermeture des accolades, crochets, parenthèses

Les fichiers se trouvent dans `Editor/` — copier dans votre projet et recharger VS Code :

```
Ctrl+Shift+P  →  Developer: Reload Window
```

---

## Compiler et lancer

```bash
# Créer un nouveau projet
sapi new mon-api

# Compiler un fichier .sapi (génère le projet Rust dans ./out/)
sapi build main.sapi

# Compiler vers un dossier spécifique
sapi build main.sapi mon-projet

# Lancer directement (compile + exécute)
sapi run main.sapi

# Mode watch — recompile automatiquement à chaque sauvegarde (dev)
sapi watch main.sapi

# Générer la documentation HTML (dans ./docs/)
sapi doc main.sapi --html

# Générer la documentation dans un dossier spécifique
sapi doc main.sapi --html --output api-docs

# Créer une migration SQL (fichiers .up.sql + .down.sql)
sapi migrate add -r init_schema

# Appliquer les migrations
sapi migrate run

# Afficher l'état des migrations
sapi migrate info

# Revert de la dernière migration
sapi migrate revert

# Installer l'extension VS Code Sapi (depuis le binaire CLI)
sapi plugin install

# Installer les instructions + skills Copilot pour un projet Sapi
sapi plugin install-ai

# Installer dans un dossier cible et remplacer les fichiers existants
sapi plugin install-ai --dir mon-api --force

# Réinstaller proprement l'extension
sapi plugin reinstall

# Diagnostiquer l'installation plugin
sapi plugin doctor

# Diagnostiquer + corriger automatiquement
sapi plugin doctor --fix
```

---

## Documentation et GitHub Pages

Source de référence de la documentation langage:

- `C:\SAPI\LANGUAGE.html`

Publication dans ce dépôt:

- `V[n]/Documentation/sapi.html` pour la release active
- `docs/index.html` pour GitHub Pages

URL GitHub Pages attendue:

- https://dslyders.github.io/sapi-lang/

Workflow automatique:

- `.github/workflows/deploy-docs-pages.yml`
- Déclenché à chaque push sur `main` qui modifie `docs/**`

Mise à jour manuelle rapide (Windows PowerShell):

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

## Structure du dépôt

```
Distribution/
├── README.md            ← Ce fichier
├── Editor/              ← Support VS Code (optionnel)
│   ├── Plugin/          ← Extension de syntaxe + coloration
│   └── vscode/          ← settings.json + snippets
└── V[n]/                ← Versions de release
    ├── CHANGE.md        ← Nouveautés de cette version
    ├── Documentation/
    │   └── sapi.html    ← Référence complète du langage
    └── Install/
        ├── windows/
        │   ├── sapi.exe
        │   └── install.ps1
        └── linux/
            ├── sapi
            └── install.sh
```

---

## Licence

© Slyders — Tous droits réservés.

## Support VS Code (optionnel)

Copier le dossier `Editor/Plugin/sapi-lang` dans `~/.vscode/extensions/` pour la coloration syntaxique et les snippets.
