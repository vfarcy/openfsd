# Déploiement openfsd sur un VPS OVH

Ce guide propose un déploiement simple et robuste avec Docker Compose et Caddy (terminaison TLS automatique via Let's Encrypt).

## Pré-requis

- Un VPS OVH (Debian/Ubuntu récents)
- Un nom de domaine pointant vers l'IP du VPS (A/AAAA)
- Docker et Docker Compose installés
- Ports 80 et 443 ouverts (Caddy) et 6809/TCP (FSD)

## Arborescence

```
openfsd/
  deploy/
    docker-compose.ovh.yml
    Caddyfile
    README-ovh.md
```

## Variables d'environnement

Créer un fichier `.env` dans `deploy/`:

```
OPENFSD_DOMAIN=fsd.example.com
LETSENCRYPT_EMAIL=admin@example.com
```

## Lancer

Depuis `deploy/`:

```bash
docker compose -f docker-compose.ovh.yml up -d
```

- Le service Web est accessible via `https://$OPENFSD_DOMAIN`
- Le port FSD (6809/TCP) est exposé publiquement pour les clients pilotes/ATC

## Configuration initiale

1. Aller sur l'interface Web, se connecter avec l'admin par défaut (imprimé dans les logs du conteneur `fsd` au premier démarrage)
2. Définir le `API_SERVER_BASE_URL` dans la configuration: `https://$OPENFSD_DOMAIN`
3. (Optionnel) passer en PostgreSQL si souhaité (voir section suivante)

## Basculer en PostgreSQL (optionnel)

Ajouter un service Postgres au compose et adapter les variables d'env des services `fsd` et `web`:

```
  postgres:
    image: postgres:16-alpine
    restart: unless-stopped
    environment:
      POSTGRES_DB: openfsd
      POSTGRES_USER: openfsd
      POSTGRES_PASSWORD: change_me
    volumes:
      - pgdata:/var/lib/postgresql/data
    networks:
      - openfsd_net
```

Puis, pour `fsd` et `web`:

```
  environment:
    DATABASE_DRIVER: postgres
    DATABASE_SOURCE_NAME: postgresql://openfsd:change_me@postgres:5432/openfsd?sslmode=disable
    DATABASE_AUTO_MIGRATE: "true"  # au moins sur fsd pour appliquer les migrations au démarrage
```

Et ajouter le volume:

```
volumes:
  openfsd_db:
  caddy_data:
  caddy_config:
  pgdata:
```

## Sécurité réseau

- L'API interne FSD (port 13618) n'est pas exposée; `web` y accède sur le réseau docker interne.
- Caddy termine le TLS et propage un `X-Forwarded-Proto https`.
- Des en-têtes de sécurité sont appliquées côté app et côté Caddy.

## Sauvegardes

- SQLite: volume `openfsd_db`. Sauvegarder le répertoire de volume.
- PostgreSQL: effectuer des sauvegardes logiques (`pg_dump`) et/ou snapshots de volume.

## Mise à jour

```
# Depuis deploy/
docker compose -f docker-compose.ovh.yml pull
docker compose -f docker-compose.ovh.yml up -d
```

Pour inclure les correctifs locaux non publiés en image, construire des images depuis la branche `vpsovh` et remplacer les images `ghcr.io/...` par vos images personnalisées.
