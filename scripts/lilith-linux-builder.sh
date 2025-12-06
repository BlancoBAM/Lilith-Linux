#!/bin/bash

# Lilith Linux Distribution Builder
# Creates a custom Linux ISO with Deepin source integration and AI

set -e

# Configuration
LILITH_VERSION="1.0.0"
SOURCE_INTEGRATION=false
AI_INTEGRATION=false
QUIET_MODE=false

# Colors for output
RED='\x1b[0;31m'
GREEN='\x1b[0;32m'
YELLOW='\x1b[1;33m'
BLUE='\x1b[0;34m'
NC='\x1b[0m'

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --source-integration)
            SOURCE_INTEGRATION=true
            shift
            ;;
        --ai)
            AI_INTEGRATION=true
            shift
            ;;
        --quiet)
            QUIET_MODE=true
            shift
            ;;
        --help)
            echo "Lilith Linux Distribution Builder v$LILITH_VERSION"
            echo ""
            echo "Usage: $0 [options]"
            echo ""
            echo "Options:"
            echo "  --source-integration  Include Deepin source code modifications"
            echo "  --ai                  Include AI integration and models"
            echo "  --quiet              Suppress verbose output"
            echo "  --help               Show this help message"
            echo ""
            echo "Examples:"
            echo "  $0 --source-integration --ai"
            echo "  $0 --quiet"
            echo ""
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}❌ ERROR: This script must be run as root (sudo)${NC}"
    echo "Usage: sudo $0 [options]"
    exit 1
fi

# Logging
LOG_FILE="/var/log/lilith-builder-$(date +%Y%m%d-%H%M%S).log"
if [ "$QUIET_MODE" = false ]; then
    exec > >(tee -a "$LOG_FILE") 2>&1
fi

# Function to show progress
show_progress() {
    local current=$1
    local total=$2
    local message=$3
    local percentage=$((current * 100 / total))

    if [ "$QUIET_MODE" = false ]; then
        echo -e "${BLUE}[$percentage%] ${message}${NC}"
    fi
}

# Function to check system requirements
check_requirements() {
    show_progress 5 100 "Checking system requirements..."

    # Check RAM (minimum 8GB for build)
    RAM_GB=$(free -g | sed -n 's/^Mem:\s*\([0-9]*\).*/\1/p')
    if [ "$RAM_GB" -lt 8 ]; then
        echo -e "${RED}❌ ERROR: Minimum 8GB RAM required for building (you have ${RAM_GB}GB)${NC}"
        exit 1
    fi

    # Check disk space (minimum 25GB free)
    DISK_GB=$(df / | tail -1 | awk '{print int($4/1024/1024)}')
    if [ "$DISK_GB" -lt 25 ]; then
        echo -e "${RED}❌ ERROR: Minimum 25GB free disk space required (you have ${DISK_GB}GB)${NC}"
        exit 1
    fi

    show_progress 10 100 "System requirements met: ${RAM_GB}GB RAM, ${DISK_GB}GB disk space"
}

# Function to setup build environment
setup_build_environment() {
    show_progress 15 100 "Setting up build environment..."

    BASE_PATH="/opt/lilith-build"
    mkdir -p "$BASE_PATH"/{iso,squashfs,config,branding,scripts,output}

    # Create chroot environment
    if [ ! -d "$BASE_PATH/squashfs/rootfs" ]; then
        show_progress 20 100 "Creating base Ubuntu system..."
        debootstrap --arch=amd64 jammy "$BASE_PATH/squashfs/rootfs" http://archive.ubuntu.com/ubuntu
    fi

    show_progress 30 100 "Build environment ready"
}

