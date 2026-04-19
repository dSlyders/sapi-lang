# Sapi V2 -- Changelog

## 1.0.6

## Nouveautes

- Nouvelle famille de commandes plugin dans la CLI :
	- `sapi plugin install`
	- `sapi plugin reinstall`
	- `sapi plugin doctor`
	- `sapi plugin doctor --fix`
- Le plugin VS Code Sapi est maintenant embarque dans le binaire CLI (assets inclus), ce qui permet l'installation/reparation plugin depuis n'importe quel dossier, sans dependre du repo source.
- Documentation CLI mise a jour pour inclure les commandes plugin.

## Corrections

- Amelioration de la robustesse d'installation du plugin VS Code : suppression des conflits d'anciennes installations detectees lors d'une reinstallation.
- Alignement de version sur `1.0.6` pour la CLI et le package plugin VS Code distribue.
