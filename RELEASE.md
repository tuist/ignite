# Release Process

This document describes the automated release process for Ignite.

## Overview

Ignite uses an automated release workflow powered by GitHub Actions, git-cliff, and Burrito to create standalone executables. Releases are triggered automatically when changes are pushed to the `main` branch.

## Automated Release Process

The release workflow (`/.github/workflows/release.yml`) performs the following steps:

1. **Check for releasable changes**: Uses git-cliff to determine if there are any conventional commits that warrant a new release
2. **Determine next version**: Automatically calculates the next semantic version based on commit types
3. **Build macOS release**: Creates a standalone executable using Burrito
4. **Sign and notarize**: Signs the executable with Apple Developer certificates and notarizes it
5. **Generate artifacts**: Creates release archives with SHA256 and SHA512 checksums
6. **Update files**: Updates `CHANGELOG.md` and version in `mix.exs`
7. **Create GitHub release**: Publishes the release with artifacts and release notes

## Required Secrets

The following GitHub secrets must be configured for the release process:

- `MISE_SOPS_AGE_KEY`: Age key for mise SOPS integration (if needed)
- `CERTIFICATE_PASSWORD`: Password for the Apple Developer certificate
- `APP_SPECIFIC_PASSWORD`: Apple ID app-specific password for notarization
- `BASE_64_DEVELOPER_ID_APPLICATION_CERTIFICATE`: Base64-encoded Developer ID Application certificate (.p12)

### Setting up Apple Developer Certificates

1. Export your Developer ID Application certificate from Keychain Access as a .p12 file
2. Convert to base64: `base64 -i certificate.p12 | pbcopy`
3. Add as GitHub secret `BASE_64_DEVELOPER_ID_APPLICATION_CERTIFICATE`

### Creating App-Specific Password

1. Sign in to https://appleid.apple.com
2. Generate an app-specific password
3. Add as GitHub secret `APP_SPECIFIC_PASSWORD`

## Conventional Commits

The project follows [Conventional Commits](https://www.conventionalcommits.org/) specification:

- `feat:` - New features (bumps minor version)
- `fix:` - Bug fixes (bumps patch version)
- `feat!:` or `BREAKING CHANGE:` - Breaking changes (bumps major version)
- `docs:` - Documentation changes
- `refactor:` - Code refactoring
- `test:` - Test additions/changes
- `chore:` - Maintenance tasks

## Manual Release Testing

To test the release process locally:

```bash
# Install dependencies
mise install
mix deps.get --only prod

# Build assets
mix assets.deploy

# Build release with Burrito
MIX_ENV=prod BURRITO_TARGET=macos_m1 mix release

# The executable will be in one of these locations:
# - _build/prod/rel/ignite/ignite
# - _build/prod/burrito_out/ignite_macos_m1
# - _build/prod/burrito_out/ignite
```

## Release Artifacts

Each release includes:

- `ignite-macos.zip`: Signed and notarized macOS executable
- `SHA256.txt`: SHA256 checksum of the release archive
- `SHA512.txt`: SHA512 checksum of the release archive

## Troubleshooting

### Burrito Build Issues

If the burrito build fails:

1. Ensure Zig is properly installed: `mise install zig`
2. Check Zig version compatibility with Burrito
3. Review build logs for specific error messages

### Notarization Issues

If notarization fails:

1. Verify the certificate is valid and not expired
2. Check the app-specific password is correct
3. Ensure the executable is properly signed before notarization
4. Review notarization logs with `xcrun notarytool log`

### Version Bumping Issues

If version bumping doesn't work as expected:

1. Ensure commits follow conventional commit format
2. Check `cliff.toml` configuration
3. Verify git tags are properly formatted (e.g., `0.1.0`, not `v0.1.0`)

## Configuration Files

- `/.github/workflows/release.yml`: GitHub Actions workflow
- `/cliff.toml`: git-cliff configuration for changelog and release notes generation
- `/mix.exs`: Contains version and burrito configuration