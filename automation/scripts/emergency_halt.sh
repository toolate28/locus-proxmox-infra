#!/bin/bash
# Emergency Halt System for Project Locus Fork B
# Cross-machine emergency stop for constitutional violations

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Generate REF tag for this emergency halt
REF_TAG=$("$SCRIPT_DIR/generate_ref_tag.sh" "job" "emergency-halt")

# Function to perform emergency halt
emergency_halt() {
    local reason="${1:-constitutional_violation}"
    local severity="${2:-critical}"
    
    echo "🚨 === LOCUS Fork B: EMERGENCY HALT INITIATED ==="
    echo "REF: $REF_TAG"
    echo "Reason: $reason"
    echo "Severity: $severity"
    echo "Timestamp: $(date -Iseconds)"
    echo "Initiated by: $(hostname)"
    
    # Create emergency halt record
    cat > "/tmp/locus_emergency_halt_${REF_TAG}.json" << EOF
{
  "ref_tag": "$REF_TAG",
  "halt_type": "constitutional_emergency",
  "timestamp": "$(date -Iseconds)",
  "reason": "$reason",
  "severity": "$severity",
  "initiated_by": "$(hostname)",
  "affected_systems": [
    "core_machine",
    "experimental_machine"
  ],
  "actions_taken": [
    "stop_automation_scripts",
    "preserve_state",
    "notify_human_operators",
    "cross_machine_propagation"
  ],
  "status": "halted",
  "human_approval_required": true,
  "human_approval_received": false
}
EOF
    
    # Stop automation processes (simulated - in real implementation would kill processes)
    echo "🛑 Stopping automation processes..."
    echo "  [SIMULATED] Stopping resource_check.sh"
    echo "  [SIMULATED] Stopping vm_provision.sh"
    echo "  [SIMULATED] Stopping heartbeat_monitor.sh"
    echo "  [SIMULATED] Stopping freshness_loop.sh"
    
    # Preserve current state
    echo "💾 Preserving current system state..."
    mkdir -p "/tmp/locus_emergency_state_$REF_TAG"
    
    # Copy critical state files
    if [ -d "/tmp/locus_ref_state" ]; then
        cp -r /tmp/locus_ref_state "/tmp/locus_emergency_state_$REF_TAG/"
    fi
    
    if [ -d "/tmp/locus_coordination" ]; then
        cp -r /tmp/locus_coordination "/tmp/locus_emergency_state_$REF_TAG/"
    fi
    
    # Copy recent logs
    find /tmp -name "locus_*_*.json" -mtime -1 -exec cp {} "/tmp/locus_emergency_state_$REF_TAG/" \; 2>/dev/null || true
    
    echo "✓ System state preserved in: /tmp/locus_emergency_state_$REF_TAG"
    
    # Notify human operators (simulated)
    echo "📢 Notifying human operators..."
    echo "  [SIMULATED] Email notification sent to: operations@locus.internal"
    echo "  [SIMULATED] Slack alert sent to: #locus-emergency"
    echo "  [SIMULATED] SMS alert sent to on-call engineer"
    
    # Cross-machine propagation (simulated)
    echo "🌐 Propagating emergency halt to connected machines..."
    echo "  [SIMULATED] rsync emergency halt to: experimental_machine"
    echo "  [SIMULATED] ssh emergency halt trigger: experimental_machine"
    
    # Create human approval checkpoint
    echo "⏳ Waiting for human approval to resume operations..."
    echo "   Use: $0 --approve $REF_TAG"
    echo "   Or:  $0 --status $REF_TAG"
    
    echo ""
    echo "🚨 EMERGENCY HALT COMPLETE"
    echo "📋 Emergency record: /tmp/locus_emergency_halt_${REF_TAG}.json"
    echo "💾 State backup: /tmp/locus_emergency_state_$REF_TAG"
    echo "REF: $REF_TAG"
}

