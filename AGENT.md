# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### Setup and Dependencies
- `mix setup` - Install dependencies, create database, run migrations, and build assets
- `mix deps.get` - Install Elixir dependencies

### Running the Application
- `mix phx.server` - Start Phoenix server (accessible at http://localhost:4000)
- `iex -S mix phx.server` - Start Phoenix server with interactive Elixir shell

### Database Operations
- `mix ecto.create` - Create the database
- `mix ecto.migrate` - Run database migrations
- `mix ecto.reset` - Drop, create, and migrate database with seeds
- `mix ecto.setup` - Create, migrate database and run seeds

### Testing
- `mix test` - Run all tests (creates test database if needed)
- `mix test test/path/to/test.exs` - Run specific test file
- `mix test test/path/to/test.exs:LINE` - Run specific test at line number

### Assets
- `mix assets.build` - Build CSS and JavaScript assets
- `mix assets.deploy` - Build and minify assets for production

### Building Releases

#### Using Mise Task (Recommended)
```bash
# Build for current platform
mise run release

# Build for specific platform
mise run release --linux
mise run release --macos
mise run release --windows

# Build for all platforms
mise run release --all

# Clean build before building
mise run release --clean --macos

# Short alias
mise rel --all
```

Releases will be created in the `releases/` directory with timestamps.

#### Manual Build
```bash
MIX_ENV=prod mix release
MIX_ENV=prod mix release --overwrite  # Rebuild
```

The release will be created in `_build/prod/rel/ignite/`.

### Running the Release

To run the release:
```bash
# From build directory
_build/prod/rel/ignite/bin/ignite start

# From extracted release archive
tar -xzf releases/ignite-*.tar.gz
./bin/ignite start
```

The release will run with these defaults:
- Server enabled automatically
- PHX_HOST defaults to `localhost`
- SECRET_KEY_BASE uses a default value (override with env var in production)

You can override any settings with environment variables:
```bash
PHX_HOST=myapp.com SECRET_KEY_BASE=my-secret _build/prod/rel/ignite/bin/ignite start
```

### Building Standalone Binaries (Burrito)
Note: Burrito support is included but requires Zig 0.13.0 (for burrito 1.2.0) or later versions may require different Zig versions. 
Currently, the project is configured for standard releases due to Zig version compatibility issues.

To enable burrito builds:
1. Install the required Zig version
2. Update mix.exs releases() function to include burrito steps
3. Run `MIX_ENV=prod mix release`

## Architecture Overview

This is a Phoenix Framework web application using:

- **Phoenix 1.7.21** - Main web framework
- **PostgreSQL** - Database via Ecto/Postgrex
- **Phoenix LiveView** - For interactive UI components
- **Tailwind CSS** - For styling (configured in assets/tailwind.config.js)
- **Esbuild** - JavaScript bundling
- **Bandit** - HTTP server
- **Burrito** - For creating standalone executables

### Key Directories and Modules

- `lib/ignite/` - Core business logic
  - `application.ex` - OTP application supervisor tree
  - `repo.ex` - Ecto repository for database access
  - `mailer.ex` - Email configuration using Swoosh

- `lib/ignite_web/` - Web layer
  - `router.ex` - HTTP routing definitions
  - `endpoint.ex` - Phoenix endpoint configuration
  - `controllers/` - Request handlers
  - `components/` - Reusable UI components
  - `layouts/` - Page layouts (root.html.heex, app.html.heex)

### Supervision Tree

The application starts these processes (defined in lib/ignite/application.ex):
1. Telemetry for metrics
2. Ecto Repository for database connections
3. DNS Cluster for distributed Elixir
4. Phoenix PubSub for real-time features
5. Finch HTTP client for external requests
6. Phoenix Endpoint for serving web requests

### Development Environment

Uses mise (mise.toml) for version management:
- Elixir 1.18.4
- Erlang 28.0.2

### Development Routes

In development, additional routes are available:
- `/dev/dashboard` - Phoenix LiveDashboard for monitoring
- `/dev/mailbox` - Swoosh mailbox preview for testing emails