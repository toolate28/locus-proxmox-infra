# Project Locus: Multi-Agent Proxmox Infrastructure

**ALWAYS follow these instructions first. Only search for additional information or run bash commands if these instructions are incomplete or found to be in error.**

Project Locus is a **bash-based infrastructure automation system** for multi-agent orchestration of Proxmox environments. This is NOT a traditional software application with builds/tests, but an infrastructure automation toolkit using shell scripts.

## Working Effectively

### Bootstrap and Validate the Repository
Run these commands to set up and validate the environment:

```bash
# Install system dependencies
sudo apt-get update && sudo apt-get install -y qrencode jq shellcheck

# Make scripts executable 
chmod +x automation/scripts/*.sh scripts/*.sh

# Validate all scripts with linting - EXPECTED: warnings only, no errors
shellcheck automation/scripts/*.sh scripts/*.sh
# Note: Shellcheck warnings are acceptable - they're style suggestions, not errors

# Test all automation scripts - TOTAL TIME: ~10 seconds
time ./automation/scripts/generate_ref_tag.sh task "bootstrap-test"
time ./automation/scripts/resource_check.sh
time ./automation/scripts/vm_provision.sh web test-vm
time ./automation/scripts/status_report.sh  
time ./automation/scripts/heartbeat_monitor.sh
time ./automation/scripts/freshness_loop.sh

# Test QR generation - TIME: <1 second
time ./scripts/generate_qr.sh "https://example.com/test"

# Validate JSON outputs are well-formed
ls /tmp/locus_*.json | head -3 | xargs -I {} jq 'keys' {}
```

**CRITICAL TIMING**: All operations complete in under 10 seconds. No long-running builds exist. NEVER set timeouts longer than 30 seconds for any operation in this repository.

### Daily Validation Workflow
Always run this complete validation sequence after making changes:

```bash
# 1. Lint all scripts (1-2 seconds)
shellcheck automation/scripts/*.sh scripts/*.sh

# 2. Run all automation scripts (6-10 seconds total)
./automation/scripts/generate_ref_tag.sh task "validation-$(date +%s)"
./automation/scripts/resource_check.sh
./automation/scripts/vm_provision.sh web "test-$(date +%s)"  
./automation/scripts/status_report.sh
./automation/scripts/heartbeat_monitor.sh
./automation/scripts/freshness_loop.sh

# 3. Verify outputs exist and are valid JSON
ls -la /tmp/locus_*.json | tail -5
ls -la docs/status_report_*.md | tail -2
jq 'keys' /tmp/locus_resource_report_*.json | tail -1
```

## Repository Structure and Navigation

### Core Automation Scripts (`/automation/scripts/`)
- `generate_ref_tag.sh` - Creates unique REF tags for traceability (1 sec)
- `resource_check.sh` - Monitors PVE/PBS/PMS infrastructure (3 secs)  
- `vm_provision.sh` - Automates VM creation workflows (7 secs)
- `status_report.sh` - Generates infrastructure status reports (2 secs)
- `heartbeat_monitor.sh` - Checks multi-agent heartbeats (3 secs)
- `freshness_loop.sh` - Perplexity-powered real-time research (4 secs)

### Configuration (`/config/`)
- `resource_config.json` - Infrastructure monitoring endpoints and settings
- All configuration is JSON-based, validate with `jq`

### Documentation (`/docs/`)
- `connector_guide.md` - Agent setup and API configuration
- `onboarding_playbook.md` - New contributor training (2.5 hours)
- `copilot_space_activation.md` - GitHub Copilot space setup
- Auto-generated status reports appear here

### Agent Context (`/context/`)
- `AGENT_STATUS.json` - Multi-agent registration and capabilities

### Utilities (`/scripts/`)  
- `generate_qr.sh` - QR code generation for agent context sharing

## Manual Validation Scenarios

**ALWAYS perform these validation scenarios after making any changes:**

