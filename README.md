# 🚀 Démos DevOps - Approches Modernes de Déploiement

Ce projet démontre différentes approches pour déployer une application Todo full-stack (.NET 8 + Angular 17 + MySQL) :

## 📁 Structure du projet

```
├── README.md                    # Ce fichier
├── docker/                      # 🐳 Application Docker complète
│   ├── TodoApi/                 # API .NET 8 avec Entity Framework
│   ├── TodoAngularApp/          # Interface Angular 17 + Bootstrap
│   ├── docker-compose.yml       # Orchestration multi-services
│   ├── Dockerfile.new           # Image Docker API
│   ├── Dockerfile.angular       # Image Docker Angular
│   └── README.md               # Documentation détaillée
└── vagrants/                    # 🎯 Approches Vagrant
    ├── vagrant-ansible/         # Infrastructure as Code avec Ansible
    │   ├── Vagrantfile          # Configuration VM Ubuntu
    │   ├── README.md            # Documentation Ansible
    │   └── scripts/
    │       └── provision.yml    # Playbook Ansible
    └── vagrant-shell/           # Approche Shell traditionnelle
        ├── Vagrantfile          # Configuration VM Ubuntu  
        ├── README.md            # Documentation Shell
        └── scripts/
            └── provision.sh     # Script de provisioning
```

# ☁️ GitHub Codespaces (Développement Cloud)

**GitHub Codespaces** permet de développer directement dans le cloud sans installation locale.

## 🚀 Démarrage avec Codespaces

1. **Créer un Codespace** :
   - Cliquez sur le bouton **"Code"** > **"Codespaces"** > **"Create codespace on main"**
   - Ou utilisez ce lien : `https://github.com/Octopusy-dev/demo-vagrant-ansible/codespaces`

2. **Environnement automatique** :
   - Docker pre-installé dans le Codespace
   - VS Code intégré dans le navigateur
   - Terminaux disponibles

3. **Lancer l'application** :
```bash
# Dans le terminal du Codespace
cd docker
docker-compose up -d --build

# Les ports seront automatiquement forwardés
# Interface Angular : sur port 3000 (forwarded)
# API REST : sur port 5000 (forwarded)
# phpMyAdmin : sur port 8080 (forwarded)
```

### ✅ Avantages Codespaces
- ⚡ **Démarrage instantané** : Pas d'installation nécessaire
- 🌐 **Accessible partout** : Depuis n'importe quel navigateur
- 🔄 **Synchronisation automatique** : Changements sauvés dans le cloud
- 💻 **Environnement cohérent** : Même configuration pour toute l'équipe
- 🆓 **Gratuit** : 120h/mois incluses avec GitHub

# 🐳 Approche Docker Compose 
**L'approche Docker dans le dossier `docker/` est la plus aboutie** et inclut :

- ✅ **Frontend Angular 17** avec interface utilisateur moderne
- ✅ **Backend .NET 8** avec API REST complète  
- ✅ **Base de données MySQL** avec persistance
- ✅ **phpMyAdmin** pour administration
- ✅ **Architecture microservices** avec Docker Compose
- ✅ **CORS configuré** pour communication frontend-backend

## 🚀 Démarrage rapide (Docker)

```bash
# Aller dans le dossier Docker
cd docker

# Lancer toute l'application (4 services)
docker-compose up -d --build

# Accéder à l'interface web complète
# 🌐 Interface Angular : http://localhost:3000
# 📡 API REST : http://localhost:5000  
# 🗄️ phpMyAdmin : http://localhost:8080
```

