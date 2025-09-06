# Contributing to Project Locus

<div align="center">

```
🤝 CONTRIBUTING TO PROJECT LOCUS
┌─────────────────────────────────────────────────────────────┐
│             Welcome to the Multi-Agent Community!           │
│                                                             │
│  We believe in collaborative intelligence where human       │
│  creativity meets AI capability to build amazing things.   │
└─────────────────────────────────────────────────────────────┘
```

[![Contributors](https://img.shields.io/github/contributors/toolate28/locus-proxmox-infra?style=for-the-badge&color=success)](https://github.com/toolate28/locus-proxmox-infra/graphs/contributors)
[![Forks](https://img.shields.io/github/forks/toolate28/locus-proxmox-infra?style=for-the-badge&color=blue)](https://github.com/toolate28/locus-proxmox-infra/network/members)
[![Issues](https://img.shields.io/github/issues/toolate28/locus-proxmox-infra?style=for-the-badge&color=orange)](https://github.com/toolate28/locus-proxmox-infra/issues)

</div>

---

## 🌟 Ways to Contribute

### 🚀 **For Developers**
- 🔧 Improve automation scripts and infrastructure
- 🐛 Fix bugs and optimize performance
- 📊 Add monitoring and reporting features
- 🔒 Enhance security and compliance

### 📚 **For Documentation Enthusiasts**
- 📝 Write guides and tutorials
- 🎨 Improve visual documentation
- 🔍 Update reference materials
- 🌐 Translate content

### 🤖 **For AI/Agent Specialists**
- 🧠 Enhance multi-agent workflows
- 🔄 Improve handover protocols
- 📈 Optimize agent coordination
- 🎯 Design new agent capabilities

### 💡 **For Infrastructure Experts**
- 🏗️ Proxmox integration improvements
- ☁️ Cloud platform extensions
- 📊 Performance optimization
- 🔐 Security hardening

---

## 🚀 Getting Started

### 1️⃣ **Environment Setup**

<details>
<summary>📋 Prerequisites</summary>

```bash
# Required tools
sudo apt-get update && sudo apt-get install -y \
  git bash jq qrencode shellcheck curl

# Verify installation
command -v git && echo "✅ git"
command -v jq && echo "✅ jq" 
command -v qrencode && echo "✅ qrencode"
command -v shellcheck && echo "✅ shellcheck"
```

</details>

### 2️⃣ **Repository Setup**

```bash
# Fork and clone
git clone https://github.com/YOUR_USERNAME/locus-proxmox-infra.git
cd locus-proxmox-infra

# Add upstream remote
git remote add upstream https://github.com/toolate28/locus-proxmox-infra.git

# Make scripts executable
chmod +x automation/*.sh scripts/*.sh

# Validate environment
shellcheck automation/*.sh scripts/*.sh
```

### 3️⃣ **Development Workflow**

```bash
# Generate REF tag for your work
REF_TAG=$(./automation/generate_ref_tag.sh task "your-contribution-name")

# Create feature branch
git checkout -b "feature/$(echo $REF_TAG | tr '[:upper:]' '[:lower:]')"

# Start developing...
```

---

## 📋 Development Standards

### 🎯 **Code Quality Requirements**

<table>
<tr>
<td width="50%">

**⚡ Performance Standards**
- All scripts must execute in <10 seconds
- No long-running operations in core automation
- Efficient resource usage patterns
- Documented execution time expectations

</td>
<td width="50%">

**🔒 Security Standards**
- No hardcoded secrets or credentials
- Use GitHub Secrets for sensitive data
- Include proper input validation
- Implement comprehensive audit trails

</td>
</tr>
<tr>
<td width="50%">

**📏 Code Style**
- Follow existing shell script patterns
- Use `set -euo pipefail` for error handling
- Include meaningful comments
- Descriptive variable and function names

</td>
<td width="50%">

**🏷️ REF Tag Requirements**
- All operations must generate REF tags
- Include REF tags in commit messages
- Document REF tag usage in scripts
- Maintain audit trail compliance

</td>
</tr>
</table>

### 📝 **Documentation Standards**

#### ✅ **Required for All Changes**
- Update README.md for user-facing changes
- Include inline documentation for complex scripts
- Add examples for new functionality
- Update relevant guides in `/docs/`

#### 📊 **Documentation Types**
- **🚀 Quick Reference:** Copy-paste examples
- **📖 Comprehensive Guides:** Step-by-step tutorials  
- **🔍 Technical Reference:** Detailed specifications
- **🎯 Best Practices:** Recommended patterns

---

## 🔄 Contribution Process

### 📋 **Step-by-Step Guide**

<details>
<summary>1️⃣ **Issue Creation & Assignment**</summary>

#### **🐛 Bug Reports**
```markdown
## Bug Description
Brief description of the issue

## Steps to Reproduce
1. Run command: `./automation/script.sh`
2. Expected behavior vs actual behavior
3. Error messages or logs

## Environment
- OS: Ubuntu 22.04
- Shell: bash 5.1.16
- REF Tag: LOCUS-TASK-001 (if applicable)

## Additional Context
Any other relevant information
```

#### **💡 Feature Requests**
```markdown
## Feature Description
What new capability would you like to see?

## Use Case
Describe the problem this solves

## Proposed Solution
How would you implement this?

## Alternatives Considered
Other approaches you've thought about
```

</details>

<details>
<summary>2️⃣ **Development & Testing**</summary>

#### **🔧 Development Checklist**
- [ ] Create REF tag for tracking
- [ ] Write code following project standards
- [ ] Include error handling and validation
- [ ] Add appropriate documentation
- [ ] Test script execution times (<10 seconds)
- [ ] Validate with existing automation

#### **🧪 Testing Requirements**
```bash
# Run existing validation suite
./automation/resource_check.sh
./automation/status_report.sh
./automation/heartbeat_monitor.sh

# Test your changes
time ./your_new_script.sh
shellcheck ./your_new_script.sh

# Validate REF tag generation
REF_CHECK=$(./automation/generate_ref_tag.sh task "validation")
echo "REF validation: $REF_CHECK"
```

</details>

<details>
<summary>3️⃣ **Pull Request Submission**</summary>

#### **📝 PR Template**
```markdown
## Description
Brief description of changes

## REF Tag
LOCUS-TASK-YYYYMMDD-NNN

## Type of Change
- [ ] Bug fix (non-breaking change)
- [ ] New feature (non-breaking change)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update

## Testing
- [ ] Scripts execute in <10 seconds
- [ ] All existing automation still works
- [ ] New functionality has been tested
- [ ] Documentation has been updated

## Checklist
- [ ] Code follows project style guidelines
- [ ] Self-review of code completed
- [ ] Changes generate valid REF tags
- [ ] Security considerations addressed
```

</details>

### 🎯 **Review Process**

<div align="center">

```
📋 REVIEW WORKFLOW
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│  📝 Submit PR   │ ──►│  🔍 Auto Checks │ ──►│  👥 Human Review│
│                 │    │                 │    │                 │
│ ✅ Complete PR  │    │ ✅ CI/CD Tests  │    │ ✅ Code Review  │
│ ✅ REF Tag      │    │ ✅ Security Scan│    │ ✅ Documentation│
│ ✅ Tests Pass   │    │ ✅ Style Check  │    │ ✅ Functionality│
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

</div>

#### **⚡ Review Criteria**
- **🔧 Functionality:** Does it work as intended?
- **📊 Performance:** Meets <10 second execution requirement?
- **🔒 Security:** No credentials exposed, proper validation?
- **📚 Documentation:** Clear and comprehensive?
- **🏷️ REF Tags:** Properly implemented and documented?

---

## 🏆 Recognition & Community

### 🌟 **Contributor Levels**

<div align="center">

| 🎯 **Level** | 📊 **Requirements** | 🎁 **Benefits** |
|:---:|:---:|:---:|
| **🌱 New Contributor** | First merged PR | Welcome package, onboarding |
| **🚀 Regular Contributor** | 5+ merged PRs | Featured in README, priority support |
| **🎯 Core Contributor** | 15+ PRs + mentoring | Maintainer access, decision input |
| **👑 Champion** | Leadership + major features | Advisory role, special recognition |

</div>

### 🎖️ **Special Recognition**

- **🏅 Documentation Hero:** Outstanding documentation contributions
- **🔒 Security Guardian:** Significant security improvements
- **🤖 Agent Innovator:** Advanced multi-agent workflow development
- **🌟 Community Builder:** Exceptional mentoring and support

---

## 📞 Support & Communication

### 💬 **Getting Help**

<table>
<tr>
<td width="33%">

**🆕 New Contributors**
- 📖 [Onboarding Playbook](docs/onboarding_playbook.md)
- 💬 [GitHub Discussions](https://github.com/toolate28/locus-proxmox-infra/discussions)
- 🏷️ `good-first-issue` label

</td>
<td width="33%">

**🔧 Technical Questions**
- 🐛 [GitHub Issues](https://github.com/toolate28/locus-proxmox-infra/issues)
- 📚 Documentation in `/docs/`
- 🔍 Code examples in scripts

</td>
<td width="33%">

**🤝 Community**
- 👥 [GitHub Discussions](https://github.com/toolate28/locus-proxmox-infra/discussions)
- 📧 [Contact maintainers](mailto:maintainers@locus.internal)
- 🎯 Monthly contributor calls

</td>
</tr>
</table>

### 📧 **Direct Contact**

- **🏢 General Questions:** [community@locus.internal](mailto:community@locus.internal)
- **🔒 Security Issues:** [security@locus.internal](mailto:security@locus.internal)
- **👥 Maintainer Team:** [maintainers@locus.internal](mailto:maintainers@locus.internal)

---

## 📜 Code of Conduct

### 🤝 **Our Commitment**

We are committed to providing a welcoming and inclusive environment for all contributors, regardless of background, experience level, or identity.

### ✅ **Expected Behavior**

- **🤝 Be Respectful:** Treat everyone with kindness and professionalism
- **🧠 Be Collaborative:** Share knowledge and help others learn
- **💡 Be Constructive:** Provide helpful feedback and suggestions
- **🎯 Be Patient:** Remember everyone is learning and growing

### ❌ **Unacceptable Behavior**

- Harassment, discrimination, or personal attacks
- Sharing inappropriate or offensive content
- Spamming or excessive self-promotion
- Violating others' privacy or security

### 📧 **Reporting Issues**

If you experience or witness unacceptable behavior, please contact:
- **📧 Email:** [conduct@locus.internal](mailto:conduct@locus.internal)
- **🔒 Anonymous:** [Anonymous reporting form](https://forms.gle/anonymous-report)

---

<div align="center">

## 🎉 **Ready to Contribute?**

```bash
# Start your contribution journey
git clone https://github.com/YOUR_USERNAME/locus-proxmox-infra.git
cd locus-proxmox-infra
./automation/generate_ref_tag.sh task "my-first-contribution"
```

**Every contribution makes Project Locus better for everyone!**

[![Start Contributing](https://img.shields.io/badge/Start_Contributing-Join_Us!-success?style=for-the-badge&logo=github)](https://github.com/toolate28/locus-proxmox-infra/fork)

---

**REF:** `LOCUS-DOC-CONTRIBUTING-001`  
**📊 Community Guidelines:** ✅ Active  
**🤝 Welcome Process:** ✅ Established  
**🏆 Recognition System:** ✅ Implemented  

*Last Updated: September 2024*

</div>