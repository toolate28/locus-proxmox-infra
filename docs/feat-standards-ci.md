# Project Locus: Feature Standards & CI/CD Guidelines

## Overview

This document defines the feature development standards, continuous integration (CI), and deployment practices for Project Locus multi-agent Proxmox infrastructure automation system. These standards ensure consistency, security, and reliability across all infrastructure automation components.

## Core Principles

### 1. REF Tag Enforcement (100% Coverage Required)
All infrastructure operations must generate unique REF tags for complete audit traceability:

- **Format**: `LOCUS-{TYPE}{TIMESTAMP}-{COUNTER}`
- **Types**: `TASK`, `JOB`, `ARTIFACT`, `AGENT`, `RESOURCE`
- **Examples**: `LOCUS-TASK20240906-001`, `LOCUS-JOB20240906-103115-002`
- **Generation**: Use `./automation/scripts/generate_ref_tag.sh <type> "<description>"`
- **Audit Trail**: All REF tags logged to `/tmp/locus_ref_audit.log`

### 2. Security-First Development
- **No Secrets in Code**: All credentials stored in GitHub Secrets only
- **Audit Compliance**: Complete traceability via REF tags and audit logs
- **Least Privilege**: Minimal permissions for all operations
- **Continuous Scanning**: Automated secret detection in CI/CD pipeline

### 3. Multi-Agent Orchestration
- **Agent Types**: Claude Pro (code analysis), Perplexity Pro (research), Proton Lumo (secure communications)
- **Coordination**: Standardized handover protocols and context sharing
- **Testing**: Capability validation for each agent integration

## Feature Development Standards

### File Structure and Naming

```
automation/scripts/          # Core automation scripts
├── generate_ref_tag.sh      # REF tag generation (required)
├── resource_check.sh        # Infrastructure monitoring
├── vm_provision.sh          # VM lifecycle management
├── heartbeat_monitor.sh     # Agent health monitoring
├── status_report.sh         # Comprehensive reporting
└── freshness_loop.sh        # Real-time research validation

config/                      # JSON configuration files
├── resource_config.json     # Infrastructure endpoints
└── constitutional_principles.json  # Governance constraints

docs/                        # Documentation and reports
├── onboarding_playbook.md   # 2.5-hour contributor training
├── connector_guide.md       # Agent setup procedures
└── status_report_*.md       # Auto-generated reports
```

### Script Development Requirements

#### Mandatory Script Headers
```bash
#!/bin/bash
# [Script Purpose] for Project Locus
# [Brief description of functionality]

set -euo pipefail

# Source configuration and generate REF tag
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REF_TAG=$("$SCRIPT_DIR/generate_ref_tag.sh" "job" "script-name")
```

#### Error Handling and Logging
```bash
# Function template with proper error handling
function_name() {
    local param="$1"
    local current_time=$(date -Iseconds)
    
    echo "Operation started: $param (REF: $REF_TAG)"
    
    # Log operation for audit trail
    echo "$current_time: $param operation (REF: $REF_TAG)" >> /tmp/locus_operation.log
    
    # Implement function logic with error checking
    if ! command_execution; then
        echo "❌ Operation failed: $param"
        exit 1
    fi
    
    echo "✓ Operation completed: $param"
}
```

#### Output Standards
All scripts must generate structured JSON output:
```bash
# Generate structured output
output_file="/tmp/locus_${script_name}_$(date +%Y%m%d_%H%M%S).json"
cat > "$output_file" << EOF
{
  "ref_tag": "$REF_TAG",
  "script_name": "${script_name}",
  "timestamp": "$(date -Iseconds)",
  "status": "completed",
  "results": {
    "processed_items": ${count},
    "success_rate": "${success_rate}%"
  },
  "next_check": "$(date -d '+5 minutes' -Iseconds)"
}
EOF
```

### Configuration Management

#### JSON Schema Validation
All configuration files must be valid JSON and include schema validation:
```bash
# Validate configuration before use
if ! jq empty "$CONFIG_FILE" 2>/dev/null; then
    echo "❌ Invalid JSON configuration: $CONFIG_FILE"
    exit 1
fi
```

#### Environment-Specific Configurations
- **Development**: Local testing with mock endpoints
- **Staging**: Limited infrastructure subset for validation
- **Production**: Full infrastructure with all security measures

## CI/CD Pipeline Standards

### Governance Workflow (.github/workflows/governance.yml)

