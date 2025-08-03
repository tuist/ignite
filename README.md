# 🔥 Ignite

> An LLM-powered app development experience that breaks free from platform constraints

## 🚀 Vision

At Tuist, we believe there's an incredible opportunity to reimagine the coding experience. While Xcode has served developers well, we envision a future where:

- 🌍 **Platform Independence**: Code from anywhere, on any device
- 🤖 **AI-First Development**: LLMs as your coding companion, not an afterthought
- 📱 **Beyond macOS**: Treat Mac infrastructure as an implementation detail, not a requirement
- ⚡ **Local-First**: Run it locally on your machine with full control

Ignite is our step towards this vision - a lightweight, AI-powered coding environment that runs everywhere.

## 🎯 What is Ignite?

Ignite is a local-first, LLM-based coding experience to build apps. Whether running on your machine or accessed remotely, Ignite gives you an AI-powered development environment that adapts to your workflow.

### 🚀 Run it

```bash
curl -fsSL https://ignite.tuist.dev | sh
```

## 🏗️ Project Structure

Ignite is organized as a monorepo with the following components:

```
ignite/
├── app/              # Native iOS/macOS app (Swift)
├── web/              # Main server (Elixir/Phoenix + Vue.js)
├── sidekick/         # Infrastructure service (Elixir)
├── sidekick-swift/   # Companion to interface with macOS platform
└── worker/           # Cloudflare Worker for marketing site
```

## 🔗 Learn More

- 🏠 **Tuist**: [https://tuist.dev](https://tuist.dev)
- 💬 **Community**: [community.tuist.dev](https://community.tuist.dev)
- 🐙 **GitHub**: [https://github.com/tuist](https://github.com/tuist)

## 🤝 Contributing

We welcome contributions! Whether it's bug fixes, new features, or documentation improvements, we'd love to have you on board. Check out our contributing guidelines to get started.

## 📄 License

Ignite is open source and available under the MPL-2.0 License.

---

Built with ❤️ by the Tuist team
