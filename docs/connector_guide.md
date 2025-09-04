# Project Locus: Multi-Agent Connector Guide

## Overview
This guide provides step-by-step instructions for connecting and configuring agents in the Project Locus multi-agent orchestration system.

## Prerequisites
- GitHub repository access with Secrets management permissions
- Agent API credentials (Claude Pro, Perplexity Pro, Proton Lumo)
- Basic understanding of REST APIs and webhook configurations

## Step 1: GitHub Secrets Configuration

### Required Secrets
Configure the following secrets in your GitHub repository settings:

```bash
# Claude Pro Configuration
CLAUDE_API_KEY=sk-ant-api03-...

# Perplexity Pro Configuration  
PERPLEXITY_API_KEY=pplx-...

# Proton Lumo Configuration
PROTON_LUMO_TOKEN=lumo-token-...
LUMO_INSTANCE_ID=instance-uuid-...

# Infrastructure API Tokens (Optional)
PVE_API_TOKEN=PVEAPIToken=...
PBS_API_TOKEN=PBSAPIToken=...
AWS_ACCESS_KEY=AKIA...
```

### Setting Up Secrets
1. Navigate to your repository on GitHub
2. Go to Settings > Secrets and variables > Actions
3. Click "New repository secret"
4. Add each secret with the exact name shown above

## Step 2: Agent Registration

### Verify Agent Status
Check that agents are properly registered:

```bash
# View current agent status
cat context/AGENT_STATUS.json

# Generate REF tag for verification
./automation/generate_ref_tag.sh agent "status-check"
```

### Update Agent Configuration
Modify `context/AGENT_STATUS.json` if needed:

```json
{
  "agents": {
    "claude_pro": {
      "ref_tag": "LOCUS-CLAUDE-001",
      "status": "active",
      "last_heartbeat": "2024-09-04T16:23:00Z"
    }
  }
}
```

## Step 3: Automation Scripts Setup

### Test Resource Monitoring
```bash
# Run resource check
./automation/resource_check.sh

# Generate status report
./automation/status_report.sh

# Test VM provisioning (dry run)
./automation/vm_provision.sh web test-vm
```

### Schedule Automation
Add to your CI/CD pipeline or cron:

```yaml
# Example GitHub Actions workflow
name: Locus Monitoring
on:
  schedule:
    - cron: '*/5 * * * *'  # Every 5 minutes
jobs:
  resource-check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run resource check
        run: ./automation/resource_check.sh
        env:
          PVE_API_TOKEN: ${{ secrets.PVE_API_TOKEN }}
          PBS_API_TOKEN: ${{ secrets.PBS_API_TOKEN }}
```

## Step 4: Handover Flow Configuration

### Enable Handover Notifications
Configure webhook endpoint for agent handovers:

```bash
# Update agent status for handover
curl -X POST https://hooks.locus.internal/handover \
  -H "Content-Type: application/json" \
  -d '{
    "outgoing_agent": "LOCUS-CLAUDE-001",
    "incoming_agent": "LOCUS-PERPLEXITY-001",
    "ref_tag": "LOCUS-TASK20240904-01",
    "handover_available": true
  }'
```

### Create Handover Markers
```bash
# Copy template
cp handover/REF-TASK20240904-01.md handover/REF-TASK$(date +%Y%m%d)-02.md

# Update with current task details
# Edit the new file with specific task information
```

## Step 5: Security Verification

### Validate Secret Handling
```bash
# Verify no secrets in repository
git log --all --full-history -- "*" | grep -i "token\|key\|secret\|password" || echo "No secrets found"

# Check file permissions
find . -name "*.sh" -exec ls -la {} \;
```

### Test REF Tag Generation
```bash
# Generate various REF tag types
./automation/generate_ref_tag.sh task "test-task"
./automation/generate_ref_tag.sh job "monitoring"
./automation/generate_ref_tag.sh artifact "report"

# Verify audit logging
cat /tmp/locus_ref_audit.log
```

## Step 6: Agent Capability Testing

### Claude Pro Integration
```bash
# Test code analysis capability
curl -X POST https://api.anthropic.com/v1/messages \
  -H "Authorization: Bearer $CLAUDE_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "claude-3-sonnet-20240229",
    "max_tokens": 1000,
    "messages": [{"role": "user", "content": "Test connection"}]
  }'
```

### Perplexity Pro Integration  
```bash
# Test research capability
curl -X POST https://api.perplexity.ai/chat/completions \
  -H "Authorization: Bearer $PERPLEXITY_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "pplx-7b-online",
    "messages": [{"role": "user", "content": "Current Proxmox VE status"}]
  }'
```

### Proton Lumo Integration
```bash
# Test secure tunnel capability
curl -X GET https://lumo.proton.me/api/status \
  -H "Authorization: Bearer $PROTON_LUMO_TOKEN" \
  -H "X-Instance-ID: $LUMO_INSTANCE_ID"
```

## Step 7: Monitoring Dashboard Setup

### Resource Dashboard Configuration
1. Copy `config/resource_config.json` and customize endpoints
2. Configure monitoring intervals based on your infrastructure
3. Set up alerting thresholds

### Status Reporting
```bash
# Generate initial status report
./automation/status_report.sh

# Check generated reports
ls -la docs/status_report_*.md
ls -la /tmp/locus_status_*.json
```

## Step 8: Freshness Loop Implementation

### Perplexity-Powered Reports
Schedule regular freshness validation:

```bash
# Create freshness check script
cat > automation/freshness_check.sh << 'EOF'
#!/bin/bash
REF_TAG=$(./automation/generate_ref_tag.sh job "freshness-check")
echo "Running freshness check with REF: $REF_TAG"

# Use Perplexity to validate current infrastructure trends
# Implementation would call Perplexity API for real-time data
echo "Freshness validation complete"
EOF

chmod +x automation/freshness_check.sh
```

## Troubleshooting

### Common Issues

1. **Agent Not Responding**
   - Check GitHub Secrets configuration
   - Verify API endpoints are accessible
   - Review agent heartbeat logs

2. **REF Tag Generation Fails**
   - Ensure `/tmp` directory is writable
   - Check script permissions
   - Verify counter file access

3. **Resource Monitoring Errors**
   - Validate API tokens
   - Check network connectivity
   - Review endpoint configurations

### Support Contacts
- **Infrastructure Team:** infra@locus.internal
- **Security Team:** security@locus.internal  
- **On-Call Support:** oncall@locus.internal

## Next Steps
1. Complete agent testing for all three platforms
2. Configure production monitoring intervals
3. Set up alerting and notification systems
4. Plan capacity scaling for multi-agent workloads

---
**Document REF:** LOCUS-DOC-CONNECTOR-GUIDE  
**Version:** 1.0  
**Last Updated:** 2024-09-04T16:23:00Z