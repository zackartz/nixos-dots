#!/usr/bin/env bash

# Generate client keys
wg genkey | tee client-private.key | wg pubkey >client-public.key

# Get the keys
CLIENT_PRIVATE_KEY=$(cat client-private.key)
CLIENT_PUBLIC_KEY=$(cat client-public.key)
SERVER_PUBLIC_KEY=$(sudo cat /home/zoey/wg-keys/private | wg pubkey)

# Your server's public IP
SERVER_IP="66.227.177.15"

# Create the client configuration
cat >wg0-client.conf <<EOF
[Interface]
PrivateKey = ${CLIENT_PRIVATE_KEY}
Address = 10.100.0.2/24
DNS = 1.1.1.1

[Peer]
PublicKey = ${SERVER_PUBLIC_KEY}
Endpoint = ${SERVER_IP}:51820
AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 25
EOF

echo "Client Public Key (add this to your server config):"
echo ${CLIENT_PUBLIC_KEY}
