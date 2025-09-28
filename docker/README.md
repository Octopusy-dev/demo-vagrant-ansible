# Todo App Complète - Angular + .NET + MySQL + Docker

Une application Todo complète avec interface utilisateur Angular, API REST .NET 8, base de données MySQL, le tout conteneurisé avec Docker.

## 🚀 Fonctionnalités

- **Interface utilisateur Angular** moderne et réactive
- **CRUD complet** sur les tâches (TodoItems)
- **API REST .NET 8** avec validation et gestion d'erreurs
- **Base de données MySQL** avec Entity Framework Core
- **Swagger/OpenAPI** pour la documentation API
- **Docker Compose** pour l'orchestration complète
- **PhpMyAdmin** pour la gestion de la base de données
- **CORS configuré** pour la communication Angular ↔ API

## 📋 Prérequis

- [Docker](https://www.docker.com/get-started) installé
- [Docker Compose](https://docs.docker.com/compose/install/) installé

## 🔧 Installation et lancement

### Méthode 1 : Docker Compose (Recommandée)

```bash
# Cloner et aller dans le dossier docker
cd docker

# Lancer tous les services
docker-compose up -d

# Voir les logs
docker-compose logs -f todoapi
```

### Méthode 2 : Docker manuel

```bash
# Construire l'image API
docker build -f Dockerfile.new -t todo-api .

# Lancer MySQL
docker run -d --name mysql-db \
  -e MYSQL_ROOT_PASSWORD=rootpassword \
  -e MYSQL_DATABASE=todoapi \
  -p 3306:3306 mysql:8.0

# Lancer l'API
docker run -d --name todo-api-container \
  --link mysql-db:mysql \
  -p 5000:5000 todo-api
```

## 🌐 Accès aux services

| Service | URL | Description |
|---------|-----|-------------|
| **Application Angular** | http://localhost:3000 | Interface utilisateur web |
| **API** | http://localhost:5000 | API REST principale |
| **Swagger** | http://localhost:5000/swagger | Documentation interactive |
| **PhpMyAdmin** | http://localhost:8080 | Interface de gestion MySQL |

### Connexion PhpMyAdmin
- **Serveur** : `mysql`
- **Utilisateur** : `root`
- **Mot de passe** : `rootpassword`

## 📡 Endpoints API

### Tâches (TodoItems)

| Méthode | Endpoint | Description |
|---------|----------|-------------|
| `GET` | `/api/todos` | Récupérer toutes les tâches |
| `GET` | `/api/todos/{id}` | Récupérer une tâche par ID |
| `POST` | `/api/todos` | Créer une nouvelle tâche |
| `PUT` | `/api/todos/{id}` | Mettre à jour une tâche |
| `DELETE` | `/api/todos/{id}` | Supprimer une tâche |

### Autres endpoints
- `GET` `/` - Status de l'API
- `GET` `/health` - Vérification de santé

## 🎨 Utilisation de l'interface Angular

Une fois tous les services démarrés, ouvrez votre navigateur et rendez-vous sur :
**http://localhost:3000**

### Fonctionnalités de l'interface :

- ✅ **Ajouter une tâche** : Formulaire avec validation (titre obligatoire, description optionnelle)
- ✅ **Lister les tâches** : Affichage en temps réel avec statistiques
- ✅ **Marquer comme terminée** : Cliquez sur la checkbox pour basculer le statut
- ✅ **Supprimer une tâche** : Bouton de suppression avec confirmation
- ✅ **Interface responsive** : Fonctionne sur desktop et mobile
- ✅ **Gestion des erreurs** : Messages d'erreur et de succès
- ✅ **Actualisation auto** : La liste se met à jour automatiquement

## 🧪 Tests avec curl

### Créer une tâche
```bash
curl -X POST "http://localhost:5000/api/todos" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Ma première tâche",
    "description": "Description de ma tâche",
    "isCompleted": false
  }'
```

### Récupérer toutes les tâches
```bash
curl -X GET "http://localhost:5000/api/todos"
```

### Récupérer une tâche par ID
```bash
curl -X GET "http://localhost:5000/api/todos/1"
```

### Mettre à jour une tâche
```bash
curl -X PUT "http://localhost:5000/api/todos/1" \
  -H "Content-Type: application/json" \
  -d '{
    "id": 1,
    "title": "Tâche modifiée",
    "description": "Description mise à jour",
    "isCompleted": true
  }'
```

### Supprimer une tâche
```bash
curl -X DELETE "http://localhost:5000/api/todos/1"
```

## 🗂️ Structure du projet

```
docker/
├── TodoAngularApp/              # Application Angular
│   ├── src/
│   │   ├── app/
│   │   │   ├── components/      # Composants Angular
│   │   │   │   ├── todo-list/
│   │   │   │   ├── todo-item/
│   │   │   │   └── todo-form/
│   │   │   ├── models/          # Modèles TypeScript
│   │   │   ├── services/        # Services Angular
│   │   │   ├── app.component.ts
│   │   │   └── app.module.ts
│   │   ├── index.html
│   │   └── styles.css
│   ├── package.json             # Dépendances Node.js
│   ├── angular.json             # Configuration Angular
│   ├── tsconfig.json            # Configuration TypeScript
│   └── nginx.conf               # Configuration Nginx
├── TodoApi/                     # Code source de l'API
│   ├── Controllers/
│   │   └── TodosController.cs   # Contrôleur CRUD
│   ├── Data/
│   │   └── TodoContext.cs       # Contexte Entity Framework
│   ├── Models/
│   │   └── TodoItem.cs          # Modèle de données
│   ├── Program.cs               # Point d'entrée avec CORS
│   ├── TodoApi.csproj           # Fichier projet
│   └── appsettings.json         # Configuration
├── docker-compose.yml           # Orchestration complète (4 services)
├── Dockerfile.new               # Image Docker pour l'API
├── Dockerfile.angular           # Image Docker pour Angular
├── init.sql                     # Script d'initialisation MySQL
└── README.md                    # Ce fichier
```

## 🛠️ Commandes utiles

```bash
# Voir le statut des conteneurs
docker-compose ps

# Redémarrer un service
docker-compose restart todoapi

# Voir les logs d'un service
docker-compose logs mysql
docker-compose logs todoapi

# Accéder au conteneur MySQL
docker-compose exec mysql mysql -u root -p

# Arrêter tous les services
docker-compose down

# Supprimer tout (y compris les volumes)
docker-compose down -v
```

## 🔍 Dépannage

### L'API ne se connecte pas à MySQL
1. Vérifier que MySQL est démarré : `docker-compose logs mysql`
2. Attendre que le healthcheck soit OK
3. Vérifier la chaîne de connexion dans `appsettings.json`

### Erreur "port already in use"
```bash
# Changer les ports dans docker-compose.yml ou arrêter les services conflictuels
docker-compose down
```

### Réinitialiser complètement
```bash
# Supprimer tout et recommencer
docker-compose down -v
docker system prune -f
docker-compose up -d
```

## 📊 Base de données

La base de données `todoapi` contient une table `TodoItems` avec :

- `Id` (int, auto-increment, clé primaire)
- `Title` (varchar(200), requis)
- `Description` (varchar(1000), optionnel)
- `IsCompleted` (boolean, défaut: false)
- `CreatedAt` (datetime, défaut: NOW())
- `UpdatedAt` (datetime, nullable)

Entity Framework crée automatiquement la base de données et les tables au premier lancement.