# Changelog

All notable changes to this project will be documented in this file.

<!-- RELEASE NOTES START -->
## [0.16.5] - 2025-08-06

### <!-- 7 -->🏗️ Miscellaneous Tasks
- Remove path-based triggers from GitHub Actions workflows by @pepicrft
**Full Changelog**: https://github.com/tuist/ignite/compare/0.16.4...0.16.5
<!-- RELEASE NOTES START -->
## [0.16.4] - 2025-08-06

### <!-- 1 -->🐛 Bug Fixes
- Regenerate daemon protobuf to include BuildEnvironmentInfoResponse by @pepicrft
**Full Changelog**: https://github.com/tuist/ignite/compare/0.16.3...0.16.4
<!-- RELEASE NOTES START -->
## [0.16.3] - 2025-08-06

### <!-- 1 -->🐛 Bug Fixes
- Remove duplicate protobuf file from web app to resolve module conflicts by @pepicrft
**Full Changelog**: https://github.com/tuist/ignite/compare/0.16.2...0.16.3
<!-- RELEASE NOTES START -->
## [0.16.2] - 2025-08-06

### <!-- 1 -->🐛 Bug Fixes
- Disable cancel-in-progress for release workflow to prevent builds from being canceled by @pepicrft
**Full Changelog**: https://github.com/tuist/ignite/compare/0.16.1...0.16.2
<!-- RELEASE NOTES START -->
## [0.16.1] - 2025-08-06

### <!-- 1 -->🐛 Bug Fixes
- Run Mix commands from web/ directory in release build script by @pepicrft
**Full Changelog**: https://github.com/tuist/ignite/compare/0.16.0...0.16.1
<!-- RELEASE NOTES START -->
## [0.16.0] - 2025-08-06

### <!-- 0 -->⛰️  Features
- **daemon-swift**: Add testing infrastructure and CI pipeline by @pepicrft- Add daemon CI workflow with build, test, and format checks by @pepicrft- Reorganize project structure into monorepo by @pepicrft

### <!-- 1 -->🐛 Bug Fixes
- Update release workflow to use correct mix.exs path in web/ directory by @pepicrft- Use correct commit hash for mise-action@v2 by @pepicrft- Address CodeRabbit review comments by @pepicrft- Correct shebang in daemon test script by @pepicrft- Remove working-directory from daemon workflow by @pepicrft- Only run tuist install on macOS by @pepicrft- Add missing dev.exs and prod.exs config files by @pepicrft- Address PR review comments by @pepicrft

### <!-- 4 -->🔨 Refactor
- Simplify mise task paths to be relative to project root by @pepicrft- Use Mimic for proper test mocking by @pepicrft- Rename sidekick to daemon throughout codebase by @pepicrft- Reorganize project as monorepo with separate components by @pepicrft

### <!-- 6 -->🧪 Testing
- Add comprehensive test suite for daemon by @pepicrft
**Full Changelog**: https://github.com/tuist/ignite/compare/0.15.0...0.16.0
<!-- RELEASE NOTES START -->
## [0.15.0] - 2025-08-03

### <!-- 0 -->⛰️  Features
- Transform ignite into Vue.js SPA with GraphQL API and database integration by @pepicrft
**Full Changelog**: https://github.com/tuist/ignite/compare/0.14.1...0.15.0
<!-- RELEASE NOTES START -->
## [0.14.1] - 2025-08-03

### <!-- 1 -->🐛 Bug Fixes
- Resolve Vue app setup and CORS issues by @pepicrft
**Full Changelog**: https://github.com/tuist/ignite/compare/0.14.0...0.14.1
<!-- RELEASE NOTES START -->
## [0.14.0] - 2025-08-02

### <!-- 0 -->⛰️  Features
- Rename ignite-swift to sidekick-swift by @pepicrft
**Full Changelog**: https://github.com/tuist/ignite/compare/0.13.2...0.14.0
<!-- RELEASE NOTES START -->
## [0.13.2] - 2025-08-02

### <!-- 1 -->🐛 Bug Fixes
- Improve mobile terminal display with horizontal scrolling and better touch support by @pepicrft
**Full Changelog**: https://github.com/tuist/ignite/compare/0.13.1...0.13.2
<!-- RELEASE NOTES START -->
## [0.13.1] - 2025-08-01

### <!-- 1 -->🐛 Bug Fixes
- Remove Mix.env() usage for production compatibility by @pepicrft
**Full Changelog**: https://github.com/tuist/ignite/compare/0.13.0...0.13.1
<!-- RELEASE NOTES START -->
## [0.13.0] - 2025-08-01

### <!-- 0 -->⛰️  Features
- Add browser launcher with MuonTrap for lifecycle management by @pepicrft
**Full Changelog**: https://github.com/tuist/ignite/compare/0.12.0...0.13.0
<!-- RELEASE NOTES START -->
## [0.12.0] - 2025-08-01

### <!-- 0 -->⛰️  Features
- Create Sidekick package for platform-specific operations by @pepicrft

