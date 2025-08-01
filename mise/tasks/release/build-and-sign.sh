#!/bin/bash
# mise description="Build and sign a release"

set -euo pipefail

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

print_status() {
    echo -e "${GREEN}▶ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# Ensure we're in the project root
cd "${MISE_PROJECT_ROOT}"

# Check if running locally (not in CI)
if [ -z "${CI:-}" ]; then
    print_status "Running in local mode - skipping keychain operations"
    LOCAL_MODE=true
else
    LOCAL_MODE=false
fi

# Ensure environment is set up for signing
if [ "$LOCAL_MODE" = "false" ]; then
    if [ -z "${CERTIFICATE_PASSWORD:-}" ] || [ -z "${BASE_64_DEVELOPER_ID_APPLICATION_CERTIFICATE:-}" ]; then
        print_error "Required environment variables are not set. Please ensure .env.json is properly configured."
        print_error "CERTIFICATE_PASSWORD: ${CERTIFICATE_PASSWORD:+[SET]}${CERTIFICATE_PASSWORD:-[NOT SET]}"
        print_error "BASE_64_DEVELOPER_ID_APPLICATION_CERTIFICATE: ${BASE_64_DEVELOPER_ID_APPLICATION_CERTIFICATE:+[SET]}${BASE_64_DEVELOPER_ID_APPLICATION_CERTIFICATE:-[NOT SET]}"
        exit 1
    fi
fi

print_status "Building release with Burrito..."

# Clean previous builds
rm -rf _build/prod
rm -rf burrito_out

# Get dependencies and compile
MIX_ENV=prod mix deps.get
MIX_ENV=prod mix compile

# Ensure assets are built for production
MIX_ENV=prod mix assets.deploy

# Build the release with Burrito
print_status "Running mix release with Burrito..."
MIX_ENV=prod BURRITO_TARGET=macos_arm mix release --overwrite

print_status "Looking for Burrito output..."

# Find the Burrito executable
if [ ! -d "burrito_out" ]; then
    print_error "Burrito output directory not found!"
    exit 1
fi

# Find the macOS executable
BURRITO_BINARY=$(find burrito_out -type f -name "ignite*" | grep -v ".exe" | head -1)

if [ -z "$BURRITO_BINARY" ] || [ ! -f "$BURRITO_BINARY" ]; then
    print_error "Burrito binary not found!"
    ls -la burrito_out/
    exit 1
fi

print_status "Found Burrito binary: $BURRITO_BINARY"

# Copy the binary to current directory with simple name
cp "$BURRITO_BINARY" ignite
chmod +x ignite

# Ensure jq is available for JSON parsing
if ! command -v jq &> /dev/null; then
    print_error "jq is required for notarization but not found. Please install jq."
    if [ "$(uname)" = "Darwin" ]; then
        echo "You can install jq with: brew install jq"
    fi
    exit 1
fi

# Just verify the binary is executable
if [ ! -x "./ignite" ]; then
    print_error "Binary is not executable!"
    exit 1
fi

# Check what type of file the executable is
print_status "Checking executable type..."
file ignite
ls -la ignite

CERTIFICATE_NAME="Developer ID Application: Tuist GmbH (U6LC622NKF)"

if [ "$LOCAL_MODE" = "false" ]; then
    print_status "Setting up keychain for signing..."

    # Create keychain for signing (following Tuist's approach)
    KEYCHAIN_PATH="${RUNNER_TEMP:-/tmp}/keychain.keychain"
    KEYCHAIN_PASSWORD=$(uuidgen)

    # Create and configure keychain
    print_status "Creating temporary keychain..."
    security create-keychain -p "$KEYCHAIN_PASSWORD" "$KEYCHAIN_PATH"
    security set-keychain-settings -lut 21600 "$KEYCHAIN_PATH"
    security default-keychain -s "$KEYCHAIN_PATH"
    security unlock-keychain -p "$KEYCHAIN_PASSWORD" "$KEYCHAIN_PATH"

    # Import certificate directly without specifying keychain (like Tuist)
    print_status "Importing certificate..."
    CERT_PATH="${RUNNER_TEMP:-/tmp}/certificate.p12"
    echo $BASE_64_DEVELOPER_ID_APPLICATION_CERTIFICATE | base64 --decode > "$CERT_PATH"
    security import "$CERT_PATH" -P "$CERTIFICATE_PASSWORD" -A
    rm -f "$CERT_PATH"

    # Verify certificate is available
    print_status "Verifying certificate..."
    security find-identity -v -p codesigning

    print_status "Signing executable..."

    # Sign the single Burrito executable
    /usr/bin/codesign --force --sign "$CERTIFICATE_NAME" --timestamp --options runtime --verbose ignite

    # Verify the signature
    print_status "Verifying signature..."
    /usr/bin/codesign --verify --deep --verbose ignite

    print_status "Executable signed successfully"
    
    # Notarize the executable if Apple ID credentials are available
    if [ -n "${APP_SPECIFIC_PASSWORD:-}" ]; then
        print_status "Notarizing executable..."
        
        # Create a zip for notarization (notarytool requires zip format)
        zip -q -r --symlinks "notarization-bundle.zip" ignite
        
        # Submit for notarization and get submission ID
        RAW_JSON=$(xcrun notarytool submit "notarization-bundle.zip" \
            --apple-id "pedro@pepicrft.me" \
            --team-id "U6LC622NKF" \
            --password "$APP_SPECIFIC_PASSWORD" \
            --output-format json)
        echo "$RAW_JSON"
        SUBMISSION_ID=$(echo "$RAW_JSON" | jq -r '.id')
        echo "Submission ID: $SUBMISSION_ID"
        
        # Wait for notarization to complete
        while true; do
            STATUS=$(xcrun notarytool info "$SUBMISSION_ID" \
                --apple-id "pedro@pepicrft.me" \
                --team-id "U6LC622NKF" \
                --password "$APP_SPECIFIC_PASSWORD" \
                --output-format json | jq -r '.status')
            
            case $STATUS in
                "Accepted")
                    print_status "Notarization succeeded!"
                    break
                    ;;
                "In Progress")
                    echo "Notarization in progress... waiting 30 seconds"
                    sleep 30
                    ;;
                "Invalid"|"Rejected")
                    print_error "Notarization failed with status: $STATUS"
                    xcrun notarytool log "$SUBMISSION_ID" \
                        --apple-id "pedro@pepicrft.me" \
                        --team-id "U6LC622NKF" \
                        --password "$APP_SPECIFIC_PASSWORD"
                    exit 1
                    ;;
                *)
                    print_error "Unknown status: $STATUS"
                    exit 1
                    ;;
            esac
        done
        
        # Clean up notarization zip
        rm -f "notarization-bundle.zip"
        
        print_status "Notarization complete!"
    else
        print_status "Skipping notarization (APP_SPECIFIC_PASSWORD not provided)"
        print_status "The binary will trigger Gatekeeper warnings when downloaded"
    fi
else
    print_status "Local mode: Skipping code signing and notarization"
fi

# Create the distribution archive with just the executable
print_status "Creating distribution archive..."
tar -czf ignite-macos.tar.gz ignite

# Generate checksums
shasum -a 256 ignite-macos.tar.gz > SHA256.txt
shasum -a 512 ignite-macos.tar.gz > SHA512.txt

# Display checksums
echo "SHA256:"
cat SHA256.txt
echo "SHA512:"
cat SHA512.txt

# Clean up keychain
if [ "$LOCAL_MODE" = "false" ] && [ -n "$KEYCHAIN_PATH" ]; then
    print_status "Cleaning up keychain..."
    security delete-keychain "$KEYCHAIN_PATH" || true
fi

# Clean up temporary files
rm -f ignite
rm -rf burrito_out

print_status "Release build complete!"
echo "Artifacts created:"
echo "  - ignite-macos.tar.gz (single portable executable)"
echo "  - SHA256.txt"
echo "  - SHA512.txt"