# Function to install base packages
install_base_packages() {
    show_progress 35 100 "Installing base system packages..."

    # Prepare chroot
    mount --bind /dev "$BASE_PATH/squashfs/rootfs/dev" 2>/dev/null || true
    mount --bind /dev/pts "$BASE_PATH/squashfs/rootfs/dev/pts" 2>/dev/null || true
    mount --bind /proc "$BASE_PATH/squashfs/rootfs/proc" 2>/dev/null || true
    mount --bind /sys "$BASE_PATH/squashfs/rootfs/sys" 2>/dev/null || true

    # Create installation script
    cat > "$BASE_PATH/squashfs/rootfs/tmp/install-base.sh" << 'INSTALL_EOF'
#!/bin/bash
set -e
export DEBIAN_FRONTEND=noninteractive

# Update package lists
apt-get update
apt-get upgrade -y

# Install essential packages
apt-get install -y ubuntu-desktop ubuntu-standard linux-generic
apt-get install -y network-manager network-manager-gnome
apt-get install -y firefox thunderbird
apt-get install -y gnome-terminal gedit
apt-get install -y pulseaudio alsa-utils
apt-get install -y cups printer-driver-all
apt-get install -y language-pack-en language-pack-gnome-en

# Clean up
apt-get autoremove -y
apt-get clean
rm -rf /var/lib/apt/lists/*
INSTALL_EOF

    chmod +x "$BASE_PATH/squashfs/rootfs/tmp/install-base.sh"
    chroot "$BASE_PATH/squashfs/rootfs" /tmp/install-base.sh

    show_progress 50 100 "Base packages installed"
}

# Function to apply branding and customization
apply_branding() {
    show_progress 55 100 "Applying Lilith branding..."

    cat > "$BASE_PATH/squashfs/rootfs/tmp/branding.sh" << 'BRANDING_EOF'
#!/bin/bash
set -e

# System branding
cat > /etc/os-release << 'OS_EOF'
NAME="Lilith Linux"
VERSION="1.0.0"
ID=lilith
PRETTY_NAME="Lilith Linux 1.0.0 (Deepin Hell Edition)"
VERSION_ID="1.0.0"
HOME_URL="https://lilithlinux.org"
OS_EOF

cat > /etc/lsb-release << 'LSB_EOF'
DISTRIB_ID="Lilith Linux"
DISTRIB_RELEASE="1.0.0"
DISTRIB_CODENAME=lilith
DISTRIB_DESCRIPTION="Lilith Linux 1.0.0"
LSB_EOF

echo "lilith-linux" > /etc/hostname

# MOTD
cat > /etc/motd << 'MOTD_EOF'

██╗     ██╗██╗     ██╗████████╗██╗  ██╗    ██╗     ██╗███╗   ██╗██╗   ██╗██╗  ██╗
██║     ██║██║     ██║╚══██╔══╝██║  ██║    ██║     ██║████╗  ██║██║   ██║╚██╗██╔╝
██║     ██║██║     ██║   ██║   ███████║    ██║     ██║██╔██╗ ██║██║   ██║ ╚███╔╝
██║     ██║██║     ██║   ██║   ██╔══██║    ██║     ██║██║╚██╗██║██║   ██║ ██╔██╗
███████╗██║███████╗██║   ██║   ██║  ██║    ███████╗██║██║ ╚████║╚██████╔╝██╔╝ ██╗
╚══════╝╚═╝╚══════╝╚═╝   ╚═╝   ╚═╝  ╚═╝    ╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝

Welcome to Lilith Linux - Where Power Meets Elegance

MOTD_EOF

# GRUB branding
if [ -f "/etc/default/grub" ]; then
    sed -i 's/GRUB_DISTRIBUTOR=.*/GRUB_DISTRIBUTOR="Lilith Linux"/' /etc/default/grub || true
fi

# Create Lilith theme
mkdir -p /usr/share/themes/LilithHell/gtk-3.0
cat > /usr/share/themes/LilithHell/gtk-3.0/gtk.css << 'THEME_EOF'
@define-color accent_color #8b0000;
@define-color secondary_color #ff4444;
@define-color bg_color #1a1a1a;
@define-color text_color #ffffff;

* {
    font-family: Ubuntu;
    color: @text_color;
    background-color: @bg_color;
}

*:selected {
    background-color: @accent_color;
}

button {
    border-radius: 8px;
    background: linear-gradient(135deg, @accent_color, @secondary_color);
    color: @text_color;
    font-weight: bold;
}

window {
    border-radius: 12px;
    border: 1px solid @accent_color;
}
THEME_EOF

# Set default theme
mkdir -p /etc/skel/.config/gtk-3.0
cat > /etc/skel/.config/gtk-3.0/settings.ini << 'GTK_EOF'
[Settings]
gtk-theme-name=LilithHell
gtk-icon-theme-name=Papirus-Dark
gtk-font-name=Ubuntu 11
gtk-cursor-theme-name=Bibata-Modern-Ice
gtk-application-prefer-dark-theme=1
GTK_EOF
BRANDING_EOF

    chmod +x "$BASE_PATH/squashfs/rootfs/tmp/branding.sh"
    chroot "$BASE_PATH/squashfs/rootfs" /tmp/branding.sh

    show_progress 70 100 "Lilith branding applied"
}

