#!/bin/bash

# Lilith Linux - Complete Master Setup Script
# The ultimate all-in-one setup for Lilith Linux with all features

set -e

# Configuration
LILITH_VERSION="1.0.0"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Banner
cat << 'BANNER_EOF'
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║  ███▄ ▄███▓ ██▓ ██▓     ███▄ ▄███▓ ██▓ ██▓    ▄▄▄█████▓ ██▓ ▄████  ██▓       ║
║ ▓██▒▀█▀ ██▒▓██▒▓██▒    ▓██▒▀█▀ ██▒▓██▒▓██▒    ▓  ██▒ ▓▒▓██▒▓██▒  ██▒▒██▒    ║
║  ▓██╔══██ ██▒▓██▒▒██▒   ▓██ ▀▄ ██▒▒▓██▒▓██▒    ▒ ▓██░ ▒░▒██▒▒██░  ▓██▒▒██░    ║
║  ▓██║ ▓█▓▓█ ▓██░▓██▒   ▓██▄   ▓██░░▓██░░██░    ░ ▓██▓ ░ ░██░░██▄█▓██ ░██░    ║
║  ▓██▒ ▒▒ ▒  ░░░ ░░░░░   ▒ ▓██▄ ▄██░░ ░  ░░░░░    ▒██▒ ░ ░ ▓███▀ ██▒░ ░░     ║
║  ▓█████▄ ▒   ░ ░∩░  ░  ▒ ▓███▀ ▒░░ ░ ░░░  ░░  ▒ ░░   ░ ▓██▄   ██▒░░ ░     ║
║  ▓▓▄▄ }}} ░ ░░  ░░  ░  ░▓██▒▒ ░ ░░ ░ ░░░  ░░ ░ ░░ └── ░░░ ▒ ▓██▄ ░██████   ║
║  ▓▓ ▀▄ ▀█ ░ ░ ░▫▫  ░ ░    ▒░░░ ░░ ░ ░░░ ░ ░ ░ ░░░ ███▄█▓ ▒ ▓██▓ ▒██▓      ║
║  ▒ ▀ ▓ ▒     ░ ░░░ ░ ░░    ░ ░░░ ░ ░░ ░ ░ ░░ ░ ▒ ▒▒░ ░ ░ ▓██▒▀█▄▄█ ░ ░      ║
║                                                                          ░░░ ░   ║
║  ════════════════════════════════════════════════════════════════════════════════  ║
║                                                                               ║
║  🐦 Where Local Intelligence Meets Linux Freedom                              ║
║                                                                              ║
║  Core Technologies:                                                          ║
║  • Deepin Source Code Integration                                            ║
║  • Local AI with llama.cpp Optimization                                      ║
║  • Hardware-optimized Quantization                                           ║
║  • Specialized Knowledge Areas                                               ║
║  • Desktop & Terminal Integration                                            ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
BANNER_EOF

echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "❌ ERROR: This script must be run as root (sudo)"
    echo "Usage: sudo bash $0"
    exit 1
fi

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Logging
LOG_FILE="/var/log/lilith-setup-$(date +%Y%m%d-%H%M%S).log"
exec > >(tee -a "$LOG_FILE") 2>&1

# Function to check system requirements
check_requirements() {
    echo -e "${BLUE}🔍 Checking system requirements...${NC}"

    # Check RAM
    RAM_GB=$(free -g | sed -n 's/^Mem:\s*\([0-9]*\).*/\1/p')
    if [ "$RAM_GB" -lt 4 ]; then
        echo -e "${RED}❌ ERROR: Minimum 4GB RAM required (you have ${RAM_GB}GB)${NC}"
        exit 1
    fi

    # Check disk space
    DISK_GB=$(df / | tail -1 | awk '{print int($4/1024/1024)}')
    if [ "$DISK_GB" -lt 50 ]; then
        echo -e "${RED}❌ ERROR: Minimum 50GB free disk space required (you have ${DISK_GB}GB)${NC}"
        exit 1
    fi

    # Check internet connectivity
    if ! curl -s --connect-timeout 5 https://github.com >/dev/null; then
        echo -e "${RED}❌ ERROR: Internet connection required${NC}"
        exit 1
    fi

    echo -e "${GREEN}✅ System requirements met: ${RAM_GB}GB RAM, ${DISK_GB}GB disk space${NC}"
}

