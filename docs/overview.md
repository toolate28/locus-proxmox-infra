# Project Locus: Architecture Deep Dive

**Multi-Agent Proxmox Infrastructure Orchestration Platform**

---

## 🏗️ System Architecture Overview

Project Locus is a production-ready multi-agent orchestration framework implementing **Model Context Protocol (MCP)** standards with enterprise-grade audit trails and **zero-trust security architecture**. The system coordinates three AI agents to manage Proxmox infrastructure with sub-10-second execution requirements.

### Core Agent Topology

```
┌─────────────────────────────────────────────────────────────────┐
│                    LOCUS ORCHESTRATION LAYER                    │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐      │
│  │  Claude Pro  │    │Perplexity Pro│    │ Proton Lumo  │      │
│  │(Orchestrator)│◄──►│ (Research)   │◄──►│ (Security)   │      │
│  └──────┬───────┘    └──────┬───────┘    └──────┬───────┘      │
│         │                   │                   │              │
│         ▼                   ▼                   ▼              │
│  ┌─────────────────────────────────────────────────────────────┤
│  │             REF-TAG GENERATION SYSTEM                       │
│  │     LOCUS-[ACTION][YYYYMMDD]-[SEQUENCE]                    │
│  └─────────────────┬───────────────────────────────────────────┤
│                    │                                           │
│                    ▼                                           │
│  ┌─────────────────────────────────────────────────────────────┤
│  │            PROXMOX INFRASTRUCTURE LAYER                     │
│  │  ┌─────────┐  ┌─────────┐  ┌─────────┐                    │
│  │  │   PVE   │  │   PBS   │  │   PMS   │                    │
│  │  │ Cluster │  │ Backup  │  │ Media   │                    │
│  │  └─────────┘  └─────────┘  └─────────┘                    │
│  └─────────────────────────────────────────────────────────────┤
└─────────────────────────────────────────────────────────────────┘
```

---

## 🤖 Multi-Agent Coordination Framework

### Agent Capabilities Matrix

| Agent | Role | Capabilities | API Integration | Status |
|-------|------|-------------|-----------------|---------|
| **Claude Pro** | Orchestrator | Code analysis, documentation, infrastructure planning, automation scripting, security review | Direct CLI integration | ✅ Active |
| **Perplexity Pro** | Researcher | Real-time research, infrastructure monitoring, report generation, trend analysis | `api.perplexity.ai:443` | 🟡 Registered |
| **Proton Lumo** | Security | Secure communications, encrypted storage, VPN management, privacy enforcement | `lumo.proton.me:443` | 🟡 Registered |

### Agent Handover Protocol

```json
{
  "ref_tag": "LOCUS-HANDOVER-20250908-001",
  "source_agent": "claude_pro",
  "target_agent": "perplexity_pro", 
  "handover_context": {
    "task_type": "infrastructure_analysis",
    "data_classification": "internal",
    "expected_response_time": "< 10s",
    "validation_requirements": ["json_schema", "ref_tag_compliance"]
  },
  "cryptographic_signature": "sha256:...",
  "constitutional_compliance": true
}
```

---

## 🏷️ REF-Tag Traceability System

### REF-Tag Schema

The REF-Tag system provides **100% traceability** for all operations with immutable audit trails:

**Format:** `LOCUS-{ACTION}{YYYYMMDD}-{SEQUENCE}`

**Supported Actions:**
- `TASK` - Individual operational tasks
- `JOB` - Batch operations and workflows
- `ARTIFACT` - Generated files and reports
- `AGENT` - Multi-agent interactions
- `RESOURCE` - Infrastructure resource operations
- `NOTIFY` - System notifications
- `RESEARCH` - Research and analysis tasks
- `DEPLOY` - Deployment operations
- `VALIDATE` - Validation and compliance checks

### Audit Trail Implementation

```bash
# REF tag generation with audit logging
./automation/scripts/generate_ref_tag.sh task "vm-provision-web-server"
# Output: LOCUS-TASK20250908-001

# Audit trail location
/tmp/locus_ref_audit.log
```

**Sample Audit Entry:**
```
2025-09-08T13:06:53+00:00 | LOCUS-TASK20250908-130653-001 | task | bootstrap-test | SUCCESS
```

---

## 🚀 Infrastructure Automation Layer

### Core Automation Scripts

Located in `/automation/scripts/` with strict **<10 second execution** requirements:

| Script | Purpose | Execution Time | REF Tag Required |
|--------|---------|----------------|------------------|
| `generate_ref_tag.sh` | REF tag generation and audit | <1s | N/A (generates) |
| `resource_check.sh` | Infrastructure health monitoring | <3s | ✅ |
| `vm_provision.sh` | VM lifecycle management | <7s | ✅ |
| `status_report.sh` | Comprehensive reporting | <2s | ✅ |
| `heartbeat_monitor.sh` | Agent health monitoring | <3s | ✅ |
| `freshness_loop.sh` | Real-time research validation | <4s | ✅ |

### Infrastructure Resource Topology

```
Proxmox Infrastructure
├── PVE Cluster
│   ├── pve-node1 (Primary)
│   ├── pve-node2 (Secondary)
│   └── pve-node3 (Tertiary)
│
├── PBS Backup Infrastructure
│   ├── pbs-backup1 (Primary backup server)
│   └── pbs-backup2 (Redundant backup server)
│
├── PMS Media/Mail Services
│   ├── pms-media1 (Media processing)
│   └── pms-transcoder1 (Transcoding services)
│
└── Cloud Integration
    ├── Cloud storage endpoints
    ├── CDN distribution
    └── DNS resolution services
```

---

## 🛡️ Constitutional Framework & Governance

### Constitutional Principles

The system operates under strict constitutional constraints defined in `/config/constitutional_principles.json`:

#### Core Principles
- **Resource Constraint Enforcement**: Automatic halt for operations exceeding limits
- **Cross-Machine Principle Propagation**: System-wide response to violations  
- **Expert Authority Preservation**: Human approval for high-impact decisions
- **Transparency Maintenance**: Complete reasoning logging for all decisions
- **Ethical Behavior Under Pressure**: Maintains ethical standards under load
- **Democratic Decision Making**: Multi-agent consensus with 67% threshold

#### Enforcement Mechanisms
- **Automatic Throttling**: Resource usage management
- **Emergency Halt**: Critical failure response
- **Human Escalation**: Manual intervention triggers
- **Cross-Machine Coordination**: Distributed enforcement

---

## 🔒 Security & Compliance Architecture

### Zero-Trust Security Model

```
Security Layers:
┌─────────────────────────────────────────┐
│         Application Security            │
│  ┌─────────────────────────────────────┐│
│  │        Agent Authentication         ││
│  │  ┌─────────────────────────────────┐││
│  │  │     Data Encryption (AES-256)   │││
│  │  │  ┌─────────────────────────────┐│││
│  │  │  │   Network Isolation (VPN)   ││││
│  │  │  │                             ││││
│  │  │  └─────────────────────────────┘│││
│  │  └─────────────────────────────────┘││
│  └─────────────────────────────────────┘│
└─────────────────────────────────────────┘
```

### Compliance Standards
- **ISO 27001**: Information security management
- **SOC 2**: Service organization controls
- **NIST CSF**: Cybersecurity framework alignment
- **GDPR**: Privacy and data protection compliance

### Secret Management
- **GitHub Secrets**: All credentials stored securely
- **Zero Credential Exposure**: No hardcoded secrets in code
- **Key Rotation**: Automated credential rotation
- **Least Privilege**: Minimal access rights principle

---

## 📊 Monitoring & Observability

### Real-Time System Monitoring

```
┌─────────────────────────────────────────────────────────────────┐
│                    LOCUS MISSION CONTROL                        │
├─────────────────────────────────────────────────────────────────┤
│ Agent Status:  Claude ✅ | Perplexity ✅ | Lumo ✅              │
│ Infrastructure: PVE 98% | PBS 99% | PMG 100%                   │
│ Security:      100% REF-Tag compliance | Audit trail ✅ CLEAN  │
│ Performance:   Sub-10s execution maintained                     │
└─────────────────────────────────────────────────────────────────┘
```

### Monitoring Components

1. **Infrastructure Health**: Continuous monitoring of PVE/PBS/PMS
2. **Agent Heartbeats**: 60-second interval health checks
3. **REF Tag Compliance**: 100% coverage validation
4. **Performance Metrics**: Sub-10s execution requirement tracking
5. **Security Monitoring**: Real-time threat assessment

### Report Generation

Auto-generated reports in `/docs/` and `/tmp/`:
- **Status Reports**: `status_report_YYYYMMDD_HHMMSS.md`
- **Resource Reports**: `/tmp/locus_resource_report_*.json`
- **Heartbeat Reports**: `/tmp/locus_heartbeat_report_*.json`
- **Audit Logs**: `/tmp/locus_ref_audit.log`

---

## 🔄 Development & Integration Workflow

### Repository Structure

