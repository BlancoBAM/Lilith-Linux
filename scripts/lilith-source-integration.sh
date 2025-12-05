#!/bin/bash

# Lilith Linux - Deepin Source Code Integration System
# Automates cloning, modifying, and building Deepin source with Lilith branding

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
LOG_FILE="/var/log/lilith-source-integration.log"

# Initialize logging
echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Lilith Linux - Deepin Source Code Integration System  ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Create directories
mkdir -p "$SOURCE_DIR" "$BUILD_DIR" "$(dirname "$LOG_FILE")"
exec > >(tee -a "$LOG_FILE") 2>&1

# Function to clone repositories
clone_repositories() {
    echo -e "${YELLOW}► Cloning Deepin source repositories...${NC}"

    # Note: Many Deepin repositories may not be available or have moved
    # This function attempts to clone what exists and skips what doesn't
    local repos=(
        "https://github.com/linuxdeepin/dde-daemon.git"
        "https://github.com/linuxdeepin/dde-session-ui.git"
        "https://github.com/linuxdeepin/dde-control-center.git"
        "https://github.com/linuxdeepin/dde-file-manager.git"
        "https://github.com/linuxdeepin/dde-dock.git"
        "https://github.com/linuxdeepin/dde-launcher.git"
        "https://github.com/linuxdeepin/dde-polkit-agent.git"
        "https://github.com/linuxdeepin/dde-session-shell.git"
    )

    # Removed non-existent repositories:
    # "https://github.com/linuxdeepin/dde-qt5integration.git"
    # "https://github.com/linuxdeepin/dde-qt5platform-plugins.git"

    local cloned_count=0
    local failed_count=0

    for repo in "${repos[@]}"; do
        local repo_name=$(basename "$repo" .git)
        if [ ! -d "$SOURCE_DIR/$repo_name" ]; then
            echo "  Cloning $repo_name..."
            if git clone --depth 1 "$repo" "$SOURCE_DIR/$repo_name" 2>/dev/null; then
                echo "    ✓ Successfully cloned $repo_name"
                ((cloned_count++))
            else
                echo "    ⚠️ Failed to clone $repo_name (repository may not exist or be inaccessible)"
                ((failed_count++))
            fi
        else
            echo "  $repo_name already exists, pulling updates..."
            cd "$SOURCE_DIR/$repo_name"
            if git pull 2>/dev/null; then
                echo "    ✓ Updated $repo_name"
            else
                echo "    ⚠️ Failed to update $repo_name"
            fi
            cd -
            ((cloned_count++))
        fi
    done

    echo -e "${GREEN}✓ Repository cloning complete: $cloned_count cloned, $failed_count failed${NC}"
    if [ $failed_count -gt 0 ]; then
        echo -e "${YELLOW}Note: Some repositories were not available. This is normal and expected.${NC}"
    fi
}

# Function to modify source code
modify_source_code() {
    echo -e "${YELLOW}► Modifying source code for Lilith branding...${NC}"

    # Find and replace Deepin references
    find "$SOURCE_DIR" -type f \( -name "*.cpp" -o -name "*.h" -o -name "*.c" -o -name "*.qml" -o -name "*.js" -o -name "*.ts" -o -name "*.tsx" -o -name "*.json" -o -name "*.desktop" -o -name "*.conf" -o -name "*.config" -o -name "*.pro" -o -name "*.pri" -o -name "*.cmake" -o -name "CMakeLists.txt" -o -name "*.md" -o -name "*.txt" -o -name "*.in" \) | while read -r file; do
        echo "  Processing $file..."

        # Replace Deepin with Lilith
        sed -i 's/Deepin/Lilith/gI' "$file"
        sed -i 's/deepin/lilith/gI' "$file"
        sed -i 's/DDE/LHE/gI' "$file"  # DDE -> LHE (Lilith Hell Edition)

        # Remove Chinese language references
        sed -i '/zh_CN/d' "$file"
        sed -i '/zh-Hans/d' "$file"
        sed -i '/Chinese/d' "$file"
        sed -i '/中文/d' "$file"

        # Add Lilith branding
        sed -i "s/Linux Distribution/Lilith Linux - $DEEPIN_HELL_EDITION/g" "$file"
    done

    echo -e "${GREEN}✓ Source code modification complete${NC}"
}

