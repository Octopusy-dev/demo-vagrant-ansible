# 🔧 Vagrant + Shell - Approche Traditionnelle

Cette approche utilise un **script bash** pour provisionner une machine virtuelle Ubuntu avec une API .NET 8 de manière procédurale.

## 📋 Prérequis

- [Vagrant](https://www.vagrantup.com/downloads) installé
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads) installé
- 4 Go de RAM disponible

## 📁 Structure

```
vagrant-shell/
├── Vagrantfile          # Configuration de la VM
└── scripts/
    └── provision.sh     # Script de provisioning bash
```

## 🚀 Utilisation

```bash
# Démarrer la VM avec provisioning Shell
vagrant up

# API accessible sur http://localhost:5000

# Se connecter à la VM
vagrant ssh

# Arrêter la VM
vagrant halt

# Supprimer la VM
vagrant destroy
```

## ⚙️ Script de provisioning

Le script `provision.sh` effectue les étapes suivantes :

1. **Mise à jour système** : `apt update && apt upgrade`
2. **Installation des dépendances** : wget, curl, apt-transport-https
3. **Configuration du repository Microsoft**
4. **Installation de .NET SDK 8** via snap
5. **Création du projet WebAPI** avec `dotnet new webapi`
6. **Génération du code Program.cs** personnalisé
7. **Publication de l'API** en mode Release
8. **Configuration du service systemd** pour auto-démarrage
9. **Démarrage du service**

## ✅ Avantages de l'approche Shell

- **🚀 Simple** : Syntaxe bash familière
- **⚡ Rapide** : Exécution directe sans overhead
- **🎯 Direct** : Contrôle total sur chaque commande
- **📦 Autonome** : Aucune dépendance externe (bash disponible partout)
- **🔍 Transparent** : Facile à déboguer ligne par ligne

## ⚠️ Limitations

- **❌ Non-idempotent** : Nécessite des vérifications manuelles
- **🔧 Difficile à maintenir** : Pour des configurations complexes
- **🐛 Sujet aux erreurs** : Gestion manuelle des cas d'échec
- **📝 Moins lisible** : Logique procédurale vs déclarative

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

# Vérifier les processus .NET
ps aux | grep dotnet
```

## 🔧 Personnalisation

Pour modifier le provisioning, éditez le fichier `scripts/provision.sh` et relancez :

```bash
vagrant provision
```

## 📊 Comparaison avec Ansible

| Aspect | Shell Script | Ansible |
|--------|-------------|---------|
| Simplicité | ✅ Très simple | ❌ Plus complexe |
| Idempotence | ❌ Manuelle | ✅ Automatique |
| Lisibilité | ❌ Procédurale | ✅ Déclarative |
| Maintenance | ❌ Difficile | ✅ Facile |
| Debugging | ✅ Direct | ❌ Plus complexe |