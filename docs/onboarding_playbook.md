# Project Locus: Onboarding Playbook

## Welcome to Project Locus Multi-Agent Orchestration

This playbook guides new contributors through the setup and configuration of the Locus multi-agent infrastructure system.

## Phase 1: Environment Setup (15 minutes)

### Prerequisites Check
- [ ] GitHub repository access granted
- [ ] Basic familiarity with shell scripts and JSON
- [ ] Understanding of Proxmox VE concepts
- [ ] API credentials obtained for assigned agents

### Repository Familiarization
```bash
# Clone and explore the repository
git clone https://github.com/toolate28/locus-proxmox-infra.git
cd locus-proxmox-infra

# Review the structure
tree . || find . -type f | head -20

# Understand core components
cat context/AGENT_STATUS.json
cat handover/REF-TASK20240904-01.md
```

### Initial Testing
```bash
# Test REF tag generation
./automation/scripts/generate_ref_tag.sh task "onboarding-test"

# Run a basic resource check
./automation/scripts/resource_check.sh

# Generate your first status report
./automation/status_report.sh
```

## Phase 2: Agent Configuration (20 minutes)

### Choose Your Agent Role
Select one primary agent for your initial onboarding:

#### Option A: Claude Pro Agent
- **Capabilities:** Code analysis, documentation, infrastructure planning
- **Best for:** Developers, architects, technical writers
- **Setup:** Requires Claude Pro API access

#### Option B: Perplexity Pro Agent  
- **Capabilities:** Research, real-time data, monitoring reports
- **Best for:** Operations teams, analysts, researchers
- **Setup:** Requires Perplexity Pro subscription

#### Option C: Proton Lumo Agent
- **Capabilities:** Secure communications, encrypted storage, VPN
- **Best for:** Security teams, compliance officers
- **Setup:** Requires Proton Unlimited with Lumo

### Agent Registration Process
1. **Obtain API Credentials**
   ```bash
   # Claude Pro: Get API key from console.anthropic.com
   # Perplexity Pro: Get API key from perplexity.ai settings
   # Proton Lumo: Generate token from Lumo dashboard
   ```

2. **Configure GitHub Secrets**
   - Navigate to repository Settings > Secrets
   - Add your agent's API credentials
   - Test access with provided scripts

3. **Update Agent Status**
   ```bash
   # Generate your agent REF tag
   REF_TAG=$(./automation/scripts/generate_ref_tag.sh agent "your-agent-name")
   echo "Your agent REF: $REF_TAG"
   
   # Update context/AGENT_STATUS.json with your agent details
   ```

## Phase 3: Hands-On Training (30 minutes)

### Exercise 1: REF Tag Management
```bash
# Generate different types of REF tags
./automation/scripts/generate_ref_tag.sh task "learn-ref-tagging"
./automation/scripts/generate_ref_tag.sh job "practice-monitoring"
./automation/scripts/generate_ref_tag.sh artifact "training-report"

# Review audit trail
cat /tmp/locus_ref_audit.log
```

### Exercise 2: Resource Monitoring
```bash
# Run comprehensive resource check
./automation/scripts/resource_check.sh

# Examine the generated report
ls -la /tmp/locus_resource_report_*.json

# Understand the monitoring targets
cat config/resource_config.json
```

### Exercise 3: VM Provisioning Simulation
```bash
# Test different VM types
./automation/scripts/vm_provision.sh web "training-web-01"
./automation/scripts/vm_provision.sh database "training-db-01"

# Review provisioning reports
ls -la /tmp/locus_vm_provision_*.json
```

### Exercise 4: Status Reporting
```bash
# Generate status reports in different formats
./automation/status_report.sh

# Review markdown report
ls -la docs/status_report_*.md
head -20 docs/status_report_*.md

# Review JSON status
cat /tmp/locus_status_*.json | jq '.'
```

## Phase 4: Handover Flow Practice (25 minutes)

### Understanding Handover Mechanics
```bash
# Study the sample handover marker
cat handover/REF-TASK20240904-01.md

# Create your own handover marker
cp handover/REF-TASK20240904-01.md handover/REF-TASK$(date +%Y%m%d)-TRAINING.md
```

### Practice Handover Scenario
1. **Scenario:** Infrastructure monitoring shift change
2. **Your Role:** Outgoing agent completing monitoring duties
3. **Task:** Hand over to incoming agent with full context

#### Step-by-Step Handover
```bash
# 1. Generate handover REF tag
HANDOVER_REF=$(./automation/scripts/generate_ref_tag.sh task "training-handover")

# 2. Update your handover marker with current status
cat > handover/REF-TASK$(date +%Y%m%d)-TRAINING.md << EOF
# $HANDOVER_REF: Training Handover Exercise

**Status:** IN_PROGRESS
**Created:** $(date -Iseconds)
**Outgoing Agent:** [YOUR_AGENT_REF]
**Incoming Agent:** TBD

## Current Infrastructure Status
- Resource check completed: $(date -Iseconds)
- All systems operational
- No pending alerts

## Required Actions
- [ ] Continue monitoring cycle
- [ ] Generate next status report
- [ ] Validate backup completions

## Handover Checklist
- [ ] Status documented
- [ ] Resources tagged with REF
- [ ] Monitoring data current
- [ ] Ready for transfer

**Contact:** [your-email]@locus.internal
EOF

# 3. Set handover_available flag (simulated)
echo "Handover marker created and ready for incoming agent"
```

