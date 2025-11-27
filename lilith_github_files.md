# GitHub Repository Files for Lilith

## FILE 1: LICENSE (MIT License)
```
MIT License

Copyright (c) 2024 [Your Name/Organization]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## FILE 2: .gitignore
```
# Dependencies
node_modules/
package-lock.json
yarn.lock

# Build outputs
dist/
build/
*.iso
*.squashfs

# System files
/opt/lilith-build/
.DS_Store
Thumbs.db

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# Logs
logs/
*.log
npm-debug.log*

# Environment
.env
.env.local
.env.*.local

# Temporary files
tmp/
temp/
*.tmp

# OS
.DS_Store
.AppleDouble
.LSOverride
```

---

## FILE 3: CONTRIBUTING.md
```markdown
# Contributing to Lilith Linux Distribution Builder

Thank you for your interest in contributing to Lilith! We welcome all contributions, from bug reports to feature implementations.

## Code of Conduct

This project adheres to the Contributor Covenant Code of Conduct. By participating, you are expected to uphold this code.

## How to Contribute

### Reporting Bugs

Before creating bug reports, please check the [issue list](https://github.com/yourusername/lilith/issues) as you might find out that you don't need to create one.

When creating a bug report, please include:
- **Clear description** of what the bug is
- **Steps to reproduce** the issue
- **Expected behavior** vs actual behavior
- **Screenshots or logs** if applicable
- **System information** (OS, hardware specs)

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion, please include:
- **Clear description** of the enhancement
- **Use case** and why it would be useful
- **Possible implementation** ideas (optional)

### Pull Requests

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Development Setup

```bash
# Clone your fork
git clone https://github.com/yourusername/lilith.git
cd lilith

# Install dependencies
npm install

# Start development server
npm run dev

# Run tests
npm run test

# Build for production
npm run build
```

### Coding Standards

- Use TypeScript for React components
- Follow ESLint configuration
- Write clear commit messages
- Add tests for new features
- Update documentation accordingly

### Commit Messages

- Use present tense ("Add feature" not "Added feature")
- Use imperative mood ("Move cursor to..." not "Moves cursor to...")
- Limit first line to 72 characters
- Reference issues and pull requests liberally

### Testing

- Write tests for new features
- Ensure all tests pass: `npm run test`
- Test on both Deepin Linux and Ubuntu
- Test ISO generation and boot

## Recognition

Contributors will be recognized in:
- Project README
- Changelog/Release notes
- GitHub contributors page

## Questions?

Feel free to open an issue or start a GitHub discussion with any questions!

---

**Thank you for contributing to Lilith!** 🔥
```

---

## FILE 4: CODE_OF_CONDUCT.md
```markdown
# Contributor Covenant Code of Conduct

## Our Pledge

In the interest of fostering an open and welcoming environment, we as contributors and maintainers pledge to making participation in our project and our community a harassment-free experience for everyone, regardless of age, body size, disability, ethnicity, sex characteristics, gender identity and expression, level of experience, education, socio-economic status, nationality, personal appearance, race, religion, or sexual identity and orientation.

## Our Standards

Examples of behavior that contributes to creating a positive environment include:

- Using welcoming and inclusive language
- Being respectful of differing viewpoints and experiences
- Gracefully accepting constructive criticism
- Focusing on what is best for the community
- Showing empathy towards other community members

Examples of unacceptable behavior by participants include:

- The use of sexualized language or imagery and unwelcome sexual attention or advances
- Trolling, insulting/derogatory comments, and personal or political attacks
- Public or private harassment
- Publishing others' private information, such as a physical or electronic address, without explicit permission
- Other conduct which could reasonably be considered inappropriate in a professional setting

## Enforcement

Instances of abusive, harassing, or otherwise unacceptable behavior may be reported to the project team at [your-email@example.com]. All complaints will be reviewed and investigated.

Project maintainers are obligated to maintain confidentiality with regard to the reporter of an incident.

---

For more information, see the [Contributor Covenant](https://www.contributor-covenant.org/) website.
```

---

## FILE 5: package.json
```json
{
  "name": "lilith-linux-distribution-builder",
  "version": "1.0.0",
  "description": "Interactive GUI application for building custom Linux distributions based on Deepin Linux 25.01",
  "main": "index.js",
  "scripts": {
    "dev": "react-scripts start",
    "build": "react-scripts build",
    "test": "react-scripts test",
    "eject": "react-scripts eject",
    "lint": "eslint src/",
    "format": "prettier --write src/"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "lucide-react": "^0.263.1",
    "tailwindcss": "^3.3.0"
  },
  "devDependencies": {
    "@types/react": "^18.2.0",
    "@types/react-dom": "^18.2.0",
    "typescript": "^5.0.0",
    "eslint": "^8.0.0",
    "prettier": "^3.0.0",
    "react-scripts": "5.0.0"
  },
  "browserslist": {
    "production": [
      ">0.2%",
      "not dead",
      "not op_mini all"
    ],
    "development": [
      "last 1 chrome version",
      "last 1 firefox version",
      "last 1 safari version"
    ]
  },
  "keywords": [
    "linux",
    "distribution",
    "deepin",
    "custom",
    "builder",
    "gui",
    "rebranding"
  ],
  "author": "Your Name",
  "license": "MIT",
  "repository": {
    "type": "git",
    "url": "https://github.com/yourusername/lilith.git"
  },
  "bugs": {
    "url": "https://github.com/yourusername/lilith/issues"
  },
  "homepage": "https://github.com/yourusername/lilith#readme"
}
```

---

## FILE 6: .github/workflows/build.yml (CI/CD)
```yaml
name: Build & Test

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  build:
    runs-on: ubuntu-latest

    strategy:
      matrix:
        node-version: [16.x, 18.x, 20.x]

    steps:
    - uses: actions/checkout@v3
    
    - name: Use Node.js ${{ matrix.node-version }}
      uses: actions/setup-node@v3
      with:
        node-version: ${{ matrix.node-version }}
        cache: 'npm'
    
    - name: Install dependencies
      run: npm ci
    
    - name: Lint code
      run: npm run lint --if-present
    
    - name: Run tests
      run: npm test -- --passWithNoTests
    
    - name: Build application
      run: npm run build --if-present

  security:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Run Trivy security scan
      uses: aquasecurity/trivy-action@master
      with:
        scan-type: 'fs'
        scan-ref: '.'
        format: 'sarif'
        output: 'trivy-results.sarif'
    
    - name: Upload Trivy results to GitHub Security tab
      uses: github/codeql-action/upload-sarif@v2
      with:
        sarif_file: 'trivy-results.sarif'
```

---

## FILE 7: SECURITY.md
```markdown
# Security Policy

## Reporting a Vulnerability

**Do not** open public GitHub issues for security vulnerabilities.

Instead, please email security concerns to: security@lilithlinux.org

Please include:
- Description of the vulnerability
- Steps to reproduce
- Potential impact
- Suggested fix (if any)

We will acknowledge receipt within 48 hours and provide updates every 5 days.

## Security Best Practices

When using Lilith Linux Distribution Builder:

1. **Always verify downloads** - Check file checksums
2. **Keep dependencies updated** - Run `npm update` regularly
3. **Use HTTPS for repositories** - Never host unencrypted repositories
4. **Secure your GPG keys** - Protect repository signing keys
5. **Test in isolation** - Build in VMs before hardware deployment
6. **Review build scripts** - Always inspect generated scripts before execution
7. **Secure sudo access** - Restrict who can run build commands

## Supported Versions

| Version | Supported          |
|---------|-------------------|
| 1.0.x   | ✅ Yes             |
| < 1.0   | ❌ No              |

## Dependency Updates

We maintain up-to-date dependencies and publish security updates as needed. Subscribe to releases for notifications.
```

---

## FILE 8: .github/ISSUE_TEMPLATE/bug_report.md
```markdown
---
name: Bug report
about: Create a report to help us improve
title: '[BUG] '
labels: bug
assignees: ''

---

## Describe the bug
A clear and concise description of what the bug is.

## Steps to Reproduce
Steps to reproduce the behavior:
1. Go to '...'
2. Click on '....'
3. Scroll down to '....'
4. See error

## Expected behavior
A clear and concise description of what you expected to happen.

## Screenshots
If applicable, add screenshots to help explain your problem.

## System Information
- OS: [e.g., Deepin 25.01, Ubuntu 22.04]
- Available disk space: [e.g., 50GB]
- RAM: [e.g., 8GB]
- CPU: [e.g., Intel i7, 4 cores]
- Browser: [e.g., Chrome, Firefox]

## Additional context
Add any other context about the problem here.
```

---

## FILE 9: .github/ISSUE_TEMPLATE/feature_request.md
```markdown
---
name: Feature request
about: Suggest an idea for this project
title: '[FEATURE] '
labels: enhancement
assignees: ''

---

## Is your feature request related to a problem?
A clear and concise description of what the problem is.

## Describe the solution you'd like
A clear and concise description of what you want to happen.

## Describe alternatives you've considered
A clear and concise description of any alternative solutions or features you've considered.

## Additional context
Add any other context or screenshots about the feature request here.
```

---

## FILE 10: .editorconfig
```
# EditorConfig is awesome: https://EditorConfig.org

# top-most EditorConfig file
root = true

# Unix-style newlines with a newline ending every file
[*]
end_of_line = lf
insert_final_newline = true
charset = utf-8
trim_trailing_whitespace = true

# JavaScript/TypeScript files
[*.{js,jsx,ts,tsx,json}]
indent_style = space
indent_size = 2

# Bash files
[*.sh]
indent_style = space
indent_size = 2

# Markdown files
[*.md]
trim_trailing_whitespace = false
```

---

All files are ready to be added to your GitHub repository!
