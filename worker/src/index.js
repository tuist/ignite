const html = `<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ignite - Phoenix Development, Simplified</title>
    <meta name="description" content="Ignite is a Phoenix application template that gets you up and running in seconds.">
    
    <style>
        :root {
            --bg-primary: #000000;
            --bg-secondary: #0a0a0a;
            --text-primary: #ffffff;
            --text-secondary: #999999;
            --accent: #f97316;
            --accent-hover: #fb923c;
            --terminal-bg: #0d0d0d;
            --terminal-border: #1a1a1a;
            --terminal-text: #10b981;
            --gradient-1: #f97316;
            --gradient-2: #ec4899;
            --gradient-3: #8b5cf6;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            background: var(--bg-primary);
            color: var(--text-primary);
            line-height: 1.6;
            overflow-x: hidden;
        }

        .noise {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            opacity: 0.03;
            z-index: 1;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='100' height='100'%3E%3Cfilter id='noise'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' /%3E%3C/filter%3E%3Crect width='100' height='100' filter='url(%23noise)' opacity='1'/%3E%3C/svg%3E");
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 24px;
            position: relative;
            z-index: 2;
        }

        header {
            padding: 32px 0;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .logo {
            font-size: 24px;
            font-weight: 700;
            background: linear-gradient(135deg, var(--gradient-1), var(--gradient-2));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .hero {
            padding: 120px 0;
            text-align: center;
        }

        .hero h1 {
            font-size: clamp(48px, 8vw, 96px);
            font-weight: 800;
            line-height: 1.1;
            margin-bottom: 24px;
            letter-spacing: -0.03em;
            background: linear-gradient(135deg, var(--text-primary) 0%, var(--text-secondary) 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .hero .subtitle {
            font-size: clamp(20px, 3vw, 28px);
            color: var(--text-secondary);
            margin-bottom: 64px;
            font-weight: 400;
            max-width: 600px;
            margin-left: auto;
            margin-right: auto;
        }

        .terminal-container {
            max-width: 800px;
            margin: 0 auto 48px;
            position: relative;
        }

        .terminal {
            background: var(--terminal-bg);
            border: 1px solid var(--terminal-border);
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.5);
            position: relative;
        }

        .terminal::before {
            content: '';
            position: absolute;
            top: -1px;
            left: -1px;
            right: -1px;
            bottom: -1px;
            background: linear-gradient(135deg, var(--gradient-1), var(--gradient-2), var(--gradient-3));
            border-radius: 16px;
            opacity: 0;
            transition: opacity 0.3s ease;
            z-index: -1;
        }

        .terminal:hover::before {
            opacity: 0.1;
        }

        .terminal-header {
            background: rgba(255, 255, 255, 0.05);
            padding: 16px 20px;
            display: flex;
            align-items: center;
            gap: 8px;
            border-bottom: 1px solid var(--terminal-border);
        }

        .terminal-dot {
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background: var(--terminal-border);
        }

        .terminal-dot:nth-child(1) { background: #ff5f57; }
        .terminal-dot:nth-child(2) { background: #ffbd2e; }
        .terminal-dot:nth-child(3) { background: #28ca42; }

        .terminal-body {
            padding: 32px;
            font-family: 'SF Mono', Monaco, 'Cascadia Code', 'Roboto Mono', monospace;
            font-size: 16px;
            line-height: 1.6;
        }

        .command-line {
            display: flex;
            align-items: center;
            gap: 12px;
            color: var(--terminal-text);
            position: relative;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .command-line:hover {
            transform: translateX(4px);
        }

        .prompt {
            color: var(--text-secondary);
            user-select: none;
        }

        .command {
            color: var(--terminal-text);
            font-weight: 500;
        }

        .cursor {
            display: inline-block;
            width: 10px;
            height: 20px;
            background: var(--terminal-text);
            animation: blink 1s infinite;
            margin-left: 2px;
        }

        @keyframes blink {
            0%, 50% { opacity: 1; }
            51%, 100% { opacity: 0; }
        }

        .copy-hint {
            position: absolute;
            right: 0;
            top: 50%;
            transform: translateY(-50%);
            background: rgba(255, 255, 255, 0.1);
            padding: 4px 12px;
            border-radius: 6px;
            font-size: 12px;
            color: var(--text-secondary);
            opacity: 0;
            transition: opacity 0.2s ease;
            pointer-events: none;
        }

        .command-line:hover .copy-hint {
            opacity: 1;
        }

        .features {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 32px;
            margin-top: 96px;
            margin-bottom: 96px;
        }

        .feature {
            padding: 32px;
            background: rgba(255, 255, 255, 0.03);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 16px;
            transition: all 0.3s ease;
        }

        .feature:hover {
            background: rgba(255, 255, 255, 0.05);
            border-color: rgba(255, 255, 255, 0.2);
            transform: translateY(-4px);
        }

        .feature h3 {
            font-size: 20px;
            margin-bottom: 12px;
            background: linear-gradient(135deg, var(--gradient-1), var(--gradient-2));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .feature p {
            color: var(--text-secondary);
            line-height: 1.6;
        }

        .toast {
            position: fixed;
            bottom: 32px;
            left: 50%;
            transform: translateX(-50%) translateY(100px);
            background: var(--accent);
            color: white;
            padding: 16px 24px;
            border-radius: 8px;
            font-weight: 500;
            opacity: 0;
            transition: all 0.3s ease;
            z-index: 1000;
        }

        .toast.show {
            transform: translateX(-50%) translateY(0);
            opacity: 1;
        }

        footer {
            padding: 48px 0;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            text-align: center;
            color: var(--text-secondary);
        }

        @media (max-width: 768px) {
            .hero {
                padding: 80px 0;
            }
            
            .terminal-body {
                padding: 20px;
                font-size: 14px;
            }
            
            .features {
                gap: 24px;
                margin-top: 64px;
            }
        }
    </style>
</head>
<body>
    <div class="noise"></div>
    
    <div class="container">
        <header>
            <div class="logo">Ignite</div>
        </header>
        
        <section class="hero">
            <h1>Phoenix Development,<br>Simplified</h1>
            <p class="subtitle">
                A modern Phoenix application template that gets you up and running in seconds
            </p>
            
            <div class="terminal-container">
                <div class="terminal">
                    <div class="terminal-header">
                        <div class="terminal-dot"></div>
                        <div class="terminal-dot"></div>
                        <div class="terminal-dot"></div>
                    </div>
                    <div class="terminal-body">
                        <div class="command-line" onclick="copyCommand()">
                            <span class="prompt">$</span>
                            <span class="command">curl -fsSL https://ignite.tuist.dev | sh</span>
                            <span class="cursor"></span>
                            <span class="copy-hint">Click to copy</span>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        
        <section class="features">
            <div class="feature">
                <h3>🚀 Instant Setup</h3>
                <p>Get a fully configured Phoenix application running in seconds. No complex setup or configuration needed.</p>
            </div>
            <div class="feature">
                <h3>🔥 Modern Stack</h3>
                <p>Built with Phoenix LiveView, Tailwind CSS, and all the modern tools you need for rapid development.</p>
            </div>
            <div class="feature">
                <h3>⚡ Lightning Fast</h3>
                <p>Optimized for performance with built-in caching, asset optimization, and production-ready configurations.</p>
            </div>
        </section>
        
        <footer>
            <p>Built with ❤️ by the Tuist team</p>
        </footer>
    </div>
    
    <div class="toast" id="toast">Command copied to clipboard!</div>
    
    <script>
        function copyCommand() {
            const command = 'curl -fsSL https://ignite.tuist.dev | sh';
            navigator.clipboard.writeText(command).then(() => {
                const toast = document.getElementById('toast');
                toast.classList.add('show');
                setTimeout(() => {
                    toast.classList.remove('show');
                }, 2000);
            });
        }
    </script>
</body>
</html>`;

