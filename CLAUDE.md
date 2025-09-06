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
  status: "registered"
  api_endpoint: "https://api.anthropic.com/v1"
  auth_method: "github_secret:CLAUDE_API_KEY"
  heartbeat_interval: 60
  capabilities:
    - code_analysis
    - documentation_generation
    - infrastructure_planning
    - automation_scripting
    - security_review
```

---

## 🚀 Quick Start for Claude Agents

### Prerequisites
- Claude Pro API access (`CLAUDE_API_KEY` in GitHub Secrets)
- Basic understanding of Project Locus architecture
- Access to repository automation scripts

### Initial Setup
```bash
# 1. Verify Claude API access
curl -X POST https://api.anthropic.com/v1/messages \
  -H "Authorization: Bearer $CLAUDE_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "claude-3-5-sonnet-20241022",
    "max_tokens": 100,
    "messages": [{"role": "user", "content": "Test connection"}]
  }'

# 2. Generate your agent REF tag
REF_TAG=$(./automation/generate_ref_tag.sh agent "claude-pro-setup")
echo "Your Claude Agent REF: $REF_TAG"

# 3. Update agent status
# Edit context/AGENT_STATUS.json with your Claude agent details
```

---

## 🧠 MCP (Model Context Protocol) Integration

### Context Management
Claude agents in Project Locus follow standardized context protocols:

#### Context Structure
```json
{
  "ref_tag": "LOCUS-CLAUDE-20240904-001",
  "agent_type": "claude_pro",
  "context": {
    "infrastructure_state": "current system status",
    "active_tasks": ["task1", "task2"],
    "dependencies": ["perplexity_data", "lumo_security"],
    "constraints": ["resource_limits", "security_policies"]
  },
  "capabilities": {
    "code_analysis": true,
    "documentation": true,
    "architecture_planning": true,
    "multi_language": true
  }
}
```

#### Context Sharing Protocol
```bash
# Capture current context for handover
./automation/capture_context.sh claude $REF_TAG

# Coordinate with other agents
./automation/coordinate_agents.sh claude perplexity "task description"

# Use invoke_agent.sh for specific agent tasks
./automation/invoke_agent.sh perplexity "research task" $REF_TAG
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
   CLAUDE HIGH REVIEW automation/vm_provision.sh SECURITY-COMPLIANCE
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
./automation/resource_check.sh

# Monitor agent heartbeats
./automation/heartbeat_monitor.sh
```

### Weekly Tasks
```bash
# Generate REF tag for weekly review
REF_TAG=$(./automation/generate_ref_tag.sh task "weekly-claude-review")

# Run freshness validation
./automation/freshness_loop.sh

# Check for infrastructure updates needed
./automation/resource_check.sh
```

### Monthly Tasks
```bash
# Generate comprehensive status report
REF_TAG=$(./automation/generate_ref_tag.sh task "monthly-comprehensive-review")
./automation/status_report.sh

# Run full freshness validation
./automation/freshness_loop.sh

# Check emergency halt status
./automation/emergency_halt.sh --status
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
./automation/capture_context.sh $REF_TAG

# Use QR code generation for sharing
./scripts/generate_qr.sh "https://locus.internal/context/$REF_TAG"

# Notify receiving agent via coordination system
./automation/coordinate_agents.sh claude perplexity "context-transfer"
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
./automation/emergency_halt.sh --halt "critical-issue" high

# Capture current context for recovery
./automation/capture_context.sh $REF_TAG

# Coordinate emergency response with other agents
./automation/coordinate_agents.sh claude "all" "emergency-response"
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
./automation/resource_check.sh

# Generate status report for performance analysis
./automation/status_report.sh

# Check agent heartbeats for system health
./automation/heartbeat_monitor.sh
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
./automation/invoke_agent.sh claude "pre-task-check" $REF_TAG

# Post-task validation via status reports
./automation/status_report.sh

# Continuous monitoring with heartbeat
./automation/heartbeat_monitor.sh
```

### Advanced Context Management
```bash
# Use capture_context.sh for advanced context handling
./automation/capture_context.sh $REF_TAG

# Coordinate context sharing between agents
./automation/coordinate_agents.sh claude perplexity "context-analysis"

# Sync reference state for consistency
./automation/sync_ref_state.sh --sync
```

---

**Document REF:** LOCUS-DOC-CLAUDE-ONBOARDING  
**Version:** 2.0  
**Last Updated:** 2024-09-04T22:20:00Z  
**Next Review:** 2024-10-04T22:20:00Z

**Integration Status:**
- ✅ MCP Protocol Implemented
- ✅ Multi-Agent Coordination Ready
- ✅ Performance Monitoring Active
- ✅ Decision Framework Established
- 🔄 Continuous Learning Pipeline (In Progress)