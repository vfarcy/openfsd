# openfsd

[![license](https://img.shields.io/github/license/renorris/openfsd)](https://github.com/renorris/openfsd/blob/main/LICENSE)

openfsd est un serveur multijoueur open source pour la simulation de vol implémentant le protocole FSD moderne de VATSIM. Il connecte les pilotes et les contrôleurs aériens dans un environnement virtuel partagé.

## À propos

Flight Sim Daemon (communément appelé FSD) est le logiciel/protocole chargé de connecter les clients de simulateur de vol domestique à un monde multijoueur unique et partagé, sur des réseaux de passionnés comme [VATSIM](https://vatsim.net/docs/about/about-vatsim) et [IVAO](https://www.ivao.aero/).
FSD a été écrit à la fin des années 1990 par [Marty Bochane](https://github.com/kuroneko/fsd) pour [SATCO](https://web.archive.org/web/20000619145015/http://www.satco.org/), puis a été forké et rendu propriétaire par VATSIM en 2001.
En mai 2025, FSD est toujours utilisé pour permettre à plus de 140 000 membres actifs de connecter leurs simulateurs au [réseau](https://vatsim-radar.com/).

## Fonctionnalités

- Assurer le multijoueur de simulation de vol avec compatibilité du protocole VATSIM.
- Intégrer une interface Web d’administration pour les utilisateurs, la configuration et les connexions.
- Prendre en charge SQLite et PostgreSQL pour le stockage persistant.

## Démarrage rapide avec Docker

La méthode recommandée pour exécuter openfsd est **Docker** et **Docker Compose**. Consulte la [page de déploiement](https://github.com/renorris/openfsd/wiki/Deployment).

### Prérequis

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)

### Étapes

1. Cloner le dépôt :
   ```bash
   git clone https://github.com/renorris/openfsd.git
   cd openfsd
   ```

2. Démarrer avec Docker Compose :
   ```bash
   docker-compose up -d
   ```
   Cela lance le serveur FSD et le serveur Web en partageant une base SQLite persistée dans un volume Docker nommé. Cette configuration convient à la plupart des usages pour de petits serveurs.

3. Configurer le serveur via l’interface Web :
    - Ouvre `http://localhost:8000` dans un navigateur.
    - Connecte-toi avec les identifiants administrateur par défaut (affichés dans les logs du serveur FSD au premier démarrage).
    - Va dans le menu **Configure Server**.
    - Renseigne la configuration. Voir la [documentation Configuration](https://github.com/renorris/openfsd/wiki/Configuration).

4. Connexion des clients :
   Consulte la page [Client Connection](https://github.com/renorris/openfsd/wiki/Client-Connection) pour les instructions spécifiques aux clients.

## API

Le serveur Web expose des API sous `/api/v1` pour l’authentification, la gestion des utilisateurs et la configuration. Une interface Web de base est fournie, mais tu peux aussi appeler cette API depuis tes propres applications. Voir la [documentation de l’API](https://github.com/renorris/openfsd/tree/main/web).

## Docs

Une documentation officieuse (rétro‑ingénierie) du protocole est incluse dans ce dépôt :

```
pip install mkdocs
git clone git@github.com:renorris/openfsd.git
cd openfsd/
mkdocs serve
```
