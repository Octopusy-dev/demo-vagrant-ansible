# Script de test PowerShell pour l'API Todo
$API_URL = "http://localhost:5000/api/todos"

Write-Host "=== Test de l'API Todo ===" -ForegroundColor Green
Write-Host

# Fonction pour attendre que l'API soit prête
function Wait-ForApi {
    Write-Host "Attente de l'API..." -ForegroundColor Yellow
    for ($i = 1; $i -le 30; $i++) {
        try {
            $response = Invoke-RestMethod -Uri "http://localhost:5000/health" -Method Get -TimeoutSec 5
            Write-Host "API prête !" -ForegroundColor Green
            return $true
        }
        catch {
            Write-Host "Tentative $i/30..." -ForegroundColor Yellow
            Start-Sleep -Seconds 2
        }
    }
    Write-Host "Erreur : L'API n'est pas accessible" -ForegroundColor Red
    exit 1
}

# Attendre que l'API soit prête
Wait-ForApi

Write-Host
Write-Host "1. Test GET /api/todos (liste vide au début)" -ForegroundColor Cyan
try {
    $todos = Invoke-RestMethod -Uri $API_URL -Method Get
    $todos | ConvertTo-Json -Depth 3
} catch {
    Write-Host "Erreur: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host
Write-Host "2. Test POST - Créer une tâche" -ForegroundColor Cyan
$newTask1 = @{
    title = "Apprendre Docker"
    description = "Comprendre Docker et Docker Compose"
    isCompleted = $false
} | ConvertTo-Json

try {
    $task1 = Invoke-RestMethod -Uri $API_URL -Method Post -Body $newTask1 -ContentType "application/json"
    $task1 | ConvertTo-Json -Depth 3
    $task1Id = $task1.id
} catch {
    Write-Host "Erreur: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host
Write-Host "3. Test POST - Créer une deuxième tâche" -ForegroundColor Cyan
$newTask2 = @{
    title = "Tester l'API"
    description = "Faire des tests CRUD complets"
    isCompleted = $false
} | ConvertTo-Json

try {
    $task2 = Invoke-RestMethod -Uri $API_URL -Method Post -Body $newTask2 -ContentType "application/json"
    $task2 | ConvertTo-Json -Depth 3
    $task2Id = $task2.id
} catch {
    Write-Host "Erreur: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host
Write-Host "4. Test GET /api/todos (avec données)" -ForegroundColor Cyan
try {
    $todos = Invoke-RestMethod -Uri $API_URL -Method Get
    $todos | ConvertTo-Json -Depth 3
} catch {
    Write-Host "Erreur: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host
Write-Host "5. Test GET /api/todos/$task1Id (récupérer une tâche)" -ForegroundColor Cyan
try {
    $task = Invoke-RestMethod -Uri "$API_URL/$task1Id" -Method Get
    $task | ConvertTo-Json -Depth 3
} catch {
    Write-Host "Erreur: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host
Write-Host "6. Test PUT - Mettre à jour la première tâche" -ForegroundColor Cyan
$updateTask = @{
    id = $task1Id
    title = "Maîtriser Docker"
    description = "Docker et Docker Compose maîtrisés !"
    isCompleted = $true
} | ConvertTo-Json

try {
    Invoke-RestMethod -Uri "$API_URL/$task1Id" -Method Put -Body $updateTask -ContentType "application/json"
    Write-Host "Mise à jour réussie" -ForegroundColor Green
} catch {
    Write-Host "Erreur: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host
Write-Host "7. Test GET - Vérifier la mise à jour" -ForegroundColor Cyan
try {
    $updatedTask = Invoke-RestMethod -Uri "$API_URL/$task1Id" -Method Get
    $updatedTask | ConvertTo-Json -Depth 3
} catch {
    Write-Host "Erreur: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host
Write-Host "8. Test DELETE - Supprimer la deuxième tâche" -ForegroundColor Cyan
try {
    Invoke-RestMethod -Uri "$API_URL/$task2Id" -Method Delete
    Write-Host "Suppression réussie" -ForegroundColor Green
} catch {
    Write-Host "Erreur: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host
Write-Host "9. Test GET final /api/todos" -ForegroundColor Cyan
try {
    $finalTodos = Invoke-RestMethod -Uri $API_URL -Method Get
    $finalTodos | ConvertTo-Json -Depth 3
} catch {
    Write-Host "Erreur: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host
Write-Host "=== Tests terminés ===" -ForegroundColor Green