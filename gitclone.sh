#!/bin/bash
#bash setup_ssh.sh "your-email@example.com" "my_custom_key_name"
#EMAIL="user@email.com" KEY_NAME="work_key" bash setup_ssh.sh
# Check if arguments are provided; if not, use defaults or exit
EMAIL=${1:-"default@example.com"}
KEY_NAME=${2:-"id_rsa_ssh_key"}

echo "1. Generating SSH Key for $EMAIL..."
ssh-keygen -t ed25519 -C "$EMAIL" -f ~/.ssh/"$KEY_NAME" -N ""

echo "2. Starting SSH Agent..."
eval "$(ssh-agent -s)"

echo "3. Adding key to Agent..."
ssh-add ~/.ssh/"$KEY_NAME"

echo "4. Configuring SSH Config..."
# Append to config
cat <<EOF >> ~/.ssh/config

Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/$KEY_NAME
EOF

chmod 600 ~/.ssh/config

echo "-------------------------------------------------------"
echo "FINISHED: Copy the public key below and add it to your settings."
cat ~/.ssh/"$KEY_NAME".pub
echo "-------------------------------------------------------"