### Scenario 1: REF Tag Workflow Validation
```bash
# Generate different tag types and verify uniqueness
REF1=$(./automation/scripts/generate_ref_tag.sh task "test-workflow")
REF2=$(./automation/scripts/generate_ref_tag.sh job "test-job") 
REF3=$(./automation/scripts/generate_ref_tag.sh artifact "test-artifact")

# Verify tags are unique and properly formatted
echo "Generated REFs: $REF1, $REF2, $REF3"
[[ "$REF1" != "$REF2" ]] && [[ "$REF2" != "$REF3" ]] && echo "✓ REF tags are unique"

# Check audit logging works
cat /tmp/locus_ref_audit.log | tail -3
```

### Scenario 2: Infrastructure Monitoring Validation  
```bash
# Run resource check and validate outputs
./automation/scripts/resource_check.sh

# Verify JSON report is generated and valid
REPORT=$(ls /tmp/locus_resource_report_*.json | tail -1)
jq '.status' "$REPORT"
jq '.resources | keys' "$REPORT"
echo "✓ Resource monitoring functional"
```

### Scenario 3: Agent Operations Validation
```bash
# Test heartbeat monitoring
./automation/scripts/heartbeat_monitor.sh

# Verify all agents show healthy status
HEARTBEAT=$(ls /tmp/locus_heartbeat_report_*.json | tail -1)
jq '.summary.healthy_agents, .summary.failed_agents' "$HEARTBEAT"
echo "✓ Agent heartbeat monitoring operational"
```

### Scenario 4: VM Provisioning Validation
```bash
# Test VM provisioning for different types
./automation/scripts/vm_provision.sh web "validation-web"
./automation/scripts/vm_provision.sh database "validation-db"

# Verify configuration generation
PROVISION=$(ls /tmp/locus_vm_provision_*.json | tail -1)
jq '.vm_config.name, .vm_config.type, .status' "$PROVISION"
echo "✓ VM provisioning workflow functional"
```

### Scenario 5: Status Reporting Validation
```bash
# Generate comprehensive status report
./automation/scripts/status_report.sh

# Verify both markdown and JSON outputs
ls -la docs/status_report_*.md | tail -1
ls -la /tmp/locus_status_*.json | tail -1
echo "✓ Status reporting functional"
```

### Scenario 6: QR Code Generation Validation
```bash
# Test QR code generation 
./scripts/generate_qr.sh "https://github.com/toolate28/locus-proxmox-infra"

# Verify QR image was created
[[ -f qr.png ]] && echo "✓ QR generation functional" || echo "✗ QR generation failed"
```

## Dependencies and System Requirements

### Required System Dependencies
```bash
# Install all dependencies (run once)
sudo apt-get update
sudo apt-get install -y bash jq qrencode shellcheck curl
```

### Dependency Verification
```bash
# Verify all tools are available
command -v bash && echo "✓ bash available"
command -v jq && echo "✓ jq available" 
command -v qrencode && echo "✓ qrencode available"
command -v shellcheck && echo "✓ shellcheck available"
```

## Understanding REF Tags (Critical System)

REF tags are the foundation of Project Locus traceability:

- **Format**: `LOCUS-{TYPE}{TIMESTAMP}-{COUNTER}`
- **Examples**: `LOCUS-TASK20240904-001`, `LOCUS-JOB20240904-002`
- **Types**: task, job, artifact, agent, resource
- **Storage**: Counter in `/tmp/locus_ref_counter`, audit in `/tmp/locus_ref_audit.log`

Always generate REF tags for any infrastructure operation:
```bash
# For tasks: ./automation/scripts/generate_ref_tag.sh task "description"
# For jobs: ./automation/scripts/generate_ref_tag.sh job "description"  
# For artifacts: ./automation/scripts/generate_ref_tag.sh artifact "description"
```

## Common Tasks and Expected Outputs