### <!-- 1 -->🐛 Bug Fixes
- Configure Sidekick to use Phoenix endpoint URL configuration by @pepicrft
**Full Changelog**: https://github.com/tuist/ignite/compare/0.11.1...0.12.0
<!-- RELEASE NOTES START -->
## [0.11.1] - 2025-08-01

### <!-- 2 -->📚 Documentation
- Add local agent architecture documentation by @pepicrft
**Full Changelog**: https://github.com/tuist/ignite/compare/0.11.0...0.11.1
<!-- RELEASE NOTES START -->
## [0.11.0] - 2025-08-01

### <!-- 0 -->⛰️  Features
- Add Swift package and integrate with release process by @pepicrft
**Full Changelog**: https://github.com/tuist/ignite/compare/0.10.0...0.11.0
<!-- RELEASE NOTES START -->
## [0.10.0] - 2025-08-01

### <!-- 0 -->⛰️  Features
- Change install location to ~/.local/share/ignite to avoid sudo by @pepicrft
**Full Changelog**: https://github.com/tuist/ignite/compare/0.9.0...0.10.0
<!-- RELEASE NOTES START -->
## [0.9.0] - 2025-08-01

### <!-- 0 -->⛰️  Features
- Update notarization process to match Tuist's approach by @pepicrft
**Full Changelog**: https://github.com/tuist/ignite/compare/0.8.0...0.9.0
<!-- RELEASE NOTES START -->
## [0.8.0] - 2025-08-01

### <!-- 0 -->⛰️  Features
- Update marketing site features and add CI workflow for Cloudflare Worker deployment by @pepicrft
**Full Changelog**: https://github.com/tuist/ignite/compare/0.7.1...0.8.0
<!-- RELEASE NOTES START -->
## [0.7.1] - 2025-08-01

### <!-- 1 -->🐛 Bug Fixes
- Move 'by Tuist' badge next to logo with solid purple background and better contrast by @pepicrft
**Full Changelog**: https://github.com/tuist/ignite/compare/0.7.0...0.7.1
<!-- RELEASE NOTES START -->
## [0.7.0] - 2025-08-01

### <!-- 0 -->⛰️  Features
- Add 'by Tuist' badge to header by @pepicrft
**Full Changelog**: https://github.com/tuist/ignite/compare/0.6.2...0.7.0
<!-- RELEASE NOTES START -->
## [0.6.2] - 2025-08-01

### <!-- 1 -->🐛 Bug Fixes
- Compress layout further to fit on single screen and add flame emoji to logo by @pepicrft
**Full Changelog**: https://github.com/tuist/ignite/compare/0.6.1...0.6.2
<!-- RELEASE NOTES START -->
## [0.6.1] - 2025-08-01

### <!-- 1 -->🐛 Bug Fixes
- Update marketing site copy and styling to match requirements by @pepicrft
**Full Changelog**: https://github.com/tuist/ignite/compare/0.6.0...0.6.1
<!-- RELEASE NOTES START -->
## [0.6.0] - 2025-08-01

### <!-- 0 -->⛰️  Features
- Add Cloudflare Worker for marketing site and install script by @pepicrft
**Full Changelog**: https://github.com/tuist/ignite/compare/0.5.1...0.6.0
<!-- RELEASE NOTES START -->
## [0.5.1] - 2025-08-01

### <!-- 1 -->🐛 Bug Fixes
- Add CLI module to handle --version flag and prevent hanging during release by @pepicrft
**Full Changelog**: https://github.com/tuist/ignite/compare/0.5.0...0.5.1
<!-- RELEASE NOTES START -->
## [0.5.0] - 2025-08-01

### <!-- 0 -->⛰️  Features
- Use Burrito to create a single portable executable by @pepicrft
**Full Changelog**: https://github.com/tuist/ignite/compare/0.4.1...0.5.0
<!-- RELEASE NOTES START -->
## [0.4.1] - 2025-08-01

### <!-- 1 -->🐛 Bug Fixes
- Sign all executables in the release to prevent macOS security warnings by @pepicrft
**Full Changelog**: https://github.com/tuist/ignite/compare/0.4.0...0.4.1
<!-- RELEASE NOTES START -->
## [0.4.0] - 2025-08-01

### <!-- 0 -->⛰️  Features
- Remove notarization as it's not needed for CLI tools by @pepicrft
**Full Changelog**: https://github.com/tuist/ignite/compare/0.3.11...0.4.0
<!-- RELEASE NOTES START -->
## [0.3.11] - 2025-08-01

### <!-- 1 -->🐛 Bug Fixes
- Only sign and notarize the main binary executable by @pepicrft
**Full Changelog**: https://github.com/tuist/ignite/compare/0.3.10...0.3.11
<!-- RELEASE NOTES START -->
## [0.3.10] - 2025-08-01

### <!-- 1 -->🐛 Bug Fixes
- Sign actual binaries instead of wrapper script and notarize entire package by @pepicrft
**Full Changelog**: https://github.com/tuist/ignite/compare/0.3.9...0.3.10
<!-- RELEASE NOTES START -->
## [0.3.9] - 2025-08-01