```
locus-proxmox-infra/
├── automation/          # Core scripts (<10s runtime)
│   ├── scripts/        # Automation executables
│   └── sync_ref_state.sh
├── config/             # JSON configuration files
│   ├── constitutional_principles.json
│   ├── resource_config.json
│   └── machine_topology.json
├── context/            # Agent state management
│   └── AGENT_STATUS.json
├── docs/              # Technical documentation & SOPs
│   ├── onboarding_playbook.md
│   ├── connector_guide.md
│   └── status_report_*.md (auto-generated)
├── handover/          # REF-Tag audit trail storage
├── scripts/           # Utility scripts (QR generation, etc.)
└── validation/        # Schema validation & compliance testing
```

### Development Standards

- **Constitutional Compliance**: All operations validated against principles
- **Mandatory REF-tag Emission**: 100% coverage requirement
- **JSON Schema Validation**: Handoff boundary validation
- **GitHub Secrets**: Zero credential exposure
- **Pre-commit Hooks**: shellcheck, gitleaks, YAML validation

### Performance SLA

- **Critical Operations**: Sub-10s execution requirement
- **Agent Response Time**: < 5s for standard operations
- **Infrastructure Polling**: 300s intervals
- **Heartbeat Monitoring**: 60s intervals

---

## 🎯 Use Cases & Applications

### Primary Use Cases

1. **Infrastructure Automation**: Automated VM provisioning and management
2. **Multi-Agent Research**: Real-time infrastructure intelligence gathering
3. **Security Orchestration**: Automated security policy enforcement
4. **Compliance Monitoring**: Continuous constitutional principle validation
5. **Emergency Response**: Automated incident detection and response

### Integration Examples

```bash
# Complete infrastructure validation workflow
./automation/scripts/generate_ref_tag.sh task "infra-validation"
./automation/scripts/resource_check.sh
./automation/scripts/heartbeat_monitor.sh
./automation/scripts/status_report.sh

# Multi-agent coordination example
python3 ./automation/scripts/agent_handover.py create claude_pro perplexity_pro "infrastructure-analysis"
```

---

## 🚨 Emergency Procedures

### Emergency Halt System

Constitutional framework includes automatic emergency procedures:

1. **Resource Threshold Breach**: Automatic operation halt at 95% resource usage
2. **Security Violation**: Immediate isolation and human escalation
3. **Agent Communication Failure**: Fallback to safe operational mode
4. **Cross-Machine Coordination Loss**: Distributed system graceful degradation

### Incident Response

```bash
# Emergency halt trigger
./automation/scripts/emergency_halt.sh --reason="resource_exhaustion"

# Manual override (requires human authorization)
./automation/scripts/emergency_halt.sh --override --auth-token="HUMAN_APPROVAL"
```

---

## 📈 Future Roadmap

### Planned Enhancements

1. **Geographic Distribution**: Multi-region deployment support
2. **Service Mesh Integration**: Istio/Consul integration for service discovery
3. **Advanced AI Capabilities**: Enhanced agent reasoning and decision-making
4. **Expanded Compliance**: Additional regulatory framework support

### Research Areas

- **Agent Cooperation Models**: Enhanced multi-agent coordination algorithms
- **Infrastructure Prediction**: Predictive analytics for resource planning
- **Security AI**: AI-powered threat detection and response
- **Constitutional AI**: Enhanced ethical decision-making frameworks

---

## 📚 Additional Resources

### Documentation
- [Onboarding Playbook](./onboarding_playbook.md) - 2.5-hour contributor training
- [Connector Guide](./connector_guide.md) - Agent setup procedures
- [Feature Standards](./feat-standards-ci.md) - Development guidelines

### Agent-Specific Guides
- [Claude Pro Integration](../CLAUDE.md) - MCP integration specifications
- [Perplexity Pro Setup](../PERPLEXITY.md) - Research agent configuration
- [Proton Lumo Security](../LUMO.md) - Security agent protocols

### Quick Reference
```bash
# System validation (complete test suite)
time ./automation/scripts/generate_ref_tag.sh task "system-test"
time ./automation/scripts/resource_check.sh
time ./automation/scripts/heartbeat_monitor.sh
time ./automation/scripts/status_report.sh

# Expected total execution time: < 10 seconds
```

---

**Document REF**: LOCUS-DOC-OVERVIEW-20250908  
**Version**: 1.0.0  
**Last Updated**: 2025-09-08T13:07:00Z  
**Maintained by**: Project Locus Infrastructure Team

**Emergency Contact**: For urgent infrastructure issues, use the emergency halt system or contact the infrastructure team through established channels.