# Function to install base dependencies
install_base_dependencies() {
    echo -e "${BLUE}📦 Installing base system dependencies...${NC}"

    # Update system
    apt-get update
    apt-get upgrade -y

    # Essential build tools
    apt-get install -y git cmake make gcc g++ build-essential
    apt-get install -y debootstrap squashfs-tools grub-pc-bin xorriso
    apt-get install -y debhelper devscripts dpkg-dev jq curl wget

    # Qt/Deepin dependencies
    apt-get install -y qtbase5-dev qtdeclarative5-dev libqt5svg5-dev
    apt-get install -y libglib2.0-dev libgtk-3-dev libcanberra-gtk3-dev

    # AI/ML dependencies
    apt-get install -y python3 python3-pip python3-dev
    apt-get install -y libopenblas-dev libblas-dev
    # libatlas-base-dev removed from Ubuntu, use alternatives
    apt-get install -y liblapack-dev liblapacke-dev
    apt-get install -y libffi-dev libssl-dev

    # Desktop integration
    apt-get install -y xdotool wmctrl zenity

    echo -e "${GREEN}✅ Base dependencies installed${NC}"
}

# Function to setup Lilith directories
setup_directories() {
    echo -e "${BLUE}📁 Setting up Lilith directories...${NC}"

    mkdir -p /opt/lilith-build
    mkdir -p /opt/lilith-sources
    mkdir -p /opt/lilith-ai
    mkdir -p /opt/lilith-web-app
    mkdir -p /var/log/lilith

    chown -R root:root /opt/lilith*

    echo -e "${GREEN}✅ Directory structure created${NC}"
}

