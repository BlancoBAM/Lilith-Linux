#!/bin/bash

# Lilith Linux - Complete Integration Setup Script
# Sets up the entire system including source code integration

set -e
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
LILITH_NAME="Lilith Linux"
DEEPIN_HELL_EDITION="Deepin Hell Edition"
VERSION="1.0.0"
SOURCE_DIR="/opt/lilith-sources"
BUILD_DIR="/opt/lilith-build"
WEB_APP_DIR="/opt/lilith-web-app"
LOG_FILE="/var/log/lilith-integration-setup.log"

# Initialize logging
echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Lilith Linux - Complete Integration Setup            ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Create directories
mkdir -p "$SOURCE_DIR" "$BUILD_DIR" "$WEB_APP_DIR" "$(dirname "$LOG_FILE")"
exec > >(tee -a "$LOG_FILE") 2>&1

# Function to install essential dependencies
install_essential_dependencies() {
    echo -e "${YELLOW}► Installing essential dependencies...${NC}"

    # Update system
    apt-get update
    apt-get upgrade -y

    # Essential build tools
    apt-get install -y git cmake make gcc g++ build-essential
    apt-get install -y debootstrap squashfs-tools grub-pc-bin xorriso
    apt-get install -y debhelper devscripts dpkg-dev

    # Qt/Deepin development libraries
    apt-get install -y qtbase5-dev qtdeclarative5-dev libqt5svg5-dev qt5-qmake
    apt-get install -y libglib2.0-dev libgtk-3-dev libcanberra-gtk3-dev
    apt-get install -y lib_systemd-dev libpulse-dev libnm-dev
    apt-get install -y libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev
    apt-get install -y libgstreamer-plugins-good1.0-dev libglibmm-2.4-dev

    echo -e "${GREEN}✓ Essential dependencies installed${NC}"
}

# Function to install GUI dependencies
install_gui_dependencies() {
    echo -e "${YELLOW}► Installing GUI development dependencies...${NC}"

    # Node.js and npm (if not available)
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
    apt-get install -y nodejs

    # GUI dependencies
    apt-get install -y libnss3-dev libatk-bridge2.0-dev libdrm2 libxkbcommon-dev
    apt-get install -y libxcomposite1 libxdamage1 libxrandr2 libgbm1 libxss1 libasound2

    echo -e "${GREEN}✓ GUI dependencies installed${NC}"
}

