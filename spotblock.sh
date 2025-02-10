#!/bin/bash

# Spotify Ad Blocker Script
# This script modifies the hosts file to block Spotify advertisements

# Spotify app bundle identifier
SPOTIFY_BUNDLE_ID="com.spotify.client"

# Error handling
set -e
trap 'echo "Error occurred. Exiting..." >&2' ERR

# Check for root privileges
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root (sudo)" >&2
    exit 1
fi

# Platform detection
is_windows() {
    [[ "$OSTYPE" == "msys"* || "$OSTYPE" == "cygwin"* ]]
}

# Function to get hosts file location
get_hosts_file() {
    if is_windows; then
        echo "/c/Windows/System32/drivers/etc/hosts"
    else
        echo "/etc/hosts"
    fi
}

# Function to check if Spotify is running
is_spotify_running() {
    if is_windows; then
        tasklist | grep -i "Spotify.exe" > /dev/null
    else
        pgrep -x "Spotify" > /dev/null
    fi
    return $?
}

block_spotify_ads() {
    local hosts_file=$(get_hosts_file)
    # Comprehensive list of known Spotify ad domains
    local ad_domains=(
        # Primary Ad Domains
        "pubads.g.doubleclick.net"
        "googleads.g.doubleclick.net"
        "ads.spotify.com"
        "ads-fa.spotify.com"
        "adstudio.spotify.com"
        "adeventtracker.spotify.com"
        
        # Audio Ad Domains
        "audio-sp-*.spotify.com"
        "audio-fa.spotify.com"
        "audio-ak.spotify.com"
        "audio-akp-*.spotify.com"
        "audio-cf.spotify.com"
        "audio-akp-bbr-spotify-com.akamaized.net"
        "heads-akp.spotify.com"
        "audio-gc.scdn.co"
        "audio-fa.scdn.co"
        "audio-sp.scdn.co"
        "audio-akp.scdn.co"
        "promoted.spotify.com"
        "ad.spotify.com"
        "adstudio.spotify.com"
        "adeventtracker.spotify.com"
        "ads-fa.spotify.com"
        "heads-fa.spotify.com"
        "heads4.spotify.com"
        "media-match.com"
        "omaze.com"
        "analytics.spotify.com"
        "log.spotify.com"
        "pixel.spotify.com"
        "pixel-static.spotify.com"
        "crashdump.spotify.com"
        
        # CDN and Delivery Networks
        "audio-ak-spotify-com.akamaized.net"
        "heads-ak-spotify-com.akamaized.net"
        "audio-sp-*.pscdn.co"
        "audio-sp-*.spotifycdn.net"
        "audio-gc.scdn.co"
        "audio-fa.scdn.co"
        "audio-sp.scdn.co"
        "audio-akp.scdn.co"
        "*.akamaized.net"
        "*.fastly.net"
        "*.cloudfront.net"
        
        # Analytics and Tracking
        "analytics.spotify.com"
        "log.spotify.com"
        "pixel.spotify.com"
        "pixel-static.spotify.com"
        "crashdump.spotify.com"
        "weblb-wg.gslb.spotify.com"
        
        # Other Ad-related
        "media-match.com"
        "omaze.com"
        "promoted.spotify.com"
    )

    # Remove duplicates and domains needed for music playback
    # Removed: spclient.wg.spotify.com, audio2.spotify.com, audio4.spotify.com

    local hosts_file="/etc/hosts"
    local backup_dir="$HOME/.spotify_adblock_backups"
    local backup_file="$backup_dir/hosts_backup_$(date +%Y%m%d_%H%M%S)"

    # Create backup directory if it doesn't exist
    mkdir -p "$backup_dir"

    # Backup the hosts file with timestamp
    echo "Creating backup of hosts file at $backup_file"
    cp "$hosts_file" "$backup_file"

    # Add header to identify our modifications
    echo -e "\n# Spotify Ad Blocking (Added $(date))" >> "$hosts_file"

    # Add ad domains to the hosts file
    for domain in "${ad_domains[@]}"; do
        if ! grep -q "$domain" "$hosts_file"; then
            echo "127.0.0.1 $domain" >> "$hosts_file"
            echo "Blocking: $domain"
        fi
    done

    echo -e "\nSpotify ad blocking has been applied."
    echo "Please restart Spotify for changes to take effect."
    echo "Backup saved at: $backup_file"
}

# Function to restore the hosts file
restore_hosts_file() {
    local backup_dir="$HOME/.spotify_adblock_backups"
    
    if [ ! -d "$backup_dir" ]; then
        echo "No backups found." >&2
        exit 1
    fi

    # Get the most recent backup
    local latest_backup=$(ls -t "$backup_dir"/hosts_backup_* 2>/dev/null | head -n1)

    if [ -z "$latest_backup" ]; then
        echo "No backup files found in $backup_dir" >&2
        exit 1
    fi

    echo "Restoring from backup: $latest_backup"
    cp "$latest_backup" "/etc/hosts"
    echo "Hosts file has been restored."
}

# Function to show current status
show_status() {
    if is_spotify_running; then
        echo "Spotify is currently running."
    else
        echo "Spotify is not running."
    fi

    # Check if any ad domains are currently blocked
    if grep -q "# Spotify Ad Blocking" "/etc/hosts"; then
        echo "Ad blocking is currently active."
        echo "Number of blocked domains: $(grep -c "spotify" "/etc/hosts")"
    else
        echo "Ad blocking is not active."
    fi
}

# Function to clear Spotify cache
clear_spotify_cache() {
    if is_windows; then
        local cache_dir="$APPDATA/Spotify/Data"
    else
        local cache_dir="$HOME/Library/Application Support/Spotify/PersistentCache"
    fi

    if [ -d "$cache_dir" ]; then
        echo "Clearing Spotify cache at: $cache_dir"
        rm -rf "$cache_dir"
        mkdir -p "$cache_dir"
        echo "Cache cleared successfully."
    else
        echo "Spotify cache directory not found."
    fi
}

# Main script logic
case "$1" in
    "block")
        block_spotify_ads
        ;;
    "restore")
        restore_hosts_file
        ;;
    "status")
        show_status
        ;;
    "clear-cache")
        clear_spotify_cache
        ;;
    *)
        echo "Usage: $0 [block|restore|status|clear-cache]" >&2
        echo "  block       - Block Spotify ads by modifying hosts file"
        echo "  restore     - Restore hosts file from backup"
        echo "  status      - Show current Spotify and ad blocking status"
        echo "  clear-cache - Clear Spotify cache directory"
        exit 1
        ;;
esac

exit 0