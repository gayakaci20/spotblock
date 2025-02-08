# 🚫🎵 SpotBlock - Spotify Ad Blocker  

Un **script Bash** permettant de **bloquer les publicités Spotify** en modifiant le fichier `hosts` du système. Simple, efficace et rapide !  

## 🔧 Installation  

1️⃣ **Cloner ou télécharger** ce repository 📂  
2️⃣ **Rendre le script exécutable** :  
   ```bash
   chmod +x spotblock.sh
   ```

## 🚀 Utilisation  

Le script nécessite des **droits root (sudo)** et prend en charge les commandes suivantes :  

```bash
# Bloquer les publicités Spotify 🚫
sudo ./spotblock.sh block  

# Restaurer le fichier hosts original 🔄
sudo ./spotblock.sh restore  

# Vérifier le statut de Spotify et du blocage des pubs 🔍
sudo ./spotblock.sh status  
```

## ⚙️ Comment ça marche ?  

🛠️ **SpotBlock** modifie le fichier `/etc/hosts` en redirigeant les **domaines de publicité de Spotify** vers `127.0.0.1`.  
🚫 Cela empêche Spotify de charger les publicités.  

## 🔴 Points Importants  

✅ **Sauvegarde automatique** 🗂️ : Le script crée une **sauvegarde** du fichier `hosts` avant toute modification.  
✅ **Redémarrage nécessaire** 🔄 : Après le blocage des pubs, **Spotify doit être redémarré** pour appliquer les changements.  
✅ **Mises à jour requises** 🔄 : Spotify peut changer ses domaines publicitaires, nécessitant des **mises à jour** de la liste des domaines bloqués.  

## ⚠️ Avertissement  

📢 **Ce script est fourni à des fins éducatives uniquement.** Modifier les fichiers système peut avoir des conséquences imprévues. **Utilisation à vos propres risques.**  
📡 **Spotify peut modifier ses systèmes pour contourner ce blocage.** L'efficacité de cette méthode peut donc varier.  

## 📜 Licence  

📝 **MIT License** - Projet open-source, libre d'utilisation et de modification.  
