# Demo Vagrant - Ansible vs Shell

Ce projet démontre deux approches pour provisionner automatiquement une machine virtuelle Ubuntu avec une API .NET 8 :
- **Ansible** (déclaratif, structuré)  
- **Script Shell** (procédural, simple)

## Structure du projet

```
├── README.md                    # Ce fichier
├── vagrant-ansible/             # Version avec provisioning Ansible
│   ├── Vagrantfile
│   └── scripts/
│       └── provision.yml
├── vagrant-shell/               # Version avec provisioning Shell
│   ├── Vagrantfile
│   └── scripts/
│       └── provision.sh
├── dockerfile                   # Alternative Docker (optionnel)
└── [anciens fichiers...]        # Fichiers de l'ancienne structure
```

## Prérequis

- [Vagrant](https://www.vagrantup.com/downloads) installé
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads) installé
- Environ 4 Go de RAM disponible pour la VM

## Utilisation

### Version Ansible

```bash
# Aller dans le dossier Ansible
cd vagrant-ansible

# Démarrer la VM avec provisioning Ansible
vagrant up

# API accessible sur http://localhost:5000
```

### Version Shell

```bash
# Aller dans le dossier Shell
cd vagrant-shell

# Démarrer la VM avec provisioning Shell
vagrant up

# API accessible sur http://localhost:5000
```

## Comparaison des approches

| Aspect | Ansible | Script Shell |
|--------|---------|-------------|
| **Complexité** | Plus complexe, syntaxe YAML | Plus simple, bash standard |
| **Idempotence** | Intégrée (vérifie avant d'agir) | Manuelle (avec conditions if) |
| **Lisibilité** | Très structurée et déclarative | Procédurale, plus directe |
| **Maintenance** | Plus facile pour projets complexes | Plus facile pour scripts simples |
| **Dépendances** | Nécessite Ansible | Bash disponible partout |
| **Performances** | Peut être plus lent | Plus rapide à l'exécution |

## Ce que fait le provisioning

Les deux approches font exactement la même chose :

1. **Met à jour le système** : `apt update`
2. **Installe les dépendances** : wget, apt-transport-https, software-properties-common
3. **Configure le repository Microsoft** pour .NET
4. **Installe .NET SDK 8** via snap
5. **Crée le projet API** : `dotnet new webapi`
6. **Génère un Program.cs minimal** avec endpoint Hello World
7. **Publie l'API** en mode Release
8. **Configure un service systemd** pour auto-démarrage
9. **Démarre le service** automatiquement

## Commandes utiles

```bash
# Dans n'importe quel dossier (ansible ou shell)
vagrant status          # Voir le statut de la VM
vagrant ssh             # Se connecter en SSH
vagrant reload          # Redémarrer la VM
vagrant provision       # Re-exécuter le provisioning
vagrant halt            # Arrêter la VM
vagrant destroy         # Supprimer la VM
```

## Vérification dans la VM

```bash
# Se connecter à la VM
vagrant ssh

# Vérifier le service
sudo systemctl status dotnet-hello

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