## Pull Request Template - Project Locus

### Summary
<!-- Provide a brief description of the changes in this PR: Explain context, motivation, and what this PR achieves for Project Locus documentation, security, infra, or agent capability. Also reference formatting improvements if relevant. -->

### Type of Change
- [ ] 🐛 Bug fix (non-breaking change which fixes an issue)
- [ ] ✨ New feature (non-breaking change which adds functionality)
- [ ] 💥 Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] 📚 Documentation only changes (README, onboarding, connectors, migration kits—ensure formatting schema compliance)
- [ ] 🔧 Refactoring (no functional changes, no API changes, pure formatting/structure)
- [ ] 🔒 Security update
- [ ] 🏗️ Infrastructure/DevOps changes (Cloudflare domain mapping, monitoring, DNS/TLS/Zero Trust etc.)

### REF Tag Compliance
- [ ] All changes include proper REF tag generation where applicable
- [ ] REF tags follow format: `LOCUS-{TYPE}{TIMESTAMP}-{COUNTER}`
- [ ] Audit trail updated for significant changes

### Security Checklist
- [ ] No secrets or sensitive data committed
- [ ] All API keys use GitHub Secrets or Cloudflare Vaults
- [ ] File permissions are appropriate
- [ ] Changes follow least-privilege principles
- [ ] Cloudflare domain config (if updated) reviewed for TLS, DNSSEC, WAF, OAuth policy

### Testing
- [ ] I have tested this change locally in my environment(s)
- [ ] Automation scripts pass syntax/format/lint validation (`markdownlint`, CI pipeline etc.)
- [ ] Documentation updated as needed (README, playbook, migration kit)
- [ ] No breaking changes to existing workflows; backward compatibility reviewed

### Agent Integration
If this PR affects agent capabilities, check applicable boxes:
- [ ] Claude Pro integration tested and documented
- [ ] Perplexity Pro integration tested and documented
- [ ] Proton Lumo integration tested and documented
- [ ] Multi-agent orchestration validated (handover, REF tag, dashboard linkage)

### Infrastructure Impact
- [ ] Proxmox VE configuration changes (attach audit result if updated)
- [ ] Cloudflare DNS/TLS domain changes (subdomain mapping, HTTPS cert validation)
- [ ] Monitoring and analytics configuration updated (APM, status dashboard)
- [ ] Backup/recovery implications considered and tested
- [ ] Performance impact assessed and noted (cache/CDN, smart routing, Workers)

### Documentation
- [ ] README.md updated (banner, badge, formatting schema, changelog block)
- [ ] Connector guide / onboarding playbook updated
- [ ] MIGRATION_KIT.md updated for any infrastructure moves/ecosystem changes
- [ ] Domain schema block included in docs (if Cloudflare/infra mapping affected)

### Governance Compliance
- [ ] Changes align with Project Locus governance policy and documentation standards
- [ ] CODEOWNERS and PR reviewer requirements met
- [ ] CI/CD pipeline (and markdownlint) checks passed
- [ ] Compliance report reviewed or referenced (for security/domain/infra moves)

### Related Issues
<!-- Link any related issues using #issue_number (e.g., closes #123, refs #456). -->

### Additional Notes
<!-- Any deployment, rollback, migration, monitoring, or marketing notes. Highlight any creative display/branding, Zero Trust integrations, or new domain features as needed. -->

***

**Instructions:**  
  - All PRs must be opened from a properly-named branch and reference the "ultimate formatting schema" as discussed in Locus governance.
  - Use this checklist to ensure every change is auditable, secure, creative, and compliant.
  - On domain/infra mapping, include new DNS records/config samples where appropriate; attach the Cloudflare dashboard screenshot where possible for compliance.
 - Always add yourself at the end: `Co-authored-by: [username] <email>` (if multiple authors).

***
