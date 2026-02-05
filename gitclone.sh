#!/bin/bash

# --- Configuration ---
EMAIL="your-email@example.com"
REPO_URL="git@github.com:username/repository.git" # Use the SSH URL, not HTTPS
KEY_NAME="id_rsa_aws_repo"

echo "1. Generating SSH Key..."
# -t specifies type, -b specifies bits, -C is a comment, -f is the filename, -N "" sets no passphrase
ssh-keygen -t ed25519 -C "$EMAIL" -f ~/.ssh/$KEY_NAME -N ""

echo "2. Starting SSH Agent..."
eval "$(ssh-agent -s)"

echo "3. Adding key to Agent..."
ssh-add ~/.ssh/$KEY_NAME

echo "4. Configuring SSH for GitHub/GitLab..."
# This ensures the server uses this specific key for this host
cat <<EOF >> ~/.ssh/config
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/$KEY_NAME
EOF

chmod 600 ~/.ssh/config

echo "-------------------------------------------------------"
echo "FINISHED: Copy the public key below and add it to your"
echo "repository provider's 'Deploy Keys' or 'SSH Keys' settings."
echo "-------------------------------------------------------"
cat ~/.ssh/$KEY_NAME.pub
echo "-------------------------------------------------------"

