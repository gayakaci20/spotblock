# 🚫🎵 SpotBlock - Spotify Ad Blocker  

A **Bash script** that **blocks Spotify ads** by modifying your system's `hosts` file. Simple, effective, and easy to use!  

## 🔧 Installation  

1️⃣ **Clone or download** this repository 📂  
2️⃣ **Make the script executable**:  
   ```bash
   chmod +x spotblock.sh
   ```

## 🚀 Usage  

The script **requires root privileges (sudo)** and supports the following commands:  

```bash
# Block Spotify ads 🚫
sudo ./spotblock.sh block  

# Restore the original hosts file 🔄
sudo ./spotblock.sh restore  

# Check Spotify and ad-blocking status 🔍
sudo ./spotblock.sh status  
```

## ⚙️ How It Works  

🛠️ **SpotBlock** modifies the `/etc/hosts` file, redirecting **Spotify ad domains** to `127.0.0.1`.  
🚫 This prevents ads from loading while you enjoy your music.  

## 🔴 Important Notes  

✅ **Automatic backup** 🗂️: The script **creates a backup** of the `hosts` file before making any changes.  
✅ **Restart required** 🔄: After blocking ads, **Spotify must be restarted** for the changes to take effect.  
✅ **Updates needed** 🔄: Spotify may change its ad domains, so periodic **updates** to the blocklist may be required.  

## ⚠️ Disclaimer  

📢 **This script is provided for educational purposes only.** Modifying system files may have unintended consequences. **Use at your own risk.**  
📡 **Spotify may update its system to bypass this method,** so effectiveness may vary over time.  

## 📜 License  

📝 **MIT License** - Open-source project, free to use and modify.