# Function to check emergency halt status
check_status() {
    local ref_tag="${1:-}"
    
    if [ -z "$ref_tag" ]; then
        echo "=== Active Emergency Halts ==="
        
        # Find all active emergency halts
        mapfile -t emergency_files < <(find /tmp -name "locus_emergency_halt_*.json" 2>/dev/null || true)
        
        if [ ${#emergency_files[@]} -eq 0 ]; then
            echo "✓ No active emergency halts"
            return 0
        fi
        
        for file in "${emergency_files[@]}"; do
            local halt_ref=$(jq -r '.ref_tag' "$file" 2>/dev/null || echo "unknown")
            local reason=$(jq -r '.reason' "$file" 2>/dev/null || echo "unknown")
            local approved=$(jq -r '.human_approval_received' "$file" 2>/dev/null || echo "false")
            local timestamp=$(jq -r '.timestamp' "$file" 2>/dev/null || echo "unknown")
            
            echo "🚨 $halt_ref: $reason (approved: $approved) - $timestamp"
        done
    else
        echo "=== Emergency Halt Status: $ref_tag ==="
        
        local halt_file="/tmp/locus_emergency_halt_${ref_tag}.json"
        
        if [ ! -f "$halt_file" ]; then
            echo "❌ Emergency halt record not found: $ref_tag"
            return 1
        fi
        
        jq '.' "$halt_file"
    fi
}

# Function to approve emergency halt resolution
approve_halt() {
    local ref_tag="${1:-}"
    
    if [ -z "$ref_tag" ]; then
        echo "Error: REF tag required for approval"
        echo "Usage: $0 --approve <REF_TAG>"
        return 1
    fi
    
    local halt_file="/tmp/locus_emergency_halt_${ref_tag}.json"
    
    if [ ! -f "$halt_file" ]; then
        echo "❌ Emergency halt record not found: $ref_tag"
        return 1
    fi
    
    echo "=== Human Approval for Emergency Halt Resolution ==="
    echo "REF: $ref_tag"
    
    # Update halt record with approval
    jq '.human_approval_received = true | .approved_at = "'$(date -Iseconds)'" | .approved_by = "'$(whoami)'"' \
       "$halt_file" > "${halt_file}.tmp" && mv "${halt_file}.tmp" "$halt_file"
    
    echo "✓ Emergency halt approved for resolution"
    echo "✓ Systems may now resume normal operations"
    echo "📋 Updated record: $halt_file"
    
    # Log approval
    local approval_ref=$("$SCRIPT_DIR/generate_ref_tag.sh" "job" "halt-approval")
    cat > "/tmp/locus_halt_approval_${approval_ref}.json" << EOF
{
  "ref_tag": "$approval_ref",
  "action_type": "emergency_halt_approval",
  "timestamp": "$(date -Iseconds)",
  "approved_halt": "$ref_tag",
  "approved_by": "$(whoami)",
  "approval_method": "manual_command",
  "next_steps": "resume_normal_operations"
}
EOF
    
    echo "📝 Approval logged: $approval_ref"
}

# Function to show usage
usage() {
    echo "Usage: $0 [--halt <reason> <severity>|--status [ref_tag]|--approve <ref_tag>]"
    echo ""
    echo "Implemented Commands:"
    echo "  --halt <reason> <severity>   Initiate emergency halt"
    echo "  --status [ref_tag]           Check emergency halt status"
    echo "  --approve <ref_tag>          Approve halt resolution"
    echo ""
    echo "Future Enhancements (Not Yet Implemented):"
    echo "  --test-secure-halt           Test emergency halt procedures"
    echo "  --propagate <reason> <type>  Cross-machine security propagation"
    echo "  --secure-preserve <ref_tag>  Secure state preservation during halt"
    echo "  --network-isolate <reason>   Isolate compromised systems"
    echo "  --constitutional-violation   Constitutional violation response"
    echo ""
    echo "Examples:"
    echo "  $0 --halt resource_violation critical"
    echo "  $0 --status"
    echo "  $0 --status LOCUS-JOB20250905-123456-001"
    echo "  $0 --approve LOCUS-JOB20250905-123456-001"
}

# Main execution
main() {
    case "${1:-}" in
        "--halt")
            if [ $# -lt 3 ]; then
                echo "Error: --halt requires reason and severity"
                usage
                exit 1
            fi
            emergency_halt "$2" "$3"
            ;;
        "--status")
            check_status "${2:-}"
            ;;
        "--approve")
            if [ $# -lt 2 ]; then
                echo "Error: --approve requires REF tag"
                usage
                exit 1
            fi
            approve_halt "$2"
            ;;
        *)
            usage
            exit 1
            ;;
    esac
}

# Execute if run directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    main "$@"
fi