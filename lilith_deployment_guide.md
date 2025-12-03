# Lilith Distribution Builder
## Complete Deployment & Usage Guide

---

## 📋 Quick Start (5 Minutes)

### Step 1: Access the Application
1. Open this app in chosen framework (you're already here!)
2. The interface will load with 6 configuration steps
3. Follow each step sequentially from top to bottom

### Step 2: Configure Your Distribution
- Fill in your OS name, desktop edition name, and version
- Adjust packages to remove/add as needed
- Customize colors, fonts, and themes
- Enable custom repository if needed

### Step 3: Download Your Build Script
- Click the **"Download Build Script"** button on the final step
- This saves `lilith-linux-builder.sh` to your computer

### Step 4: Run on Deepin Linux
```bash
# Copy the script to your Deepin Linux system
# Then:

chmod +x lilith-linux-builder.sh
sudo ./lilith-linux-builder.sh

# Wait 20-45 minutes for build completion
```

---

## 🔧 Installation Guide

### Prerequisites

Before building Lilith Linux, ensure you have:

**System Requirements:**
- Deepin Linux 25.01 (or Ubuntu 22.04+ / Debian Bookworm)
- 20GB+ free disk space
- 4GB+ RAM (8GB recommended)
- Internet connection for package downloads

**Required Tools:**
```bash
sudo apt-get update
sudo apt-get install -y debootstrap squashfs-tools grub-pc-bin xorriso
```

### Step-by-Step Setup

#### 1. **Prepare Your System**
```bash
# Update system packages
sudo apt-get update
sudo apt-get upgrade -y

# Install dependencies
sudo apt-get install -y debootstrap squashfs-tools grub-pc-bin xorriso
```

#### 2. **Download and Prepare Build Script**
- Use the Lilith GUI to configure your distribution
- Download the generated `lilith-linux-builder.sh`
- Transfer to your Deepin Linux system (USB, SCP, etc.)

#### 3. **Execute the Build**
```bash
# Make script executable
chmod +x lilith-linux-builder.sh

# Run with root privileges
sudo bash lilith-linux-builder.sh
```

The script will:
- Create `/opt/lilith-build/` directory structure
- Extract base filesystem using debootstrap
- Remove Chinese packages and Deepin references
- Install your custom packages
- Apply custom theming and branding
- Generate squashfs filesystem
- Create bootable ISO image

#### 4. **Locate Your ISO**
After build completes:
```bash
# Find your ISO file
ls -lh /opt/lilith-build/output/

# Example output:
# lilith-linux-deepin-hell-edition-1.0.0.iso (2.1G)
```

---

## 🎯 GUI Configuration Guide

### Step 1: Welcome
- **Action:** Review requirements
- **Your Job:** Click "Begin Configuration" when ready

### Step 2: Basic Configuration
- **Distribution Name:** Your Linux distro name (default: "Lilith Linux")
- **Desktop Edition:** Environment name (default: "Deepin Hell Edition")
- **Version Number:** Release version (default: "1.0.0")

**Tip:** Use semantic versioning (e.g., 1.0.0, 1.1.0, 2.0.0)

### Step 3: Packages
- **To Remove:** One package per line (Chinese/Deepin packages)
- **To Install:** One package per line (your desired tools)

**Pre-filled Examples:**
- Remove: `deepin-store-data`, `fcitx*`, `*chinese*`
- Install: `curl`, `wget`, `git`, `vim`, `htop`

**Tip:** Use wildcards (`*`) for bulk removal of related packages

### Step 4: Advanced Theming
- **Primary Accent Color:** Main UI color (default: dark red `#8b0000`)
- **Secondary Accent:** Gradient/hover effects (default: bright red `#ff4444`)
- **Font Family:** System font (Ubuntu, Noto Sans, Roboto)
- **Icon Theme:** Icon set (Papirus-Dark, Breeze, Numix)

**Live Preview:** See theme changes in real-time

### Step 5: Repository Setup
- **Enable Custom Repository:** Optional, for package distribution
- **Repository Domain:** Your repo URL (e.g., `repo.lilithlinux.org`)

**Skip if:** You don't plan to host custom packages yet

### Step 6: Review & Download
- **Summary:** Confirms all configuration
- **Download Button:** Generates and saves build script
- **Next Steps:** Instructions for running the build

---

## 📦 Build Script Reference

The generated `lilith-linux-builder.sh` automates:

### What It Does:
1. **Creates Build Environment**
   - `/opt/lilith-build/iso/` - Live environment files
   - `/opt/lilith-build/squashfs/` - Root filesystem
   - `/opt/lilith-build/output/` - Final ISO

2. **Extracts Base System**
   - Uses `debootstrap` to create minimal Ubuntu/Debian base
   - Minimal installation (~500MB)

3. **Customizes in Chroot**
   - Removes unwanted packages
   - Installs your package list
   - Updates system files (`/etc/os-release`, `/etc/hostname`, etc.)
   - Applies GTK theme configuration
   - Configures GRUB bootloader

4. **Compiles Output**
   - Creates squashfs compressed filesystem
   - Generates GRUB bootloader
   - Produces bootable ISO image

### Timeline:
- **5 min:** Initial setup
- **5 min:** Base extraction
- **5-10 min:** Package operations
- **10-15 min:** Filesystem compression
- **5 min:** ISO generation
- **Total: ~20-45 minutes**

---

## 💾 Deployment Options

### Option 1: USB Installation (Recommended for Testing)
```bash
# Identify USB device
lsblk

# Write ISO to USB (replace sdX with your device, e.g., sdb)
sudo dd if=/opt/lilith-build/output/lilith-linux-*.iso of=/dev/sdX bs=4M status=progress && sync

# Eject safely
sudo eject /dev/sdX
```

### Option 2: Virtual Machine Testing
1. Open VirtualBox/VMware
2. Create new VM, set 20GB disk
3. Boot from ISO file
4. Install to virtual disk
5. Test functionality before hardware deployment

### Option 3: Direct Hardware Installation
1. Create bootable USB (see Option 1)
2. Boot target machine from USB
3. Follow Deepin installation wizard
4. Configure your preferences
5. Reboot into Lilith Linux

### Option 4: Network Installation
```bash
# Host the ISO on a web server
python3 -m http.server 8000 --directory /opt/lilith-build/output/

# Download and boot on other machines
wget http://your-server:8000/lilith-linux-*.iso
```

---

## 🔍 Troubleshooting

### Build Fails with "permission denied"
```bash
# Solution: Run with sudo
sudo bash lilith-linux-builder.sh
```

### Insufficient disk space
```bash
# Check available space
df -h

# Clean up and retry
rm -rf /opt/lilith-build
# Then run build again
```

### Packages not found
```bash
# Verify internet connection
ping archive.ubuntu.com

# Check package availability
apt-cache search package-name
```

### Mount errors during chroot
```bash
# Manually unmount if build fails
sudo umount /opt/lilith-build/squashfs/rootfs/dev/pts
sudo umount /opt/lilith-build/squashfs/rootfs/dev
sudo umount /opt/lilith-build/squashfs/rootfs/proc
sudo umount /opt/lilith-build/squashfs/rootfs/sys
```

### ISO won't boot
- Verify ISO with checksum
- Use Etcher or Rufus for USB creation
- Test in VirtualBox first
- Check BIOS boot order

---

## 📝 Configuration Files Reference

Your build script generates these key files:

### `/etc/os-release`
- Distribution identification
- Version information
- Homepage and support URLs

### `/etc/lsb-release`
- LSB (Linux Standard Base) information
- Used by system tools

### `/etc/hostname`
- System hostname
- Set to "lilith-linux"

### `/etc/motd`
- Message of the day
- Displayed on login

### `/usr/share/themes/LilithHell/gtk-3.0/gtk.css`
- GTK3 theme definition
- Color, font, and button styling

### `/etc/skel/.config/gtk-3.0/settings.ini`
- Default user theme settings
- Applied to new user accounts

---

## 🎨 Advanced Customization

### After Build: Add Custom Wallpapers
```bash
# Mount ISO and explore
sudo mount -o loop /opt/lilith-build/output/lilith-linux-*.iso /mnt

# Custom wallpapers go in:
# /mnt/usr/share/backgrounds/lilith/
```

### Modify GRUB Boot Menu
Edit the generated script section:
```bash
menuentry "${config.osName} Live" {
    # Add custom GRUB configurations here
}
```

### Change Default GTK Theme
Edit the GTK CSS file path in the script:
```bash
/usr/share/themes/LilithHell/gtk-3.0/gtk.css
```

### Add Custom Logo/Icon
Place logo file at:
```
/usr/share/pixmaps/lilith-logo.png
```

---

## 📊 Post-Build Verification

### Check ISO integrity
```bash
# Verify file size and integrity
ls -lh /opt/lilith-build/output/

# Test ISO with loopback
sudo losetup -f
sudo losetup /dev/loop0 /opt/lilith-build/output/lilith-linux-*.iso
sudo mount /dev/loop0 /mnt
ls -la /mnt
sudo umount /mnt
sudo losetup -d /dev/loop0
```

### Boot Test
- Use VirtualBox to test live environment
- Verify all packages installed correctly
- Check theme and branding applied
- Test package management (apt)

---

## 🚀 Next Steps

### After Successful Build:
1. ✅ Test ISO in virtual machine
2. ✅ Create bootable USB for testing
3. ✅ Install to test hardware/VM
4. ✅ Verify all customizations applied
5. ✅ Set up custom repository (if enabled)
6. ✅ Configure AI integration (when ready)

### Distribution & Sharing:
```bash
# Host ISO on web server
scp /opt/lilith-build/output/lilith-linux-*.iso user@server:/var/www/html/

# Share with others
rsync -avz /opt/lilith-build/output/ remote-host:/backups/lilith/
```

---

## 📞 Support & Documentation

**Key Directories:**
- Build files: `/opt/lilith-build/`
- Output ISO: `/opt/lilith-build/output/`
- Configuration: `/opt/lilith-build/config/`

**Common Commands:**
```bash
# Check build status
tail -f /tmp/lilith-build.log

# Clean up and rebuild
sudo rm -rf /opt/lilith-build && sudo ./lilith-linux-builder.sh

# Compress ISO for backup
tar -czf lilith-backup.tar.gz /opt/lilith-build/output/
```

---

## ✨ You're Ready!

Your Lilith Distribution Builder is complete and ready to deploy.

**Quick Recap:**
1. Configure using the GUI (6 steps)
2. Download the build script
3. Run on Deepin Linux with sudo
4. Wait 20-45 minutes
5. Find your ISO in `/opt/lilith-build/output/`
6. Deploy to USB, VirtualBox, or hardware

**Questions?** Review the GUI tooltips or this guide section-by-section.

Happy building! 🔥