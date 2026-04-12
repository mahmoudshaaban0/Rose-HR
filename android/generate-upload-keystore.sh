#!/bin/bash

# Rose HR Upload Keystore Generation Script
# Best Practices Implementation
# - Uses PKCS12 format (modern standard)
# - 4096-bit RSA key (maximum security)
# - 10,000 day validity (~27 years)
# - Strong random passwords
# - Clear naming convention for multiple keystores

set -e

KEYSTORE_DIR="/Users/mahmoud/Desktop/Rose HR/rose_hr/android"
KEYSTORE_NAME="upload-keystore.jks"
KEYSTORE_PATH="${KEYSTORE_DIR}/${KEYSTORE_NAME}"
KEY_ALIAS="upload"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Rose HR Upload Keystore Generator ===${NC}"
echo ""

# Check if keystore already exists
if [ -f "$KEYSTORE_PATH" ]; then
    echo -e "${YELLOW}Warning: Keystore already exists at: ${KEYSTORE_PATH}${NC}"
    read -p "Do you want to overwrite it? (yes/no): " confirm
    if [ "$confirm" != "yes" ]; then
        echo "Aborted."
        exit 1
    fi
    rm -f "$KEYSTORE_PATH"
fi

# Generate strong random passwords (24 characters, alphanumeric)
STORE_PASSWORD=$(openssl rand -base64 32 | tr -dc 'A-Za-z0-9' | head -c24)
KEY_PASSWORD=$(openssl rand -base64 32 | tr -dc 'A-Za-z0-9' | head -c24)

echo -e "${GREEN}Generating keystore...${NC}"
echo ""

# Generate the keystore
keytool -genkeypair \
  -v \
  -storetype PKCS12 \
  -keystore "$KEYSTORE_PATH" \
  -alias "$KEY_ALIAS" \
  -keyalg RSA \
  -keysize 4096 \
  -validity 10000 \
  -storepass "$STORE_PASSWORD" \
  -keypass "$KEY_PASSWORD" \
  -dname "CN=Rose Holding HR, OU=Mobile Development, O=Rose Holding, L=Cairo, ST=Cairo, C=EG"

echo ""
echo -e "${GREEN}✓ Keystore generated successfully!${NC}"
echo ""
echo -e "${YELLOW}IMPORTANT: Save these credentials securely!${NC}"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Keystore Location: ${KEYSTORE_PATH}"
echo "Key Alias: ${KEY_ALIAS}"
echo "Store Password: ${STORE_PASSWORD}"
echo "Key Password: ${KEY_PASSWORD}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Create key.properties file
KEY_PROPERTIES_PATH="${KEYSTORE_DIR}/key.properties"
cat > "$KEY_PROPERTIES_PATH" << EOF
# Generated on $(date)
# CRITICAL: Never commit this file to version control!

storePassword=${STORE_PASSWORD}
keyPassword=${KEY_PASSWORD}
keyAlias=${KEY_ALIAS}
storeFile=${KEYSTORE_PATH}
EOF

echo -e "${GREEN}✓ Created key.properties file${NC}"
echo ""

# Create a backup credentials file
CREDENTIALS_FILE="${KEYSTORE_DIR}/KEYSTORE_CREDENTIALS_BACKUP.txt"
cat > "$CREDENTIALS_FILE" << EOF
ROSE HR - UPLOAD KEYSTORE CREDENTIALS
Generated: $(date)

═══════════════════════════════════════════════════════════
⚠️  CRITICAL SECURITY INFORMATION ⚠️
═══════════════════════════════════════════════════════════

Store these credentials in a secure password manager immediately!
Delete this file after backing up to a secure location.

KEYSTORE DETAILS:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
File Name:      ${KEYSTORE_NAME}
Location:       ${KEYSTORE_PATH}
Key Alias:      ${KEY_ALIAS}
Store Password: ${STORE_PASSWORD}
Key Password:   ${KEY_PASSWORD}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

KEYSTORE SPECIFICATIONS:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Type:           PKCS12 (Modern Standard)
Algorithm:      RSA
Key Size:       4096 bits (Maximum Security)
Validity:       10,000 days (~27 years)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

DISTINGUISHED NAME:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Common Name (CN):        Rose Holding HR
Organizational Unit (OU): Mobile Development
Organization (O):        Rose Holding
Locality (L):           Cairo
State (ST):             Cairo
Country (C):            EG
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

BACKUP INSTRUCTIONS:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
1. Copy these credentials to a secure password manager (1Password, LastPass, etc.)
2. Make a backup of the keystore file (${KEYSTORE_NAME})
3. Store the backup in multiple secure locations (cloud + local)
4. Never commit these to version control
5. Delete this file after backing up: rm "${CREDENTIALS_FILE}"
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

SECURITY NOTES:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚠️  If you lose this keystore, you CANNOT update your app on Play Store
⚠️  You will need to publish as a new app with a new package name
⚠️  Always keep multiple secure backups
⚠️  Never share these credentials
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

echo -e "${GREEN}✓ Created credentials backup file${NC}"
echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo "1. Verify keystore info: keytool -list -v -keystore \"$KEYSTORE_PATH\" -storepass \"$STORE_PASSWORD\""
echo "2. Backup the keystore file and credentials to a secure location"
echo "3. Store credentials in a password manager"
echo "4. Read the backup file: cat \"$CREDENTIALS_FILE\""
echo "5. Delete the backup file after securing: rm \"$CREDENTIALS_FILE\""
echo ""
echo -e "${GREEN}Done!${NC}"
