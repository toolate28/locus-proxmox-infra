<div align="center">

```
🧠 CLAUDE PRO INTEGRATION GUIDE
┌─────────────────────────────────────────────────────────────┐
│             MCP Onboarding & Advanced Workflows             │
│                                                             │
│  Comprehensive guide for Claude Pro agents within the      │
│  Project Locus multi-agent infrastructure ecosystem.       │
└─────────────────────────────────────────────────────────────┘
```

[![Claude Pro](https://img.shields.io/badge/Claude_Pro-MCP_Ready-success?style=for-the-badge&logo=anthropic&logoColor=white)](https://www.anthropic.com/claude)
[![MCP Protocol](https://img.shields.io/badge/MCP-Context_Protocol-blue?style=for-the-badge&logo=protocol&logoColor=white)](#-mcp-model-context-protocol-integration)
[![Agent Status](https://img.shields.io/badge/Agent_Status-LOCUS--CLAUDE--001-purple?style=for-the-badge&logo=robot&logoColor=white)](#-agent-registration)

</div>

---

## 🎯 **Claude Agent Overview**

### 🧠 **Primary Capabilities**

<div align="center">

| 🎯 **Capability** | 📊 **Proficiency** | 🔧 **Use Cases** |
|:---:|:---:|:---:|
| **Code Analysis** | ⭐⭐⭐⭐⭐ | Security reviews, optimization, refactoring |
| **Infrastructure Planning** | ⭐⭐⭐⭐⭐ | Architecture design, scaling strategies |
| **Documentation** | ⭐⭐⭐⭐⭐ | Technical writing, API docs, guides |
| **Automation Scripting** | ⭐⭐⭐⭐⭐ | Shell scripts, workflow automation |
| **Security Review** | ⭐⭐⭐⭐⭐ | Vulnerability assessment, compliance |

</div>

### 🎭 **Agent Identity**

```yaml
agent_profile:
  ref_tag: "LOCUS-CLAUDE-001"
  status: "active"  # Updated: First active Claude Code session
  api_endpoint: "https://api.anthropic.com/v1"
  auth_method: "claude_code_integration"  # Updated: Direct integration method
  heartbeat_interval: 60
  session_type: "claude_code_cli"  # New: Indicates Claude Code CLI integration
  capabilities:
    - code_analysis
    - documentation_generation
    - infrastructure_planning
    - automation_scripting
    - security_review
    - real_time_interaction  # New: Direct CLI capability
    - context_preservation   # New: Session context maintained
```

---

## 🚀 Quick Start for Claude Agents

### Prerequisites
- Claude Pro API access (`CLAUDE_API_KEY` in GitHub Secrets)
- Basic understanding of Project Locus architecture
- Access to repository automation scripts

### Initial Setup

#### For Claude Code Integration (Current Method)
```bash
# 1. Generate agent REF tag for this session
REF_TAG=$(./automation/scripts/generate_ref_tag.sh agent "claude-code-session")
echo "Your Claude Agent REF: $REF_TAG"

# 2. Capture initial context
./automation/scripts/capture_context.sh claude $REF_TAG

# 3. Verify system status
./automation/scripts/status_report.sh

# 4. Test agent coordination framework
./automation/scripts/invoke_agent.sh claude HIGH "system-validation" "first-session"
```

#### For API-Based Integration (Future Enhancement)
```bash
# 1. Verify Claude API access (when implemented)
curl -X POST https://api.anthropic.com/v1/messages \
  -H "Authorization: Bearer $CLAUDE_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "claude-3-5-sonnet-20241022",
    "max_tokens": 100,
    "messages": [{"role": "user", "content": "Test connection"}]
  }'

# 2. Update agent status (requires API integration implementation)
# Edit context/AGENT_STATUS.json with active heartbeat
```

---

## 🏷️ REF Tag Schema & Standards

### REF Tag Format
Project Locus uses a standardized REF tagging system for all operations:

```
Format: LOCUS-<TYPE><TIMESTAMP>-<COUNTER>
Examples:
  - LOCUS-TASK20250906-114155-001 (Task execution)
  - LOCUS-AGENT-001 (Agent registration)  
  - LOCUS-JOB20250906-103443-012 (Automation job)
  - LOCUS-ART20250906-070703-005 (Artifact creation)
  - LOCUS-CONTEXT20250906-001 (Context capture)
```

### REF Tag Types
| Type | Usage | Example |
|------|-------|---------|
| `TASK` | Individual task execution | `LOCUS-TASK20250906-114155-001` |
| `AGENT` | Agent registration/session | `LOCUS-AGENT-001` |
| `JOB` | Automation job execution | `LOCUS-JOB20250906-103443-012` |
| `ARTIFACT` | Document/file creation | `LOCUS-ART20250906-070703-005` |
| `RESOURCE` | Infrastructure resource | `LOCUS-RES-001` |
| `CONTEXT` | Context capture | `LOCUS-CONTEXT20250906-001` |
| Custom | Any other operation | `LOCUS-CUSTOM20250906-001` |

### REF Tag Generation
```bash
# Generate REF tag for different operations
./automation/scripts/generate_ref_tag.sh task "description"
./automation/scripts/generate_ref_tag.sh agent "session-identifier"  
./automation/scripts/generate_ref_tag.sh job "automation-job"
./automation/scripts/generate_ref_tag.sh artifact "document-creation"

# Audit trail is automatically maintained at:
# /tmp/locus_ref_audit.log
```

---

## 🧠 MCP (Model Context Protocol) Integration

### Context Management
Claude agents in Project Locus follow standardized context protocols:

#### Context Structure
```json
{
  "ref_tag": "LOCUS-CONTEXT20250906-001",
  "agent_type": "claude_code",
  "session_type": "cli_integration",
  "context": {
    "infrastructure_state": "proxmox_cluster_healthy",
    "active_tasks": ["first_claude_code_session", "claude_md_update"],
    "dependencies": ["system_monitoring", "ref_tag_generation"],
    "constraints": ["sub_10s_performance", "ref_tag_compliance"]
  },
  "capabilities": {
    "code_analysis": true,
    "documentation": true,
    "architecture_planning": true,
    "multi_language": true,
    "real_time_interaction": true,
    "context_preservation": true,
    "file_operations": true,
    "automation_integration": true
  },
  "system_state": {
    "proxmox_nodes": "3/3_online",
    "backup_status": "current",
    "agent_registrations": "all_registered",
    "heartbeat_status": "monitoring_ready"
  }
}
```

#### Context Sharing Protocol
```bash
# Capture current context for handover
./automation/scripts/capture_context.sh claude $REF_TAG

# Coordinate with other agents
./automation/scripts/coordinate_agents.sh claude perplexity "task description"

# Use invoke_agent.sh for specific agent tasks
./automation/scripts/invoke_agent.sh perplexity "research task" $REF_TAG
```

---

## 🎯 Claude Agent Capabilities & Use Cases

### Primary Strengths
- **Code Analysis:** Deep code review, architecture analysis, refactoring suggestions
- **Documentation:** Technical writing, API documentation, user guides
- **Infrastructure Planning:** System design, deployment strategies, scaling plans
- **Problem Solving:** Complex reasoning, debugging, optimization strategies

### Optimal Task Types
1. **Code Review & Analysis**
   ```bash
   CLAUDE HIGH REVIEW automation/scripts/vm_provision.sh SECURITY-COMPLIANCE
   ```

2. **Documentation Generation**
   ```bash
   CLAUDE MEDIUM GENERATE docs/api-reference.md COMPREHENSIVE-DOCS
   ```

3. **Architecture Planning**
   ```bash
   CLAUDE HIGH DESIGN infrastructure-expansion SCALABILITY-PLAN
   ```

4. **Debugging & Troubleshooting**
   ```bash
   CLAUDE CRITICAL DEBUG monitoring-failure ROOT-CAUSE-ANALYSIS
   ```

---

## 🔄 Multi-Agent Coordination

### Claude as Lead Agent
When Claude leads multi-agent tasks:

```bash
# Coordinate with Perplexity for research
CLAUDE_TASK="infrastructure-upgrade"
PERPLEXITY_RESEARCH="current-proxmox-versions"
LUMO_SECURITY="upgrade-security-review"

# Sequence: Claude → Perplexity → Lumo → Claude (integration)
```

### Claude as Support Agent
When supporting other agents:

```bash
# Supporting Perplexity with code analysis
PERPLEXITY_LEAD="monitoring-optimization"
CLAUDE_SUPPORT="script-analysis"

# Supporting Lumo with implementation
LUMO_LEAD="security-hardening"
CLAUDE_SUPPORT="automation-scripts"
```

---

## 🔧 Operational Procedures

### Daily Tasks
```bash
# Generate infrastructure status report
./automation/status_report.sh

# Check resource availability
./automation/scripts/resource_check.sh

# Monitor agent heartbeats
./automation/scripts/heartbeat_monitor.sh
```

### Weekly Tasks
```bash
# Generate REF tag for weekly review
REF_TAG=$(./automation/scripts/generate_ref_tag.sh task "weekly-claude-review")

# Run freshness validation
./automation/scripts/freshness_loop.sh

# Check for infrastructure updates needed
./automation/scripts/resource_check.sh
```

### Monthly Tasks
```bash
# Generate comprehensive status report
REF_TAG=$(./automation/scripts/generate_ref_tag.sh task "monthly-comprehensive-review")
./automation/status_report.sh

# Run full freshness validation
./automation/scripts/freshness_loop.sh

# Check emergency halt status
./automation/scripts/emergency_halt.sh --status
```

---

## 📋 Decision Log & Best Practices

### Claude Agent Decision Framework
1. **Task Assessment:** Evaluate complexity and required capabilities
2. **Resource Planning:** Determine computational and time requirements
3. **Collaboration Needs:** Identify other agents needed for optimal outcome
4. **Quality Gates:** Define success criteria and validation methods

### Best Practices for Claude Agents
- ✅ Always validate code before suggesting changes
- ✅ Provide clear, actionable documentation
- ✅ Consider security implications in all recommendations
- ✅ Maintain consistency with existing codebase patterns
- ✅ Document reasoning behind complex decisions
- ✅ Test suggestions in safe environments first

### Common Pitfalls to Avoid
- ❌ Making assumptions about current system state
- ❌ Suggesting changes without considering dependencies
- ❌ Overcomplicating simple solutions
- ❌ Ignoring performance implications
- ❌ Bypassing security review processes

---

## 🔗 QR-Code Generation for Agent Context

Agents can share access to Locus artifacts by generating a QR code that embeds a shortened URL. This is useful for quickly passing context or prompts to users or other agents.

### Steps:
1. Upload your artifact and copy the shortened URL.
2. Run `./scripts/generate_qr.sh <shortened-url>` to create a QR code image.
3. Share the QR code for agent context transfer.

### Advanced Context Sharing
```bash
# Generate context with capture_context.sh
./automation/scripts/capture_context.sh $REF_TAG

# Use QR code generation for sharing
./scripts/generate_qr.sh "https://locus.internal/context/$REF_TAG"

# Notify receiving agent via coordination system
./automation/scripts/coordinate_agents.sh claude perplexity "context-transfer"
```

See [docs/qr-share.md](docs/qr-share.md) for more details.

---

## 🔍 Troubleshooting

### Common Issues
1. **API Rate Limits**
   - Implement exponential backoff
   - Use batch processing for multiple requests
   - Monitor usage through status reports: `./automation/status_report.sh`

2. **Context Size Limits**
   - Summarize large contexts before handover
   - Use context compression techniques
   - Prioritize most relevant information

3. **Integration Failures**
   - Check API key validity
   - Verify network connectivity
   - Review error logs and use emergency halt if needed

### Emergency Procedures
```bash
# Use emergency halt for critical situations
./automation/scripts/emergency_halt.sh --halt "critical-issue" high

# Capture current context for recovery
./automation/scripts/capture_context.sh $REF_TAG

# Coordinate emergency response with other agents
./automation/scripts/coordinate_agents.sh claude "all" "emergency-response"
```

---

## 📊 Performance Monitoring

### Key Metrics
- **Response Time:** Average time for task completion
- **Accuracy:** Percentage of successful task outcomes
- **Context Utilization:** Efficiency of context usage
- **Collaboration Score:** Success rate in multi-agent tasks

### Monitoring Commands
```bash
# Real-time resource monitoring
./automation/scripts/resource_check.sh

# Generate status report for performance analysis
./automation/status_report.sh

# Check agent heartbeats for system health
./automation/scripts/heartbeat_monitor.sh
```

---

## 🎓 Advanced Features

### Custom Prompt Templates
Located in `context/claude_prompts/`:
- `code_review.prompt` - Standard code review template
- `documentation.prompt` - Documentation generation template
- `architecture.prompt` - System architecture analysis template

### Integration Hooks
```bash
# Use existing automation scripts for integration
./automation/scripts/invoke_agent.sh claude "pre-task-check" $REF_TAG

# Post-task validation via status reports
./automation/status_report.sh

# Continuous monitoring with heartbeat
./automation/scripts/heartbeat_monitor.sh
```

### Advanced Context Management
```bash
# Use capture_context.sh for advanced context handling
./automation/scripts/capture_context.sh $REF_TAG

# Coordinate context sharing between agents
./automation/scripts/coordinate_agents.sh claude perplexity "context-analysis"

# Sync reference state for consistency
./automation/sync_ref_state.sh --sync
```

---

**Document REF:** LOCUS-DOC-CLAUDE-ONBOARDING  
**Version:** 3.0  
**Last Updated:** 2025-09-06T15:30:00Z  
**Next Review:** 2025-10-06T15:30:00Z

**Integration Status:**
- ✅ MCP Protocol Implemented
- ✅ Multi-Agent Coordination Ready  
- ✅ Performance Monitoring Active
- ✅ Decision Framework Established
- ✅ Claude Code CLI Integration Active (NEW)
- ✅ REF Tag Schema Documented (NEW)
- ✅ First Active Claude Session Recorded (NEW)
- 🔄 API Integration Enhancement (Planned)
## Claude Code "Memories" (Guard Rails & Global Rules)
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