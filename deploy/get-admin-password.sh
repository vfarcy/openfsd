#!/bin/bash
# Script pour récupérer les identifiants admin par défaut
# À exécuter sur le VPS après le premier lancement

echo "=== Récupération des identifiants administrateur par défaut ==="
echo ""

# Chercher dans les logs du conteneur FSD
docker logs deploy-fsd-1 2>&1 | grep -A 10 "DEFAULT ADMINISTRATOR CREDENTIALS"

echo ""
echo "Si aucun résultat n'apparaît ci-dessus :"
echo "1. Le compte admin avec CID=1 existe déjà"
echo "2. Ou les logs ont été nettoyés"
echo ""
echo "Solutions :"
echo "- Recréer la base de données (supprime toutes les données) :"
echo "    docker compose -f docker-compose.ovh.yml down -v"
echo "    docker compose -f docker-compose.ovh.yml up -d"
echo ""
echo "- Ou réinitialiser le mot de passe via l'API (si vous avez un autre admin) :"
echo "    Voir la documentation dans deploy/README-ovh.md"
