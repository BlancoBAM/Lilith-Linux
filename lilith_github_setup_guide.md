# Lilith Linux - GitHub Repository Setup Guide

## 📋 Step-by-Step Setup Instructions

### Step 1: Create GitHub Repository

1. Go to [github.com/new](https://github.com/new)
2. **Repository name:** `lilith`
3. **Description:** `Interactive GUI for building custom Linux distributions based on Deepin Linux 25.01`
4. **Visibility:** Choose **Public** (for open source)
5. **Initialize repository:** Leave unchecked (we'll push existing files)
6. Click **Create repository**

---

### Step 2: Prepare Your Local Environment

```bash
# Create a working directory
mkdir -p ~/projects/lilith
cd ~/projects/lilith

# Initialize git repository
git init

# Configure git (if not already done)
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

---

### Step 3: Create Project Structure

Create these directories and files:

```bash
# Create directory structure
mkdir -p src/components
mkdir -p src/utils
mkdir -p scripts
mkdir -p docs
mkdir -p assets/screenshots
mkdir -p .github/workflows
mkdir -p .github/ISSUE_TEMPLATE

# Create placeholder files (we'll fill these in next)
touch README.md
touch LICENSE
touch CONTRIBUTING.md
touch CODE_OF_CONDUCT.md
touch SECURITY.md
touch package.json
touch .gitignore
touch .editorconfig
touch docs/DEPLOYMENT.md
touch docs/CONFIGURATION.md
touch docs/REPOSITORY.md
touch docs/AI-INTEGRATION.md
touch docs/BUILD-SCRIPT.md
```

---

### Step 4: Add Files from Artifacts

**Copy these files from the artifacts provided:**

#### From "Lilith - GitHub README.md" artifact:
- Copy content → Save as `README.md`

#### From "Lilith - GitHub Repository Files" artifact:

- **LICENSE (MIT)** content → Save as `LICENSE`
- **CONTRIBUTING.md** content → Save as `CONTRIBUTING.md`
- **CODE_OF_CONDUCT.md** content → Save as `CODE_OF_CONDUCT.md`
- **SECURITY.md** content → Save as `SECURITY.md`
- **package.json** content → Save as `package.json`
- **.gitignore** content → Save as `.gitignore`
- **.editorconfig** content → Save as `.editorconfig`
- **.github/workflows/build.yml** content → Save as `.github/workflows/build.yml`
- **.github/ISSUE_TEMPLATE/bug_report.md** → Save as `.github/ISSUE_TEMPLATE/bug_report.md`
- **.github/ISSUE_TEMPLATE/feature_request.md** → Save as `.github/ISSUE_TEMPLATE/feature_request.md`

---

### Step 5: Add Application Source Code

#### Create `src/index.js`:
```javascript
import React from 'react';
import ReactDOM from 'react-dom/client';
import LilithApp from './components/LilithApp';
import './index.css';

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
  <React.StrictMode>
    <LilithApp />
  </React.StrictMode>
);
```

#### Create `src/components/LilithApp.tsx`:
**Copy the entire React component from the "Lilith - Complete Distribution Builder" artifact**

#### Create `public/index.html`:
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lilith Linux Distribution Builder</title>
    <meta name="description" content="Interactive GUI for building custom Linux distributions based on Deepin Linux 25.01">
</head>
<body>
    <div id="root"></div>
    <script src="index.js"></script>
</body>
</html>
```

---

### Step 6: Add Build Scripts

#### Create `scripts/lilith-linux-builder.sh`:
**Copy the generated build script from the Lilith GUI application download**

#### Create `scripts/lilith-repo-setup.sh`:
```bash
#!/bin/bash
# Lilith Linux Repository Setup Script
# This script sets up a repository server for Lilith Linux packages

echo "Setting up Lilith Linux Repository..."
echo "This script will:"
echo "  - Install reprepro for package management"
echo "  - Install nginx for web distribution"
echo "  - Generate GPG keys for package signing"
echo "  - Configure repository structure"

# Implementation details...
# See docs/REPOSITORY.md for full instructions
```

#### Create `scripts/lilith-automated-builder.sh`:
```bash
#!/bin/bash
# Lilith Linux Automated Package Building System

echo "Automated Package Building for Lilith Linux"
echo "This script automates compilation and repository uploads"

# Implementation details...
# See docs/BUILD-SCRIPT.md for full instructions
```

---

### Step 7: Add Documentation Files

#### `docs/DEPLOYMENT.md`
**Copy from the "Lilith Distribution Builder - Complete Deployment Guide" artifact**

#### `docs/CONFIGURATION.md`:
```markdown
# Configuration Guide

See the main [README.md](../README.md) for GUI configuration details.

## Advanced Configuration

### Custom GTK Theme
Modify `/usr/share/themes/LilithHell/gtk-3.0/gtk.css`

### System Files
- `/etc/os-release` - Distribution info
- `/etc/hostname` - System hostname
- `/etc/motd` - Welcome message

For detailed instructions, see [DEPLOYMENT.md](DEPLOYMENT.md)
```

#### `docs/REPOSITORY.md`:
```markdown
# Custom Repository Setup

This guide covers setting up your own package repository for Lilith Linux.

## Quick Start

```bash
sudo bash scripts/lilith-repo-setup.sh
```

## Components

- **reprepro** - Debian package management
- **nginx** - Web distribution
- **GPG** - Package signing

For complete setup instructions, see [DEPLOYMENT.md](DEPLOYMENT.md#-custom-repository)
```

#### `docs/AI-INTEGRATION.md`:
```markdown
# AI Model Integration

Lilith supports integration with local AI models for specialized tasks.

## Supported Models

- Ollama - Easiest setup
- llama.cpp - Best performance
- LocalAI - API-compatible
- Hugging Face - Most flexible

## Installation

1. Choose your model based on hardware
2. Install model framework
3. Configure integration
4. Test with Lilith

See [DEPLOYMENT.md](DEPLOYMENT.md) for hardware requirements table.
```

#### `docs/BUILD-SCRIPT.md`:
```markdown
# Build Script Technical Reference

Generated scripts automate distribution building.

## Script Flow

1. Environment setup
2. Base system extraction
3. Package customization
4. System rebranding
5. Filesystem compilation
6. ISO generation

## Timeline

- 5 min: Setup
- 5 min: Base extraction
- 5-10 min: Packages
- 10-15 min: Compression
- 5 min: ISO generation
- **Total: 20-45 minutes**

## Troubleshooting

See [DEPLOYMENT.md](DEPLOYMENT.md#-troubleshooting)
```

---

### Step 8: Create a `.gitattributes` File

```bash
# Create .gitattributes
cat > .gitattributes << 'EOF'
# Auto detect text files and normalize line endings to LF
* text=auto

# Bash scripts
*.sh text eol=lf

# Documents
*.md text eol=lf

# Source code
*.js text eol=lf
*.jsx text eol=lf
*.ts text eol=lf
*.tsx text eol=lf
*.json text eol=lf

# Binary files
*.iso binary
*.squashfs binary
*.gz binary
EOF
```

---

### Step 9: Commit and Push to GitHub

```bash
# Check status
git status

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit: Lilith Linux Distribution Builder

- Complete GUI application for building custom Linux distributions
- Automated rebranding and system customization
- Package management and repository setup
- Advanced theming and branding tools
- CI/CD automation framework
- Comprehensive documentation"

# Add remote repository
git remote add origin https://github.com/yourusername/lilith.git

# Verify remote
git remote -v

# Push to GitHub (main branch)
git branch -M main
git push -u origin main
```

---

### Step 10: Configure GitHub Settings

#### 1. **Repository Settings**
- Go to Settings → General
- Add description: "Interactive GUI for building custom Linux distributions based on Deepin Linux 25.01"
- Add topics: `linux`, `distribution`, `deepin`, `custom-os`, `gui`, `builder`
- Set default branch to `main`

#### 2. **Collaborators & Permissions**
- Settings → Collaborators
- Add any co-maintainers if needed

#### 3. **Branches Protection** (optional but recommended)
- Settings → Branches
- Add rule for `main` branch
- Require pull request reviews
- Require status checks to pass

#### 4. **Enable Discussions**
- Settings → Features
- Enable "Discussions" for community Q&A

#### 5. **Setup Issues Templates**
- Already configured via `.github/ISSUE_TEMPLATE/` files

---

### Step 11: Verify GitHub Pages (Optional)

For hosting documentation:

```bash
# Settings → Pages
# Source: Deploy from a branch
# Branch: main, folder: /docs
```

---

### Step 12: Create Release

```bash
# Tag your release
git tag -a v1.0.0 -m "Lilith Linux Distribution Builder v1.0.0

Release features:
- Complete GUI application
- Automated build system
- Repository setup tools
- Comprehensive documentation"

# Push tags to GitHub
git push origin v1.0.0
```

Then on GitHub:
1. Go to Releases
2. Click "Draft a new release"
3. Select tag `v1.0.0`
4. Add release notes
5. Click "Publish release"

---

## 📝 Customization Steps

Before pushing, update these files with your information:

**README.md:**
```bash
# Replace these in README.md:
yourusername          → Your GitHub username
your-email@example.com → Your email
Your Name             → Your name/organization
```

**package.json:**
```bash
# Update:
"author": "Your Name"
"repository.url": "https://github.com/yourusername/lilith.git"
"bugs.url": "https://github.com/yourusername/lilith/issues"
"homepage": "https://github.com/yourusername/lilith#readme"
```

**LICENSE:**
```bash
# Update:
Copyright (c) 2024 [Your Name/Organization]
```

**SECURITY.md:**
```bash
# Update:
security@lilithlinux.org → Your security email
```

---

## 🚀 Post-Publish Checklist

- [ ] Repository created and pushed
- [ ] README displays correctly on GitHub
- [ ] All documentation files are accessible
- [ ] GitHub Actions workflows running
- [ ] Issues and Pull Request templates working
- [ ] Release published
- [ ] Topics added
- [ ] Discussions enabled
- [ ] Contributors guide visible

---

## 📊 Project Structure Verification

```
lilith/
├── .github/
│   ├── workflows/
│   │   └── build.yml
│   └── ISSUE_TEMPLATE/
│       ├── bug_report.md
│       └── feature_request.md
├── docs/
│   ├── DEPLOYMENT.md
│   ├── CONFIGURATION.md
│   ├── REPOSITORY.md
│   ├── AI-INTEGRATION.md
│   └── BUILD-SCRIPT.md
├── scripts/
│   ├── lilith-linux-builder.sh
│   ├── lilith-repo-setup.sh
│   └── lilith-automated-builder.sh
├── src/
│   ├── components/
│   │   └── LilithApp.tsx
│   ├── utils/
│   ├── index.js
│   └── index.css
├── public/
│   └── index.html
├── assets/
│   └── screenshots/
├── .editorconfig
├── .gitattributes
├── .gitignore
├── CODE_OF_CONDUCT.md
├── CONTRIBUTING.md
├── SECURITY.md
├── LICENSE
├── package.json
└── README.md
```

---

## 🎯 Next Steps

1. **Announce your project**
   - Share on Reddit's `/r/linux`
   - Post in Linux forums
   - Tweet about it

2. **Gather feedback**
   - Monitor issues
   - Respond to discussions
   - Iterate based on feedback

3. **Continue development**
   - Fix reported bugs
   - Implement requested features
   - Keep dependencies updated

4. **Build community**
   - Respond to contributions
   - Mentor new contributors
   - Celebrate milestones

---

## ❓ Troubleshooting GitHub Setup

### Push fails with "fatal: remote origin already exists"
```bash
git remote remove origin
git remote add origin https://github.com/yourusername/lilith.git
```

### Large file errors
```bash
# Remove large files from history if needed
git rm --cached *.iso
git commit -m "Remove ISO files"
```

### Branch protection errors
- Temporarily disable branch protection
- Push changes
- Re-enable protection

### Workflows not running
- Check `.github/workflows/` syntax
- Verify file permissions
- Check GitHub Actions limits

---

## 📞 Support

For GitHub-specific help:
- [GitHub Docs](https://docs.github.com)
- [GitHub Community](https://github.com/community)
- [Stack Overflow - GitHub tag](https://stackoverflow.com/questions/tagged/github)

---

**You're all set!** Your Lilith Linux project is now on GitHub and ready for the world. 🔥

Good luck with your project!