# Function to integrate AI components
integrate_ai() {
    if [ "$AI_INTEGRATION" = true ]; then
        show_progress 75 100 "Integrating AI components..."

        # Copy AI files if they exist
        if [ -d "/opt/lilith-ai" ]; then
            cp -r /opt/lilith-ai "$BASE_PATH/squashfs/rootfs/opt/" 2>/dev/null || true
        fi

        # Create AI launcher script in chroot
        cat > "$BASE_PATH/squashfs/rootfs/usr/local/bin/lilith" << 'AI_EOF'
#!/bin/bash
# Lilith AI Launcher

AI_DIR="/opt/lilith-ai"

if [ ! -d "$AI_DIR" ]; then
    echo "Lilith AI not installed. Please run setup first."
    exit 1
fi

cd "$AI_DIR"
python3 main.py "$@"
AI_EOF

        chmod +x "$BASE_PATH/squashfs/rootfs/usr/local/bin/lilith"

        show_progress 80 100 "AI integration complete"
    fi
}

# Function to apply source integration
apply_source_integration() {
    if [ "$SOURCE_INTEGRATION" = true ]; then
        show_progress 82 100 "Applying source code integration..."

        # Run source integration if available
        if [ -f "/opt/lilith-build/integrate-source.sh" ]; then
            bash /opt/lilith-build/integrate-source.sh
        fi

        show_progress 90 100 "Source integration applied"
    fi
}

# Function to create ISO
create_iso() {
    show_progress 92 100 "Creating ISO image..."

    # Cleanup mounts
    umount "$BASE_PATH/squashfs/rootfs/dev/pts" 2>/dev/null || true
    umount "$BASE_PATH/squashfs/rootfs/dev" 2>/dev/null || true
    umount "$BASE_PATH/squashfs/rootfs/proc" 2>/dev/null || true
    umount "$BASE_PATH/squashfs/rootfs/sys" 2>/dev/null || true

    # Create squashfs
    mkdir -p "$BASE_PATH/iso/casper"
    mksquashfs "$BASE_PATH/squashfs/rootfs" "$BASE_PATH/iso/casper/filesystem.squashfs" -comp xz

    # Create ISO structure
    mkdir -p "$BASE_PATH/iso/boot/grub"

    # Create GRUB config
    cat > "$BASE_PATH/iso/boot/grub/grub.cfg" << 'GRUB_EOF'
set default="0"
set timeout=10

menuentry "Lilith Linux Live" {
    linux /casper/vmlinuz boot=casper quiet splash
    initrd /casper/initrd
}

menuentry "Lilith Linux Live (Safe Graphics)" {
    linux /casper/vmlinuz boot=casper nomodeset quiet splash
    initrd /casper/initrd
}
GRUB_EOF

    # Generate ISO
    cd "$BASE_PATH/iso"
    grub-mkrescue -o "../output/lilith-linux-$LILITH_VERSION.iso" . 2>/dev/null || true

    show_progress 98 100 "ISO creation complete"
}

# Function to show completion
show_completion() {
    echo ""
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                           BUILD COMPLETE!                                 ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${GREEN}🎉 Your custom Lilith Linux distribution is ready!${NC}"
    echo ""
    echo -e "${YELLOW}📁 Output Location:${NC}"
    echo -e "  ISO: ${CYAN}$BASE_PATH/output/lilith-linux-$LILITH_VERSION.iso${NC}"
    echo ""
    echo -e "${YELLOW}📊 Build Information:${NC}"
    echo -e "  Version: $LILITH_VERSION"
    echo -e "  Source Integration: $([ "$SOURCE_INTEGRATION" = true ] && echo "Enabled" || echo "Disabled")"
    echo -e "  AI Integration: $([ "$AI_INTEGRATION" = true ] && echo "Enabled" || echo "Disabled")"
    echo -e "  Build Time: $(date)"
    echo ""
    echo -e "${BLUE}🚀 Next Steps:${NC}"
    echo -e "  1. Test the ISO in VirtualBox or burn to USB"
    echo -e "  2. Install Lilith Linux on your system"
    echo -e "  3. Configure AI settings post-installation"
    echo ""
    echo -e "${GREEN}🧠 Enjoy your intelligent Linux distribution!${NC}"
    echo ""
    echo -e "Log file: $LOG_FILE"
}

# Main execution
main() {
    echo -e "${YELLOW}Lilith Linux Distribution Builder v$LILITH_VERSION${NC}"
    echo -e "${YELLOW}Source Integration: $([ "$SOURCE_INTEGRATION" = true ] && echo "Enabled" || echo "Disabled")${NC}"
    echo -e "${YELLOW}AI Integration: $([ "$AI_INTEGRATION" = true ] && echo "Enabled" || echo "Disabled")${NC}"
    echo ""

    check_requirements
    setup_build_environment
    install_base_packages
    apply_branding
    integrate_ai
    apply_source_integration
    create_iso
    show_completion
}

# Run main function
main

exit 0
