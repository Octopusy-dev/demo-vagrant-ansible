# 🎯 Vagrant + Ansible - Infrastructure as Code

Cette approche utilise **Ansible** pour provisionner de manière déclarative une machine virtuelle Ubuntu avec une API .NET 8.

## 📋 Prérequis

- [Vagrant](https://www.vagrantup.com/downloads) installé
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads) installé
- 4 Go de RAM disponible

## 📁 Structure

```
vagrant-ansible/
├── Vagrantfile          # Configuration de la VM
└── scripts/
    └── provision.yml    # Playbook Ansible
```

## 🚀 Utilisation

```bash
# Démarrer la VM avec provisioning Ansible
vagrant up

# API accessible sur http://localhost:5000

# Se connecter à la VM
vagrant ssh

# Arrêter la VM
vagrant halt

# Supprimer la VM
vagrant destroy
```

## ⚙️ Configuration Ansible

Le playbook `provision.yml` effectue les tâches suivantes :

1. **Mise à jour système** : `apt update`
2. **Installation des dépendances** : wget, apt-transport-https
3. **Configuration du repository Microsoft**
4. **Installation de .NET SDK 8** 
5. **Création du projet WebAPI**
6. **Configuration du service systemd**
7. **Démarrage automatique du service**

## ✅ Avantages de l'approche Ansible

- **📝 Déclaratif** : Décrit l'état souhaité plutôt que les étapes
- **🔄 Idempotent** : Peut être exécuté plusieurs fois sans effet de bord
- **📚 Lisible** : Syntaxe YAML claire et structurée
- **🎯 Reproductible** : Résultats cohérents sur différents environnements
- **🛠️ Modulaire** : Réutilisable et facilement extensible

## 🔍 Vérification

```bash
# Dans la VM
vagrant ssh

# Vérifier le service
sudo systemctl status dotnet-hello

# Voir les logs
journalctl -u dotnet-hello -f

# Tester l'API
curl http://localhost:5000
```

## 🔧 Personnalisation

Pour modifier le provisioning, éditez le fichier `scripts/provision.yml` et relancez :

```bash
vagrant provision
```