# Function to setup web app
setup_web_app() {
    echo -e "${YELLOW}► Setting up Lilith web application...${NC}"

    # Copy web app files if they don't exist
    if [ ! -f "$WEB_APP_DIR/package.json" ]; then
        cp -r lilith-web-app/* "$WEB_APP_DIR/" 2>/dev/null || true

        # Install web app dependencies
        cd "$WEB_APP_DIR"
        npm install

        # Copy our SourceIntegration component
        mkdir -p "$WEB_APP_DIR/src/components"
        cp "lilith-web-app/src/components/SourceIntegration.tsx" "$WEB_APP_DIR/src/components/" 2>/dev/null || true

        # Update main App.tsx to include source integration
        if [ -f "$WEB_APP_DIR/src/App.tsx" ]; then
            sed -i 's/import.*from.*lucide-react/import SourceIntegration from \".\/components\/SourceIntegration\"\\nimport { Download, ChevronRight, Menu, X } from '\''lucide-react'\''/' "$WEB_APP_DIR/src/App.tsx"
            sed -i '/const LilithApp/,/return (/-1a\\n  const [config, setConfig] = useState({osName: '\''Lilith Linux'\'', desktopName: '\''Deepin Hell Edition'\'', version: '\''1.0.0'\'', packagesToRemove: '\''deepin-store*,fcitx*,*chinese*'\'', packagesToAdd: '\''curl,wget,git,vim,htop'\'', accentColor: '\''#8b0000'\'', secondaryColor: '\''#ff4444'\'', backgroundColor: '\''#1a1a1a'\'', textColor: '\''#ffffff'\'', fontFamily: '\''Ubuntu'\'', iconTheme: '\''Papirus-Dark'\'', cursorTheme: '\''Bibata-Modern-Ice'\'', windowBorderRadius: '\''8'\'', customRepoEnabled: false, customRepoDomain: '\''repo.lilithlinux.org'\'', sourceIntegrationEnabled: false, sourceDir: '\''\/opt\/lilith-sources'\'', buildDir: '\''\/opt\/lilith-build'\''});' "$WEB_APP_DIR/src/App.tsx"
            sed -i 's/steps.*=.*\[/steps = [welcome, config, packages, theming, repository, {title: '\''Deepin Source Integration'\'', icon: '\''📂'\'', content: '\''source-integration'\''}]/' "$WEB_APP_DIR/src/App.tsx"
        fi

        cd -
    fi

    echo -e "${GREEN}✓ Web application setup complete${NC}"
}

# Function to integrate with main GUI
integrate_with_main_gui() {
    echo -e "${YELLOW}► Integrating source code features with main GUI...${NC}"

    # Copy source integration component to main GUI
    cp "lilith-web-app/src/components/SourceIntegration.tsx" "$WEB_APP_DIR/src/components/" 2>/dev/null || true

    # Update main App.tsx to include source integration step
    if [ -f "$WEB_APP_DIR/src/App.tsx" ]; then
        # Add the new step to the steps array
        sed -i 's/steps = .*]/steps = steps.concat([{title: '\''Deepin Source Integration'\'', icon: '\''📂'\'', content: '\''source-integration'\''}])/' "$WEB_APP_DIR/src/App.tsx" 2>/dev/null || \
        sed -i '/steps = \[/a\\    {title: '\''Deepin Source Integration'\'', icon: '\''📂'\'', content: '\''source-integration'\''},' "$WEB_APP_DIR/src/App.tsx" 2>/dev/null || \
        sed -i 's/]\s*$/,{title: '\''Deepin Source Integration'\'', icon: '\''📂'\'', content: '\''source-integration'\''}]/' "$WEB_APP_DIR/src/App.tsx"

        # Add source integration render case
        sed -i '/renderContent.*{/a\\      case '\''source-integration'\'':\\n        return <SourceIntegration config={config} setConfig={setConfig} currentStep={currentStep} setCurrentStep={setCurrentStep} steps={steps} />;' "$WEB_APP_DIR/src/App.tsx" 2>/dev/null || true

        # Add import if not present
        if ! grep -q "SourceIntegration" "$WEB_APP_DIR/src/App.tsx"; then
            sed -i '/import.*from.*react/a\\nimport SourceIntegration from '\''./components/SourceIntegration'\'';' "$WEB_APP_DIR/src/App.tsx"
        fi
    fi

    echo -e "${GREEN}✓ GUI integration complete${NC}"
}

# Function to create master runner
create_master_runner() {
    echo -e "${YELLOW}► Creating master runner script...${NC}"

    cat > lilith-complete-setup.sh << 'MASTER_EOF'
#!/bin/bash

# Lilith Linux - Master Runner Script
# Run this after setup to execute the complete integration

set -e

echo "🐦 Welcome to Lilith Linux Setup"
echo "=================================="
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run with sudo:"
    echo "sudo bash lilith-complete-setup.sh"
    exit 1
fi

echo "Starting Lilith Linux Setup..."
echo ""

# Run the integration setup
bash lilith-integration-setup.sh

# Run source code integration
bash lilith-source-integration.sh

# Final setup
echo ""
echo "🎉 Setup Complete!"
echo ""
echo "Next steps:"
echo "1. Run: cd /opt/lilith-web-app && npm run dev"
echo "2. Open browser and configure your distribution"
echo "3. Run: sudo bash /opt/lilith-build/lilith-linux-builder.sh"
echo ""
echo "For source code builds:"
echo "1. sudo bash /opt/lilith-sources/build-lilith-components.sh"
echo "2. Test with --source-integration flag"
MASTER_EOF

    chmod +x lilith-complete-setup.sh

    echo -e "${GREEN}✓ Master runner script created${NC}"
}

# Main execution
main() {
    echo -e "${YELLOW}Starting Lilith Linux Complete Setup...${NC}"
    echo ""

    install_essential_dependencies
    install_gui_dependencies
    setup_web_app
    integrate_with_main_gui
    create_master_runner

    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║  Complete Integration Setup Finished!                ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}Next Steps:${NC}"
    echo "1. Run: sudo bash lilith-complete-setup.sh"
    echo "2. Then: cd /opt/lilith-web-app && npm run dev"
    echo "3. Configure your distribution in the web interface"
    echo ""
    echo -e "${GREEN}Your Lilith Linux project is now ready for deep source code integration!${NC}"
}

# Run main function
main

exit 0
