#!/bin/bash
# Script de diagnostic pour le problème de connexion
# Doit être exécuté avec sudo ou en tant qu'utilisateur dans le groupe docker

echo "=== Diagnostic de connexion openfsd ==="
echo ""

echo "1. Vérification que les services sont actifs..."
sudo docker compose -f docker-compose.ovh.yml ps
echo ""

echo "2. Logs récents du service web (API de connexion)..."
sudo docker logs deploy-web-1 --tail 30
echo ""

echo "3. Logs récents du service FSD..."
sudo docker logs deploy-fsd-1 --tail 30
echo ""

echo "4. Test de connectivité interne web -> fsd..."
sudo docker exec deploy-web-1 wget -q -O- http://fsd:13618/online_users 2>&1 | head -n 5
echo ""

echo "5. Vérification des variables d'environnement..."
echo "DATABASE_SOURCE_NAME (web):"
sudo docker exec deploy-web-1 env | grep DATABASE_SOURCE_NAME
echo ""
echo "FSD_HTTP_SERVICE_ADDRESS (web):"
sudo docker exec deploy-web-1 env | grep FSD_HTTP_SERVICE_ADDRESS
echo ""

echo "6. Tentative de récupération du CID 1 depuis la base..."
echo "Si vous voyez des données ci-dessous, le compte existe :"
sudo docker exec deploy-fsd-1 ls -lh /db/
echo ""

echo "=== Fin du diagnostic ==="
echo ""
echo "Problèmes possibles :"
echo "- Le web et le FSD n'utilisent pas la même base de données"
echo "- Le mot de passe contient des caractères spéciaux mal interprétés"
echo "- Les services ne partagent pas le même volume de base de données"
echo "- Un problème de synchronisation entre les conteneurs"