### <!-- 1 -->🐛 Bug Fixes
- Only notarize the main executable, not the entire package by @pepicrft
**Full Changelog**: https://github.com/tuist/ignite/compare/0.3.8...0.3.9
<!-- RELEASE NOTES START -->
## [0.3.8] - 2025-08-01

### <!-- 1 -->🐛 Bug Fixes
- Use zip format for notarization while keeping tar.gz for distribution by @pepicrft
**Full Changelog**: https://github.com/tuist/ignite/compare/0.3.7...0.3.8
<!-- RELEASE NOTES START -->
## [0.3.7] - 2025-08-01

### <!-- 1 -->🐛 Bug Fixes
- Update keychain setup to match Tuist's approach by @pepicrft
**Full Changelog**: https://github.com/tuist/ignite/compare/0.3.6...0.3.7
<!-- RELEASE NOTES START -->
## [0.3.6] - 2025-08-01

### <!-- 1 -->🐛 Bug Fixes
- Ensure SOPS age key is properly set up in CI and add local mode to release script by @pepicrft
**Full Changelog**: https://github.com/tuist/ignite/compare/0.3.5...0.3.6
<!-- RELEASE NOTES START -->
## [0.3.5] - 2025-08-01

### <!-- 1 -->🐛 Bug Fixes
- Handle empty keychain list in CI environment by @pepicrft
**Full Changelog**: https://github.com/tuist/ignite/compare/0.3.4...0.3.5
<!-- RELEASE NOTES START -->
## [0.3.4] - 2025-08-01

### <!-- 1 -->🐛 Bug Fixes
- Add postinstall hook to setup dependencies by @pepicrft
**Full Changelog**: https://github.com/tuist/ignite/compare/0.3.3...0.3.4
<!-- RELEASE NOTES START -->
## [0.3.3] - 2025-08-01

### <!-- 4 -->🔨 Refactor
- Move release build logic to mise task for better environment handling by @pepicrft
**Full Changelog**: https://github.com/tuist/ignite/compare/0.3.2...0.3.3
<!-- RELEASE NOTES START -->
## [0.3.2] - 2025-08-01

### <!-- 1 -->🐛 Bug Fixes
- Ensure encrypted environment variables are available in signing/notarization steps by @pepicrft
**Full Changelog**: https://github.com/tuist/ignite/compare/0.3.1...0.3.2
<!-- RELEASE NOTES START -->
## [0.3.1] - 2025-08-01

### <!-- 2 -->📚 Documentation
- Update AGENT.md to include guideline about keeping README up to date by @pepicrft
**Full Changelog**: https://github.com/tuist/ignite/compare/0.3.0...0.3.1
<!-- RELEASE NOTES START -->
## [0.3.0] - 2025-08-01

### <!-- 0 -->⛰️  Features
- Make ignite executable start by default without arguments by @pepicrft

### <!-- 1 -->🐛 Bug Fixes
- Use environment variables for secrets in release workflow by @pepicrft- Correctly reference GitHub secrets in release workflow by @pepicrft
**Full Changelog**: https://github.com/tuist/ignite/compare/0.2.0...0.3.0
<!-- RELEASE NOTES START -->
## [0.2.0] - 2025-08-01

### <!-- 0 -->⛰️  Features
- Add macOS code signing and notarization to releases by @pepicrft
**Full Changelog**: https://github.com/tuist/ignite/compare/0.1.4...0.2.0
<!-- RELEASE NOTES START -->
## [0.1.4] - 2025-08-01

### <!-- 1 -->🐛 Bug Fixes
- Improve release archive structure to avoid unnecessary nested folder by @pepicrft
**Full Changelog**: https://github.com/tuist/ignite/compare/0.1.3...0.1.4
<!-- RELEASE NOTES START -->
## [0.1.3] - 2025-08-01

### <!-- 1 -->🐛 Bug Fixes
- Simplify release process by removing Burrito and using standard Elixir releases by @pepicrft
**Full Changelog**: https://github.com/tuist/ignite/compare/0.1.2...0.1.3
<!-- RELEASE NOTES START -->
## [0.1.2] - 2025-08-01

### <!-- 1 -->🐛 Bug Fixes
- Use Erlang 27.1 for better Burrito compatibility by @pepicrft
**Full Changelog**: https://github.com/tuist/ignite/compare/0.1.1...0.1.2
<!-- RELEASE NOTES START -->
## [0.1.1] - 2025-08-01

### <!-- 1 -->🐛 Bug Fixes
- Use Zig 0.13.0 for Burrito compatibility by @pepicrft
**Full Changelog**: https://github.com/tuist/ignite/compare/0.1.0...0.1.1
<!-- RELEASE NOTES START -->
## [0.1.0] - 2025-08-01

### <!-- 0 -->⛰️  Features
- Add automated release workflow with git-cliff, Burrito, and macOS notarization by @pepicrft- Update README with Tuist vision and emojis by @pepicrft

### <!-- 2 -->📚 Documentation
- Clarify that Ignite is specifically for app development by @pepicrft
**Full Changelog**: https://github.com/tuist/ignite/commits/0.1.0
<!-- generated by git-cliff -->
