# Ignite Agent Architecture

## Overview

Ignite is an agentic coding assistant for developing applications for Apple platforms (iOS, macOS, watchOS, tvOS). It provides multiple interfaces including a Vue.js SPA for web clients and a native sidekick-swift component for platform-specific operations.

## Architecture

### Core Components

1. **Vue.js Single Page Application** - Modern web interface
   - Built with Vue 3 and vanilla JavaScript (no TypeScript)
   - NuxtUI component library for consistent design system
   - Real-time updates via GraphQL subscriptions
   - Apollo Client for GraphQL communication
   - Tailwind CSS v4 for styling
   - Bundled with Vite for faster development

2. **GraphQL API** - Primary API for web clients
   - Built with Absinthe (Elixir GraphQL library)
   - WebSocket subscriptions for real-time updates
   - Schema-first design with type safety
   - Accessible at `/api/graphql` with GraphiQL playground at `/api/graphiql`

3. **GRPC Server** - Internal communication layer
   - Provides RPC endpoints for native operations
   - Handles authentication between components
   - Used by sidekick-swift for platform-specific tasks
   - Runs on port 9090

4. **Implementation Details** (not exposed to users)
   - **Sidekick** - Internal service that bridges the GRPC server with system operations
   - **Sidekick-Swift** - Renamed from ignite-swift, handles Apple platform-specific operations
   - **Orchard** - Manages Apple simulators and devices through OTP supervision trees
   - **AXe** - Provides low-level simulator control and UI automation

### Data Flow

1. User interacts with the Vue.js SPA
2. Vue app makes GraphQL queries/mutations
3. Absinthe processes GraphQL requests
4. Real-time updates delivered via GraphQL subscriptions
5. Native operations delegated to sidekick-swift via GRPC
6. Orchard manages simulator/device lifecycle
7. UI updates reflect system state changes

## Features

- **Chat Interface**: Natural language interaction for development assistance
- **Simulator Management**: Boot, shutdown, and control iOS/watchOS/tvOS simulators
- **Device Support**: Connect and manage physical Apple devices
- **Real-time Updates**: Live status updates for simulators and devices
- **Platform Agnostic**: Supports all Apple platforms, not just iOS

## Implementation Notes

The system uses several internal services to provide functionality:

- **Frontend**: Vue 3 with NuxtUI components and Apollo Client for GraphQL
- **API Layer**: GraphQL (Absinthe) for web clients, GRPC for native clients
- **Backend**: Elixir OTP for process supervision and fault tolerance
- **Database**: SQLite with Ecto for data persistence (XDG-compliant location)
- **Build System**: Vite for JavaScript bundling with Vue and Tailwind CSS v4 plugins
- **Package Management**: PNPM for JavaScript dependencies
- **Native Components**: sidekick-swift for Apple platform operations
- **Simulator Management**: Orchard library integrated for real simulator/device data

### Development Setup

1. **JavaScript Dependencies**: Managed at project root with PNPM
2. **Asset Building**: Vite handles Vue SPA bundling with `pnpm dev` for development
3. **GraphQL Playground**: Available at `/api/graphiql` in development
4. **Component Library**: NuxtUI components provide consistent design system
5. **Database**: Automatically migrates on application start, stored in XDG-compliant directory

All implementation details are abstracted from the user - they interact with either the Vue.js web interface or native clients that provide development assistance for Apple platforms.