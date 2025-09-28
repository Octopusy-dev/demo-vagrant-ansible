# Utiliser une image Ubuntu avec .NET 8 SDK
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

WORKDIR /app

# Installer dépendances si nécessaire
RUN apt-get update && \
    apt-get install -y wget apt-transport-https software-properties-common && \
    rm -rf /var/lib/apt/lists/*

# Créer le projet API
RUN dotnet new webapi -o HelloApi --no-https

# Remplacer Program.cs pour Hello World minimal
RUN echo 'var builder = WebApplication.CreateBuilder(args);\n\
var app = builder.Build();\n\
app.MapGet("/", () => "Hello World from .NET 8 + Docker on port 5001!");\n\
app.Run();' > HelloApi/Program.cs

# Travailler dans le projet
WORKDIR /app/HelloApi

# Exposer le port 5001
EXPOSE 5001

# Lancer l’API sur le port 5001
ENTRYPOINT ["dotnet", "run", "--urls", "http://0.0.0.0:5001"]
