# Sapi V1 -- Version initiale

## Nouveautés

- Compilateur Sapi : génère un projet Rust (Axum + Tokio) depuis un fichier `.sapi`
- Commandes : `sapi new`, `sapi build`, `sapi run`, `sapi watch`, `sapi doc`
- Types : `string`, `int`, `float`, `bool`, `list:T`
- Routes HTTP : `get`, `post`, `put`, `delete`, `patch`
- Body : `body json`, `body form`
- Paramètres de route : `route { ... }`
- Retour typé avec code HTTP : `return 201: { ... }`
- Variables et interpolation de chaînes : `"{variable}"`
- Conditions `if / else if / else`
- Fonctions `fn`
- Base de données PostgreSQL : `database`, `sql`, `await`
- Authentification JWT : `auth`, `guard`
- Documentation Swagger/OpenAPI intégrée : `swagger: true`
- Documentation HTML interactive (`sapi doc --html`)
- Binaires autonomes Windows (x86_64, statique MSVC) et Linux (x86_64, musl statique)

