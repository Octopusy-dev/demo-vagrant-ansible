# Demo Vagrant + Ansible

Ce projet démontre l'utilisation de Vagrant avec Ansible pour provisionner automatiquement une machine virtuelle Ubuntu avec une API .NET 8.

## Prérequis

- [Vagrant](https://www.vagrantup.com/downloads) installé
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads) installé
- Environ 4 Go de RAM disponible pour la VM

## Structure du projet

```
├── Vagrantfile          # Configuration de la VM Vagrant
├── dockerfile           # Alternative Docker (optionnel)
├── scripts/
│   ├── provision.yml    # Playbook Ansible pour le provisioning
│   └── provision.sh     # Script shell alternatif (si nécessaire)
└── publish/             # Dossier où sera publié l'API .NET (généré automatiquement)
```

## Utilisation

### 1. Démarrage de la VM avec provisioning Ansible

```bash
# Démarrer et provisionner la VM
vagrant up
```

Cette commande va :
- Télécharger l'image Ubuntu 20.04 LTS si nécessaire
- Créer la VM avec 4 Go de RAM et 2 CPUs
- Exécuter le playbook Ansible `scripts/provision.yml` qui :
  - Met à jour le système
  - Installe .NET SDK 8
  - Crée un projet API Hello World
  - Publie l'API en mode Release
  - Configure un service systemd pour l'API
  - Démarre l'API sur le port 5000

### 2. Accès à l'API

Une fois le provisioning terminé, l'API sera accessible sur :
```
http://localhost:5000
```

### 3. Commandes utiles

```bash
# Voir le statut de la VM
vagrant status

# Se connecter en SSH à la VM
vagrant ssh

# Redémarrer la VM
vagrant reload

# Re-exécuter le provisioning Ansible
vagrant provision

# Arrêter la VM
vagrant halt

# Supprimer la VM
vagrant destroy
```

### 4. Vérification du service dans la VM

```bash
# Se connecter à la VM
vagrant ssh

# Vérifier le statut du service
sudo systemctl status dotnet-hello

# Voir les logs du service
sudo journalctl -u dotnet-hello -f

# Redémarrer le service si nécessaire
sudo systemctl restart dotnet-hello
```

## Configuration Ansible

Le fichier `scripts/provision.yml` contient le playbook Ansible qui :

1. **Met à jour le système** : `apt update`
2. **Installe les dépendances** : wget, apt-transport-https, software-properties-common
3. **Configure le repository Microsoft** pour .NET
4. **Installe .NET SDK 8** via snap
5. **Crée le projet API** : `dotnet new webapi`
6. **Génère un Program.cs minimal** avec endpoint Hello World
7. **Publie l'API** en mode Release
8. **Configure un service systemd** pour auto-démarrage
9. **Démarre le service** automatiquement

## Redirection de ports

Le `Vagrantfile` configure une redirection du port 5000 de la VM vers le port 5000 de l'hôte :
```ruby
config.vm.network "forwarded_port", guest: 5000, host: 5000
```

## Dépannage

### Si la VM ne démarre pas
```bash
# Vérifier VirtualBox
VBoxManage --version

# Redémarrer avec plus de verbosité
vagrant up --debug
```

### Si Ansible échoue
```bash
# Re-exécuter seulement le provisioning
vagrant provision

# Se connecter et vérifier manuellement
vagrant ssh
```

### Si l'API n'est pas accessible
```bash
# Vérifier que le service fonctionne dans la VM
vagrant ssh
sudo systemctl status dotnet-hello
curl http://localhost:5000
```

## Alternative Docker

Un `dockerfile` est également fourni pour une approche alternative avec Docker :
```bash
# Construire l'image Docker
docker build -t hello-dotnet .

# Lancer le conteneur
docker run -p 5001:5001 hello-dotnet
```
