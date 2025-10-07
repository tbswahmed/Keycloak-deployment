#!/bin/bash

# Script to create self-signed certificates for Keycloak

# Create directory for certificates
mkdir -p certs

# Set variables
CERT_DAYS=365
COUNTRY="TN"
STATE="Tunis"
LOCALITY="Tunis"
ORGANIZATION="OTBS"
ORGANIZATIONAL_UNIT="IT"
COMMON_NAME="onetech-group.corp"  # Change this to your domain
#EMAIL="admin@example.com"       # Change to your email

# Generate self-signed certificate with non-interactive prompts
openssl req -newkey rsa:2048 -nodes \
  -keyout certs/key.pem \
  -x509 -sha256 -days $CERT_DAYS \
  -out certs/cert.pem \
  -subj "/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=$ORGANIZATION/OU=$ORGANIZATIONAL_UNIT/CN=$COMMON_NAME/emailAddress=$EMAIL"

# Adjust file permissions
chmod 644 certs/cert.pem
chmod 600 certs/key.pem

# Output certificates location and details
echo "Self-signed certificates created successfully!"
echo "Certificate location: $(pwd)/certs/cert.pem"
echo "Private key location: $(pwd)/certs/key.pem"
echo "Validity: $CERT_DAYS days"
echo "Common Name (CN): $COMMON_NAME"

# Display certificate information
echo -e "\nCertificate details:"
openssl x509 -in certs/cert.pem -text -noout | grep -E 'Subject:|Issuer:|Not Before:|Not After :|Subject Alternative Name:'

echo -e "\nTo use with Keycloak, run:"
echo "podman run --name keycloak \\"
echo "  -p 8443:8443 \\"
echo "  -e KEYCLOAK_ADMIN=admin \\"
echo "  -e KEYCLOAK_ADMIN_PASSWORD=admin_password \\"
echo "  -v $(pwd)/certs:/opt/keycloak/conf/certs:Z \\"
echo "  -e KC_HTTPS_CERTIFICATE_FILE=/opt/keycloak/conf/certs/cert.pem \\"
echo "  -e KC_HTTPS_CERTIFICATE_KEY_FILE=/opt/keycloak/conf/certs/key.pem \\"
echo "  keycloak-prod:v1"
