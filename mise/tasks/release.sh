#!/usr/bin/env bash
#MISE description="Build release for different platforms"
#MISE alias="rel"
#USAGE flag "--linux" help="Build for Linux"
#USAGE flag "--macos" help="Build for macOS"  
#USAGE flag "--windows" help="Build for Windows"
#USAGE flag "--all" help="Build for all platforms"
#USAGE flag "--clean" help="Clean build directory before building"

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Parse platform flags
BUILD_LINUX=false
BUILD_MACOS=false
BUILD_WINDOWS=false
CLEAN_BUILD=false

if [[ "${usage_all:-}" == "true" ]]; then
    BUILD_LINUX=true
    BUILD_MACOS=true
    BUILD_WINDOWS=true
fi

if [[ "${usage_linux:-}" == "true" ]]; then
    BUILD_LINUX=true
fi

if [[ "${usage_macos:-}" == "true" ]]; then
    BUILD_MACOS=true
fi

if [[ "${usage_windows:-}" == "true" ]]; then
    BUILD_WINDOWS=true
fi

if [[ "${usage_clean:-}" == "true" ]]; then
    CLEAN_BUILD=true
fi

# If no platform specified, build for current platform
if [[ "$BUILD_LINUX" == "false" && "$BUILD_MACOS" == "false" && "$BUILD_WINDOWS" == "false" ]]; then
    case "$(uname -s)" in
        Linux)
            BUILD_LINUX=true
            print_info "No platform specified, building for current platform: Linux"
            ;;
        Darwin)
            BUILD_MACOS=true
            print_info "No platform specified, building for current platform: macOS"
            ;;
        MINGW*|CYGWIN*|MSYS*)
            BUILD_WINDOWS=true
            print_info "No platform specified, building for current platform: Windows"
            ;;
        *)
            print_error "Unknown platform: $(uname -s)"
            exit 1
            ;;
    esac
fi

# Clean build directory if requested
if [[ "$CLEAN_BUILD" == "true" ]]; then
    print_info "Cleaning build directory..."
    rm -rf _build/prod
    print_success "Build directory cleaned"
fi

# Ensure we're in the project root
cd "${MISE_PROJECT_ROOT:-$(pwd)}"

# Check if mix is available
if ! command -v mix &> /dev/null; then
    print_error "mix command not found. Please ensure Elixir is installed."
    exit 1
fi

# Get dependencies
print_info "Getting dependencies..."
MIX_ENV=prod mix deps.get

# Compile assets
print_info "Building assets..."
MIX_ENV=prod mix assets.deploy

# Build release
print_info "Building Elixir release..."
MIX_ENV=prod mix release --overwrite

# Create releases directory
RELEASES_DIR="releases"
mkdir -p "$RELEASES_DIR"

# Current timestamp for versioning
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
VERSION=$(grep 'version:' mix.exs | head -1 | awk -F'"' '{print $2}')

# Function to package release
package_release() {
    local platform=$1
    local archive_name="ignite-${VERSION}-${platform}-${TIMESTAMP}"
    local archive_ext="tar.gz"
    
    if [[ "$platform" == "windows" ]]; then
        archive_ext="zip"
    fi
    
    print_info "Packaging release for $platform..."
    
    cd _build/prod/rel/ignite
    
    if [[ "$archive_ext" == "zip" ]]; then
        zip -r "../../../../$RELEASES_DIR/${archive_name}.${archive_ext}" .
    else
        tar -czf "../../../../$RELEASES_DIR/${archive_name}.${archive_ext}" .
    fi
    
    cd ../../../..
    
    print_success "Release packaged: $RELEASES_DIR/${archive_name}.${archive_ext}"
}

# Package for each selected platform
if [[ "$BUILD_LINUX" == "true" ]]; then
    print_warning "Linux cross-compilation from $(uname -s) requires additional setup"
    print_info "For true Linux binaries, build on a Linux machine or use Docker/CI"
    package_release "linux"
fi

if [[ "$BUILD_MACOS" == "true" ]]; then
    if [[ "$(uname -s)" != "Darwin" ]]; then
        print_warning "macOS cross-compilation from $(uname -s) is not supported"
        print_info "For macOS binaries, build on a macOS machine"
    fi
    package_release "macos"
fi

if [[ "$BUILD_WINDOWS" == "true" ]]; then
    print_warning "Windows cross-compilation from $(uname -s) requires additional setup"
    print_info "For true Windows binaries, build on a Windows machine or use proper toolchain"
    package_release "windows"
fi

# Print summary
echo
print_success "Build complete!"
echo
echo "Releases created in: $RELEASES_DIR/"
ls -la "$RELEASES_DIR"/*.{tar.gz,zip} 2>/dev/null || true

# Instructions for running
echo
print_info "To run a release:"
echo "  1. Extract the archive: tar -xzf $RELEASES_DIR/ignite-*.tar.gz"
echo "  2. Run: ./bin/ignite start"
echo
print_info "Note: Cross-platform builds require proper toolchains or building on target OS"