# Function to create custom themes
create_custom_themes() {
    echo -e "${YELLOW}► Creating custom Deepin themes...${NC}"

    # Create Lilith Hell Edition theme directory
    mkdir -p "$SOURCE_DIR/lilith-themes/gtk-3.0"
    mkdir -p "$SOURCE_DIR/lilith-themes/qt5ct"

    # Create GTK theme
    cat > "$SOURCE_DIR/lilith-themes/gtk-3.0/gtk.css" << 'THEME_EOF'
@define-color accent_color #8b0000;
@define-color secondary_color #ff4444;
@define-color bg_color #1a1a1a;
@define-color text_color #ffffff;

* {
    font-family: Ubuntu;
    color: @text_color;
    background-color: @bg_color;
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

headerbar {
    background-color: @accent_color;
    color: @text_color;
}

entry, spinbutton, scale {
    border: 1px solid @accent_color;
    border-radius: 4px;
}
THEME_EOF

    # Create Qt theme
    cat > "$SOURCE_DIR/lilith-themes/qt5ct/lilith.qss" << 'QT_THEME_EOF'
QMainWindow {
    background-color: #1a1a1a;
    color: #ffffff;
}

QPushButton {
    background-color: qlineargradient(x1:0, y1:0, x2:1, y2:1, stop:0 #8b0000, stop:1 #ff4444);
    color: white;
    border-radius: 8px;
    padding: 6px;
    font-weight: bold;
}

QLineEdit, QTextEdit, QComboBox {
    border: 1px solid #8b0000;
    border-radius: 4px;
    padding: 4px;
    background-color: #2a2a2a;
    color: #ffffff;
}
QT_THEME_EOF

    echo -e "${GREEN}✓ Custom theme creation complete${NC}"
}

# Function to customize Deepin components
customize_deepin_components() {
    echo -e "${YELLOW}► Customizing Deepin components...${NC}"

    # Customize DDE Control Center
    if [ -d "$SOURCE_DIR/dde-control-center" ]; then
        echo "  Customizing control center..."

        # Modify about dialog
        local about_file=$(find "$SOURCE_DIR/dde-control-center" -name "*about*" -type f | head -1)
        if [ -n "$about_file" ]; then
            sed -i "s/Deepin Control Center/Lilith Control Center - $DEEPIN_HELL_EDITION/g" "$about_file"
            sed -i "s/Deepin Linux/$LILITH_NAME $VERSION/g" "$about_file"
        fi

        # Customize appearance settings
        local appearance_file=$(find "$SOURCE_DIR/dde-control-center" -path "*/appearance*" -type f | head -1)
        if [ -n "$appearance_file" ]; then
            sed -i "s/deepin/lilith/gI" "$appearance_file"
        fi
    fi

    # Customize DDE Dock
    if [ -d "$SOURCE_DIR/dde-dock" ]; then
        echo "  Customizing dock..."

        # Modify dock branding
        find "$SOURCE_DIR/dde-dock" -name "*.cpp" -o -name "*.h" | while read -r file; do
            sed -i "s/Deepin Dock/Lilith Dock - $DEEPIN_HELL_EDITION/g" "$file"
        done
    fi

    # Customize DDE Launcher
    if [ -d "$SOURCE_DIR/dde-launcher" ]; then
        echo "  Customizing launcher..."

        # Modify launcher branding
        find "$SOURCE_DIR/dde-launcher" -name "*.qml" | while read -r file; do
            sed -i "s/Deepin Launcher/Lilith Launcher/g" "$file"
            sed -i "s/deepin-launcher/lilith-launcher/g" "$file"
        done
    fi

    echo -e "${GREEN}✓ Deepin component customization complete${NC}"
}

# Function to create build system
create_build_system() {
    echo -e "${YELLOW}► Creating build system...${NC}"

    # Create build script
    cat > "$SOURCE_DIR/build-lilith-components.sh" << 'BUILD_EOF'
#!/bin/bash

# Lilith Component Build Script
set -e

SOURCE_DIR="/opt/lilith-sources"
BUILD_DIR="/opt/lilith-build/components"
INSTALL_DIR="/opt/lilith-build/install"

mkdir -p "$BUILD_DIR" "$INSTALL_DIR"

# Build each component
for component in dde-daemon dde-session-ui dde-control-center dde-file-manager dde-dock dde-launcher; do
    if [ -d "$SOURCE_DIR/$component" ]; then
        echo "Building $component..."
        cd "$SOURCE_DIR/$component"

        # Create build directory
        mkdir -p build
        cd build

        # Configure and build
        cmake .. -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" -DCMAKE_BUILD_TYPE=Release
        make -j$(nproc)
        make install

        cd "$SOURCE_DIR"
    fi
done

echo "Lilith component build complete!"
BUILD_EOF

    chmod +x "$SOURCE_DIR/build-lilith-components.sh"

    # Create package script
    cat > "$SOURCE_DIR/package-lilith-components.sh" << 'PACKAGE_EOF'
#!/bin/bash

# Lilith Component Packaging Script
set -e

INSTALL_DIR="/opt/lilith-build/install"
PACKAGE_DIR="/opt/lilith-build/packages"

mkdir -p "$PACKAGE_DIR"

# Create debian packages for each component
for component in dde-daemon dde-session-ui dde-control-center dde-file-manager dde-dock dde-launcher; do
    if [ -d "$INSTALL_DIR/usr" ]; then
        echo "Packaging $component..."

        # Create package structure
        mkdir -p "$PACKAGE_DIR/$component/DEBIAN"
        mkdir -p "$PACKAGE_DIR/$component/usr"

        # Copy files
        cp -r "$INSTALL_DIR/usr" "$PACKAGE_DIR/$component/"

        # Create control file
        cat > "$PACKAGE_DIR/$component/DEBIAN/control" << CONTROL_EOF
Package: lilith-$component
Version: 1.0.0
Section: utils
Priority: optional
Architecture: amd64
Maintainer: Lilith Linux Team <team@lilithlinux.org>
Description: Lilith Linux $component - $DEEPIN_HELL_EDITION
 Customized Deepin component for Lilith Linux distribution
CONTROL_EOF

        # Build package
        dpkg-deb --build "$PACKAGE_DIR/$component" "$PACKAGE_DIR/lilith-$component.deb"
    fi
done

echo "Lilith component packaging complete!"
PACKAGE_EOF

    chmod +x "$SOURCE_DIR/package-lilith-components.sh"

    echo -e "${GREEN}✓ Build system creation complete${NC}"
}

# Function to integrate with existing GUI
integrate_with_gui() {
    echo -e "${YELLOW}► Integrating with existing GUI system...${NC}"

    # Create integration script for GUI
    cat > "$BUILD_DIR/integrate-source.sh" << 'INTEGRATE_EOF'
#!/bin/bash

# Integration script to be called from GUI
# This will be triggered when user clicks "Build with Source Integration"

echo "Starting Lilith source integration..."

# Run the main integration
bash /opt/lilith-sources/lilith-source-integration.sh

# Copy built components to ISO build
if [ -d "/opt/lilith-build/install" ]; then
    echo "Copying built components to ISO build..."
    cp -r /opt/lilith-build/install/* /opt/lilith-build/squashfs/rootfs/
fi

# Copy themes to ISO build
if [ -d "/opt/lilith-sources/lilith-themes" ]; then
    echo "Copying themes to ISO build..."
    cp -r /opt/lilith-sources/lilith-themes /opt/lilith-build/squashfs/rootfs/usr/share/themes/
fi

echo "Source integration complete!"
INTEGRATE_EOF

    chmod +x "$BUILD_DIR/integrate-source.sh"

    # Modify the main build script to include source integration option
    if [ -f "$BUILD_DIR/lilith-linux-builder.sh" ]; then
        echo "  Adding source integration option to main build script..."

        # Add source integration flag
        sed -i '/^set -e/a\\n# Source integration flag\\nSOURCE_INTEGRATION=false' "$BUILD_DIR/lilith-linux-builder.sh"

        # Add source integration option to help
        sed -i '/Usage:/a\\n  --source-integration  Enable Deepin source code integration' "$BUILD_DIR/lilith-linux-builder.sh"

        # Add source integration parsing
        sed -i '/while getopts/a\\n  s)\\n    SOURCE_INTEGRATION=true\\n    ;;' "$BUILD_DIR/lilith-linux-builder.sh"

        # Add source integration execution
        sed -i '/chroot squashfs\\/rootfs \\/tmp\\/customize.sh/i\\nif [ "$SOURCE_INTEGRATION" = true ]; then\\n  echo -e "\\${YELLOW}► Running source code integration...\\${NC}"\\n  bash /opt/lilith-build/integrate-source.sh\\nfi' "$BUILD_DIR/lilith-linux-builder.sh"
    fi

    echo -e "${GREEN}✓ GUI integration complete${NC}"
}

# Main execution
main() {
    echo -e "${YELLOW}Starting Lilith Linux Source Code Integration...${NC}"
    echo ""

    clone_repositories
    modify_source_code
    create_custom_themes
    customize_deepin_components
    create_build_system
    integrate_with_gui

    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║  Source Code Integration Complete!                     ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}Next Steps:${NC}"
    echo "1. Run: sudo bash $SOURCE_DIR/build-lilith-components.sh"
    echo "2. Run: sudo bash $SOURCE_DIR/package-lilith-components.sh"
    echo "3. Use --source-integration flag with main build script"
    echo ""
    echo -e "${YELLOW}Source repositories are ready in: $SOURCE_DIR${NC}"
    echo -e "${YELLOW}Build scripts are ready in: $SOURCE_DIR${NC}"
    echo -e "${YELLOW}Integration script is ready in: $BUILD_DIR/integrate-source.sh${NC}"
}

# Run main function
main

exit 0