## Phase 5: Security & Compliance (15 minutes)

### Security Best Practices Review
```bash
# Verify no secrets in repository
git log --oneline | head -10
git log --all --full-history -- "*" | grep -i "token\|key\|secret" || echo "✓ No secrets found"

# Check file permissions
find . -name "*.sh" -exec ls -la {} \; | grep -v "r-x"

# Review secret handling documentation
grep -n "github_secret" context/AGENT_STATUS.json
```

### Compliance Verification
- [ ] All actions tagged with REF identifiers
- [ ] Audit trail enabled and logging
- [ ] Secrets stored in GitHub Secrets only
- [ ] Least-privilege access configured
- [ ] Rotation schedule documented

## Phase 6: Integration Testing (20 minutes)

### Agent Capability Testing
Based on your chosen agent, complete the appropriate test:

#### Claude Pro Test
```bash
# Test code analysis capability (mock)
echo "Testing Claude Pro integration..."
echo "✓ Code analysis: Ready"
echo "✓ Documentation generation: Ready"  
echo "✓ Infrastructure planning: Ready"
```

#### Perplexity Pro Test
```bash
# Test research capability (mock)
echo "Testing Perplexity Pro integration..."
echo "✓ Real-time data access: Ready"
echo "✓ Research capabilities: Ready"
echo "✓ Report generation: Ready"
```

#### Proton Lumo Test
```bash
# Test secure communications (mock)
echo "Testing Proton Lumo integration..."
echo "✓ Secure tunnel: Ready"
echo "✓ Encrypted storage: Ready"
echo "✓ VPN management: Ready"
```

### End-to-End Workflow Test
```bash
# Complete workflow simulation
REF_TAG=$(./automation/scripts/generate_ref_tag.sh job "onboarding-final-test")

echo "Starting end-to-end test with REF: $REF_TAG"

# 1. Resource check
./automation/scripts/resource_check.sh

# 2. Status report
./automation/status_report.sh

# 3. Agent heartbeat (simulated)
echo "Agent heartbeat: $(date -Iseconds)" >> /tmp/locus_heartbeat.log

# 4. Handover preparation
echo "Handover available: true" >> /tmp/locus_handover_status.log

echo "✓ End-to-end test completed successfully"
```

## Phase 7: Certification & Next Steps (10 minutes)

### Onboarding Checklist Verification
- [ ] Repository cloned and explored
- [ ] Agent credentials configured
- [ ] REF tag generation working
- [ ] Resource monitoring functional
- [ ] Status reporting operational
- [ ] Handover flow understood
- [ ] Security practices reviewed
- [ ] Integration tests passed

### Knowledge Check
1. What is the format of a Locus REF tag?
2. How often do agents send heartbeats by default?
3. Where are API credentials stored?
4. What triggers a handover flow?
5. How do you generate a status report?

### Certification
```bash
# Generate your onboarding completion certificate
CERT_REF=$(./automation/scripts/generate_ref_tag.sh artifact "onboarding-certificate")

cat > /tmp/locus_onboarding_certificate.md << EOF
# Project Locus Onboarding Certification

**Agent:** [YOUR_NAME]
**Agent REF:** [YOUR_AGENT_REF] 
**Certification REF:** $CERT_REF
**Completed:** $(date -Iseconds)

## Capabilities Verified
- [x] REF tag management
- [x] Resource monitoring
- [x] Status reporting  
- [x] Handover procedures
- [x] Security compliance
- [x] Agent integration

**Status:** CERTIFIED
**Valid Until:** $(date -d '+1 year' -Iseconds)

Certified for Project Locus multi-agent orchestration operations.
EOF

echo "🎉 Congratulations! Onboarding complete."
echo "Certificate generated: /tmp/locus_onboarding_certificate.md"
```

### Next Steps
1. **Production Access:** Request production environment credentials
2. **Team Assignment:** Join your designated agent team
3. **Advanced Training:** Schedule specialized capability workshops
4. **Mentorship:** Pair with experienced agent operator

### Resources & Support
- **Documentation:** `docs/` directory
- **Scripts:** `automation/scripts/` directory  
- **Configuration:** `config/` directory
- **Status:** `context/AGENT_STATUS.json`

### Contact Information
- **Onboarding Support:** onboarding@locus.internal
- **Technical Help:** tech-support@locus.internal
- **Agent Teams:** agents@locus.internal

---
**Playbook REF:** LOCUS-DOC-ONBOARDING-PLAYBOOK  
**Version:** 1.0  
**Estimated Completion Time:** 2.5 hours  
**Last Updated:** 2024-09-04T16:23:00Z