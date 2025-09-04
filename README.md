# Project Locus: Multi-Agent Proxmox Infrastructure

This repository establishes the institutional scaffolding for Project Locus with **multi-agent orchestration** and **resource-aware automation** for Proxmox infrastructure management.

## 🤖 Copilot Space Activated

**Status:** ✅ FULLY ACTIVE  
**Space URL:** [GitHub Copilot Space](https://github.com/toolate28/locus-proxmox-infra/copilot-space)  
**Agents:** Claude Pro, Perplexity Pro, Proton Lumo  

## 🏗️ Architecture Overview

### Multi-Agent Orchestration
- **Claude Pro (LOCUS-CLAUDE-001):** Code analysis, infrastructure planning, automation scripting
- **Perplexity Pro (LOCUS-PERPLEXITY-001):** Real-time research, monitoring reports, trend analysis
- **Proton Lumo (LOCUS-LUMO-001):** Secure communications, encrypted storage, VPN management

### Infrastructure Targets
- **Proxmox VE (PVE):** Virtualization cluster management
- **Proxmox Backup Server (PBS):** Backup verification and monitoring  
- **Proxmox Mail Gateway (PMS):** Container and mail security
- **Cloud Resources:** CDN, storage, and DNS monitoring

## 🚀 Quick Start

### Prerequisites
- GitHub repository access with Secrets management
- Agent API credentials (Claude Pro, Perplexity Pro, Proton Lumo)
- Basic shell scripting knowledge

### Essential Commands
```bash
# Generate REF tags for traceability
./automation/generate_ref_tag.sh task "your-task-name"

# Monitor infrastructure resources  
./automation/resource_check.sh

# Generate status reports
./automation/status_report.sh

# Check agent heartbeats
./automation/heartbeat_monitor.sh

# Run freshness validation
./automation/freshness_loop.sh

# Provision new VMs with automation
./automation/vm_provision.sh web myapp-frontend
```

## 📁 Repository Structure

```
├── context/
│   └── AGENT_STATUS.json          # Agent registration and capabilities
├── handover/
│   └── REF-TASK20240904-01.md     # Sample handover marker
├── automation/
│   ├── generate_ref_tag.sh        # REF tag generator for traceability
│   ├── resource_check.sh          # Infrastructure monitoring
│   ├── status_report.sh           # Comprehensive status reporting
│   ├── vm_provision.sh            # Automated VM deployment
│   ├── heartbeat_monitor.sh       # Agent heartbeat tracking
│   └── freshness_loop.sh          # Perplexity-powered real-time reports
├── config/
│   └── resource_config.json       # Resource monitoring configuration
└── docs/
├── docs/
│   ├── connector_guide.md          # Step-by-step agent setup
│   ├── onboarding_playbook.md      # New contributor guide
│   ├── copilot_space_activation.md # Space activation details
│   ├── user-ai-directive-guide.md  # Multi-agent coordination protocols
│   └── perplexity-integration.md   # Research & knowledge management
└── CLAUDE.md                       # Claude Pro MCP onboarding guide
```

## 🔐 Security & Compliance

### GitHub Secrets (Required)
```bash
CLAUDE_API_KEY          # Claude Pro API access
PERPLEXITY_API_KEY      # Perplexity Pro research engine
PROTON_LUMO_TOKEN       # Proton Lumo secure communications
LUMO_INSTANCE_ID        # Lumo instance identifier
```

### REF Tag Enforcement
- **Format:** `LOCUS-{TYPE}{TIMESTAMP}-{COUNTER}`
- **Coverage:** 100% of jobs, tasks, and artifacts
- **Audit Trail:** Full traceability for compliance

### Governance & CI
- **Automated Policy Validation:** GitHub Actions workflow checks
- **Secret Scanning:** Continuous monitoring for exposed credentials
- **Code Owners:** `CODEOWNERS` file enforces review requirements
- **PR Templates:** Standardized contribution process
- **Multi-Agent Coordination:** Governed by USER-AI directive protocols

## 📊 Resource Awareness

### Monitoring Intervals
- **Resource Polling:** Every 5 minutes
- **Agent Heartbeat:** Every 60 seconds  
- **Status Reports:** Hourly
- **Freshness Validation:** Every 4 hours

### Automated Handover Flow
1. Outgoing agent sets `handover_available=true`
2. System generates handover marker with REF tag
3. Incoming agent receives webhook notification
4. Context transfer with full resource state
5. Audit trail updated with completion

## 📚 Getting Started

### For New Contributors
1. **Read:** [Onboarding Playbook](docs/onboarding_playbook.md) (2.5 hours)
2. **Setup:** Follow [Connector Guide](docs/connector_guide.md)
3. **Learn:** Study [USER-AI Directive Guide](docs/user-ai-directive-guide.md) for multi-agent workflows
4. **Claude Users:** Review [Claude MCP Onboarding](CLAUDE.md) for advanced integration
5. **Test:** Run automation scripts to verify integration
6. **Contribute:** Join your assigned agent team

### For Infrastructure Teams  
1. **Configure:** Update `config/resource_config.json` with your endpoints
2. **Deploy:** Set up monitoring intervals and alerting
3. **Automate:** Add scripts to your CI/CD pipeline
4. **Coordinate:** Implement multi-agent workflows per USER-AI directive guide
5. **Monitor:** Use generated reports for capacity planning

## 🔄 Agent Capabilities

| Agent | Primary Focus | Key Features |
|-------|---------------|--------------|
| **Claude Pro** | Development & Planning | Code analysis, documentation, security reviews |
| **Perplexity Pro** | Research & Monitoring | Real-time data, trend analysis, freshness reports |
| **Proton Lumo** | Security & Privacy | Encrypted communications, secure tunneling |

## 📈 Next Phase

### Immediate (Week 1)
- Production API credentials setup
- Real infrastructure integration
- Team onboarding completion

### Expansion (Month 1)
- Advanced automation workflows
- Custom dashboard deployment
- Performance optimization

### Innovation (Quarter 1)
- AI-driven capacity planning
- Predictive maintenance
- Cross-platform integration

## 🆘 Support

- **Documentation:** Complete guides in `docs/` directory
- **Infrastructure:** infra@locus.internal
- **Security:** security@locus.internal  
- **On-Call:** oncall@locus.internal

---
**REF:** LOCUS-REPO-README-001  
**Multi-Agent Orchestration:** ✅ Active  
**Resource Awareness:** ✅ Enabled  
**Copilot Space:** ✅ Activated
