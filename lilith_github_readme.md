# Lilith Linux Distribution Builder

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Build Status](https://img.shields.io/badge/Status-Active-brightgreen.svg)](https://github.com/yourusername/lilith)
[![Platform](https://img.shields.io/badge/Platform-Linux-blue.svg)](https://www.linux.org/)

**Where Power Meets Elegance** 🔥

A comprehensive, interactive GUI application for building custom Linux distributions based on Deepin Linux 25.01. Transform Deepin into your branded Lilith Linux with automated system rebranding, advanced theming, custom repositories, and complete package management.

## ✨ Features

- **🎨 Advanced GUI Interface** - 6-step interactive wizard with real-time preview
- **🔥 Complete System Rebranding** - Automatic replacement of Deepin references with your branding
- **🎭 Visual Customization** - Full color control, fonts, icons, and theme generation
- **📦 Package Management** - Automated removal of unwanted packages and installation of custom software
- **🗂️ Custom Repository Support** - Built-in framework for hosting your own package repository
- **⚙️ Automated Builds** - Scripted CI/CD pipeline for package compilation
- **🤖 AI Integration Ready** - Flexible framework for local AI model deployment
- **🔐 English-Only System** - Complete removal of Chinese language components and Deepin dependencies
- **📱 Responsive Design** - Works on desktop and mobile browsers

## 🚀 Quick Start

### Prerequisites
- Deepin Linux 25.01 (or Ubuntu 22.04+ / Debian Bookworm)
- 20GB+ free disk space
- 4GB+ RAM (8GB recommended)
- Root/sudo access
- Internet connection

### Installation (5 Minutes)

1. **Clone the Repository**
```bash
git clone https://github.com/yourusername/lilith.git
cd lilith
```

2. **Install Dependencies**
```bash
# On Deepin/Ubuntu/Debian
sudo apt-get update
sudo apt-get install -y debootstrap squashfs-tools grub-pc-bin xorriso
```

3. **Run the Application**
- Open `index.html` in your browser, or
- Access via Claude AI platform directly

4. **Configure Your Distribution**
- Follow the 6-step wizard
- Customize OS name, packages, colors, and branding
- Download the generated build script

5. **Build Your ISO**
```bash
chmod +x lilith-linux-builder.sh
sudo ./lilith-linux-builder.sh
```

6. **Deploy**
- Find your ISO in `/opt/lilith-build/output/`
- Create bootable USB or test in VirtualBox
- Install to hardware or distribute

**Total time: 20-45 minutes for a complete custom Linux distribution**

## 📚 Documentation

- **[Complete Deployment Guide](docs/DEPLOYMENT.md)** - Step-by-step setup and troubleshooting
- **[Configuration Guide](docs/CONFIGURATION.md)** - GUI walkthrough and advanced customization
- **[Repository Setup](docs/REPOSITORY.md)** - How to host your own package repository
- **[AI Integration](docs/AI-INTEGRATION.md)** - Framework for local AI model deployment
- **[Build Script Reference](docs/BUILD-SCRIPT.md)** - Technical details of the builder

## 🎯 Use Cases

✅ Create a custom enterprise Linux distribution  
✅ Build a specialized distribution for your organization  
✅ Remove bloatware and Chinese dependencies from Deepin  
✅ Deploy consistent systems across multiple machines  
✅ Host custom software packages via your repository  
✅ Integrate local AI models into Linux systems  
✅ Educational distribution building  

## 🏗️ Architecture

### Components

```
lilith/
├── src/
│   ├── components/
│   │   ├── LilithApp.tsx          # Main GUI component
│   │   ├── ConfigWizard.tsx       # Configuration wizard
│   │   └── BuildPreview.tsx       # Build preview/status
│   └── utils/
│       ├── scriptGenerator.js     # Build script generator
│       ├── configValidator.js     # Configuration validation
│       └── helpers.js             # Utility functions
├── scripts/
│   ├── lilith-linux-builder.sh    # Main build script template
│   ├── lilith-repo-setup.sh       # Repository setup script
│   └── lilith-automated-builder.sh # CI/CD automation script
├── docs/
│   ├── DEPLOYMENT.md              # Complete deployment guide
│   ├── CONFIGURATION.md           # Configuration reference
│   ├── REPOSITORY.md              # Repository setup guide
│   ├── AI-INTEGRATION.md          # AI model integration
│   └── BUILD-SCRIPT.md            # Technical reference
├── assets/
│   ├── lilith-logo.svg            # Project logo
│   └── screenshots/               # GUI screenshots
├── README.md                       # This file
├── LICENSE                         # MIT License
└── package.json                    # Node.js dependencies
```

### Technology Stack

- **Frontend:** React + TypeScript + Tailwind CSS
- **Backend:** Bash scripting for system operations
- **Build Tools:** debootstrap, squashfs-tools, grub, xorriso
- **Repository:** reprepro, nginx
- **CI/CD:** GitLab CI/GitHub Actions compatible

## 📖 Workflow

```
GUI Configuration
       ↓
Generate Build Script
       ↓
Download Script
       ↓
Execute on Deepin Linux
       ↓
System Extraction & Customization
       ↓
Package Management
       ↓
Theme & Branding Application
       ↓
Filesystem Compression
       ↓
ISO Generation
       ↓
Deploy to USB/VirtualBox/Hardware
```

## ⚙️ Configuration Options

### Basic Settings
- Distribution name (default: "Lilith Linux")
- Desktop edition name (default: "Deepin Hell Edition")
- Version number (semantic versioning)

### Package Management
- Packages to remove (with wildcard support)
- Packages to install
- Automatic removal of Chinese language packs

### Visual Customization
- Primary & secondary accent colors
- Background and text colors
- Font family selection
- Icon theme
- Cursor theme
- Window border radius

### Advanced Features
- Custom repository hosting
- GPG package signing
- CI/CD pipeline configuration
- AI model integration framework

## 🔧 Customization

### Add Custom Wallpapers
```bash
# After build, add to ISO
sudo mount -o loop /opt/lilith-build/output/lilith-linux-*.iso /mnt
sudo cp wallpaper.jpg /mnt/usr/share/backgrounds/lilith/
```

### Modify GTK Theme
Edit `/usr/share/themes/LilithHell/gtk-3.0/gtk.css` to customize appearance.

### Custom Boot Menu
Modify GRUB configuration in the generated build script.

### Add Custom Logos
Place logo at `/usr/share/pixmaps/lilith-logo.png`

## 🤖 AI Integration

Lilith supports integration with local AI models:

- **Ollama** - Easiest setup, recommended for beginners
- **llama.cpp** - Best performance, maximum optimization
- **LocalAI** - API-compatible, web interface
- **Hugging Face Transformers** - Most flexible, custom fine-tuning

See [AI Integration Guide](docs/AI-INTEGRATION.md) for details.

## 🚨 Troubleshooting

### Build Fails
```bash
# Check system requirements
df -h                    # Verify 20GB+ free space
free -h                  # Check available RAM

# Retry with cleanup
sudo rm -rf /opt/lilith-build
sudo ./lilith-linux-builder.sh
```

### Insufficient Space
```bash
# Clean temporary files
sudo rm -rf /opt/lilith-build/squashfs
# Or expand partition
```

### ISO Won't Boot
- Verify ISO integrity: `ls -lh /opt/lilith-build/output/`
- Use Etcher or Rufus for USB creation
- Test in VirtualBox first
- Check BIOS boot order

See [Complete Troubleshooting Guide](docs/DEPLOYMENT.md#-troubleshooting) for more solutions.

## 📊 System Requirements

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| Storage | 20GB | 40GB+ |
| RAM | 4GB | 8GB |
| CPU | 2 cores | 4+ cores |
| Network | Required | Required |
| OS | Ubuntu 22.04+ | Deepin 25.01 |

## 🤝 Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

### Development Setup
```bash
git clone https://github.com/yourusername/lilith.git
cd lilith
npm install
npm run dev
```

### Testing
```bash
npm run test
npm run build
```

## 📝 License

This project is licensed under the MIT License - see [LICENSE](LICENSE) file for details.

## 🙋 Support

- 📖 Read the [Complete Documentation](docs/)
- 🐛 Report bugs on [GitHub Issues](https://github.com/yourusername/lilith/issues)
- 💬 Start a [GitHub Discussion](https://github.com/yourusername/lilith/discussions)
- 📧 Email: your-email@example.com

## 🔗 Related Projects

- [Deepin Linux](https://www.deepin.org/)
- [Linux From Scratch](https://www.linuxfromscratch.org/)
- [Fedora Kickstart](https://fedoraproject.org/wiki/Anaconda/Kickstart)

## 📈 Roadmap

- [ ] Web-based GUI hosting
- [ ] Docker support for reproducible builds
- [ ] Automatic package repository generation
- [ ] Pre-built AI model packages
- [ ] System monitoring dashboard
- [ ] Multi-language support
- [ ] Custom boot splash screen builder
- [ ] Live ISO testing environment

## 🎉 Acknowledgments

Built with inspiration from:
- Deepin Linux project
- Linux distribution builders
- Open source community

---

**Where Power Meets Elegance** 🔥

Made with ❤️ by [Your Name]