### View Repository Root
```
ls -la /home/runner/work/locus-proxmox-infra/locus-proxmox-infra
total 32
drwxr-xr-x 8 runner docker 4096 Sep  4 21:12 .
drwxr-xr-x 3 runner docker 4096 Sep  4 21:06 ..
drwxr-xr-x 8 runner docker 4096 Sep  4 21:12 .git
-rw-r--r-- 1 runner docker 1674 Sep  4 21:06 .gitignore
-rw-r--r-- 1 runner docker  325 Sep  4 21:06 CLAUDE.md
-rw-r--r-- 1 runner docker 1071 Sep  4 21:06 LICENSE
-rw-r--r-- 1 runner docker 4650 Sep  4 21:06 README.md
drwxr-xr-x 2 runner docker 4096 Sep  4 21:12 automation
drwxr-xr-x 2 runner docker 4096 Sep  4 21:06 config
drwxr-xr-x 2 runner docker 4096 Sep  4 21:06 context
drwxr-xr-x 2 runner docker 4096 Sep  4 21:12 docs
drwxr-xr-x 2 runner docker 4096 Sep  4 21:06 handover
drwxr-xr-x 2 runner docker 4096 Sep  4 21:06 scripts
```

### Check Agent Status Configuration
```bash
jq '.' context/AGENT_STATUS.json
# Shows multi-agent configuration with Claude Pro, Perplexity Pro, and Proton Lumo
```

### Review Infrastructure Configuration  
```bash
jq '.' config/resource_config.json
# Shows PVE, PBS, PMS endpoints and monitoring settings
```

## Troubleshooting

### Script Execution Issues
- **Permission denied**: Run `chmod +x automation/*.sh scripts/*.sh`
- **Command not found**: Install missing dependencies with apt-get
- **JSON parsing errors**: Validate JSON with `jq` before processing

### REF Tag Counter Issues  
- **Counter reset**: Remove `/tmp/locus_ref_counter` to reset to 001
- **Audit trail**: Check `/tmp/locus_ref_audit.log` for generation history

### Output File Issues
- **Missing reports**: Check `/tmp/locus_*.json` and `docs/*.md` directories
- **Permission errors**: Ensure `/tmp` is writable
- **Invalid JSON**: Validate with `jq` and check script output

## Build and Test Information

**CRITICAL**: This repository does NOT have traditional builds or tests:

- **No Build Process**: Scripts run directly, no compilation needed
- **No Test Suite**: Validation is done by running scripts and checking outputs  
- **No Package Managers**: No npm, pip, maven, or similar
- **No CI/CD Builds**: Infrastructure automation, not software development
- **No Long-Running Operations**: All scripts complete in seconds

### Validation Strategy
Instead of traditional testing, use the manual validation scenarios above. The "test" is that all scripts execute successfully and produce expected outputs.

## Agent Integration Points

### GitHub Secrets Required (Production)
```
CLAUDE_API_KEY - Claude Pro API access
PERPLEXITY_API_KEY - Perplexity Pro research
PROTON_LUMO_TOKEN - Proton Lumo secure communications  
LUMO_INSTANCE_ID - Lumo instance identifier
```

### Multi-Agent Capabilities
- **Claude Pro**: Code analysis, documentation, infrastructure planning
- **Perplexity Pro**: Real-time research, monitoring reports, trend analysis  
- **Proton Lumo**: Secure communications, encrypted storage, VPN management

## Security and Compliance

- **REF Tag Enforcement**: 100% coverage required for audit compliance
- **Secret Management**: All credentials in GitHub Secrets only
- **Audit Logging**: Complete traceability via REF tags and audit logs
- **No Secrets in Code**: Verify with `git log --all --full-history -- "*" | grep -i "token\|key\|secret"`

---

**Remember**: This is infrastructure automation, not software development. Focus on script execution, output validation, and REF tag workflows rather than traditional build/test cycles.