# Contributing to Locus-Proxmox Infrastructure

We welcome contributions to the Locus-Proxmox infrastructure project! This document provides guidelines for contributing.

## Development Setup

1. **Fork and clone the repository**:
   ```bash
   git clone https://github.com/your-username/locus-proxmox-infra.git
   cd locus-proxmox-infra
   ```

2. **Install development dependencies**:
   ```bash
   # Ubuntu/Debian
   sudo apt-get update
   sudo apt-get install shellcheck python3 python3-yaml qrencode

   # macOS with Homebrew
   brew install shellcheck python3 qrencode
   ```

3. **Run tests**:
   ```bash
   ./tests/basic_tests.sh
   ```

## Code Style Guidelines

### Shell Scripts
- Use `#!/bin/bash` shebang
- Enable strict mode: `set -euo pipefail`
- Use meaningful variable names
- Include help functions for user-facing scripts
- Add comments for complex logic
- Follow Google Shell Style Guide

### JSON Configuration
- Validate all JSON files against schemas
- Use consistent indentation (2 spaces)
- Include meaningful descriptions in schemas
- Provide example configurations

### Documentation
- Use clear, concise language
- Include code examples
- Update README for significant changes
- Document all script options and environment variables

## Testing Requirements

Before submitting a pull request:

1. **Run the test suite**:
   ```bash
   ./tests/basic_tests.sh
   ```

2. **Test your scripts manually**:
   ```bash
   # Test help functions
   ./scripts/vm_provision.sh --help
   ./scripts/status_report.sh --help

   # Test JSON validation
   python3 -m json.tool schemas/vm-config.json
   ```

3. **Validate GitHub Actions workflows** (if modified):
   ```bash
   # Use GitHub CLI or online validators
   gh workflow validate .github/workflows/ci.yml
   ```

## Pull Request Process

1. **Create a feature branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes**:
   - Follow the code style guidelines
   - Add tests if applicable
   - Update documentation

3. **Test your changes**:
   ```bash
   ./tests/basic_tests.sh
   ```

4. **Commit your changes**:
   ```bash
   git add .
   git commit -m "feat: add your feature description"
   ```

5. **Push and create pull request**:
   ```bash
   git push origin feature/your-feature-name
   ```

## Commit Message Format

Use conventional commit format:

- `feat:` New features
- `fix:` Bug fixes
- `docs:` Documentation changes
- `test:` Test additions or modifications
- `refactor:` Code refactoring
- `style:` Formatting changes
- `ci:` CI/CD changes

Examples:
```
feat: add VM template management script
fix: resolve resource threshold calculation bug
docs: update installation instructions
test: add validation for JSON schemas
```

## Review Process

All pull requests require:
1. Passing CI checks
2. Code review from maintainers
3. No merge conflicts
4. Updated documentation (if applicable)

## Issue Reporting

When reporting issues:
1. Use the issue templates
2. Provide detailed reproduction steps
3. Include environment information
4. Add relevant logs or error messages

## Feature Requests

For feature requests:
1. Check existing issues first
2. Clearly describe the use case
3. Explain the expected behavior
4. Consider implementation complexity

## Security

- Never commit sensitive information
- Report security vulnerabilities privately
- Follow security best practices in scripts
- Use appropriate file permissions

Thank you for contributing to Locus-Proxmox Infrastructure!