### 📋 Prérequis Docker
- [Docker Desktop](https://www.docker.com/products/docker-desktop) installé
- 4 Go de RAM disponible




# 🎯 Approches Vagrant (Apprentissage)

Les approches Vagrant sont idéales pour **comprendre l'Infrastructure as Code** et les **machines virtuelles**.

## 🚀 Démarrage avec Vagrant

### 📋 Prérequis Vagrant
- [Vagrant](https://www.vagrantup.com/downloads) installé
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads) installé  
- 4 Go de RAM disponible pour la VM

### Version Ansible (Infrastructure as Code)

```bash
# Aller dans le dossier Ansible
cd vagrants/vagrant-ansible

# Démarrer la VM avec provisioning Ansible
vagrant up

# API accessible sur http://localhost:5000
```

### Version Shell (Scripting traditionnel)

```bash
# Aller dans le dossier Shell
cd vagrants/vagrant-shell

# Démarrer la VM avec provisioning Shell  
vagrant up

# API accessible sur http://localhost:5000
```

# 📊 Comparaison des approches

| Aspect | 🐳 Docker | ☁️ Codespaces | 🎯 Ansible | 🔧 Shell |
|--|--|--||-|
| **Setup** | Local install | ✅ **Zéro install** | Local install | Local install |
| **Application** | ✅ **Full-stack** | ✅ **Full-stack** | API basique | API basique |
| **Frontend** | ✅ Angular 17 | ✅ Angular 17 | ❌ Aucun | ❌ Aucun |
| **Base de données** | ✅ MySQL + Admin | ✅ MySQL + Admin | ❌ Aucune | ❌ Aucune |
| **Portabilité** | ✅ Multi-OS | ✅ **Navigateur** | Linux uniquement | Linux uniquement |
| **Collaboration** | Local | ✅ **Partageable** | Local | Local |
| **Ressources** | 4 Go RAM | ☁️ **Cloud** | 4 Go RAM | 4 Go RAM |
| **Temps setup** | ~5 min install | ⚡ **Instantané** | ~5-10 minutes | ~5-8 minutes |
| **Internet requis** | Setup uniquement | ✅ **Toujours** | Setup uniquement | Setup uniquement |
| **Coût** | Gratuit | 120h/mois gratuit | Gratuit | Gratuit |

## 🛠️ Ce que fait chaque approche

### 🐳 **Docker Compose** (Application complète - RECOMMANDÉ)

Déploie une **application Todo full-stack** avec :
- **Frontend Angular 17** : Interface utilisateur moderne avec Bootstrap
- **Backend .NET 8** : API REST avec CRUD complet et Entity Framework  
- **MySQL 8.0** : Base de données relationnelle avec migrations
- **phpMyAdmin** : Interface d'administration de la base
- **Nginx** : Serveur web pour servir l'application Angular
- **CORS configuré** : Communication seamless frontend ↔ backend

### 🎯 **Vagrant + Ansible** (Infrastructure as Code)

Provisionne une VM Ubuntu avec une API .NET basique :
1. Met à jour le système et installe les dépendances
2. Configure le repository Microsoft pour .NET
3. Installe .NET SDK 8  
4. Crée un projet WebAPI minimal
5. Configure un service systemd pour l'auto-démarrage

### 🔧 **Vagrant + Shell** (Approche traditionnelle)

Même résultat qu'Ansible mais avec scripting bash :
1. **Met à jour le système** : `apt update`
2. **Installe les dépendances** : wget, apt-transport-https
3. **Configure le repository Microsoft** pour .NET  
4. **Installe .NET SDK 8** via snap
5. **Crée le projet API** : `dotnet new webapi`
6. **Configure un service systemd** pour auto-démarrage

## 🎮 Fonctionnalités de l'application Docker

### 🌐 Interface utilisateur Angular
- **Gestion complète des todos** : Ajouter, modifier, supprimer
- **Interface Bootstrap responsive** 
- **Communication temps réel** avec l'API REST
- **Formulaires réactifs** avec validation

### 📡 API REST .NET 8  
- **CRUD complet** : GET, POST, PUT, DELETE
- **Entity Framework Core** avec MySQL
- **Documentation Swagger** automatique
- **CORS configuré** pour Angular
- **Migrations automatiques** de base de données

### 🗄️ Base de données MySQL
- **Persistance des données** entre redémarrages
- **Initialisation automatique** avec données de test
- **Administration via phpMyAdmin**

## 🔧 Commandes utiles

### Docker
```bash
# Dans le dossier docker/
docker-compose up -d --build    # Démarrer tous les services
docker-compose down             # Arrêter tous les services  
docker-compose logs -f          # Voir les logs en temps réel
docker-compose ps               # Statut des services
docker-compose restart api      # Redémarrer un service spécifique
```

### Codespaces
```bash
# Dans le terminal du Codespace (Docker pré-installé)
cd docker
docker-compose up -d --build    # Démarrer l'application
# Les ports sont automatiquement forwardés vers des URLs publiques
```

### Vagrant
```bash  
# Dans vagrants/vagrant-ansible/ ou vagrants/vagrant-shell/
vagrant status          # Voir le statut de la VM
vagrant ssh             # Se connecter en SSH  
vagrant reload          # Redémarrer la VM
vagrant provision       # Re-exécuter le provisioning
vagrant halt            # Arrêter la VM
vagrant destroy         # Supprimer la VM
```

## 🔍 Vérification et débogage

### Pour Docker / Codespaces
```bash
# Vérifier le statut de tous les services
docker-compose ps

# Logs d'un service spécifique
docker logs todo-api
docker logs todo-angular-app
docker logs todo-mysql

# Accéder à la base MySQL
docker exec -it todo-mysql mysql -u root -p
```

### Pour Vagrant (VM)
```bash
# Se connecter à la VM (depuis vagrants/vagrant-ansible/ ou vagrants/vagrant-shell/)
vagrant ssh

# Vérifier le service .NET
sudo systemctl status dotnet-hello

# Voir les logs du service
journalctl -u dotnet-hello -f
```

## 📚 Documentation détaillée

- **[📖 README Docker](./docker/README.md)** - Guide complet de l'application full-stack
- **[📖 README Ansible](./vagrants/vagrant-ansible/README.md)** - Configuration Ansible détaillée  
- **[📖 README Shell](./vagrants/vagrant-shell/README.md)** - Scripts de provisioning

## 🎯 Recommandations par cas d'usage

### 🚀 **Pour débuter rapidement** : GitHub Codespaces
- ✅ **Zéro installation** : Fonctionne dans le navigateur
- ✅ **Environnement pré-configuré** : Docker déjà installé
- ✅ **Partage facile** : URL publique pour montrer le résultat
- ✅ **Idéal pour** : Démos, formations, tests rapides

### 🏗️ **Pour le développement local** : Docker Compose  
- ✅ **Environnement complet** : Application production-ready
- ✅ **Développement efficace** : Hot reload, debugging
- ✅ **Idéal pour** : Développement quotidien, CI/CD

### 🎓 **Pour l'apprentissage DevOps** : Vagrant
- ✅ **Compréhension IaC** : Infrastructure as Code concepts
- ✅ **Gestion VM** : Compétences système et réseau  
- ✅ **Idéal pour** : Formation, certification, concepts DevOps

## 🎯 Conclusion

Ce projet illustre l'évolution des pratiques de déploiement modernes :

1. **☁️ Cloud-first** (Codespaces) : Développement accessible et instantané
2. **🐳 Containerisation** (Docker) : Standard industriel moderne
3. **🎯 Infrastructure as Code** (Ansible) : Reproductibilité et versioning
4. **📜 Scripting traditionnel** (Shell) : Base fondamentale à maîtriser

**Conseil** : Commencez par **Codespaces** pour tester rapidement, puis adoptez **Docker** pour vos projets réels !

# Voir les logs
sudo journalctl -u dotnet-hello -f

# Tester l'API localement
curl http://localhost:5000
```

## Quand utiliser quoi ?

### Choisir **Ansible** si :
- Vous travaillez en équipe
- Vous avez une infrastructure complexe
- Vous voulez une approche déclarative
- Vous planifiez d'étendre le projet
- Vous aimez la structure et la réutilisabilité

### Choisir **Shell** si :
- Vous faites un prototype rapide
- Vous préférez la simplicité
- Vous travaillez seul sur un projet simple
- Vous voulez comprendre exactement ce qui se passe
- Vous avez des contraintes de dépendances

## Alternative Docker

Un `dockerfile` est également disponible dans le dossier parent :
```bash
# Revenir au dossier parent
cd ..

# Construire l'image Docker
docker build -t hello-dotnet .

# Lancer le conteneur
docker run -p 5001:5001 hello-dotnet
```

L'API Docker sera accessible sur http://localhost:5001