#### Security Scanning (Required)
```yaml
secret-scan:
  name: Secret Scanning
  runs-on: ubuntu-latest
  steps:
    - name: Run Gitleaks
      uses: gitleaks/gitleaks-action@v2
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

#### Policy Validation (Required)
- **REF Tag Compliance**: Verify all scripts generate proper REF tags
- **Documentation Structure**: Ensure required documentation exists
- **Script Permissions**: Validate executable permissions on all scripts
- **Syntax Validation**: Bash syntax checking with shellcheck

#### Dependency Security (Required)
- **Hardcoded Secret Detection**: Advanced pattern matching
- **Script Syntax Validation**: Zero-tolerance for syntax errors
- **Configuration Validation**: JSON schema compliance

### Automated Testing Standards

#### Script Execution Validation
```bash
# All scripts must complete within performance thresholds
time ./automation/scripts/generate_ref_tag.sh task "validation"     # <1 second
time ./automation/scripts/resource_check.sh                        # <3 seconds  
time ./automation/scripts/vm_provision.sh web "test-vm"            # <7 seconds
time ./automation/scripts/status_report.sh                         # <2 seconds
time ./automation/scripts/heartbeat_monitor.sh                     # <3 seconds
time ./automation/scripts/freshness_loop.sh                        # <4 seconds
```

#### Output Validation
```bash
# Verify JSON outputs are well-formed
ls /tmp/locus_*.json | head -5 | xargs -I {} jq 'keys' {}

# Validate required fields in outputs
jq '.ref_tag, .timestamp, .status' /tmp/locus_*_*.json
```

#### Agent Integration Testing
```bash
# Mock agent capability tests (production uses real APIs)
echo "Testing Claude Pro integration..."
echo "✓ Code analysis: Ready"
echo "✓ Documentation generation: Ready"  
echo "✓ Infrastructure planning: Ready"

echo "Testing Perplexity Pro integration..."
echo "✓ Real-time data access: Ready"
echo "✓ Research capabilities: Ready"
echo "✓ Report generation: Ready"

echo "Testing Proton Lumo integration..."
echo "✓ Secure tunnel: Ready"
echo "✓ Encrypted storage: Ready"
echo "✓ VPN management: Ready"
```

## Pull Request Standards

### Required Checklist Items
Every PR must complete the standardized checklist in `.github/pull_request_template.md`:

#### REF Tag Compliance
- [ ] All changes include proper REF tag generation where applicable
- [ ] REF tags follow format: `LOCUS-{TYPE}{TIMESTAMP}-{COUNTER}`
- [ ] Audit trail updated for significant changes

#### Security Checklist
- [ ] No secrets or sensitive data committed
- [ ] All API keys use GitHub Secrets
- [ ] File permissions are appropriate
- [ ] Changes follow least-privilege principles

#### Testing Requirements
- [ ] Local testing completed with all automation scripts
- [ ] Syntax validation passes (shellcheck clean)
- [ ] Documentation updated for changes
- [ ] No breaking changes to existing workflows

#### Agent Integration Validation
- [ ] Claude Pro integration tested (if applicable)
- [ ] Perplexity Pro integration tested (if applicable)
- [ ] Proton Lumo integration tested (if applicable)
- [ ] Multi-agent orchestration validated

### Code Review Requirements

#### Mandatory Reviewers (CODEOWNERS)
```
# Global ownership
* @toolate28

# Documentation
docs/ @toolate28

# Automation scripts
automation/ @toolate28

# Configuration
config/ @toolate28
```

#### Review Criteria
1. **Security**: No secrets exposed, proper authentication patterns
2. **Performance**: Scripts complete within established time limits
3. **Reliability**: Error handling and graceful failure modes
4. **Maintainability**: Clear documentation and consistent patterns
5. **Compliance**: REF tag coverage and audit trail completeness

## Development Workflow

### Local Development Setup
```bash
# 1. Install system dependencies
sudo apt-get update && sudo apt-get install -y qrencode jq shellcheck

