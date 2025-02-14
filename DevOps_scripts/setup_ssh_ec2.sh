#!/bin/bash

# Variables - Replace these with your actual values
EC2_USER="ubuntu"
EC2_HOST="13.246.43.23"
PEM_FILE_PATH="/mnt/c/Users/DAddy Hubbub/downloads/awsserver.pem"
LOCAL_PRIVATE_KEY_PATH="$HOME/.ssh/wslawsserver"
SSH_CONFIG_PATH="$HOME/.ssh/config"

# Ensure SSH directory exists
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

# Step 1: Initial SSH login using the downloaded .pem key
echo "Connecting to EC2 instance using initial .pem key..."
ssh -i "$PEM_FILE_PATH" "$EC2_USER@$EC2_HOST" << 'EOF'
  # Create .ssh directory and set permissions
  mkdir -p ~/.ssh
  chmod 700 ~/.ssh
EOF

# Step 2: Generate a new SSH key pair locally
echo "Generating new SSH key pair locally..."
ssh-keygen -t rsa -b 4096 -f "$LOCAL_PRIVATE_KEY_PATH" -N "" -q

# Step 3: Copy the public key to the EC2 instance's authorized_keys
echo "Copying public key to EC2 instance..."
PUBLIC_KEY_CONTENT=$(cat "${LOCAL_PRIVATE_KEY_PATH}.pub")
ssh -i "$PEM_FILE_PATH" "$EC2_USER@$EC2_HOST" "echo '$PUBLIC_KEY_CONTENT' >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"

# Step 4: Set local private key permissions
echo "Setting local private key permissions..."
chmod 600 "$LOCAL_PRIVATE_KEY_PATH"
chown $(whoami):$(whoami) "$LOCAL_PRIVATE_KEY_PATH"

# Step 5: Configure SSH config for easier login
echo "Configuring SSH for easier access..."
# Backup existing SSH config if it exists
if [ -f "$SSH_CONFIG_PATH" ]; then
  cp "$SSH_CONFIG_PATH" "${SSH_CONFIG_PATH}.bak_$(date +%Y%m%d%H%M%S)"
fi

# Add configuration
echo -e "\nHost aws\n\tHostName $EC2_HOST\n\tUser $EC2_USER\n\tIdentityFile $LOCAL_PRIVATE_KEY_PATH\n\tPasswordAuthentication no" >> "$SSH_CONFIG_PATH"

# Step 6: Add key to SSH agent
echo "Adding private key to SSH agent..."
eval "$(ssh-agent -s)" >/dev/null
ssh-add "$LOCAL_PRIVATE_KEY_PATH"

# Step 7: Test SSH connection without specifying key
echo "Testing SSH connection..."
ssh aws "echo 'SSH connection successful!'"

echo "SSH setup complete. You can now connect to your EC2 instance using 'ssh aws'."
