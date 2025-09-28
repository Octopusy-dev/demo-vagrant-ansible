# Script de nettoyage du repository avec git-filter-repo
# Ce script supprime les fichiers et dossiers qui ne devraient pas être dans le repository

# Dossiers à supprimer complètement
$foldersToRemove = @(
    ".vagrant",
    ".vscode", 
    "docker/TodoApi/obj",
    "publish",
    "scripts",
    "vagrant-ansible", 
    "vagrant-shell"
)

# Fichiers individuels à supprimer
$filesToRemove = @(
    ";gitignore",
    "dotnet.log",
    "dockerfile", 
    "Vagrantfile",
    "Vagrantfile.shell",
    "Vagrant.sln"
)

Write-Host "🧹 Nettoyage du repository avec git-filter-repo..." -ForegroundColor Yellow

# Créer le fichier de chemins à supprimer
$pathsFile = "paths-to-remove.txt"

# Ajouter les dossiers
foreach ($folder in $foldersToRemove) {
    Add-Content -Path $pathsFile -Value $folder
}

# Ajouter les fichiers
foreach ($file in $filesToRemove) {
    Add-Content -Path $pathsFile -Value $file  
}

Write-Host "📝 Fichiers et dossiers à supprimer :" -ForegroundColor Cyan
Get-Content $pathsFile

Write-Host "`n⚠️  ATTENTION : Cette opération va réécrire l'historique Git !" -ForegroundColor Red
Write-Host "Une sauvegarde a été créée dans la branche 'backup-before-filter'" -ForegroundColor Green

$confirm = Read-Host "`nVoulez-vous continuer ? (oui/non)"

if ($confirm -eq "oui" -or $confirm -eq "o" -or $confirm -eq "yes" -or $confirm -eq "y") {
    Write-Host "🚀 Exécution du nettoyage..." -ForegroundColor Green
    
    # Exécuter git-filter-repo pour supprimer les chemins
    git filter-repo --paths-from-file $pathsFile --invert-paths --force
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Nettoyage terminé avec succès !" -ForegroundColor Green
        Write-Host "📊 Statistiques du repository :" -ForegroundColor Cyan
        git count-objects -vH
    } else {
        Write-Host "❌ Erreur lors du nettoyage" -ForegroundColor Red
        Write-Host "💡 Vous pouvez restaurer avec : git checkout backup-before-filter" -ForegroundColor Yellow
    }
} else {
    Write-Host "❌ Nettoyage annulé" -ForegroundColor Yellow
}

# Nettoyer le fichier temporaire
Remove-Item $pathsFile -ErrorAction SilentlyContinue