# Sapi V1 — Changelog

## 1.0.7

- Remplacement de l'ancienne interface migration par une interface SQLx stricte: `sapi migrate ...`.
- Commandes disponibles: `sapi migrate add`, `sapi migrate run`, `sapi migrate revert`, `sapi migrate info`.
- Options de migration alignées SQLx: `--dry-run`, `--ignore-missing`, `--target-version`, `-r/--reversible`.
- Suppression volontaire de l'alias `migration` pour conserver une seule commande canonique (`migrate`).
- Mise à jour de l'aide CLI avec liens vers la documentation SQLx + exemples d'usage.
- Documentation langage et README Distribution mis à jour pour le workflow `migrate`.

## 1.0.6

- Mise a jour de la release publique en restant sur `V1` (pas de creation de `V2` pour ce patch).
- Ajout des commandes plugin dans la CLI:
	- `sapi plugin install`
	- `sapi plugin install-ai`
	- `sapi plugin reinstall`
	- `sapi plugin doctor`
	- `sapi plugin doctor --fix`
- Installation plugin VS Code rendue autonome: assets plugin embarques dans le binaire `sapi`.
- Pack IA Copilot etendu pour Sapi: installation de 19 fichiers `.github` (instructions + prompts) pour dev, architecture, securite, runtime, SQL, tests et production.
- Alignement des binaires et de la documentation sur la version `1.0.6`.

## 1.0.5

- Maintien de la release publique sur `V1` (suppression de `V2` du dépôt Distribution).
- Bump version CLI vers `1.0.5` (source compilateur et artefacts associés).
- Alignement des fichiers de version côté éditeur/plugin sur `1.0.5`.

## Nouveautés

- **`sapi build --linux`** cross-compile un binaire Linux musl x86_64 statique depuis Windows (nécessite `zig`, `cargo-zigbuild` et la target `x86_64-unknown-linux-musl`). Vérifications préalables automatiques avec messages d'erreur clairs si un prérequis manque.
- **`sapi build --win`** force la compilation Windows (utile sur Linux).
- **`sapi build`** compile maintenant toujours en mode release et produit un binaire standalone prêt à déployer.
- **`sapi build --log <dossier>`** copie le binaire et génère un `build.log` dans le dossier spécifié.
- **Argument fichier optionnel** — `sapi run`, `sapi watch`, `sapi build` et `sapi doc` détectent automatiquement `main.sapi` dans le dossier courant si aucun fichier n'est spécifié.
- **`sapi watch`** génère ses artefacts dans `%TEMP%` (invisible dans le workspace, comme `sapi run`).
- **`sapi new <nom>`** crée un nouveau projet Sapi avec structure et fichier d'exemple.
- **Processus visible** — `sapi run` et `sapi watch` lancent maintenant directement `sapi_server.exe` (plus `cargo`), visible tel quel dans le gestionnaire des tâches.
- **if / else / else if** — branches conditionnelles avec opérateurs `==`, `!=`, `>`, `<`, `>=`, `<=`.
- **Erreurs SQL en JSON** — les erreurs de requête retournent `{"error":"sql_error","message":"..."}` avec `eprintln` côté serveur.
- **Guard hiérarchique dans `auth`** — support d'un bloc `guard { key, guard_op/op, roles }` directement dans la configuration Auth JWT.
- **Priorités dynamiques de rôles** — la clé de ranking est configurable (`rank`, `weight`, `priority`, ...), avec comparaison via `guard_op` (`>=`, `>`, `==`, `<=`, `<`).
- **Super-rôle** — support de `super: true` pour bypass des checks de niveau.
- **Syntaxe courte de route** — support de `guard "role"` en plus de `guard Auth "role"`.
- **Nouveaux tests guard multi-rôles** — scénario dédié validant hiérarchie, super-rôle, syntaxe courte et compatibilité des contrôles 401/403.

## Corrections

- **Version CLI alignée en SemVer** — `sapi -V` affiche désormais `1.0.0` (baseline officielle).
- **Plus de version hardcodée `0.1.0`** — la version OpenAPI (`info.version`) et la version du `Cargo.toml` généré (`sapi_server`) suivent maintenant automatiquement `env!("CARGO_PKG_VERSION")`.
- **Politique de bump clarifiée** — les updates standards passent en patch (`1.0.1`, `1.0.2`, ...).
- `sapi watch` ne créait pas de dossier `.sapi_watch/` visible à côté du fichier source.
- Les variables non réassignées ne sont plus déclarées `let mut` dans le code généré.
- Les structs multi-retour avec champs camelCase ne génèrent plus d'avertissement Rust.
- Les résultats SQL (MariaDB/MySQL) décodent correctement les colonnes VARCHAR via `try_get_unchecked`.
- `TRUNCATE TABLE` utilisé à la place de `DELETE FROM` dans les tests pour réinitialiser les AUTO_INCREMENT.

