#!/bin/bash
set -e

echo "=== Début du provisioning avec script shell ==="

# Mettre à jour le cache apt
echo "Mise à jour du cache apt..."
apt-get update

# Installer les dépendances
echo "Installation des dépendances..."
apt-get install -y wget apt-transport-https software-properties-common

# Télécharger et installer le repository Microsoft
echo "Configuration du repository Microsoft..."
wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O /tmp/packages-microsoft-prod.deb
dpkg -i /tmp/packages-microsoft-prod.deb

# Installer .NET SDK 8 via snap (comme dans Ansible)
echo "Installation de .NET SDK 8 via snap..."
snap install dotnet-sdk --classic --channel=8.0/stable

# Créer un alias pour dotnet
echo "Configuration de l'alias dotnet..."
snap alias dotnet-sdk.dotnet dotnet

# Créer le projet API si inexistant
if [ ! -d /vagrant/HelloApi ]; then
  echo "Création du projet API..."
  dotnet new webapi -o /vagrant/HelloApi --no-https
  
  # Créer le Program.cs minimal
  echo "Configuration du Program.cs..."
  cat > /vagrant/HelloApi/Program.cs << 'EOF'
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();
app.MapGet("/", () => "Hello World from .NET 8 + Shell Script (published)!");
app.Run();
EOF
fi

# Publier l'API en mode Release
echo "Publication de l'API en mode Release..."
dotnet publish -c Release -o /vagrant/publish /vagrant/HelloApi

# Créer le service systemd
echo "Création du service systemd..."
cat > /etc/systemd/system/dotnet-hello.service << 'EOF'
[Unit]
Description=Hello World .NET 8 API
After=network.target

[Service]
WorkingDirectory=/vagrant/publish
ExecStart=/snap/dotnet-sdk/current/dotnet /vagrant/publish/HelloApi.dll --urls http://0.0.0.0:5000
Restart=always
RestartSec=5
KillSignal=SIGINT
SyslogIdentifier=dotnet-hello
User=vagrant

[Install]
WantedBy=multi-user.target
EOF

# Recharger systemd
echo "Rechargement de systemd..."
systemctl daemon-reload

# Activer et démarrer le service
echo "Activation et démarrage du service dotnet-hello..."
systemctl enable dotnet-hello
systemctl start dotnet-hello

# Attendre que le service soit démarré
sleep 5

# Vérifier le statut du service
echo "Vérification du statut du service..."
systemctl status dotnet-hello --no-pager

echo "=== Provisioning terminé avec succès ! ==="
echo "API accessible sur http://localhost:5000"