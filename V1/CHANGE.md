# Sapi V1 — Changelog

## Nouveautés

- **`sapi build`** compile maintenant toujours en mode release et produit un binaire standalone prêt à déployer.
- **`sapi build --log <dossier>`** copie le binaire et génère un `build.log` dans le dossier spécifié.
- **Argument fichier optionnel** — `sapi run`, `sapi watch`, `sapi build` et `sapi doc` détectent automatiquement `main.sapi` dans le dossier courant si aucun fichier n'est spécifié.
- **`sapi watch`** génère ses artefacts dans `%TEMP%` (invisible dans le workspace, comme `sapi run`).
- **`sapi new <nom>`** crée un nouveau projet Sapi avec structure et fichier d'exemple.
- **Processus visible** — `sapi run` et `sapi watch` lancent maintenant directement `sapi_server.exe` (plus `cargo`), visible tel quel dans le gestionnaire des tâches.
- **if / else / else if** — branches conditionnelles avec opérateurs `==`, `!=`, `>`, `<`, `>=`, `<=`.
- **Erreurs SQL en JSON** — les erreurs de requête retournent `{"error":"sql_error","message":"..."}` avec `eprintln` côté serveur.

## Corrections

- `sapi watch` ne créait pas de dossier `.sapi_watch/` visible à côté du fichier source.
- Les variables non réassignées ne sont plus déclarées `let mut` dans le code généré.
- Les structs multi-retour avec champs camelCase ne génèrent plus d'avertissement Rust.
- Les résultats SQL (MariaDB/MySQL) décodent correctement les colonnes VARCHAR via `try_get_unchecked`.
- `TRUNCATE TABLE` utilisé à la place de `DELETE FROM` dans les tests pour réinitialiser les AUTO_INCREMENT.

