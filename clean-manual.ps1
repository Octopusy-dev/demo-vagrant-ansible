# Alternative : Nettoyage manuel avec commandes Git standard
# Si git-filter-repo ne fonctionne pas, on peut utiliser cette approche

Write-Host "🧹 Nettoyage du repository - Approche alternative" -ForegroundColor Yellow

# Supprimer les fichiers du working directory d'abord
$itemsToRemove = @(
    ".vagrant",
    ".vscode", 
    "docker/TodoApi/obj",
    "publish",
    "scripts",
    "vagrant-ansible", 
    "vagrant-shell",
    ";gitignore",
    "dotnet.log",
    "dockerfile", 
    "Vagrantfile",
    "Vagrantfile.shell",
    "Vagrant.sln"
)

Write-Host "📝 Suppression des fichiers du working directory..." -ForegroundColor Cyan

foreach ($item in $itemsToRemove) {
    if (Test-Path $item) {
        Write-Host "  ❌ Suppression : $item" -ForegroundColor Red
        Remove-Item $item -Recurse -Force -ErrorAction SilentlyContinue
        
        # Supprimer aussi du git index si tracké
        git rm -r --cached $item 2>$null
    } else {
        Write-Host "  ⚠️  Déjà absent : $item" -ForegroundColor Yellow
    }
}

Write-Host "`n📋 État du repository après nettoyage :" -ForegroundColor Cyan
git status --porcelain

Write-Host "`n💡 Pour supprimer complètement de l'historique, utilisez :" -ForegroundColor Yellow
Write-Host "python -m git_filter_repo --paths-from-file paths-to-remove.txt --invert-paths --force" -ForegroundColor Gray

Write-Host "`n🎯 Prochaines étapes recommandées :" -ForegroundColor Green
Write-Host "1. git add -A" -ForegroundColor White
Write-Host "2. git commit -m 'Nettoyage du repository - suppression fichiers indésirables'" -ForegroundColor White
Write-Host "3. git push --force-with-lease (ATTENTION : force push !)" -ForegroundColor White