#!/usr/bin/env bash
set -euo pipefail

# Ensure running as root
if [ "$(id -u)" -ne 0 ]; then
    echo -e "\033[31m[!] This script must be run as root (or with sudo).\033[0m" >&2
    exit 1
fi

echo -e "\033[36m[*] Preparing system dependencies...\033[0m"
apt-get update -qq
apt-get install -y -qq curl git make ca-certificates

# Check if salt-call is already installed
if command -v salt-call >/dev/null 2>&1; then
    echo -e "\033[32m[+] SaltStack is already installed ($(salt-call --version)).\033[0m"
else
    echo -e "\033[36m[*] Bootstrapping SaltStack in masterless mode...\033[0m"
    TMP_BOOTSTRAP=$(mktemp /tmp/install_salt.XXXXXX.sh)
    curl -fsSL https://github.com/saltstack/salt-bootstrap/releases/latest/download/bootstrap-salt.sh -o "$TMP_BOOTSTRAP"
    
    # Flags:
    #   -P: allow onedir/pip package installation
    #   -X: do not start the salt-minion daemon (standalone masterless mode)
    sh "$TMP_BOOTSTRAP" -P -X
    rm -f "$TMP_BOOTSTRAP"
fi

# Configure masterless standalone mode
echo -e "\033[36m[*] Configuring local masterless minion settings...\033[0m"
mkdir -p /etc/salt/minion.d
cat << 'EOF' > /etc/salt/minion.d/local.conf
# Masterless standalone mode
file_client: local
file_roots:
  base:
    - /srv/salt
EOF

# Ensure salt-minion daemon is disabled so it doesn't poll for a master
if systemctl is-active --quiet salt-minion 2>/dev/null; then
    systemctl stop salt-minion
    systemctl disable salt-minion
fi

echo -e "\033[32m[+] Machine ready! You can now run 'make dry-run' or 'make apply'.\033[0m"
