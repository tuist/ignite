# 🔥 Ignite

> An LLM-powered app development experience that breaks free from platform constraints

## 🚀 Vision

At Tuist, we believe there's an incredible opportunity to reimagine the coding experience. While Xcode has served developers well, we envision a future where:

- 🌍 **Platform Independence**: Code from anywhere, on any device
- 🤖 **AI-First Development**: LLMs as your coding companion, not an afterthought
- 📱 **Beyond macOS**: Treat Mac infrastructure as an implementation detail, not a requirement
- ⚡ **Instant Access**: No heavy IDEs to install, just start coding

Ignite is our step towards this vision - a lightweight, AI-powered coding environment that runs everywhere.

## 🎯 What is Ignite?

Ignite provides an alternative LLM-based coding experience to build apps. It can be used in multiple ways:

- 🖥️ **Locally with Tuist CLI**: Run `tuist ignite` to access the AI-powered coding experience directly from your terminal
- ☁️ **Remotely via Tuist Platform**: Access Ignite through the Tuist platform or app, enabling you to code on the go from any device

### 🚀 Quick Install

```bash
curl -fsSL https://ignite.tuist.dev | sh
```

## 🛠️ Development

### Prerequisites

- 🧪 Elixir 1.18.4+
- 🔧 Erlang 28.0.2+
- 📦 Mise (for version management)

### Quick Start

```bash
# Install dependencies and set up the project
mix setup

# Start the development server
mix phx.server

# Or start with interactive shell
iex -S mix phx.server
```

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser! 🎉

### 📦 Building Releases

We use mise tasks for building platform-specific releases:

```bash
# Build for current platform
mise run release

# Build for specific platforms
mise run release --macos
mise run release --linux
mise run release --windows

# Build for all platforms
mise run release --all
```

Releases are created in the `releases/` directory, ready for distribution! 📤

### 🌐 Marketing Site & Installer

The project includes a Cloudflare Worker that serves both the marketing site and the install script:

```bash
# Serve the worker locally for development
mise run worker:serve

# Deploy the worker to production
mise run worker:deploy
```

The worker intelligently detects the client:
- **Browsers** see a beautiful marketing page at https://ignite.tuist.dev
- **curl/wget** receive an install script that can be piped to `sh`

## 🔗 Learn More

- 🏠 **Tuist**: [https://tuist.io](https://tuist.io)
- 📚 **Documentation**: [https://docs.tuist.io](https://docs.tuist.io)
- 💬 **Community**: [Join our Slack](https://slack.tuist.io)
- 🐙 **GitHub**: [https://github.com/tuist](https://github.com/tuist)

## 🤝 Contributing

We welcome contributions! Whether it's bug fixes, new features, or documentation improvements, we'd love to have you on board. Check out our contributing guidelines to get started.

## 📄 License

Ignite is open source and available under the MIT License.

---

Built with ❤️ by the Tuist team