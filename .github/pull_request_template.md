## Pull Request Template - Project Locus

### Summary
<!-- Provide a brief description of the changes in this PR -->

### Type of Change
- [ ] 🐛 Bug fix (non-breaking change which fixes an issue)
- [ ] ✨ New feature (non-breaking change which adds functionality)
- [ ] 💥 Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] 📚 Documentation only changes
- [ ] 🔧 Refactoring (no functional changes, no api changes)
- [ ] 🔒 Security update
- [ ] 🏗️ Infrastructure/DevOps changes

### REF Tag Compliance
- [ ] All changes include proper REF tag generation where applicable
- [ ] REF tags follow format: `LOCUS-{TYPE}{TIMESTAMP}-{COUNTER}`
- [ ] Audit trail updated for significant changes

### Security Checklist
- [ ] No secrets or sensitive data committed
- [ ] All API keys use GitHub Secrets
- [ ] File permissions are appropriate
- [ ] Changes follow least-privilege principles

### Testing
- [ ] I have tested this change locally
- [ ] Automation scripts pass syntax validation
- [ ] Documentation is updated if needed
- [ ] No breaking changes to existing workflows

### Agent Integration
If this PR affects agent capabilities, check applicable boxes:
- [ ] Claude Pro integration tested
- [ ] Perplexity Pro integration tested  
- [ ] Proton Lumo integration tested
- [ ] Multi-agent orchestration validated

### Infrastructure Impact
- [ ] Proxmox VE configuration changes (if applicable)
- [ ] Resource monitoring updates (if applicable)
- [ ] Backup/recovery implications considered
- [ ] Performance impact assessed

### Documentation
- [ ] README.md updated if needed
- [ ] Connector guide updated if needed
- [ ] Onboarding playbook updated if needed
- [ ] MIGRATION_KIT.md updated if needed

### Governance Compliance
- [ ] Changes align with Project Locus governance policies
- [ ] CODEOWNERS review requirements met
- [ ] CI/CD pipeline considerations addressed
- [ ] Compliance report reviewed (if applicable)

### Related Issues
<!-- Link any related issues using #issue_number -->

### Additional Notes
<!-- Any additional information, deployment notes, or special considerations -->