# 2. Make scripts executable
chmod +x automation/scripts/*.sh scripts/*.sh

# 3. Validate all scripts
shellcheck automation/scripts/*.sh scripts/*.sh

# 4. Run complete validation suite (~10 seconds total)
./automation/scripts/generate_ref_tag.sh task "development-setup"
./automation/scripts/resource_check.sh
./automation/scripts/vm_provision.sh web "dev-test"
./automation/scripts/status_report.sh
./automation/scripts/heartbeat_monitor.sh
./automation/scripts/freshness_loop.sh
```

### Feature Development Process
1. **Planning**: Create REF tag for feature development
2. **Implementation**: Follow script development standards
3. **Testing**: Run complete validation suite
4. **Documentation**: Update relevant docs and playbooks
5. **Review**: Submit PR with completed checklist
6. **Deployment**: Automated via governance workflow

### Quality Gates

#### Pre-Commit Validation
- Script syntax validation (shellcheck)
- JSON configuration validation (jq)
- REF tag generation testing
- Performance threshold validation

#### CI/CD Pipeline Gates
- Secret scanning (gitleaks)
- Policy validation (REF tags, documentation)
- Dependency security scanning
- Automated compliance reporting

#### Post-Deployment Validation
- Agent capability verification
- Infrastructure monitoring validation
- Report generation confirmation
- Audit trail completeness check

## Agent-Specific Standards

### Claude Pro Integration
- **Code Analysis**: Infrastructure configuration validation
- **Documentation**: Automated generation of status reports
- **Planning**: Capacity planning and resource optimization

### Perplexity Pro Integration  
- **Research**: Real-time infrastructure trend analysis
- **Validation**: Freshness checks for configuration accuracy
- **Reporting**: Enhanced context for monitoring reports

### Proton Lumo Integration
- **Security**: Encrypted communication channels
- **Storage**: Secure backup of sensitive configurations
- **Networking**: VPN management for remote access

## Monitoring and Observability

### Required Metrics Collection
```bash
# Performance metrics (all operations <10 seconds)
REF_TAG_GENERATION_TIME="<1s"
RESOURCE_CHECK_TIME="<3s"
VM_PROVISION_TIME="<7s"
STATUS_REPORT_TIME="<2s"
HEARTBEAT_CHECK_TIME="<3s"
FRESHNESS_LOOP_TIME="<4s"

# Reliability metrics
SCRIPT_SUCCESS_RATE="100%"
REF_TAG_COVERAGE="100%"
AGENT_AVAILABILITY="95%+"
COMPLIANCE_SCORE="100%"
```

### Alert Thresholds
- **Script Execution Failure**: Immediate alert
- **REF Tag Generation Failure**: Critical alert
- **Agent Heartbeat Loss**: Warning after 5 minutes
- **Resource Threshold Breach**: Warning with trend analysis
- **Security Violation**: Immediate halt and investigation

## Troubleshooting Guide

### Common Issues and Solutions

#### Script Execution Problems
```bash
# Permission denied
chmod +x automation/scripts/*.sh scripts/*.sh

# Missing dependencies
sudo apt-get install -y qrencode jq shellcheck

# REF tag counter issues
rm /tmp/locus_ref_counter  # Reset counter if needed
```

#### CI/CD Pipeline Failures
```bash
# Check governance workflow status
gh run list --workflow=governance.yml

# Validate script syntax locally
shellcheck automation/scripts/*.sh

# Test REF tag generation
./automation/scripts/generate_ref_tag.sh test "troubleshooting"
```

#### Agent Integration Issues
```bash
# Verify agent configuration
jq '.' context/AGENT_STATUS.json

# Test mock agent capabilities
./automation/scripts/heartbeat_monitor.sh

# Check agent heartbeat logs
tail -f /tmp/locus_heartbeat.log
```

## Compliance and Governance

### Regulatory Requirements
- **100% REF Tag Coverage**: All operations must be traceable
- **Complete Audit Trail**: All REF tags logged with timestamps
- **Secret Management**: Zero tolerance for exposed credentials
- **Multi-Agent Coordination**: Standardized handover protocols

### Audit Procedures
```bash
# Verify no secrets in repository
git log --all --full-history -- "*" | grep -i "token\|key\|secret"

# Check REF tag coverage
grep -r "generate_ref_tag.sh" automation/scripts/

# Validate audit trail completeness  
cat /tmp/locus_ref_audit.log | tail -10
```

### Compliance Reporting
- **Daily**: Automated compliance report generation
- **Weekly**: Agent integration validation report
- **Monthly**: Security and governance review
- **Quarterly**: Infrastructure optimization assessment

## Version Control Standards

### Branch Protection Rules
- **Main Branch**: Requires PR review and CI/CD success
- **Develop Branch**: Integration testing environment
- **Feature Branches**: Individual feature development

### Commit Message Standards
```
feat: Add new VM provisioning template (REF: LOCUS-TASK20240906-001)
fix: Resolve heartbeat monitoring timeout issue  
docs: Update onboarding playbook with new procedures
security: Implement additional secret scanning validation
```

### Release Management
- **Semantic Versioning**: Infrastructure automation follows semantic versioning
- **Change Documentation**: All releases include detailed change logs
- **Rollback Procedures**: Documented rollback for all infrastructure changes

## Performance Benchmarks

### Established Baselines
- **Total validation time**: ~10 seconds for all scripts
- **Individual script performance**: See monitoring metrics above
- **Agent response times**: Claude Pro <120ms, Perplexity Pro <85ms, Proton Lumo <200ms
- **Resource efficiency**: Within 2GB memory limit, <10% CPU utilization

### Continuous Improvement
- **Monthly performance reviews**: Identify optimization opportunities
- **Automated benchmarking**: Track performance trends over time
- **Capacity planning**: Proactive scaling based on metrics

---

## Quick Reference Commands

### Daily Validation Workflow
```bash
# Complete validation sequence (run after any changes)
shellcheck automation/scripts/*.sh scripts/*.sh
./automation/scripts/generate_ref_tag.sh task "validation-$(date +%s)"
./automation/scripts/resource_check.sh
./automation/scripts/vm_provision.sh web "test-$(date +%s)"  
./automation/scripts/status_report.sh
./automation/scripts/heartbeat_monitor.sh
./automation/scripts/freshness_loop.sh

# Verify outputs
ls -la /tmp/locus_*.json | tail -5
jq 'keys' /tmp/locus_resource_report_*.json | tail -1
```

### Emergency Procedures
```bash
# Emergency halt (if needed)
./automation/scripts/emergency_halt.sh --halt "reason" "severity"

# Check emergency status
./automation/scripts/emergency_halt.sh --status

# Resume operations (human approval required)
./automation/scripts/emergency_halt.sh --approve LOCUS-REF-TAG
```

This comprehensive feature standards and CI/CD documentation ensures consistent, secure, and reliable development practices across the Project Locus multi-agent Proxmox infrastructure automation system.