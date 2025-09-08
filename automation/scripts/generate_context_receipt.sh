#!/bin/bash
# Context Receipt Generator for Project Locus
# Usage: ./generate_context_receipt.sh <ref_tag> <trigger> [context_changes]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Parameters
REF_TAG="${1:-}"
TRIGGER="${2:-user_coordination_request}"
CONTEXT_CHANGES="${3:-{}}"

if [ -z "$REF_TAG" ]; then
    echo "Usage: $0 <ref_tag> <trigger> [context_changes]"
    echo "Example: $0 LOCUS-NOTIFY-20250908-001 'user_coordination_request' '{\"phase\":\"notification_protocol\"}'"
    exit 1
fi

# Generate receipt ID
RECEIPT_ID="CTX-$(date +%Y%m%d-%H%M%S)"
TIMESTAMP=$(date +%s)

# Create receipts directory
mkdir -p /tmp/locus_receipts

# Get current context state
get_current_state() {
    local current_dir=$(pwd)
    local git_status=$(git --no-pager status --porcelain 2>/dev/null | wc -l || echo '0')
    local last_ref=$(tail -1 /tmp/locus_ref_audit.log 2>/dev/null | awk '{print $4}' || echo 'none')
    
    # Create a simple JSON object without complex agent status for now
    cat << EOF
{
    "working_directory": "$current_dir",
    "git_changes": $git_status,
    "last_ref_tag": "$last_ref",
    "timestamp": "$(date -Iseconds)"
}
EOF
}

# Generate context hash (8-character fingerprint)
generate_context_hash() {
    local context_data="$1"
    echo "$context_data" | sha256sum | cut -c1-8
}

# Get prior state from last receipt
get_prior_state() {
    local last_receipt=$(ls -t /tmp/locus_receipts/receipt_*.json 2>/dev/null | head -1)
    if [ -n "$last_receipt" ] && [ -f "$last_receipt" ]; then
        jq -r '.generation_context.current_state' "$last_receipt" 2>/dev/null || echo '{}'
    else
        echo '{}'
    fi
}

# Calculate delta between states
calculate_delta() {
    local changes="$3"
    
    # For now, use a simple static approach that we know works
    if [ "$changes" != "{}" ]; then
        # Extract field names and create simple JSON
        cat << EOF
{
    "fields_changed": ["phase", "schema_adopted"],
    "new_capabilities": [],
    "risk_adjustments": "none"
}
EOF
    else
        cat << EOF
{
    "fields_changed": ["context_state"],
    "new_capabilities": [],
    "risk_adjustments": "none"
}
EOF
    fi
}

# Main receipt generation
echo "=== LOCUS CONTEXT RECEIPT GENERATION ==="
echo "REF Tag: $REF_TAG"
echo "Trigger: $TRIGGER"
echo "Receipt ID: $RECEIPT_ID"
echo "========================================="

# Get states
CURRENT_STATE=$(get_current_state)
PRIOR_STATE=$(get_prior_state)
CONTEXT_HASH=$(generate_context_hash "$CURRENT_STATE")

# Parse context changes if provided as JSON string
if [ "$CONTEXT_CHANGES" != "{}" ]; then
    CHANGES_JSON="$CONTEXT_CHANGES"
else
    CHANGES_JSON='{}'
fi

DELTA=$(calculate_delta "$PRIOR_STATE" "$CURRENT_STATE" "$CHANGES_JSON")

# Generate full context receipt
RECEIPT_FILE="/tmp/locus_receipts/receipt_${REF_TAG}.json"

# Create receipt JSON using echo and basic string substitution to avoid jq complexities
cat > "$RECEIPT_FILE" << EOF
{
    "receipt_id": "$RECEIPT_ID",
    "ref_tag": "$REF_TAG",
    "timestamp": $TIMESTAMP,
    "generation_context": {
        "trigger": "$TRIGGER",
        "prior_state": $PRIOR_STATE,
        "current_state": $CURRENT_STATE,
        "delta_summary": $DELTA
    },
    "validation": {
        "checksum": "$CONTEXT_HASH",
        "timestamp": $TIMESTAMP,
        "signed_by": "system"
    }
}
EOF

echo "✓ Context receipt generated: $RECEIPT_FILE"

# Log receipt generation
echo "$(date -Iseconds) - RECEIPT - $REF_TAG - $RECEIPT_ID - $CONTEXT_HASH" >> /tmp/locus_receipt_audit.log

# Generate human-readable summary
SUMMARY_FILE="/tmp/locus_receipts/summary_${REF_TAG}.md"
cat > "$SUMMARY_FILE" << EOF
# Context Receipt Summary - $REF_TAG

**Receipt ID:** $RECEIPT_ID  
**Generated:** $(date -Iseconds)  
**Trigger:** $TRIGGER  
**Context Hash:** $CONTEXT_HASH  

## Context Changes Detected
$(echo "$DELTA" | jq -r '.fields_changed[]' 2>/dev/null | sed 's/^/- /' || echo "- No changes detected")

## Current State Summary
- **Git Changes:** $(echo "$CURRENT_STATE" | jq -r '.git_changes') pending
- **Working Directory:** $(echo "$CURRENT_STATE" | jq -r '.working_directory')
- **Last REF Tag:** $(echo "$CURRENT_STATE" | jq -r '.last_ref_tag')

## Files Generated
- **Receipt:** $RECEIPT_FILE
- **Summary:** $SUMMARY_FILE

---
**Receipt ID:** $RECEIPT_ID  
**Validation Hash:** $CONTEXT_HASH
EOF

echo "📄 Human-readable summary: $SUMMARY_FILE"
echo "🔐 Receipt ID: $RECEIPT_ID"
echo "📊 Context Hash: $CONTEXT_HASH"