const installScript = `#!/bin/bash
set -euo pipefail

# Colors for output
GREEN='\\033[0;32m'
RED='\\033[0;31m'
YELLOW='\\033[0;33m'
NC='\\033[0m'

print_status() {
    echo -e "\${GREEN}▶\${NC} \$1"
}

print_error() {
    echo -e "\${RED}✗\${NC} \$1"
}

print_warning() {
    echo -e "\${YELLOW}⚠\${NC} \$1"
}

# Detect OS and architecture
OS="$(uname -s)"
ARCH="$(uname -m)"

case "\$OS" in
    Darwin)
        PLATFORM="macos"
        ;;
    Linux)
        PLATFORM="linux"
        ;;
    *)
        print_error "Unsupported operating system: \$OS"
        exit 1
        ;;
esac

# For now, we only have macOS releases
if [ "\$PLATFORM" != "macos" ]; then
    print_error "Currently, only macOS is supported. Linux and Windows support coming soon!"
    exit 1
fi

print_status "Installing Ignite..."

# Get the latest release from GitHub
LATEST_RELEASE=\$(curl -s https://api.github.com/repos/tuist/ignite/releases/latest)
DOWNLOAD_URL=\$(echo "\$LATEST_RELEASE" | grep -o '"browser_download_url": *"[^"]*ignite-macos.tar.gz"' | cut -d'"' -f4)

if [ -z "\$DOWNLOAD_URL" ]; then
    print_error "Could not find download URL for the latest release"
    exit 1
fi

VERSION=\$(echo "\$LATEST_RELEASE" | grep -o '"tag_name": *"[^"]*"' | cut -d'"' -f4)
print_status "Downloading Ignite \$VERSION..."

# Create temporary directory
TMP_DIR=\$(mktemp -d)
cd "\$TMP_DIR"

# Download and extract
curl -fsSL "\$DOWNLOAD_URL" -o ignite.tar.gz
tar -xzf ignite.tar.gz

# Install to /usr/local/bin
print_status "Installing to /usr/local/bin/ignite..."
if [ -w "/usr/local/bin" ]; then
    mv ignite /usr/local/bin/
else
    print_warning "Need sudo access to install to /usr/local/bin"
    sudo mv ignite /usr/local/bin/
fi

# Clean up
cd - > /dev/null
rm -rf "\$TMP_DIR"

# Verify installation
if command -v ignite &> /dev/null; then
    print_status "Ignite \$VERSION installed successfully!"
    echo ""
    echo "Run 'ignite' to start your Phoenix application"
else
    print_error "Installation failed. Please check your PATH includes /usr/local/bin"
    exit 1
fi`;

export default {
  async fetch(request) {
    const url = new URL(request.url);
    const userAgent = request.headers.get('User-Agent') || '';
    
    // Check if request is from a browser
    const isBrowser = userAgent.includes('Mozilla') || 
                     userAgent.includes('Chrome') || 
                     userAgent.includes('Safari') ||
                     userAgent.includes('Firefox') ||
                     userAgent.includes('Edge');
    
    // If curl/wget or similar, return the install script
    if (!isBrowser || userAgent.includes('curl') || userAgent.includes('wget')) {
      return new Response(installScript, {
        headers: {
          'Content-Type': 'text/plain; charset=utf-8',
        },
      });
    }
    
    // Otherwise, return the marketing page
    return new Response(html, {
      headers: {
        'Content-Type': 'text/html; charset=utf-8',
      },
    });
  },
};