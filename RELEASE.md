# Release Process

This document describes the automated release process for Ignite.

## Overview

Ignite uses an automated release workflow powered by GitHub Actions and git-cliff. Releases are triggered automatically when changes are pushed to the `main` branch.

## Automated Release Process

The release workflow (`/.github/workflows/release.yml`) performs the following steps:

1. **Check for releasable changes**: Uses git-cliff to determine if there are any conventional commits that warrant a new release
2. **Determine next version**: Automatically calculates the next semantic version based on commit types
3. **Build macOS release**: Creates an Elixir release package
4. **Generate artifacts**: Creates release archives with SHA256 and SHA512 checksums
5. **Update files**: Updates `CHANGELOG.md` and version in `mix.exs`
6. **Create GitHub release**: Publishes the release with artifacts and release notes

## Required Secrets

The following GitHub secrets must be configured for the release process:

- `MISE_SOPS_AGE_KEY`: Age key for mise SOPS integration (if needed)

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

# Build release
MIX_ENV=prod mix release

# The release will be in:
# - _build/prod/rel/ignite/
```

## Release Artifacts

Each release includes:

- `ignite-macos.tar.gz`: macOS release package with Erlang runtime included
- `SHA256.txt`: SHA256 checksum of the release archive
- `SHA512.txt`: SHA512 checksum of the release archive

## Troubleshooting

### Build Issues

If the build fails:

1. Ensure all dependencies are installed: `mise install`
2. Check Elixir and Erlang versions match mise.toml
3. Review build logs for specific error messages

### Version Bumping Issues

If version bumping doesn't work as expected:

1. Ensure commits follow conventional commit format
2. Check `cliff.toml` configuration
3. Verify git tags are properly formatted (e.g., `0.1.0`, not `v0.1.0`)

## Configuration Files

- `/.github/workflows/release.yml`: GitHub Actions workflow
- `/cliff.toml`: git-cliff configuration for changelog and release notes generation
- `/mix.exs`: Contains version and release configuration