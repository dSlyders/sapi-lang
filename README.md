# Sapi Language — Distribution

**Sapi** (Slyders API) est un langage de programmation haut niveau conçu par **dSlyders** pour créer des APIs REST modernes avec un minimum de code.

## Pourquoi Sapi ?

Écrire une API en Rust demande de maîtriser Axum, Tokio, Serde, la gestion des routes, des erreurs, de la base de données… Sapi abstrait tout ça dans une syntaxe simple et expressive. Vous écrivez un fichier `.sapi`, le compilateur génère le projet Rust complet — prêt à construire et déployer.

```sapi
service MonApi {
  port:    3000
  swagger: true
}

MonApi get "/hello" {
  return "Hello, World!"
}
```

Ce fichier génère une API Rust fonctionnelle avec documentation Swagger intégrée.

## Créé par

**dSlyders** — parce qu'écrire des APIs ne devrait pas nécessiter des centaines de lignes de boilerplate.

## Structure de ce dépôt

```
Distribution/
├── Editor/              ← Support VS Code (optionnel)
│   ├── Plugin/          ← Extension de syntaxe + coloration
│   └── vscode/          ← settings.json + snippets
└── V[n]/                ← Versions de release
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

## Installation rapide

**Windows** — Lancer `Install\windows\install.ps1`

**Linux / macOS** — `bash Install/linux/install.sh`

## Support VS Code (optionnel)

Copier le dossier `Editor/Plugin/sapi-lang` dans `~/.vscode/extensions/` pour la coloration syntaxique et les snippets.
