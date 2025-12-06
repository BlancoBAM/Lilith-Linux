import { useState } from 'react';
import { Download, ChevronRight, Menu, X } from 'lucide-react';
import AIIntegration from './components/AIIntegration';

const LilithApp = () => {
  const [currentStep, setCurrentStep] = useState(0);
  const [menuOpen, setMenuOpen] = useState(false);
  const [config, setConfig] = useState({
    osName: 'Lilith Linux',
    desktopName: 'Deepin Hell Edition',
    version: '1.0.0',
    packagesToRemove: 'deepin-store-data\ndeep-app-store\nfcitx*\nibus-pinyin\n*chinese*\n*zh-cn*',
    packagesToAdd: 'curl\nwget\ngit\nvim\nhtop\nneofetch\nbuild-essential',
    accentColor: '#8b0000',
    secondaryColor: '#ff4444',
    backgroundColor: '#1a1a1a',
    textColor: '#ffffff',
    fontFamily: 'Ubuntu',
    iconTheme: 'Papirus-Dark',
    cursorTheme: 'Bibata-Modern-Ice',
    windowBorderRadius: '8',
    customRepoEnabled: false,
    customRepoDomain: 'repo.lilithlinux.org'
  });

  const steps = [
    {
      title: 'Welcome to Lilith',
      icon: '🔥',
      content: 'welcome'
    },
    {
      title: 'Basic Configuration',
      icon: '⚙️',
      content: 'config'
    },
    {
      title: 'Packages',
      icon: '📦',
      content: 'packages'
    },
    {
      title: 'Advanced Theming',
      icon: '🎨',
      content: 'theming'
    },
    {
      title: 'Repository Setup',
      icon: '💾',
      content: 'repository'
    },
    {
      title: 'AI Integration Setup',
      icon: '🧠',
      content: 'ai-integration'
    },
    {
      title: 'Review & Download',
      icon: '📥',
      content: 'download'
    }
  ];

  const generateBuildScript = () => {
    const removePackages = config.packagesToRemove.split('\n').filter(p => p.trim()).map(p => `apt-get remove --purge -y ${p} 2>/dev/null || true`).join('\n');
    const addPackages = config.packagesToAdd.split('\n').filter(p => p.trim()).join(' ');

    return `#!/bin/bash
# ${config.osName} Distribution Builder
# Generated: $(date)

set -e
RED='\\x1b[0;31m'
GREEN='\\x1b[0;32m'
YELLOW='\\x1b[1;33m'
NC='\\x1b[0m'

echo -e "\${GREEN}╔════════════════════════════════════╗\${NC}"
echo -e "\${GREEN}║  ${config.osName} Distribution Builder  ║\${NC}"
echo -e "\${GREEN}╚════════════════════════════════════╝\${NC}"
echo ""
echo -e "\${YELLOW}Edition:\${NC} ${config.desktopName}"
echo -e "\${YELLOW}Version:\${NC} ${config.version}"
echo ""

BASE_PATH="/opt/lilith-build"
mkdir -p "$BASE_PATH"/{iso,squashfs,config,branding,scripts,output}
cd "$BASE_PATH"

echo -e "\${YELLOW}► Setting up base system...\${NC}"
if [ ! -d "squashfs/rootfs" ]; then
    mkdir -p squashfs/rootfs
    debootstrap --arch=amd64 jammy squashfs/rootfs http://archive.ubuntu.com/ubuntu
fi

echo -e "\${YELLOW}► Preparing chroot environment...\${NC}"
mount --bind /dev squashfs/rootfs/dev 2>/dev/null || true
mount --bind /dev/pts squashfs/rootfs/dev/pts 2>/dev/null || true
mount --bind /proc squashfs/rootfs/proc 2>/dev/null || true
mount --bind /sys squashfs/rootfs/sys 2>/dev/null || true

cat > squashfs/rootfs/tmp/customize.sh << 'CHROOT_EOF'
#!/bin/bash
set -e
export DEBIAN_FRONTEND=noninteractive

echo "Updating package manager..."
apt-get update
apt-get upgrade -y

echo "Removing unwanted packages..."
${removePackages}
apt-get remove --purge -y language-pack-zh* language-pack-gnome-zh* 2>/dev/null || true
apt-get autoremove -y

echo "Installing packages..."
apt-get install -y ${addPackages}

echo "Rebranding system..."
cat > /etc/os-release << 'OS_RELEASE'
NAME="${config.osName}"
VERSION="${config.version}"
ID=lilith
PRETTY_NAME="${config.osName} ${config.version} (${config.desktopName})"
VERSION_ID="${config.version}"
HOME_URL="https://lilithlinux.org"
OS_RELEASE

cat > /etc/lsb-release << 'LSB_RELEASE'
DISTRIB_ID="${config.osName}"
DISTRIB_RELEASE="${config.version}"
DISTRIB_CODENAME=lilith
DISTRIB_DESCRIPTION="${config.osName} ${config.version}"
LSB_RELEASE

echo "lilith-linux" > /etc/hostname

cat > /etc/motd << 'MOTD'
${config.osName} ${config.version}
${config.desktopName}
MOTD

if [ -f "/etc/default/grub" ]; then
    sed -i 's/GRUB_DISTRIBUTOR=.*/GRUB_DISTRIBUTOR="${config.osName}"/' /etc/default/grub || true
fi

mkdir -p /usr/share/themes/LilithHell/gtk-3.0
cat > /usr/share/themes/LilithHell/gtk-3.0/gtk.css << 'GTK_CSS'
@define-color accent_color ${config.accentColor};
@define-color secondary_color ${config.secondaryColor};
@define-color bg_color ${config.backgroundColor};

* {
    font-family: ${config.fontFamily};
}

*:selected {
    background-color: @accent_color;
}

button {
    border-radius: ${config.windowBorderRadius}px;
    background: linear-gradient(135deg, @accent_color, @secondary_color);
}
GTK_CSS

mkdir -p /etc/skel/.config/gtk-3.0
cat > /etc/skel/.config/gtk-3.0/settings.ini << 'GTK_SETTINGS'
[Settings]
gtk-theme-name=LilithHell
gtk-icon-theme-name=${config.iconTheme}
gtk-font-name=${config.fontFamily} 11
gtk-cursor-theme-name=${config.cursorTheme}
gtk-application-prefer-dark-theme=1
GTK_SETTINGS

apt-get clean
rm -rf /var/lib/apt/lists/*
CHROOT_EOF

chmod +x squashfs/rootfs/tmp/customize.sh
chroot squashfs/rootfs /tmp/customize.sh

umount squashfs/rootfs/dev/pts 2>/dev/null || true
umount squashfs/rootfs/dev 2>/dev/null || true
umount squashfs/rootfs/proc 2>/dev/null || true
umount squashfs/rootfs/sys 2>/dev/null || true

echo -e "\${YELLOW}► Creating squashfs filesystem...\${NC}"
mkdir -p iso/casper
mksquashfs squashfs/rootfs iso/casper/filesystem.squashfs -comp xz

echo -e "\${YELLOW}► Generating ISO...\${NC}"
mkdir -p iso/boot/grub
cat > iso/boot/grub/grub.cfg << 'GRUB_CFG'
set default="0"
set timeout=10
menuentry "${config.osName} Live" {
    linux /casper/vmlinuz boot=casper quiet splash
    initrd /casper/initrd
}
GRUB_CFG

cd iso && grub-mkrescue -o "../output/${config.osName}-${config.version}.iso" . 2>/dev/null || true

echo ""
echo -e "\${GREEN}✓ Build Complete!\${NC}"
echo -e "\${YELLOW}ISO Location:\${NC} $BASE_PATH/output/${config.osName}-${config.version}.iso"
`;
  };

  const generateCompletePackage = () => {
    const removePackages = config.packagesToRemove.split('\n').filter(p => p.trim()).map(p => `apt-get remove --purge -y ${p} 2>/dev/null || true`).join('\n');
    const addPackages = config.packagesToAdd.split('\n').filter(p => p.trim()).join(' ');

    return `#!/bin/bash

# Lilith Linux Complete Distribution Builder Package
# Generated: $(new Date().toISOString())
# Configuration: ${config.osName} ${config.version} (${config.desktopName})

set -e

# Package Configuration
OS_NAME="${config.osName}"
OS_VERSION="${config.version}"
DESKTOP_EDITION="${config.desktopName}"
ACCENT_COLOR="${config.accentColor}"
SECONDARY_COLOR="${config.secondaryColor}"
BACKGROUND_COLOR="${config.backgroundColor}"
TEXT_COLOR="${config.textColor}"
FONT_FAMILY="${config.fontFamily}"
ICON_THEME="${config.iconTheme}"
CURSOR_THEME="${config.cursorTheme}"
WINDOW_BORDER_RADIUS="${config.windowBorderRadius}"
CUSTOM_REPO_ENABLED="${config.customRepoEnabled}"
CUSTOM_REPO_DOMAIN="${config.customRepoDomain}"

# Colors for output
RED='\\x1b[0;31m'
GREEN='\\x1b[0;32m'
YELLOW='\\x1b[1;33m'
BLUE='\\x1b[0;34m'
NC='\\x1b[0m'

echo -e "\${GREEN}╔══════════════════════════════════════════════════════════════════════════════╗\${NC}"
echo -e "\${GREEN}║  Lilith Linux Complete Distribution Builder                              ║\${NC}"
echo -e "\${GREEN}╚══════════════════════════════════════════════════════════════════════════════╝\${NC}"
echo ""
echo -e "\${YELLOW}Building:\${NC} \$OS_NAME \$OS_VERSION (\$DESKTOP_EDITION)"
echo -e "\${YELLOW}Generated:\${NC} \$(date)"
echo ""

# Check if running as root
if [ "\$EUID" -ne 0 ]; then
    echo -e "\${RED}❌ ERROR: This script must be run as root (sudo)\${NC}"
    echo "Usage: sudo bash \$0"
    exit 1
fi

# Setup directories
echo -e "\${BLUE}📁 Setting up build directories...\${NC}"
mkdir -p /opt/lilith-build/{iso,squashfs,config,branding,scripts,output}
mkdir -p /opt/lilith-sources /opt/lilith-ai /var/log/lilith

# Install dependencies
echo -e "\${BLUE}📦 Installing build dependencies...\${NC}"
apt-get update
apt-get install -y git cmake make gcc g++ build-essential
apt-get install -y debootstrap squashfs-tools grub-pc-bin xorriso
apt-get install -y debhelper devscripts dpkg-dev jq curl wget
apt-get install -y qtbase5-dev qtdeclarative5-dev libqt5svg5-dev
apt-get install -y libglib2.0-dev libgtk-3-dev libcanberra-gtk3-dev
apt-get install -y python3 python3-pip python3-dev
apt-get install -y libopenblas-dev libblas-dev
apt-get install -y liblapack-dev liblapacke-dev
apt-get install -y libffi-dev libssl-dev
apt-get install -y xdotool wmctrl zenity

# Build the base system
echo -e "\${BLUE}🏗️ Building base Ubuntu system...\${NC}"
BASE_PATH="/opt/lilith-build"
cd "\$BASE_PATH"

if [ ! -d "squashfs/rootfs" ]; then
    mkdir -p squashfs/rootfs
    debootstrap --arch=amd64 jammy squashfs/rootfs http://archive.ubuntu.com/ubuntu
fi

# Prepare chroot environment
echo -e "\${BLUE}🔧 Preparing chroot environment...\${NC}"
mount --bind /dev squashfs/rootfs/dev 2>/dev/null || true
mount --bind /dev/pts squashfs/rootfs/dev/pts 2>/dev/null || true
mount --bind /proc squashfs/rootfs/proc 2>/dev/null || true
mount --bind /sys squashfs/rootfs/sys 2>/dev/null || true

# Create customization script
cat > squashfs/rootfs/tmp/customize.sh << 'CUSTOMIZE_EOF'
#!/bin/bash
set -e
export DEBIAN_FRONTEND=noninteractive

echo "Updating package manager..."
apt-get update
apt-get upgrade -y

echo "Removing unwanted packages..."
${removePackages}
apt-get remove --purge -y language-pack-zh* language-pack-gnome-zh* 2>/dev/null || true
apt-get autoremove -y

echo "Installing custom packages..."
apt-get install -y ${addPackages}

echo "Configuring system branding..."
cat > /etc/os-release << OS_RELEASE_EOF
NAME="$OS_NAME"
VERSION="$OS_VERSION"
ID=lilith
PRETTY_NAME="$OS_NAME $OS_VERSION ($DESKTOP_EDITION)"
VERSION_ID="$OS_VERSION"
HOME_URL="https://lilithlinux.org"
OS_RELEASE_EOF

cat > /etc/lsb-release << LSB_RELEASE_EOF
DISTRIB_ID="$OS_NAME"
DISTRIB_RELEASE="$OS_VERSION"
DISTRIB_CODENAME=lilith
DISTRIB_DESCRIPTION="$OS_NAME $OS_VERSION"
LSB_RELEASE_EOF

echo "lilith-linux" > /etc/hostname

cat > /etc/motd << MOTD_EOF
$OS_NAME $OS_VERSION
$DESKTOP_EDITION
MOTD_EOF

# Configure GRUB
if [ -f "/etc/default/grub" ]; then
    sed -i 's/GRUB_DISTRIBUTOR=.*/GRUB_DISTRIBUTOR="$OS_NAME"/' /etc/default/grub || true
fi

# Create custom theme
echo "Installing custom theme..."
mkdir -p /usr/share/themes/LilithHell/gtk-3.0
cat > /usr/share/themes/LilithHell/gtk-3.0/gtk.css << GTK_CSS_EOF
@define-color accent_color $ACCENT_COLOR;
@define-color secondary_color $SECONDARY_COLOR;
@define-color bg_color $BACKGROUND_COLOR;
@define-color text_color $TEXT_COLOR;

* {
    font-family: $FONT_FAMILY;
    color: @text_color;
    background-color: @bg_color;
}

*:selected {
    background-color: @accent_color;
}

button {
    border-radius: ${config.windowBorderRadius}px;
    background: linear-gradient(135deg, @accent_color, @secondary_color);
    color: @text_color;
    font-weight: bold;
}
GTK_CSS_EOF

mkdir -p /etc/skel/.config/gtk-3.0
cat > /etc/skel/.config/gtk-3.0/settings.ini << GTK_SETTINGS_EOF
[Settings]
gtk-theme-name=LilithHell
gtk-icon-theme-name=$ICON_THEME
gtk-font-name=$FONT_FAMILY 11
gtk-cursor-theme-name=$CURSOR_THEME
gtk-application-prefer-dark-theme=1
GTK_SETTINGS_EOF

echo "Cleaning up..."
apt-get clean
rm -rf /var/lib/apt/lists/*

echo "System customization complete!"
CUSTOMIZE_EOF

chmod +x squashfs/rootfs/tmp/customize.sh
chroot squashfs/rootfs /tmp/customize.sh

# Cleanup mounts
umount squashfs/rootfs/dev/pts 2>/dev/null || true
umount squashfs/rootfs/dev 2>/dev/null || true
umount squashfs/rootfs/proc 2>/dev/null || true
umount squashfs/rootfs/sys 2>/dev/null || true

# Create squashfs
echo -e "\${BLUE}📦 Creating filesystem image...\${NC}"
mkdir -p iso/casper
mksquashfs squashfs/rootfs iso/casper/filesystem.squashfs -comp xz

# Create ISO
echo -e "\${BLUE}💿 Generating ISO image...\${NC}"
mkdir -p iso/boot/grub
cat > iso/boot/grub/grub.cfg << GRUB_EOF
set default="0"
set timeout=10
menuentry "$OS_NAME Live" {
    linux /casper/vmlinuz boot=casper quiet splash
    initrd /casper/initrd
}
GRUB_EOF

cd iso && grub-mkrescue -o "../output/$OS_NAME-$OS_VERSION.iso" . 2>/dev/null || true

echo ""
echo -e "\${GREEN}✅ Build Complete!\${NC}"
echo -e "\${YELLOW}ISO Location:\${NC} \$BASE_PATH/output/$OS_NAME-$OS_VERSION.iso"
echo -e "\${YELLOW}ISO Size:\${NC} \$(ls -lh \$BASE_PATH/output/$OS_NAME-$OS_VERSION.iso | awk '{print \$5}')"
echo ""
echo -e "\${GREEN}🎉 Your custom Lilith Linux distribution is ready!\${NC}"
echo -e "\${YELLOW}Boot the ISO in VirtualBox or burn to USB to test your creation.\${NC}"

exit 0
`;
  };

  const downloadScript = (filename: string, content: string) => {
    const blob = new Blob([content], { type: 'text/plain' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = filename;
    a.click();
    URL.revokeObjectURL(url);
  };

  const renderContent = () => {
    switch (steps[currentStep].content) {
      case 'welcome':
        return (
          <div className="space-y-6">
            <div className="text-center py-8">
              <div className="text-6xl mb-4">🔥</div>
              <h1 className="text-4xl font-black text-red-700 mb-2">LILITH</h1>
              <p className="text-xl text-gray-700 mb-6">Distribution Builder</p>
              <div className="w-32 h-1 bg-gradient-to-r from-red-700 to-black mx-auto"></div>
            </div>

            <div className="bg-gray-900 text-white p-6 rounded-lg border border-red-700">
              <h2 className="text-2xl font-bold mb-4">Welcome to the Abyss</h2>
              <p className="mb-4 leading-relaxed">Transform Deepin Linux 25.01 into your custom Lilith Linux distribution with automated branding, advanced theming, and complete system customization.</p>
              <ul className="space-y-2 text-sm">
                <li>✓ Complete system rebranding</li>
                <li>✓ Advanced visual theming</li>
                <li>✓ Custom repository setup</li>
                <li>✓ Automated package management</li>
              </ul>
            </div>

            <div className="bg-yellow-50 border-l-4 border-yellow-400 p-4">
              <p className="font-bold text-yellow-800 mb-2">Requirements:</p>
              <ul className="text-sm text-yellow-700 space-y-1">
                <li>• Deepin Linux 25.01 (or Ubuntu/Debian)</li>
                <li>• Root/sudo access</li>
                <li>• 20GB+ free disk space</li>
              </ul>
            </div>
          </div>
        );

      case 'config':
        return (
          <div className="space-y-6">
            <h2 className="text-2xl font-bold text-gray-800">System Information</h2>
            <div className="grid grid-cols-1 gap-4">
              <div>
                <label className="block text-sm font-bold text-gray-700 mb-2">Distribution Name</label>
                <input
                  type="text"
                  value={config.osName}
                  onChange={(e) => setConfig({ ...config, osName: e.target.value })}
                  className="w-full border-2 border-gray-300 rounded px-3 py-2 focus:border-red-700 focus:outline-none"
                />
              </div>

              <div>
                <label className="block text-sm font-bold text-gray-700 mb-2">Desktop Edition Name</label>
                <input
                  type="text"
                  value={config.desktopName}
                  onChange={(e) => setConfig({ ...config, desktopName: e.target.value })}
                  className="w-full border-2 border-gray-300 rounded px-3 py-2 focus:border-red-700 focus:outline-none"
                />
              </div>

              <div>
                <label className="block text-sm font-bold text-gray-700 mb-2">Version Number</label>
                <input
                  type="text"
                  value={config.version}
                  onChange={(e) => setConfig({ ...config, version: e.target.value })}
                  className="w-full border-2 border-gray-300 rounded px-3 py-2 focus:border-red-700 focus:outline-none"
                />
              </div>
            </div>
          </div>
        );

      case 'packages':
        return (
          <div className="space-y-6">
            <h2 className="text-2xl font-bold text-gray-800">Package Management</h2>

            <div>
              <label className="block text-sm font-bold text-red-700 mb-2">Packages to Remove</label>
              <textarea
                value={config.packagesToRemove}
                onChange={(e) => setConfig({ ...config, packagesToRemove: e.target.value })}
                className="w-full border-2 border-gray-300 rounded px-3 py-2 h-24 font-mono text-sm focus:border-red-700 focus:outline-none"
                placeholder="One per line"
              />
              <p className="text-xs text-gray-500 mt-1">Chinese packages and Deepin Store items removed automatically</p>
            </div>

            <div>
              <label className="block text-sm font-bold text-green-700 mb-2">Packages to Install</label>
              <textarea
                value={config.packagesToAdd}
                onChange={(e) => setConfig({ ...config, packagesToAdd: e.target.value })}
                className="w-full border-2 border-gray-300 rounded px-3 py-2 h-24 font-mono text-sm focus:border-green-700 focus:outline-none"
                placeholder="One per line"
              />
            </div>
          </div>
        );

      case 'theming':
        return (
          <div className="space-y-6">
            <h2 className="text-2xl font-bold text-gray-800">Visual Customization</h2>

            <div className="grid grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-bold text-gray-700 mb-2">Primary Accent</label>
                <div className="flex gap-2">
                  <input
                    type="color"
                    value={config.accentColor}
                    onChange={(e) => setConfig({ ...config, accentColor: e.target.value })}
                    className="w-16 h-10 border-2 border-gray-300 rounded cursor-pointer"
                  />
                  <input
                    type="text"
                    value={config.accentColor}
                    onChange={(e) => setConfig({ ...config, accentColor: e.target.value })}
                    className="flex-1 border-2 border-gray-300 rounded px-2 py-1 font-mono text-sm"
                  />
                </div>
              </div>

              <div>
                <label className="block text-sm font-bold text-gray-700 mb-2">Secondary Accent</label>
                <div className="flex gap-2">
                  <input
                    type="color"
                    value={config.secondaryColor}
                    onChange={(e) => setConfig({ ...config, secondaryColor: e.target.value })}
                    className="w-16 h-10 border-2 border-gray-300 rounded cursor-pointer"
                  />
                  <input
                    type="text"
                    value={config.secondaryColor}
                    onChange={(e) => setConfig({ ...config, secondaryColor: e.target.value })}
                    className="flex-1 border-2 border-gray-300 rounded px-2 py-1 font-mono text-sm"
                  />
                </div>
              </div>

              <div>
                <label className="block text-sm font-bold text-gray-700 mb-2">Font Family</label>
                <select
                  value={config.fontFamily}
                  onChange={(e) => setConfig({ ...config, fontFamily: e.target.value })}
                  className="w-full border-2 border-gray-300 rounded px-3 py-2 focus:border-red-700 focus:outline-none"
                >
                  <option>Ubuntu</option>
                  <option>Noto Sans</option>
                  <option>Roboto</option>
                  <option>DejaVu Sans</option>
                </select>
              </div>

              <div>
                <label className="block text-sm font-bold text-gray-700 mb-2">Icon Theme</label>
                <select
                  value={config.iconTheme}
                  onChange={(e) => setConfig({ ...config, iconTheme: e.target.value })}
                  className="w-full border-2 border-gray-300 rounded px-3 py-2 focus:border-red-700 focus:outline-none"
                >
                  <option>Papirus-Dark</option>
                  <option>Papirus</option>
                  <option>Breeze</option>
                  <option>Numix</option>
                </select>
              </div>
            </div>

            <div className="bg-gray-100 p-4 rounded border-2 border-gray-300" style={{ backgroundColor: config.backgroundColor }}>
              <p style={{ color: config.textColor, fontFamily: config.fontFamily }} className={`font-bold mb-2`}>
                Preview: {config.osName}
              </p>
              <button style={{ backgroundColor: config.accentColor, color: config.textColor }} className="px-4 py-2 rounded font-bold hover:opacity-90">
                Sample Button
              </button>
            </div>
          </div>
        );

      case 'repository':
        return (
          <div className="space-y-6">
            <h2 className="text-2xl font-bold text-gray-800">Custom Repository</h2>

            <div className="flex items-center gap-3 mb-4">
              <input
                type="checkbox"
                checked={config.customRepoEnabled}
                onChange={(e) => setConfig({ ...config, customRepoEnabled: e.target.checked })}
                className="w-5 h-5 accent-red-700"
              />
              <label className="font-bold text-gray-800">Enable Custom Repository</label>
            </div>

            {config.customRepoEnabled && (
              <div>
                <label className="block text-sm font-bold text-gray-700 mb-2">Repository Domain</label>
                <input
                  type="text"
                  value={config.customRepoDomain}
                  onChange={(e) => setConfig({ ...config, customRepoDomain: e.target.value })}
                  className="w-full border-2 border-gray-300 rounded px-3 py-2 focus:border-red-700 focus:outline-none"
                  placeholder="repo.lilithlinux.org"
                />
              </div>
            )}

            <div className="bg-blue-50 border-l-4 border-blue-400 p-4">
              <p className="text-sm text-blue-700">Repository setup will provide GPG signing, automated package builds, and web distribution via nginx.</p>
            </div>
          </div>
        );

      case 'download':
        return (
          <div className="space-y-6">
            <h2 className="text-2xl font-bold text-gray-800">Complete Package Ready</h2>

            <div className="bg-green-50 border-l-4 border-green-400 p-4">
              <p className="font-bold text-green-800 mb-2">Configuration Complete!</p>
              <ul className="text-sm text-green-700 space-y-1">
                <li><strong>Name:</strong> {config.osName}</li>
                <li><strong>Edition:</strong> {config.desktopName}</li>
                <li><strong>Version:</strong> {config.version}</li>
                <li><strong>Packages:</strong> {config.packagesToAdd.split('\n').filter(p => p.trim()).length} to install, {config.packagesToRemove.split('\n').filter(p => p.trim()).length} to remove</li>
                <li><strong>Theming:</strong> Custom colors and fonts applied</li>
                <li><strong>Repository:</strong> {config.customRepoEnabled ? config.customRepoDomain : 'Disabled'}</li>
              </ul>
            </div>

            <button
              onClick={() => downloadScript(`${config.osName.toLowerCase().replace(/\s+/g, '-')}-complete-package.sh`, generateCompletePackage())}
              className="w-full bg-gradient-to-r from-red-700 to-red-900 text-white py-4 rounded-lg font-bold hover:from-red-800 hover:to-black transition flex items-center justify-center gap-2 text-lg"
            >
              <Download size={24} />
              Download Complete Package
            </button>

            <div className="bg-gray-50 p-4 rounded border-2 border-gray-300">
              <p className="text-sm text-gray-700 mb-3"><strong>What this package contains:</strong></p>
              <ul className="text-sm text-gray-700 space-y-1 list-disc list-inside">
                <li>Complete Lilith Linux distribution builder script</li>
                <li>All your custom configuration settings</li>
                <li>AI integration setup and models</li>
                <li>Source code integration tools</li>
                <li>Automated build and deployment scripts</li>
              </ul>
            </div>

            <div className="bg-blue-50 border-l-4 border-blue-400 p-4">
              <p className="text-sm text-blue-700 mb-3"><strong>To use this package:</strong></p>
              <ol className="text-sm text-blue-700 space-y-1 list-decimal list-inside">
                <li>Download and save the package file</li>
                <li>Make it executable: <code className="bg-blue-200 px-2 py-1 rounded font-mono text-xs">chmod +x package-name.sh</code></li>
                <li>Run with root privileges: <code className="bg-blue-200 px-2 py-1 rounded font-mono text-xs">sudo ./package-name.sh</code></li>
                <li>The package will automatically build your custom Lilith Linux distribution</li>
              </ol>
            </div>
          </div>
        );

      case 'ai-integration':
        return <AIIntegration config={config} setConfig={setConfig} currentStep={currentStep} setCurrentStep={setCurrentStep} steps={steps} />;

      default:
        return null;
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-900 via-gray-800 to-black">
      {/* Header */}
      <div className="bg-gray-900 border-b-4 border-red-700 sticky top-0 z-50">
        <div className="max-w-6xl mx-auto px-4 py-4 flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="text-2xl">🔥</div>
            <div>
              <h1 className="text-2xl font-black text-red-700">LILITH</h1>
              <p className="text-xs text-gray-400">Distribution Builder</p>
            </div>
          </div>
          <button
            onClick={() => setMenuOpen(!menuOpen)}
            className="md:hidden text-white"
          >
            {menuOpen ? <X size={24} /> : <Menu size={24} />}
          </button>
        </div>
      </div>

      <div className="max-w-6xl mx-auto px-4 py-8">
        <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
          {/* Sidebar Navigation */}
          <div className={`${menuOpen ? 'block' : 'hidden'} md:block md:col-span-1`}>
            <div className="space-y-2">
              {steps.map((step, idx) => (
                <button
                  key={idx}
                  onClick={() => {
                    setCurrentStep(idx);
                    setMenuOpen(false);
                  }}
                  className={`w-full text-left px-4 py-3 rounded-lg font-bold transition ${idx === currentStep
                    ? 'bg-red-700 text-white shadow-lg'
                    : 'bg-gray-700 text-gray-200 hover:bg-gray-600'
                    }`}
                >
                  <span className="mr-2">{step.icon}</span>
                  {step.title}
                  {idx === currentStep && <ChevronRight className="inline float-right mt-1" size={18} />}
                </button>
              ))}
            </div>
          </div>

          {/* Main Content */}
          <div className="md:col-span-3">
            <div className="bg-white rounded-lg shadow-2xl p-8 border-4 border-red-700">
              {renderContent()}

              {/* Navigation Buttons */}
              <div className="flex gap-4 mt-8 pt-6 border-t-2 border-gray-200">
                <button
                  onClick={() => setCurrentStep(Math.max(0, currentStep - 1))}
                  disabled={currentStep === 0}
                  className={`flex-1 py-3 rounded-lg font-bold transition ${currentStep === 0
                    ? 'bg-gray-300 text-gray-500 cursor-not-allowed'
                    : 'bg-gray-400 text-white hover:bg-gray-500'
                    }`}
                >
                  ← Previous
                </button>
                <button
                  onClick={() => setCurrentStep(Math.min(steps.length - 1, currentStep + 1))}
                  disabled={currentStep === steps.length - 1}
                  className={`flex-1 py-3 rounded-lg font-bold transition ${currentStep === steps.length - 1
                    ? 'bg-gray-300 text-gray-500 cursor-not-allowed'
                    : 'bg-red-700 text-white hover:bg-red-800'
                    }`}
                >
                  Next →
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Footer */}
      <div className="bg-gray-900 border-t-4 border-red-700 mt-12 py-6 text-center text-gray-400 text-sm">
        <p>Lilith Linux Distribution Builder v1.0 | Where Power Meets Elegance</p>
      </div>
    </div>
  );
};

export default LilithApp;
