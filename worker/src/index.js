const html = `<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ignite - App Development in the AI World</title>
    <meta name="description" content="A web-based coding experience for apps. Create new projects or use existing ones.">
    
    <style>
        :root {
            --bg-primary: #000000;
            --bg-secondary: #0a0a0a;
            --text-primary: #ffffff;
            --text-secondary: #999999;
            --accent: #7c3aed;
            --accent-hover: #8b5cf6;
            --terminal-bg: #0d0d0d;
            --terminal-border: #1a1a1a;
            --terminal-text: #a78bfa;
            --gradient-1: #7c3aed;
            --gradient-2: #8b5cf6;
            --gradient-3: #a78bfa;
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
            padding: 20px 0;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .logo-container {
            display: inline-flex;
            align-items: center;
            gap: 12px;
        }
        
        .logo {
            font-size: 24px;
            font-weight: 700;
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.9), rgba(255, 255, 255, 0.7));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        .by-tuist {
            background: var(--accent);
            padding: 4px 10px;
            border-radius: 16px;
            font-size: 12px;
            color: white;
            font-weight: 600;
            letter-spacing: 0.3px;
        }

        .hero {
            padding: 40px 0 30px;
            text-align: center;
        }

        .hero h1 {
            font-size: clamp(32px, 5vw, 56px);
            font-weight: 800;
            line-height: 1.1;
            margin-bottom: 16px;
            letter-spacing: -0.03em;
            background: linear-gradient(135deg, var(--text-primary) 0%, var(--text-secondary) 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .hero .subtitle {
            font-size: clamp(16px, 2vw, 20px);
            color: var(--text-secondary);
            margin-bottom: 32px;
            font-weight: 400;
            max-width: 500px;
            margin-left: auto;
            margin-right: auto;
        }

        .terminal-container {
            max-width: 600px;
            margin: 0 auto 32px;
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
            padding: 12px 16px;
            display: flex;
            align-items: center;
            gap: 6px;
            border-bottom: 1px solid var(--terminal-border);
        }

        .terminal-dot {
            width: 10px;
            height: 10px;
            border-radius: 50%;
            background: var(--terminal-border);
        }

        .terminal-dot:nth-child(1) { background: #ff5f57; }
        .terminal-dot:nth-child(2) { background: #ffbd2e; }
        .terminal-dot:nth-child(3) { background: #28ca42; }

        .terminal-body {
            padding: 20px;
            font-family: 'SF Mono', Monaco, 'Cascadia Code', 'Roboto Mono', monospace;
            font-size: 14px;
            line-height: 1.5;
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
            width: 8px;
            height: 16px;
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
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 20px;
            margin-top: 40px;
            margin-bottom: 40px;
            max-width: 1000px;
            margin-left: auto;
            margin-right: auto;
        }

        .feature {
            padding: 20px;
            background: rgba(255, 255, 255, 0.03);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 12px;
            transition: all 0.3s ease;
            position: relative;
            display: flex;
            flex-direction: column;
            min-height: 160px;
        }

        .feature:hover {
            background: rgba(255, 255, 255, 0.05);
            border-color: rgba(255, 255, 255, 0.2);
            transform: translateY(-4px);
        }

        .feature h3 {
            font-size: 16px;
            margin-bottom: 6px;
            color: var(--text-primary);
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .feature-icon {
            width: 20px;
            height: 20px;
            flex-shrink: 0;
        }
        
        .feature-icon svg {
            width: 100%;
            height: 100%;
            fill: var(--terminal-text);
        }

        .feature p {
            color: var(--text-secondary);
            line-height: 1.5;
            font-size: 14px;
            flex-grow: 1;
        }
        
        .feature.paid {
            background: linear-gradient(135deg, rgba(124, 58, 237, 0.1), rgba(139, 92, 246, 0.05));
            border-color: rgba(124, 58, 237, 0.3);
        }
        
        .powered-by {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-top: auto;
            padding-top: 12px;
            font-size: 12px;
            color: var(--text-secondary);
        }
        
        .powered-by img {
            height: 20px;
            width: auto;
            filter: brightness(0.8);
        }
        
        .powered-by a {
            color: var(--terminal-text);
            text-decoration: none;
            font-weight: 500;
            transition: color 0.2s ease;
        }
        
        .powered-by a:hover {
            color: var(--accent-hover);
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
            padding: 24px 0;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            text-align: center;
            color: var(--text-secondary);
            font-size: 13px;
        }

        @media (max-width: 768px) {
            .hero {
                padding: 30px 0 20px;
            }
            
            .hero h1 {
                font-size: 28px;
            }
            
            .hero .subtitle {
                font-size: 15px;
                margin-bottom: 24px;
            }
            
            .terminal-body {
                padding: 16px;
                font-size: 12px;
            }
            
            .features {
                gap: 12px;
                margin-top: 30px;
                margin-bottom: 30px;
            }
            
            .feature {
                padding: 16px;
            }
            
            .feature h3 {
                font-size: 15px;
            }
            
            .feature p {
                font-size: 13px;
            }
        }
    </style>
</head>
<body>
    <div class="noise"></div>
    
    <div class="container">
        <header>
            <div class="logo-container">
                <div class="logo">🔥 Ignite</div>
                <div class="by-tuist">by Tuist</div>
            </div>
        </header>
        
        <section class="hero">
            <h1>Apple App Development<br>in the AI World</h1>
            <p class="subtitle">
                A web-based coding experience powered by AI
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
                <h3>
                    <span class="feature-icon">
                        <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <path d="M12 2L13.09 8.26L19 7L15.45 11.82L21 16L14.82 16.45L16 22L11 17.27L6 22L7.18 16.45L1 16L6.55 11.82L3 7L8.91 8.26L12 2Z"/>
                        </svg>
                    </span>
                    Ignite
                </h3>
                <p>We assist you in preserving the energy of your idea and help materialize it, turning inspiration into reality.</p>
            </div>
            <div class="feature">
                <h3>
                    <span class="feature-icon">
                        <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <path d="M22.7 19L13.6 9.9C14.5 7.6 14 4.9 12.1 3C10.1 1 7.1 0.6 4.7 1.7L9 6L6 9L1.6 4.7C0.4 7.1 0.9 10.1 2.9 12.1C4.8 14 7.5 14.5 9.8 13.6L18.9 22.7C19.3 23.1 19.9 23.1 20.3 22.7L22.6 20.4C23.1 20 23.1 19.3 22.7 19Z"/>
                        </svg>
                    </span>
                    Build
                </h3>
                <p>We help you build your idea with an overhauled developer experience that's conversational and web-based, making development accessible to everyone.</p>
            </div>
            <div class="feature paid">
                <h3>
                    <span class="feature-icon">
                        <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <path d="M9 11H7V13H9V11ZM13 11H11V13H13V11ZM17 11H15V13H17V11ZM19 4H18V2H16V4H8V2H6V4H5C3.89 4 3.01 4.9 3.01 6L3 20C3 21.1 3.89 22 5 22H19C20.1 22 21 21.1 21 20V6C21 4.9 20.1 4 19 4ZM19 20H5V9H19V20Z"/>
                        </svg>
                    </span>
                    QA
                </h3>
                <p>Use our intelligent agents to test your work automatically. Get comprehensive quality assurance without manual effort.</p>
                <div class="powered-by">
                    <img src="https://github.com/tuist/tuist/blob/main/docs/docs/public/logo.png?raw=true" alt="Tuist Logo">
                    <span>Powered by <a href="https://tuist.io" target="_blank">Tuist</a></span>
                </div>
            </div>
            <div class="feature paid">
                <h3>
                    <span class="feature-icon">
                        <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <path d="M18 16.08C17.24 16.08 16.56 16.38 16.04 16.85L8.91 12.7C8.96 12.47 9 12.24 9 12S8.96 11.53 8.91 11.3L15.96 7.19C16.5 7.69 17.21 8 18 8C19.66 8 21 6.66 21 5S19.66 2 18 2 15 3.34 15 5C15 5.24 15.04 5.47 15.09 5.7L8.04 9.81C7.5 9.31 6.79 9 6 9C4.34 9 3 10.34 3 12S4.34 15 6 15C6.79 15 7.5 14.69 8.04 14.19L15.16 18.35C15.11 18.56 15.08 18.78 15.08 19C15.08 20.61 16.39 21.92 18 21.92S20.92 20.61 20.92 19 19.61 16.08 18 16.08Z"/>
                        </svg>
                    </span>
                    Share
                </h3>
                <p>Release and share your creations instantly. Generate live previews and collaborate with others in real-time.</p>
                <div class="powered-by">
                    <img src="https://github.com/tuist/tuist/blob/main/docs/docs/public/logo.png?raw=true" alt="Tuist Logo">
                    <span>Powered by <a href="https://tuist.io" target="_blank">Tuist</a></span>
                </div>
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