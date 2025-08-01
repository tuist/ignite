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

# Check what type of file the executables are
print_status "Checking executable types..."
file ignite
file bin/ignite
ls -la ignite
ls -la bin/ignite

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

    # Only sign the main release binary
    if [ -f "release-package/bin/ignite" ]; then
        print_status "Signing bin/ignite..."
        /usr/bin/codesign --force --sign "$CERTIFICATE_NAME" --timestamp --options runtime --verbose release-package/bin/ignite
        
        # Verify it was signed
        print_status "Verifying signature..."
        /usr/bin/codesign --verify --verbose release-package/bin/ignite
    else
        print_error "bin/ignite not found!"
        exit 1
    fi
else
    print_status "Local mode: Skipping code signing"
fi

print_status "Creating release archive..."

# Notarization is not needed for CLI tools, only GUI apps
print_status "Skipping notarization (not required for CLI tools)"

# Now create the distribution archive
print_status "Creating distribution archive..."
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

# Clean up keychain
if [ "$LOCAL_MODE" = "false" ] && [ -n "$KEYCHAIN_PATH" ]; then
    print_status "Cleaning up keychain..."
    security delete-keychain "$KEYCHAIN_PATH" || true
fi

# Clean up temporary files
rm -rf release-package

print_status "Release build complete!"
echo "Artifacts created:"
echo "  - ignite-macos.tar.gz"
echo "  - SHA256.txt"
echo "  - SHA512.txt"