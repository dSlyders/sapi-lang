# Sapi Language — v1.0

> **Sapi** (Slyders API) est un langage de haut niveau conçu pour créer des APIs REST modernes en écrivant un minimum de code. Le compilateur génère automatiquement du Rust (Axum + Tokio) à partir de vos fichiers `.sapi`.

---

## Table des matières

- [Pourquoi Sapi ?](#pourquoi-sapi-)
- [Installation Windows](#installation-windows)
- [Installation Linux / macOS](#installation-linux--macos)
- [Créer un projet](#créer-un-projet)
- [Syntax de base](#syntax-de-base)
- [Extension VS Code](#extension-vs-code)

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

1. Télécharger la dernière version dans `Install/windows/`
2. Ouvrir un terminal PowerShell **dans votre dossier de projet**
3. Exécuter :

```powershell
powershell -ExecutionPolicy Bypass -File "chemin\vers\Install\windows\install.ps1"
```

Ou double-cliquer sur `install.ps1` → *Exécuter avec PowerShell*.

### Ce que l'instalateur fait
- Copie `sapi.exe` → `%LOCALAPPDATA%\sapi\bin\` et l'ajoute au **PATH** utilisateur
- Installe l'extension VS Code dans `~/.vscode/extensions/sapi-lang/`
- Crée `.vscode/settings.json` et `.vscode/sapi.code-snippets` dans votre projet (coloration syntaxique + autocomplétion)

### Vérifier l'installation (nouveau terminal)

```powershell
sapi --version
```

---

## Installation Linux / macOS

### Prérequis
- Ubuntu 20.04+ / Debian / macOS 12+
- [VS Code](https://code.visualstudio.com/) (recommandé)

### Étapes

1. Télécharger la dernière version dans `Install/linux/`
2. Ouvrir un terminal **dans votre dossier de projet**
3. Exécuter :

```bash
bash /chemin/vers/Install/linux/install.sh
```

Ou :

```bash
chmod +x Install/linux/install.sh
./Install/linux/install.sh
```

### Ce que l'instalateur fait
- Copie `sapi` → `~/.local/bin/sapi` et l'ajoute au **PATH** dans `.bashrc` / `.zshrc`
- Installe l'extension VS Code dans `~/.vscode/extensions/sapi-lang/`
- Crée `.vscode/settings.json` et `.vscode/sapi.code-snippets` dans votre projet

### Vérifier l'installation (nouveau terminal ou `source ~/.bashrc`)

```bash
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

### Base de données

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

### Authentification JWT

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

## Extension VS Code

L'extension **sapi-lang** apporte :
- Coloration syntaxique complète (mots-clés, types, SQL, routes, interpolations...)
- 38 snippets d'autocomplétion (`service`, `get`, `post`, `sql`, `await`, `guard`, `if`, `for`...)
- Commentaires `//` et `///`
- Auto-fermeture des accolades, crochets, parenthèses

### Après l'installation, recharger VS Code

```
Ctrl+Shift+P  →  Developer: Reload Window
```

---

## Compiler et lancer

```bash
# Compiler un fichier .sapi
sapi build main.sapi

# Lancer directement
sapi run main.sapi

# Générer la documentation HTML
sapi doc main.sapi --html
```

---

## Licence

© Slyders — Tous droits réservés.