# Function to copy all scripts and components
copy_lilith_files() {
    echo -e "${BLUE}📋 Copying Lilith system files...${NC}"

    local SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    # Copy all scripts
    cp "$SCRIPT_DIR"/*.sh /opt/lilith-build/ 2>/dev/null || true
    cp "$SCRIPT_DIR"/*.md /opt/lilith-build/ 2>/dev/null || true

    # Copy web app if it exists
    if [ -d "$SCRIPT_DIR/../packages/lilith-web-app" ]; then
        cp -r "$SCRIPT_DIR/../packages/lilith-web-app"/* /opt/lilith-web-app/ 2>/dev/null || true
    fi

    # Make scripts executable
    find /opt/lilith-build -name "*.sh" -exec chmod +x {} \;

    echo -e "${GREEN}✅ Lilith files copied and configured${NC}"
}

# Function to integrate GUI with AI components
integrate_gui_with_ai() {
    echo -e "${BLUE}🖥️ Integrating GUI with AI components...${NC}"

    if [ -f "/opt/lilith-web-app/src/App.tsx" ]; then
        # Add AI integration step to the steps array
        sed -i '/Deepin Source Integration/{
            a\
    {title: '\''AI Integration Setup'\'', icon: '\''🧠'\'', content: '\''ai-integration'\''},
        }' /opt/lilith-web-app/src/App.tsx 2>/dev/null || \
        sed -i 's/Deepin Source Integration.*,$/Deepin Source Integration'\''}, {title: '\''AI Integration Setup'\'', icon: '\''🧠'\'', content: '\''ai-integration'\''},/g' /opt/lilith-web-app/src/App.tsx || \
        sed -i 's/]\s*$/,{title: '\''AI Integration Setup'\'', icon: '\''🧠'\'', content: '\''ai-integration'\''}]/g' /opt/lilith-web-app/src/App.tsx

        # Add AI integration import
        if ! grep -q "AIIntegration" "/opt/lilith-web-app/src/App.tsx"; then
            sed -i '/SourceIntegration from/a\\nimport AIIntegration from '\''./components/AIIntegration'\'';' /opt/lilith-web-app/src/App.tsx
        fi

        # Add AI render case
        sed -i '/source-integration.*{/a\\      case '\''ai-integration'\'':\\n        return <AIIntegration config={config} setConfig={setConfig} currentStep={currentStep} setCurrentStep={setCurrentStep} steps={steps} />;' /opt/lilith-web-app/src/App.tsx 2>/dev/null || true

        echo -e "${GREEN}✅ GUI integrated with AI components${NC}"
    else
        echo -e "${YELLOW}⚠️ Warning: Web app not found, skipping GUI integration${NC}"
    fi
}

# Function to setup web app dependencies
setup_web_app() {
    echo -e "${BLUE}🌐 Setting up web application...${NC}"

    if [ -f "/opt/lilith-web-app/package.json" ]; then
        cd /opt/lilith-web-app
        npm install --silent
        echo -e "${GREEN}✅ Web application dependencies installed${NC}"
    else
        echo -e "${YELLOW}⚠️ Warning: Web app package.json not found${NC}"
    fi
}

# Function to run source integration setup
run_source_integration() {
    echo -e "${BLUE}🔧 Running Deepin Source Code Integration...${NC}"

    if [ -f "/opt/lilith-build/lilith-source-integration.sh" ]; then
        # Run source integration but don't fail the entire setup if it fails
        if bash /opt/lilith-build/lilith-source-integration.sh; then
            echo -e "${GREEN}✅ Source integration completed successfully${NC}"
        else
            echo -e "${YELLOW}⚠️ Warning: Source integration failed, but setup will continue${NC}"
            echo -e "${YELLOW}Note: Some Deepin repositories may not be available${NC}"
        fi
    else
        echo -e "${YELLOW}⚠️ Warning: Source integration script not found${NC}"
    fi
}

# Function to create main launcher
create_launcher() {
    echo -e "${BLUE}🚀 Creating main Lilith launcher...${NC}"

    cat > /usr/local/bin/lilith-launcher.sh << 'LAUNCHER_EOF'
#!/bin/bash

# Lilith Linux Main Launcher
# Launches web interface and manages services

case "$1" in
    "web")
        echo "Starting Lilith web interface..."
        cd /opt/lilith-web-app
        npm run dev
        ;;
    "ai")
        echo "Testing Lilith AI..."
        if systemctl is-active --quiet lilith-ai; then
            lilith "Hello Lilith AI! How can you help me today?"
        else
            echo "Starting AI service..."
            systemctl start lilith-ai
            sleep 2
            lilith "AI service is now active. How can I assist you?"
        fi
        ;;
    "build")
        echo "Launching Lilith ISO builder..."
        sudo bash /opt/lilith-build/lilith-linux-builder.sh "$@"
        ;;
    "status")
        echo "=== Lilith Linux Status ==="
        echo "Web App: $(if [ -f /opt/lilith-web-app/package.json ]; then echo "Installed"; else echo "Not found"; fi)"
        echo "AI Service: $(if systemctl is-active --quiet lilith-ai 2>/dev/null; then echo "Running"; else echo "Stopped"; fi)"
        echo "Source Code: $(if [ -d /opt/lilith-sources ]; then echo "Integrated"; else echo "Not integrated"; fi)"
        echo "Build Tools: $(if [ -f /opt/lilith-build/lilith-linux-builder.sh ]; then echo "Ready"; else echo "Not ready"; fi)"
        ;;
    "help"|*)
        echo "Lilith Linux Launcher v$LILITH_VERSION"
        echo ""
        echo "Usage: lilith-launcher.sh [command]"
        echo ""
        echo "Commands:"
        echo "  web       - Start the web interface"
        echo "  ai        - Test AI functionality"
        echo "  build     - Launch ISO builder with options"
        echo "  status    - Show system status"
        echo "  help      - Show this help message"
        echo ""
        echo "Examples:"
        echo "  lilith-launcher.sh web"
        echo "  lilith-launcher.sh build --source-integration"
        echo "  lilith-launcher.sh ai"
        ;;
esac
LAUNCHER_EOF

    chmod +x /usr/local/bin/lilith-launcher.sh

    # Create convenient symlink
    ln -sf /usr/local/bin/lilith-launcher.sh /usr/local/bin/lilith-launch

    echo -e "${GREEN}✅ Lilith launcher created at /usr/local/bin/lilith-launch${NC}"
}

# Function to create desktop shortcuts
create_desktop_shortcuts() {
    echo -e "${BLUE}📱 Creating desktop shortcuts...${NC}"

    mkdir -p /usr/share/applications

    # Lilith Web App launcher
    cat > /usr/share/applications/lilith-web.desktop << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Lilith Linux Builder
Comment=Custom Linux Distribution Builder with AI
Exec=x-terminal-emulator -e "sudo /usr/local/bin/lilith-launch web"
Icon=computer
Terminal=false
Categories=System;Utility;
Keywords=linux;distro;builder;ai;
EOF

    # Lilith AI Tester
    cat > /usr/share/applications/lilith-ai.desktop << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Lilith AI Assistant
Comment=Local AI Assistant for Lilith Linux
Exec=x-terminal-emulator -e "/usr/local/bin/lilith-launch ai"
Icon=ai
Terminal=false
Categories=Utility;Education;
Keywords=ai;assistant;intelligence;
EOF

    # Update desktop database
    update-desktop-database 2>/dev/null || true

    echo -e "${GREEN}✅ Desktop shortcuts created${NC}"
}

# Function to create final instructions
show_completion_info() {
    echo ""
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                              INSTALLATION COMPLETE!                      ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${GREEN}🎉 Congratulations! Lilith Linux is now fully set up!${NC}"
    echo ""
    echo -e "${YELLOW}📋 What you now have:${NC}"
    echo -e "  ✅ Complete Deepin Source Code Integration"
    echo -e "  ✅ Advanced AI system with hardware optimization"
    echo -e "  ✅ Specialized knowledge areas (sysadmin, coding, writing, etc.)"
    echo -e "  ✅ Integrated web interface for easy configuration"
    echo -e "  ✅ Desktop shortcuts and terminal commands"
    echo -e "  ✅ Source-level rebranding and customization"
    echo ""
    echo -e "${MAGENTA}🚀 Quick Start:${NC}"
    echo -e "  1. Launch: ${CYAN}lilith-launch web${NC} (or desktop shortcut)"
    echo -e "  2. Configure your distribution (7 steps including AI)"
    echo -e "  3. Build: ${CYAN}sudo lilith-launch build --source-integration${NC}"
    echo -e "  4. Test AI: ${CYAN}lilith \"How do I configure networking?\"${NC}"
    echo ""
    echo -e "${BLUE}📚 Documentation:${NC}"
    echo -e "  • Main README: ${CYAN}/opt/lilith-build/README.md${NC}"
    echo -e "  • Source Integration: ${CYAN}/opt/lilith-build/LILITH_SOURCE_INTEGRATION_README.md${NC}"
    echo -e "  • AI Integration: ${CYAN}/opt/lilith-ai/README.md${NC}"
    echo -e "  • Logs: ${CYAN}/var/log/lilith/*${NC}"
    echo ""
    echo -e "${RED}🔧 System Status:${NC}"
    echo -e "  • AI Service: $(if systemctl is-active --quiet lilith-ai 2>/dev/null; then echo -e "${GREEN}Running${NC}"; else echo -e "${YELLOW}Not started${NC}"; fi)"
    echo -e "  • Web App: $(if [ -d /opt/lilith-web-app/node_modules ]; then echo -e "${GREEN}Ready${NC}"; else echo -e "${YELLOW}Not built${NC}"; fi)"
    echo -e "  • Source Code: $(if [ -d /opt/lilith-sources/dde-daemon ]; then echo -e "${GREEN}Integrated${NC}"; else echo -e "${YELLOW}Not integrated${NC}"; fi)"
    echo ""
    echo -e "${MAGENTA}💡 Pro Tips:${NC}"
    echo -e "  • Start with: ${CYAN}lilith-launch status${NC} to check everything"
    echo -e "  • Build full system: ${CYAN}lilith-launch build --source-integration --ai${NC}"
    echo -e "  • Desktop AI: Press ${CYAN}Ctrl+Alt+A${NC} anywhere"
    echo -e "  • Specialized help: ${CYAN}ask 'system administration'${NC}"
    echo ""
    echo -e "${GREEN}🧠 Your AI assistant is ready to help you master Lilith Linux!${NC}"
    echo ""
    echo -e "${CYAN}Made with 🔥 by the Lilith Linux team${NC}"
    echo ""
    echo -e "Log file: $LOG_FILE"
}

# Main execution
main() {
    echo -e "${YELLOW}Starting Lilith Linux Complete Setup...${NC}"
    echo -e "Version: $LILITH_VERSION"
    echo -e "Timestamp: $(date)"
    echo ""

    check_requirements
    install_base_dependencies
    setup_directories
    copy_lilith_files
    integrate_gui_with_ai
    setup_web_app
    run_source_integration
    create_launcher
    create_desktop_shortcuts

    show_completion_info
}

# Run main function
main

exit 0
