# Claude Code "Memories" (Guard Rails & Global Rules)
_Expanded for Project Locus: locus-proxmox-infra_

## 1. Security & Compliance

- **No Secrets in Code or Output**: Never display, suggest, or log credentials, API tokens, SSH keys, or vault files. All secrets must be managed with GitHub Secrets and never hardcoded or printed.
- **REF Tag Enforcement**: Every operation, commit, and script must generate a unique REF tag for full auditability (`LOCUS-{TYPE}{TIMESTAMP}-{COUNTER}`), logged to `/tmp/locus_ref_audit.log`.
- **Audit Trail Completeness**: All infrastructure actions must be traceable, with daily/weekly/monthly compliance reports generated and validated.
- **Continuous Secret Scanning**: CI/CD must scan for secrets (e.g., with gitleaks) and block PRs with findings.

## 2. Infrastructure Safety

- **No Destructive Actions Without Explicit Confirmation**: Never suggest commands that can destroy or irreversibly change infrastructure (e.g., deleting VMs, wiping disks, `rm -rf`). Always prompt for and require explicit confirmation for any risky operation.
- **Respect Governance Constraints**: All actions must comply with `config/constitutional_principles.json` and project governance standards.
- **Idempotency and Rollbacks**: Prefer idempotent operations. Ensure all infrastructure changes can be rolled back, and rollback procedures are documented.

## 3. File Structure & Workflow

- **Standard Directory Usage**: Place scripts in `automation/scripts/`, configs in `config/`, documentation in `docs/`, and follow all naming conventions.
- **Documentation is Mandatory**: Every script, config, and workflow must have a corresponding markdown guide or doc. Auto-generate/update reports and status markdowns when possible.
- **Commit Message Standards**: Use semantic, REF-tagged commit messages (e.g., `feat: Add new VM provisioning template (REF: LOCUS-TASK20240906-001)`).

## 4. CI/CD, Testing, and Quality Gates

- **Pre-Commit Validation**: All code contributions must pass shellcheck, jq validation, REF tag generation testing, and performance checks (<10s execution).
- **CI/CD Gates**: PRs require code review, CI/CD pipeline success, policy validation, dependency security scanning, and compliance checks.
- **Post-Deployment Validation**: Confirm agent capability, monitoring, reporting, and audit trail completeness after deployment.

## 5. Agent & AI Integration

- **Claude/AI Usage**: Use Claude for infrastructure configuration validation, documentation automation, and planning. Never suggest or automate outside these boundaries without clear user instruction.
- **Community Template Discovery**: When suggesting templates or workflows, prefer those that maximize accessibility, sustainability, and measurable impact (see community fork criteria).

## 6. Multi-Environment Awareness

- **Environment Disambiguation**: Always distinguish between production, staging, and test workflows. Never run or suggest production-affecting commands in test/dev, and vice versa.
- **Least Privilege Principle**: All automation and agent actions should use the minimum required permissions.

## 7. Collaboration & Contribution

- **Onboarding Path**: Direct new contributors to `docs/onboarding_playbook.md` and ensure they complete the scripted environment, monitoring, and provisioning exercises before contributing.
- **Feature Branching & PRs**: All changes must be developed on feature branches, referencing unique REF tags, and submitted via PR for review.
- **Recognition & Advancement**: Recognize contributors’ progress and route them through badge→maintainer progression via merged PRs.

## 8. Performance & Observability

- **Performance Standards**: Scripts must execute in under 10 seconds and avoid long-running operations in core automation.
- **Monitoring and Reporting**: Ensure agent health, infrastructure status, and provisioning are continuously monitored and reported.

## 9. Error Handling & Troubleshooting

- **Safe Defaults**: Use `set -euo pipefail` in scripts and perform robust input validation.
- **Proactive Troubleshooting**: Reference the troubleshooting guides and maintain up-to-date documentation for known issues and resolution steps.

## 10. General LLM Guardrails

- **Ask for Clarification**: If a user’s request is ambiguous, potentially risky, or out of scope, ask for clarification before proceeding.
- **Never Disclose Internal Details Externally**: Do not output, share, or suggest internal infra details, hostnames, or architecture outside trusted channels.
- **Bias Toward Best Practices**: Always prefer secure, maintainable, and documented solutions over shortcuts or hacks.

---

_These guard rails ensure Claude Code and all agents operate safely, securely, and in alignment with Project Locus's automation and governance objectives._