#!/bin/bash
# Lilith Linux - Automatic Deepin App Conversion & Repository Setup
# Converts Deepin applications to Lilith equivalents and creates repositories

set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
REPO_BASE="/opt/lilith-repositories"
APPS_TO_CONVERT=("deepin-calculator" "deepin-editor" "deepin-music" "deepin-movie" "deepin-image-viewer")

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Create repository structure
create_repository_structure() {
    local repo_name="$1"
    log_info "Creating repository structure for: $repo_name"

    mkdir -p "$REPO_BASE/$repo_name"/{conf,dists,pool,incoming}

    # Create repository configuration
    cat > "$REPO_BASE/$repo_name/conf/distributions" << EOF
Origin: Lilith Linux
Label: Lilith Linux Repository
Suite: stable
Codename: stable
Version: 1.0.0
Architectures: amd64 i386
Components: main
Description: Lilith Linux Custom Repository
SignWith: yes
EOF

    log_success "Repository structure created for $repo_name"
}

# Convert app package names and branding
convert_app_branding() {
    local app_name="$1"
    local lilith_name="lilith-${app_name#deepin-}"

    log_info "Converting $app_name to $lilith_name"

    # Create conversion directory
    local workdir="$REPO_BASE/work/$lilith_name"
    mkdir -p "$workdir"/{source,build,output}

    # Extract original package if available (placeholder for actual implementation)
    log_info "Setting up package conversion for $lilith_name"

    # Create control file replacement
    cat > "$workdir/source/control" << EOF
Source: $lilith_name
Section: utils
Priority: optional
Maintainer: Lilith Linux Team <admin@lilithlinux.org>
Build-Depends: debhelper-compat (= 13)
Standards-Version: 4.5.1
Homepage: https://lilithlinux.org

Package: $lilith_name
Architecture: any
Depends: \${misc:Depends}, \${shlibs:Depends}
Description: Lilith Linux version of $app_name
 This is the Lilith Linux branded version of $app_name,
 converted and optimized for the Lilith Linux distribution.
EOF

    # Create postinst script for branding replacement
    cat > "$workdir/source/postinst" << EOF
#!/bin/bash
set -e

# Replace branding elements
find /usr/share/applications -name "*${app_name}*.desktop" -exec sed -i 's/$app_name/$lilith_name/g; s/Deepin/Lilith/g; s/deepin/lilith/g' {} \;
find /usr/share -name "*${app_name}*" -type f -exec sed -i 's/$app_name/$lilith_name/g; s/Deepin/Lilith/g; s/deepin/lilith/g' {} \;

# Update desktop entries
if [ -d "/usr/share/applications" ]; then
    for desktop_file in /usr/share/applications/*${app_name}*.desktop; do
        if [ -f "\$desktop_file" ]; then
            sed -i 's/Name=.*/Name=Lilith &/g; s/Comment=.*/Comment=Lilith Linux &/g' "\$desktop_file"
        fi
    done
fi

# Update system integration
systemctl daemon-reload 2>/dev/null || true
update-desktop-database 2>/dev/null || true

exit 0
EOF

    chmod +x "$workdir/source/postinst"

    log_success "Converted $app_name to $lilith_name"
}

# Generate build scripts for converted apps
generate_build_scripts() {
    local app_name="$1"
    local lilith_name="lilith-${app_name#deepin-}"
    local workdir="$REPO_BASE/work/$lilith_name"

    log_info "Generating build script for $lilith_name"

    cat > "$workdir/build.sh" << EOF
#!/bin/bash
set -e

WORK_DIR="$workdir"
OUTPUT_DIR="$REPO_BASE/packages"
SOURCE_DIR="\$WORK_DIR/source"

# Build package structure
mkdir -p "\$WORK_DIR/debian"
cp "\$SOURCE_DIR/control" "\$WORK_DIR/debian/"
cp "\$SOURCE_DIR/postinst" "\$WORK_DIR/debian/"

# Create debian package
cd "\$WORK_DIR"
dpkg-buildpackage -us -uc -b

# Move to repository
mkdir -p "\$OUTPUT_DIR"
mv "../${lilith_name}_"*"_all.deb" "\$OUTPUT_DIR/" 2>/dev/null || true
mv "../${lilith_name}_"*"_amd64.deb" "\$OUTPUT_DIR/" 2>/dev/null || true

echo "Package built: $lilith_name"
EOF

    chmod +x "$workdir/build.sh"
}

# Setup repository metadata
setup_repository_metadata() {
    local repo_name="$1"

    log_info "Setting up repository metadata for $repo_name"

    # Initialize repository
    cd "$REPO_BASE/$repo_name"
    reprepro --confdir ./conf export 2>/dev/null || true
    reprepro --confdir ./conf createsymlinks 2>/dev/null || true

    # Create Release file
    cat > "dists/stable/Release" << EOF
Origin: Lilith Linux
Label: Lilith Linux Repository
Suite: stable
Version: 1.0.0
Codename: stable
Date: $(date -R)
Architectures: amd64
Components: main
Description: Lilith Linux Custom Repository
EOF

    log_success "Repository metadata setup for $repo_name"
}

# Convert custom apps specified via command line
convert_custom_apps() {
    if [ $# -gt 0 ]; then
        log_info "Converting custom apps: $@"
        for app in "$@"; do
            if [[ $app == deepin-* ]]; then
                convert_app_branding "$app"
                generate_build_scripts "$app"
                log_success "Custom app conversion completed: $app"
            else
                log_warning "Skipping non-Deepin app: $app (must start with 'deepin-')"
            fi
        done
    fi
}

# Main function
main() {
    echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║     Lilith Linux Deepin App Conversion & Repository     ║${NC}"
    echo -e "${BLUE}║               Automated Setup System                    ║${NC}"
    echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""

    # Handle custom apps from command line
    if [ $# -gt 0 ]; then
        convert_custom_apps "$@"
        log_success "Custom app conversion completed"
        exit 0
    fi

    # Create base repository structure
    create_repository_structure "main"

    # Convert standard Deepin apps
    log_info "Converting standard Deepin applications..."
    for app in "${APPS_TO_CONVERT[@]}"; do
        convert_app_branding "$app"
        generate_build_scripts "$app"
    done

    # Setup repository
    setup_repository_metadata "main"

    # Generate summary
    echo ""
    log_success "Deepin App Conversion Completed!"
    echo ""
    echo -e "${YELLOW}Summary:${NC}"
    echo -e "  • Repository: $REPO_BASE/main/"
    echo -e "  • Packages: $REPO_BASE/packages/"
    echo -e "  • Build scripts: $REPO_BASE/work/*/build.sh"
    echo ""
    echo -e "${BLUE}Next steps:${NC}"
    echo -e "  1. Run build scripts: find $REPO_BASE/work -name '*.sh' -exec bash {} \\;"
    echo -e "  2. Update repo: reprepro -b $REPO_BASE/main includedeb stable $REPO_BASE/packages/*.deb"
    echo -e "  3. Add to sources: echo 'deb [trusted=yes] file:$REPO_BASE/main stable main' > /etc/apt/sources.list.d/lilith-apps.list"
    echo ""

    log_success "Lilith Linux app conversion setup complete!"
}

# Run main function
main "$@"
