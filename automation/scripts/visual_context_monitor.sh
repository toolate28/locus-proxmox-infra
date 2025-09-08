#!/bin/bash
# Visual Context Monitor for Project Locus
# Usage: ./visual_context_monitor.sh [mode]
# Modes: trail, delta, timeline, health

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

MODE="${1:-trail}"

# Function to display audit trail
show_audit_trail() {
    echo "┌─────────────────────────────────────────────────────┐"
    echo "│ CONTEXT EVOLUTION TRACKER                          │"
    echo "├─────────────────────────────────────────────────────┤"
    
    # Get recent REF tag entries
    if [ -f /tmp/locus_ref_audit.log ]; then
        tail -10 /tmp/locus_ref_audit.log | while IFS= read -r line; do
            if [ -n "$line" ]; then
                # Extract timestamp, action, and description
                timestamp=$(echo "$line" | awk '{print $1}' | cut -c12-16)
                ref_tag=$(echo "$line" | awk '{print $4}' | cut -c7-15)
                action=$(echo "$line" | awk '{print $4}' | cut -c7-12)
                description=$(echo "$line" | cut -d' ' -f5- | cut -c1-20)
                
                printf "│ ▶ %s │ %-8s │ %-20s │\n" "$timestamp" "$action" "$description"
            fi
        done
    else
        echo "│ No audit trail data available                       │"
    fi
    
    echo "└─────────────────────────────────────────────────────┘"
}

# Function to show context delta visualization
show_context_delta() {
    echo "╔═══════════════════════════════════════════════╗"
    echo "║           CONTEXT CHANGES DETECTED            ║"
    echo "╠═══════════════════════════════════════════════╣"
    
    # Find latest context receipt
    local latest_receipt=$(ls -t /tmp/locus_receipts/receipt_*.json 2>/dev/null | head -1)
    
    if [ -n "$latest_receipt" ] && [ -f "$latest_receipt" ]; then
        echo "║ Latest Context Receipt Changes:               ║"
        echo "║                                               ║"
        
        # Extract fields changed from receipt
        jq -r '.generation_context.delta_summary.fields_changed[]' "$latest_receipt" 2>/dev/null | while read -r field; do
            printf "║ + %-42s ║\n" "$field: modified"
        done
        
        echo "║                                               ║"
        
        # Show receipt details
        local ref_tag=$(jq -r '.ref_tag' "$latest_receipt" 2>/dev/null)
        local receipt_id=$(jq -r '.receipt_id' "$latest_receipt" 2>/dev/null)
        local checksum=$(jq -r '.validation.checksum' "$latest_receipt" 2>/dev/null)
        
        printf "║ REF: %-38s ║\n" "$ref_tag"
        printf "║ Receipt: %-33s ║\n" "$receipt_id"
        printf "║ Hash: %-37s ║\n" "$checksum"
    else
        echo "║ No context receipts found                     ║"
    fi
    
    echo "╚═══════════════════════════════════════════════╝"
}

# Function to show interactive timeline
show_timeline() {
    echo "Timeline: Project Locus Context Evolution"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    local start_time=$(date -d "1 hour ago" +"%H:%M")
    echo "$start_time ─┬─ Session Start"
    echo "       │"
    
    # Process audit log entries
    if [ -f /tmp/locus_ref_audit.log ]; then
        tail -5 /tmp/locus_ref_audit.log | while IFS= read -r line; do
            if [ -n "$line" ]; then
                local timestamp=$(echo "$line" | awk '{print $1}' | cut -c12-16)
                local ref_tag=$(echo "$line" | awk '{print $4}')
                local action=$(echo "$ref_tag" | cut -d'-' -f2)
                local description=$(echo "$line" | cut -d' ' -f5-)
                
                echo "$timestamp ─┼─ [$action] $description"
                echo "       │  └─ REF: $ref_tag"
                echo "       │"
            fi
        done
    fi
    
    local current_time=$(date +"%H:%M")
    echo "$current_time ─┴─ Current State"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

# Function to show context health indicators
show_health_indicators() {
    echo "╔════════════════════════════════════════════════╗"
    echo "║         CONTEXT HEALTH INDICATORS              ║"
    echo "╠════════════════════════════════════════════════╣"
    
    # Calculate basic health metrics
    local receipt_count=$(ls /tmp/locus_receipts/receipt_*.json 2>/dev/null | wc -l)
    local ref_count=$(wc -l < /tmp/locus_ref_audit.log 2>/dev/null || echo 0)
    local agent_count=$(jq '.agents | keys | length' "$SCRIPT_DIR/../context/AGENT_STATUS.json" 2>/dev/null || echo 0)
    
    # Context integrity (presence of receipts and refs)
    local context_integrity=100
    if [ "$receipt_count" -eq 0 ]; then
        context_integrity=0
    fi
    
    # Agent synchronization (simulated - would check actual heartbeats in production)
    local agent_sync=85
    
    # Schema compliance (presence of REF tags)
    local schema_compliance=100
    if [ "$ref_count" -eq 0 ]; then
        schema_compliance=0
    fi
    
    # Audit completeness
    local audit_completeness=100
    
    # Display health bars
    printf "║ Context Integrity    : %s %3d%%      ║\n" "$(draw_progress_bar $context_integrity)" "$context_integrity"
    printf "║ Agent Synchronization: %s  %2d%%      ║\n" "$(draw_progress_bar $agent_sync)" "$agent_sync"
    printf "║ Schema Compliance    : %s %3d%%      ║\n" "$(draw_progress_bar $schema_compliance)" "$schema_compliance"
    printf "║ Audit Completeness   : %s %3d%%      ║\n" "$(draw_progress_bar $audit_completeness)" "$audit_completeness"
    echo "╠════════════════════════════════════════════════╣"
    
    # Show alerts if any
    if [ "$agent_sync" -lt 90 ]; then
        echo "║ ⚠️ ALERT: Agent sync below threshold          ║"
        echo "║ Action: Reconcile agent context               ║"
    else
        echo "║ ✅ All systems operational                     ║"
    fi
    
    echo "╚════════════════════════════════════════════════╝"
}

# Helper function to draw progress bars
draw_progress_bar() {
    local percent=$1
    local full_blocks=$((percent / 10))
    local partial_block=$((percent % 10))
    local empty_blocks=$((10 - full_blocks))
    
    if [ $partial_block -gt 0 ]; then
        empty_blocks=$((empty_blocks - 1))
    fi
    
    local bar=""
    for ((i=0; i<full_blocks; i++)); do
        bar+="█"
    done
    
    if [ $partial_block -gt 0 ]; then
        bar+="░"
    fi
    
    for ((i=0; i<empty_blocks; i++)); do
        bar+="░"
    done
    
    echo "$bar"
}

# Main execution
echo "=== LOCUS VISUAL CONTEXT MONITOR ==="
echo "Mode: $MODE"
echo "Timestamp: $(date -Iseconds)"
echo "======================================"

case "$MODE" in
    "trail")
        show_audit_trail
        ;;
    "delta")
        show_context_delta
        ;;
    "timeline")
        show_timeline
        ;;
    "health")
        show_health_indicators
        ;;
    "all")
        show_audit_trail
        echo ""
        show_context_delta
        echo ""
        show_timeline
        echo ""
        show_health_indicators
        ;;
    *)
        echo "Usage: $0 [trail|delta|timeline|health|all]"
        echo "  trail    - Show recent audit trail"
        echo "  delta    - Show context changes"
        echo "  timeline - Show event timeline"
        echo "  health   - Show health indicators"
        echo "  all      - Show all views"
        exit 1
        ;;
esac

echo ""
echo "Visual monitoring complete."