#!/bin/bash
# Capture Context Script - Context Management for Agent Handovers
# Usage: ./capture_context.sh [AGENT] [REF_TAG]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

AGENT="${1:-claude}"
REF_TAG="${2:-$("$SCRIPT_DIR/generate_ref_tag.sh" context "capture")}"

echo "=== LOCUS CONTEXT CAPTURE ==="
echo "Agent: $AGENT"
echo "REF: $REF_TAG"
echo "Timestamp: $(date -Iseconds)"
echo "============================="

# Create context directory if it doesn't exist
mkdir -p /tmp/locus_contexts

# Capture system state
echo "Capturing system state..."
CONTEXT_FILE="/tmp/locus_contexts/context_${REF_TAG}.json"

# Get current resource status
RESOURCE_STATUS=$("$SCRIPT_DIR/resource_check.sh" 2>/dev/null || echo "Resource check unavailable")

# Get agent status
AGENT_STATUS=$(cat context/AGENT_STATUS.json 2>/dev/null || echo "{}")

# Get recent REF tags
RECENT_REFS=$(tail -n 10 /tmp/locus_ref_audit.log 2>/dev/null || echo "No recent REF tags")

# Capture current context
cat > "$CONTEXT_FILE" << EOF
{
  "capture_ref": "$REF_TAG",
  "agent": "$AGENT",
  "timestamp": "$(date -Iseconds)",
  "system_state": {
    "resource_status": "$RESOURCE_STATUS",
    "agent_status": $AGENT_STATUS,
    "recent_refs": "$RECENT_REFS",
    "current_directory": "$(pwd)",
    "git_status": "$(git --no-pager status --porcelain 2>/dev/null || echo 'No git status available')"
  },
  "environment": {
    "hostname": "$(hostname)",
    "user": "$(whoami)",
    "load_average": "$(uptime | awk -F'load average:' '{print $2}' 2>/dev/null || echo 'N/A')",
    "disk_usage": "$(df -h . | tail -1 | awk '{print $5}' 2>/dev/null || echo 'N/A')",
    "memory_usage": "$(free -h | grep '^Mem:' | awk '{print $3 "/" $2}' 2>/dev/null || echo 'N/A')"
  },
  "active_processes": {
    "automation_scripts": "$(ps aux | grep -E '(automation|locus)' | grep -v grep | wc -l)",
    "background_jobs": "$(jobs | wc -l 2>/dev/null || echo '0')"
  },
  "recent_activity": {
    "last_status_report": "$(ls -t docs/status_report_*.md 2>/dev/null | head -1 || echo 'None found')",
    "last_ref_generation": "$(tail -1 /tmp/locus_ref_audit.log 2>/dev/null || echo 'None found')",
    "pending_tasks": "$(find /tmp -name 'locus_task_*.json' -newer /tmp/locus_ref_counter 2>/dev/null | wc -l || echo '0')"
  }
}
EOF

echo "Context captured successfully: $CONTEXT_FILE"

# Create human-readable summary
SUMMARY_FILE="/tmp/locus_contexts/summary_${REF_TAG}.md"
cat > "$SUMMARY_FILE" << EOF
# Context Summary - $REF_TAG

**Agent:** $AGENT  
**Capture Time:** $(date -Iseconds)  
**System:** $(hostname) ($(whoami))  

## Resource Status
$(echo "$RESOURCE_STATUS" | head -5)

## Current State
- **Directory:** $(pwd)
- **Git Status:** $(git --no-pager status --porcelain 2>/dev/null | wc -l || echo '0') changes
- **Load Average:** $(uptime | awk -F'load average:' '{print $2}' 2>/dev/null || echo 'N/A')
- **Disk Usage:** $(df -h . | tail -1 | awk '{print $5}' 2>/dev/null || echo 'N/A')

## Recent Activity
- **Last Status Report:** $(ls -t docs/status_report_*.md 2>/dev/null | head -1 | xargs basename 2>/dev/null || echo 'None')
- **Pending Tasks:** $(find /tmp -name 'locus_task_*.json' 2>/dev/null | wc -l || echo '0')
- **Active Scripts:** $(ps aux | grep -E '(automation|locus)' | grep -v grep | wc -l) running

## Context Files
- **Full Context:** $CONTEXT_FILE
- **Summary:** $SUMMARY_FILE

---
**Capture REF:** $REF_TAG  
**Ready for handover or archival**
EOF

echo "Human-readable summary: $SUMMARY_FILE"

# Log the context capture
echo "$(date -Iseconds) - CAPTURE - $AGENT - $REF_TAG - $CONTEXT_FILE" >> /tmp/locus_context_log.log

echo "✓ Context capture completed"
echo "Files created:"
echo "  - Full context: $CONTEXT_FILE"
echo "  - Summary: $SUMMARY_FILE"
echo "CONTEXT REF: $REF_TAG"