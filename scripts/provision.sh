#!/bin/bash
set -e

# Installer dépendances
apt-get update
apt-get install -y wget apt-transport-https software-properties-common

# Installer SDK .NET 8
wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
dpkg -i packages-microsoft-prod.deb
apt-get update
apt-get install -y dotnet-sdk-8.0

# Créer un projet API si inexistant
if [ ! -d /vagrant/HelloApi ]; then
  dotnet new webapi -o /vagrant/HelloApi --no-https
  # Modifier Program.cs pour un Hello World minimal
  echo 'var builder = WebApplication.CreateBuilder(args);
        var app = builder.Build();
        app.MapGet("/", () => "Hello World from .NET 8 + Vagrant!");
        app.Run();' > /vagrant/HelloApi/Program.cs
fi

# Lancer l’API en arrière-plan
cd /vagrant/HelloApi
nohup dotnet run --urls http://0.0.0.0:5000 > /vagrant/dotnet.log 2>&1 &
