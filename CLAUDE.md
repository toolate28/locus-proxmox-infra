# Claude Pro Integration & MCP Onboarding Guide
## Project Locus Multi-Agent Infrastructure

### Overview
This guide provides comprehensive onboarding for Claude Pro agents within the Project Locus ecosystem, including MCP (Model Context Protocol) integration, context sharing, and operational procedures.

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

# Share context with other agents
./automation/share_context.sh claude perplexity $REF_TAG

# Archive completed work
./automation/archive_context.sh $REF_TAG "task-completed"
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
# Morning infrastructure review
./automation/claude_daily_review.sh

# Check for pending documentation updates
./automation/check_doc_updates.sh

# Review overnight automation logs
./automation/review_logs.sh --since="24h" --agent="claude"
```

### Weekly Tasks
```bash
# Generate architecture review
./automation/claude_arch_review.sh --weekly

# Update documentation inventory
./automation/doc_inventory.sh --update

# Performance analysis
./automation/claude_performance.sh --weekly-report
```

### Monthly Tasks
```bash
# Comprehensive system analysis
./automation/claude_system_analysis.sh --comprehensive

# Technology trend analysis
./automation/claude_tech_trends.sh --monthly

# Documentation audit
./automation/claude_doc_audit.sh --full
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
# Generate context package
./automation/package_context.sh $REF_TAG > context.json

# Upload to temporary sharing service
SHARE_URL=$(curl -X POST https://temp-share.example.com -d @context.json)

# Generate QR code for easy sharing
./scripts/generate_qr.sh "$SHARE_URL"

# Notify receiving agent
echo "Context available at: $SHARE_URL (QR: qr.png)"
```

See [docs/qr-share.md](docs/qr-share.md) for more details.

---

## 🔍 Troubleshooting

### Common Issues
1. **API Rate Limits**
   - Implement exponential backoff
   - Use batch processing for multiple requests
   - Monitor usage with `./automation/claude_usage.sh`

2. **Context Size Limits**
   - Summarize large contexts before handover
   - Use context compression techniques
   - Prioritize most relevant information

3. **Integration Failures**
   - Check API key validity
   - Verify network connectivity
   - Review error logs in `/tmp/claude_errors.log`

### Emergency Procedures
```bash
# Fallback to simplified processing
./automation/claude_fallback.sh

# Emergency context recovery
./automation/recover_context.sh $REF_TAG

# Manual intervention mode
./automation/claude_manual.sh --intervention-required
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
# Real-time performance
./automation/claude_monitor.sh --real-time

# Generate performance report
./automation/claude_report.sh --metrics --timeframe="7d"

# Compare with baseline
./automation/claude_benchmark.sh --compare-baseline
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
# Pre-task hooks
./automation/hooks/claude_pre_task.sh

# Post-task validation
./automation/hooks/claude_post_task.sh

# Continuous learning updates
./automation/hooks/claude_learning.sh
```

### Advanced Context Management
```bash
# Semantic context indexing
./automation/claude_index_context.sh

# Context pattern recognition
./automation/claude_pattern_analysis.sh

# Predictive context preparation
./automation/claude_predict_context.sh
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