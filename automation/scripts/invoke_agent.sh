#!/bin/bash
# Invoke Agent Script - USER-AI Directive Implementation
# Usage: ./invoke_agent.sh [AGENT] [PRIORITY] [TASK] [CONTEXT]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

AGENT="${1:-claude}"
PRIORITY="${2:-MEDIUM}"
TASK="${3:-status-check}"
CONTEXT="${4:-default}"

# Generate REF tag for this invocation
REF_TAG=$("$SCRIPT_DIR/generate_ref_tag.sh" task "agent-invoke-${AGENT}")

echo "=== LOCUS AGENT INVOCATION ==="
echo "Agent: $AGENT"
echo "Priority: $PRIORITY"  
echo "Task: $TASK"
echo "Context: $CONTEXT"
echo "REF: $REF_TAG"
echo "Timestamp: $(date -Iseconds)"
echo "================================"

# Log the invocation
echo "$(date -Iseconds) - INVOKE - $AGENT - $PRIORITY - $TASK - $CONTEXT - $REF_TAG" >> /tmp/locus_agent_invocations.log

# Validate agent type
case "$AGENT" in
    claude|CLAUDE)
        echo "Invoking Claude Pro Agent..."
        echo "Capabilities: Code analysis, documentation, infrastructure planning"
        ;;
    perplexity|PERPLEXITY)
        echo "Invoking Perplexity Pro Agent..."
        echo "Capabilities: Research, real-time data, monitoring reports"
        ;;
    lumo|LUMO)
        echo "Invoking Proton Lumo Agent..."
        echo "Capabilities: Secure communications, encrypted storage, VPN"
        ;;
    *)
        echo "Error: Unknown agent type '$AGENT'"
        echo "Valid agents: claude, perplexity, lumo"
        exit 1
        ;;
esac

# Validate priority
case "$PRIORITY" in
    CRITICAL|HIGH|MEDIUM|LOW)
        echo "Priority validation: ✓"
        ;;
    *)
        echo "Warning: Invalid priority '$PRIORITY'. Using MEDIUM."
        PRIORITY="MEDIUM"
        ;;
esac

# Capture current system state
echo "Capturing system state..."
"$SCRIPT_DIR/status_report.sh" > "/tmp/locus_state_${REF_TAG}.md"

# Create task context file
cat > "/tmp/locus_task_${REF_TAG}.json" << EOF
{
  "ref_tag": "$REF_TAG",
  "agent": "$AGENT",
  "priority": "$PRIORITY",
  "task": "$TASK",
  "context": "$CONTEXT",
  "timestamp": "$(date -Iseconds)",
  "status": "initiated",
  "state_snapshot": "/tmp/locus_state_${REF_TAG}.md"
}
EOF

echo "Task context created: /tmp/locus_task_${REF_TAG}.json"
echo "State snapshot: /tmp/locus_state_${REF_TAG}.md"

# Mock agent execution (in real implementation, this would call actual agent APIs)
echo "Executing task with $AGENT agent..."
sleep 2

# Update task status
cat > "/tmp/locus_task_${REF_TAG}.json" << EOF
{
  "ref_tag": "$REF_TAG",
  "agent": "$AGENT",
  "priority": "$PRIORITY",
  "task": "$TASK",
  "context": "$CONTEXT",
  "timestamp": "$(date -Iseconds)",
  "status": "completed",
  "state_snapshot": "/tmp/locus_state_${REF_TAG}.md",
  "completion_time": "$(date -Iseconds)",
  "result": "Task completed successfully by $AGENT agent"
}
EOF

echo "✓ Task completed successfully"
echo "Result logged in: /tmp/locus_task_${REF_TAG}.json"
echo "REF TAG: $REF_TAG"