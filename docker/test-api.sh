#!/bin/bash

# Script de test pour l'API Todo
API_URL="http://localhost:5000/api/todos"

echo "=== Test de l'API Todo ==="
echo

# Fonction pour attendre que l'API soit prête
wait_for_api() {
    echo "Attente de l'API..."
    for i in {1..30}; do
        if curl -s http://localhost:5000/health > /dev/null 2>&1; then
            echo "API prête !"
            return 0
        fi
        echo "Tentative $i/30..."
        sleep 2
    done
    echo "Erreur : L'API n'est pas accessible"
    exit 1
}

# Attendre que l'API soit prête
wait_for_api

echo
echo "1. Test GET /api/todos (liste vide au début)"
curl -s -X GET $API_URL | jq .

echo
echo
echo "2. Test POST - Créer une tâche"
TASK1=$(curl -s -X POST $API_URL \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Apprendre Docker",
    "description": "Comprendre Docker et Docker Compose",
    "isCompleted": false
  }')
echo $TASK1 | jq .
TASK1_ID=$(echo $TASK1 | jq -r '.id')

echo
echo
echo "3. Test POST - Créer une deuxième tâche"
TASK2=$(curl -s -X POST $API_URL \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Tester l API",
    "description": "Faire des tests CRUD complets",
    "isCompleted": false
  }')
echo $TASK2 | jq .
TASK2_ID=$(echo $TASK2 | jq -r '.id')

echo
echo
echo "4. Test GET /api/todos (avec données)"
curl -s -X GET $API_URL | jq .

echo
echo
echo "5. Test GET /api/todos/$TASK1_ID (récupérer une tâche)"
curl -s -X GET $API_URL/$TASK1_ID | jq .

echo
echo
echo "6. Test PUT - Mettre à jour la première tâche"
curl -s -X PUT $API_URL/$TASK1_ID \
  -H "Content-Type: application/json" \
  -d "{
    \"id\": $TASK1_ID,
    \"title\": \"Maîtriser Docker\",
    \"description\": \"Docker et Docker Compose maîtrisés !\",
    \"isCompleted\": true
  }" | jq .

echo
echo
echo "7. Test GET - Vérifier la mise à jour"
curl -s -X GET $API_URL/$TASK1_ID | jq .

echo
echo
echo "8. Test DELETE - Supprimer la deuxième tâche"
curl -s -X DELETE $API_URL/$TASK2_ID -w "Status Code: %{http_code}\n"

echo
echo
echo "9. Test GET final /api/todos"
curl -s -X GET $API_URL | jq .

echo
echo
echo "=== Tests terminés ==="