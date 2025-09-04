#!/bin/bash
# Coordinate Agents Script - Multi-Agent Orchestration
# Usage: ./coordinate_agents.sh [LEAD_AGENT] [SUPPORT_AGENTS] [TASK] [CONTEXT]

set -e

LEAD_AGENT="${1:-claude}"
SUPPORT_AGENTS="${2:-perplexity}"
TASK="${3:-coordination-test}"
CONTEXT="${4:-default}"

# Generate coordination REF tag
REF_TAG=$(./automation/generate_ref_tag.sh coordination "multi-agent-${LEAD_AGENT}")

echo "=== LOCUS MULTI-AGENT COORDINATION ==="
echo "Lead Agent: $LEAD_AGENT"
echo "Support Agents: $SUPPORT_AGENTS"
echo "Task: $TASK"
echo "Context: $CONTEXT"
echo "REF: $REF_TAG"
echo "Timestamp: $(date -Iseconds)"
echo "======================================"

# Log coordination start
echo "$(date -Iseconds) - COORDINATE - $LEAD_AGENT + $SUPPORT_AGENTS - $TASK - $CONTEXT - $REF_TAG" >> /tmp/locus_agent_coordinations.log

# Create coordination context
cat > "/tmp/locus_coordination_${REF_TAG}.json" << EOF
{
  "ref_tag": "$REF_TAG",
  "lead_agent": "$LEAD_AGENT",
  "support_agents": "$SUPPORT_AGENTS",
  "task": "$TASK",
  "context": "$CONTEXT",
  "timestamp": "$(date -Iseconds)",
  "status": "coordinating",
  "phases": []
}
EOF

# Phase 1: Lead agent initial analysis
echo "Phase 1: $LEAD_AGENT initial analysis..."
PHASE1_REF=$(./automation/generate_ref_tag.sh phase "coord-phase1")
./automation/invoke_agent.sh "$LEAD_AGENT" HIGH "analyze-task" "$TASK" > "/tmp/phase1_${REF_TAG}.log"

# Phase 2: Support agents contribute
echo "Phase 2: Support agents contribution..."
IFS=',' read -ra AGENTS <<< "$SUPPORT_AGENTS"
for agent in "${AGENTS[@]}"; do
    agent=$(echo "$agent" | xargs) # trim whitespace
    echo "  Invoking $agent for support analysis..."
    SUPPORT_REF=$(./automation/generate_ref_tag.sh support "coord-support-${agent}")
    ./automation/invoke_agent.sh "$agent" MEDIUM "support-analysis" "$TASK" > "/tmp/support_${agent}_${REF_TAG}.log"
done

# Phase 3: Integration by lead agent
echo "Phase 3: $LEAD_AGENT integration..."
PHASE3_REF=$(./automation/generate_ref_tag.sh integration "coord-integration")
./automation/invoke_agent.sh "$LEAD_AGENT" HIGH "integrate-results" "$TASK" > "/tmp/integration_${REF_TAG}.log"

# Update coordination status
cat > "/tmp/locus_coordination_${REF_TAG}.json" << EOF
{
  "ref_tag": "$REF_TAG",
  "lead_agent": "$LEAD_AGENT",
  "support_agents": "$SUPPORT_AGENTS",
  "task": "$TASK",
  "context": "$CONTEXT",
  "timestamp": "$(date -Iseconds)",
  "status": "completed",
  "phases": [
    {
      "phase": 1,
      "agent": "$LEAD_AGENT",
      "action": "initial-analysis",
      "ref": "$PHASE1_REF",
      "log": "/tmp/phase1_${REF_TAG}.log"
    },
    {
      "phase": 2,
      "agents": "$SUPPORT_AGENTS",
      "action": "support-analysis",
      "logs": "/tmp/support_*_${REF_TAG}.log"
    },
    {
      "phase": 3,
      "agent": "$LEAD_AGENT",
      "action": "integration",
      "ref": "$PHASE3_REF",
      "log": "/tmp/integration_${REF_TAG}.log"
    }
  ],
  "completion_time": "$(date -Iseconds)",
  "result": "Multi-agent coordination completed successfully"
}
EOF

echo "✓ Multi-agent coordination completed"
echo "Coordination log: /tmp/locus_coordination_${REF_TAG}.json"
echo "Individual logs: /tmp/*_${REF_TAG}.log"
echo "COORDINATION REF: $REF_TAG"