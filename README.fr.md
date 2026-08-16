# Fond vidéo Waypaper pour Omarchy

[English](README.md)

Plugin de service pour Omarchy Quattro qui supervise le fond vidéo `mpvpaper`
sélectionné avec Waypaper. Waypaper reste l'interface graphique de sélection ;
le plugin donne au moteur de rendu un cycle de vie fiable dans `omarchy-shell`.

![Architecture du fond vidéo Waypaper](preview.png)

## Fonctionnalités

- Waypaper gère le dossier de vidéos, la sélection et les réglages.
- `mpvpaper` reste au premier plan afin qu'Omarchy Shell supervise son cycle de
  vie.
- Les arrêts inattendus sont relancés avec un délai exponentiel plafonné.
- Les actions démarrer, arrêter, redémarrer, pause et reprise sont exposées en
  IPC.
- La désactivation du plugin ou l'arrêt du shell coupe le moteur supervisé.
- Aucun fichier de configuration Waypaper, Hyprland ou Omarchy n'est modifié.

## Compatibilité et dépendances

Versions testées :

- Omarchy `4.0.0` (Quattro), schéma de manifeste `1`
- Waypaper `2.8`
- mpvpaper `1.9`

Installation des dépendances qui ne sont pas normalement fournies par
Omarchy :

```sh
omarchy pkg aur add mpvpaper waypaper
omarchy pkg add socat
```

Le plugin utilise également `awk` (`gawk`), `pgrep` (`procps-ng`) et
`uwsm-app` (`uwsm`).

## Installation sûre

Les plugins Omarchy sont exécutés sans sandbox avec les droits de
l'utilisateur. Vérifie le code avant activation.

```sh
omarchy plugin add \
  https://github.com/GavidetDoliath/omarchy-waypaper-video-background.git
```

Lorsque la commande interactive propose d'activer immédiatement le plugin,
répondre **No**. Le fond statique actuel reste ainsi actif pendant la
configuration. Dans un shell non interactif, le plugin reste désactivé tant
que l'option `--enable` n'est pas fournie explicitement.

Dans Waypaper :

1. choisir `mpvpaper` comme backend ;
2. sélectionner le dossier contenant les vidéos ;
3. choisir une vidéo et le mode de remplissage ;
4. laisser le son désactivé sauf besoin explicite.

Réglages conseillés :

```ini
backend = mpvpaper
mpvpaper_sound = False
mpvpaper_options = hwdec=auto loop-file=inf
```

Vérifier les réglages résolus sans démarrer de fond vidéo :

```sh
~/.config/omarchy/plugins/io.github.gavidetdoliath.waypaper-video-background/start-mpvpaper.sh --check
```

Une fois la vérification réussie :

```sh
omarchy plugin disable omarchy.background
omarchy plugin enable io.github.gavidetdoliath.waypaper-video-background
```

## Interface et commandes

Ouvrir Waypaper pour changer de vidéo :

```sh
omarchy-shell waypaper-video-background open
```

Autres commandes :

```sh
omarchy-shell waypaper-video-background status
omarchy-shell waypaper-video-background start
omarchy-shell waypaper-video-background stop
omarchy-shell waypaper-video-background restart
omarchy-shell waypaper-video-background pause
omarchy-shell waypaper-video-background resume
omarchy-shell waypaper-video-background toggle
```

## Mise à jour

```sh
omarchy plugin update io.github.gavidetdoliath.waypaper-video-background
```

## Retour arrière et suppression

Restaurer d'abord le fond statique Omarchy :

```sh
omarchy plugin disable io.github.gavidetdoliath.waypaper-video-background
omarchy plugin enable omarchy.background
omarchy plugin remove io.github.gavidetdoliath.waypaper-video-background
```

La suppression ne touche ni à la configuration Waypaper, ni aux vidéos, ni
aux paquets installés.

## Comportement et sécurité

- Lecture seule de `~/.config/waypaper/config.ini`.
- Utilisation du socket Waypaper `/tmp/mpv-socket-<monitor>`.
- Arrêt uniquement du processus `mpvpaper` utilisant ce socket exact avant
  son remplacement.
- Aucun téléchargement, installateur, service système, `sudo` ou `pkexec`.
- Un fond vidéo consomme continuellement des ressources de rendu ; utilise
  pause ou stop sur batterie si nécessaire.

## Diagnostic

```sh
~/.config/omarchy/plugins/io.github.gavidetdoliath.waypaper-video-background/start-mpvpaper.sh --check
omarchy-shell waypaper-video-background status | jq
qs log -p "$OMARCHY_PATH/shell" --tail 100
```

Après correction d'une erreur de dépendance ou de configuration :

```sh
omarchy-shell waypaper-video-background start
```

## Développement

```sh
./validate.sh
```

## Licence

[MIT](LICENSE)
