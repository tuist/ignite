#!/bin/bash
# mise description="Build, sign, and notarize a release"

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

# Ensure environment is set up
if [ -z "${CERTIFICATE_PASSWORD:-}" ] || [ -z "${APP_SPECIFIC_PASSWORD:-}" ] || [ -z "${BASE_64_DEVELOPER_ID_APPLICATION_CERTIFICATE:-}" ]; then
    print_error "Required environment variables are not set. Please ensure .env.json is properly configured."
    print_error "CERTIFICATE_PASSWORD: ${CERTIFICATE_PASSWORD:+[SET]}${CERTIFICATE_PASSWORD:-[NOT SET]}"
    print_error "APP_SPECIFIC_PASSWORD: ${APP_SPECIFIC_PASSWORD:+[SET]}${APP_SPECIFIC_PASSWORD:-[NOT SET]}"
    print_error "BASE_64_DEVELOPER_ID_APPLICATION_CERTIFICATE: ${BASE_64_DEVELOPER_ID_APPLICATION_CERTIFICATE:+[SET]}${BASE_64_DEVELOPER_ID_APPLICATION_CERTIFICATE:-[NOT SET]}"
    exit 1
fi

print_status "Building release..."

# Clean previous builds
rm -rf _build/prod

# Get dependencies and compile
MIX_ENV=prod mix deps.get
MIX_ENV=prod mix compile

# Ensure assets are built for production
MIX_ENV=prod mix assets.deploy

# Build the release
MIX_ENV=prod mix release --overwrite

print_status "Packaging release..."

# Package the release
RELEASE_DIR="_build/prod/rel/ignite"

# Create a temporary directory for the release
rm -rf release-package
mkdir -p release-package
cd release-package

# Copy the entire release directory contents
cp -r ../$RELEASE_DIR/* .

# Create a wrapper script at the top level
cat > ignite << 'EOF'
#!/bin/bash
# Ignite CLI

# Determine the directory where this script resides
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# If no arguments provided, default to "start"
if [ $# -eq 0 ]; then
  exec "$SCRIPT_DIR/bin/ignite" start
else
  # Pass through any provided arguments
  exec "$SCRIPT_DIR/bin/ignite" "$@"
fi
EOF

chmod +x ignite

# Make the main binary executable as well
chmod +x bin/ignite

# Test the release
print_status "Testing release..."
./ignite eval "IO.puts(:ignite |> Application.spec(:vsn))" || echo "Version check failed"

cd ..

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
else
    print_status "Local mode: Using existing keychain and certificates"
fi

if [ "$LOCAL_MODE" = "false" ]; then
    print_status "Signing executables..."

    # Sign the main ignite wrapper (without specifying keychain like Tuist)
    /usr/bin/codesign --sign "$CERTIFICATE_NAME" --timestamp --options runtime --verbose release-package/ignite

    # Sign the actual Elixir release binary
    /usr/bin/codesign --sign "$CERTIFICATE_NAME" --timestamp --options runtime --verbose release-package/bin/ignite

    # Sign any other executables in bin directory
    find release-package/bin -type f -perm +111 | while read -r file; do
        echo "Signing: $file"
        /usr/bin/codesign --sign "$CERTIFICATE_NAME" --timestamp --options runtime --verbose "$file" || true
    done

    # Sign ERTS binaries
    if [ -d "release-package/erts-"* ]; then
        find release-package/erts-*/bin -type f -perm +111 | while read -r file; do
            echo "Signing ERTS binary: $file"
            /usr/bin/codesign --sign "$CERTIFICATE_NAME" --timestamp --options runtime --verbose "$file" || true
        done
    fi
else
    print_status "Local mode: Skipping code signing"
fi

print_status "Creating release archive..."

# Create zip archive for notarization from inside the directory
cd release-package
zip -q -r --symlinks ../ignite-macos.zip .
cd ..

# Create tar.gz archive for distribution
cd release-package
tar -czf ../ignite-macos.tar.gz .
cd ..

# Generate checksums for the tar.gz (distribution file)
shasum -a 256 ignite-macos.tar.gz > SHA256.txt
shasum -a 512 ignite-macos.tar.gz > SHA512.txt

# Display checksums
echo "SHA256:"
cat SHA256.txt
echo "SHA512:"
cat SHA512.txt

if [ "$LOCAL_MODE" = "false" ]; then
    print_status "Notarizing release..."

    APPLE_ID="pedro@pepicrft.me"
    TEAM_ID="U6LC622NKF"

    # Submit zip file for notarization
    RAW_JSON=$(xcrun notarytool submit "ignite-macos.zip" \
        --apple-id "$APPLE_ID" \
        --team-id "$TEAM_ID" \
        --password "$APP_SPECIFIC_PASSWORD" \
        --output-format json)
    echo "$RAW_JSON"
    SUBMISSION_ID=$(echo "$RAW_JSON" | jq -r ".id")
    echo "Submission ID: $SUBMISSION_ID"

    # Wait for notarization
    while true; do
        STATUS=$(xcrun notarytool info "$SUBMISSION_ID" \
            --apple-id "$APPLE_ID" \
            --team-id "$TEAM_ID" \
            --password "$APP_SPECIFIC_PASSWORD" \
            --output-format json | jq -r ".status")

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
                    --apple-id "$APPLE_ID" \
                    --team-id "$TEAM_ID" \
                    --password "$APP_SPECIFIC_PASSWORD"
                exit 1
                ;;
            *)
                print_error "Unknown status: $STATUS"
                exit 1
                ;;
        esac
    done
else
    print_status "Local mode: Skipping notarization"
fi

# Clean up keychain
if [ "$LOCAL_MODE" = "false" ] && [ -n "$KEYCHAIN_PATH" ]; then
    print_status "Cleaning up keychain..."
    security delete-keychain "$KEYCHAIN_PATH" || true
fi

# Clean up temporary files
rm -rf release-package
rm -f ignite-macos.zip  # Remove the zip file used for notarization

print_status "Release build complete!"
echo "Artifacts created:"
echo "  - ignite-macos.tar.gz"
echo "  - SHA256.txt"
echo "  - SHA512.txt"