#!/bin/bash

# Project Locus Firewall Diagnostics Script
# Purpose: Diagnose and report firewall connectivity issues for multi-agent coordination
# Usage: ./firewall_diagnostics.sh [check|fix|report]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Generate REF tag for this diagnostics run
REF_TAG=$("$SCRIPT_DIR/generate_ref_tag.sh" "job" "firewall-diagnostics")

# External API endpoints to test
declare -A EXTERNAL_APIS=(
    ["api.anthropic.com"]="443"
    ["api.perplexity.ai"]="443"
    ["lumo.proton.me"]="443"
    ["github.com"]="443"
    ["raw.githubusercontent.com"]="443"
)

# Internal infrastructure endpoints
declare -A INTERNAL_ENDPOINTS=(
    ["pve.locus.internal"]="8006"
    ["pbs.locus.internal"]="8007"
    ["monitor.locus.internal"]="443"
    ["hooks.locus.internal"]="443"
)

# Output file for diagnostics report
OUTPUT_FILE="/tmp/locus_firewall_diagnostics_$(date +%Y%m%d_%H%M%S).json"

# Function to test connectivity to an endpoint
test_connectivity() {
    local endpoint="$1"
    local port="$2"
    local timeout="${3:-5}"
    
    if command -v timeout >/dev/null 2>&1; then
        timeout "$timeout" bash -c "</dev/tcp/$endpoint/$port" 2>/dev/null
    else
        # Fallback using curl for HTTPS endpoints
        if [ "$port" = "443" ]; then
            curl -I -s -m "$timeout" "https://$endpoint" >/dev/null 2>&1
        else
            curl -I -s -m "$timeout" "http://$endpoint:$port" >/dev/null 2>&1
        fi
    fi
}

# Function to perform comprehensive connectivity tests
perform_connectivity_tests() {
    local results=()
    
    echo "=== LOCUS Firewall Diagnostics (REF: $REF_TAG) ==="
    echo "Timestamp: $(date -Iseconds)"
    echo ""
    
    # Test external API endpoints
    echo "Testing External API Endpoints..."
    for endpoint in "${!EXTERNAL_APIS[@]}"; do
        local port="${EXTERNAL_APIS[$endpoint]}"
        echo -n "  - $endpoint:$port ... "
        
        if test_connectivity "$endpoint" "$port"; then
            echo "✓ Connected"
            results+=("{\"endpoint\":\"$endpoint\",\"port\":$port,\"status\":\"connected\",\"type\":\"external\"}")
        else
            echo "✗ Blocked/Failed"
            results+=("{\"endpoint\":\"$endpoint\",\"port\":$port,\"status\":\"blocked\",\"type\":\"external\"}")
        fi
    done
    
    echo ""
    echo "Testing Internal Infrastructure Endpoints..."
    for endpoint in "${!INTERNAL_ENDPOINTS[@]}"; do
        local port="${INTERNAL_ENDPOINTS[$endpoint]}"
        echo -n "  - $endpoint:$port ... "
        
        if test_connectivity "$endpoint" "$port"; then
            echo "✓ Connected"
            results+=("{\"endpoint\":\"$endpoint\",\"port\":$port,\"status\":\"connected\",\"type\":\"internal\"}")
        else
            echo "✗ Blocked/Failed"
            results+=("{\"endpoint\":\"$endpoint\",\"port\":$port,\"status\":\"blocked\",\"type\":\"internal\"}")
        fi
    done
    
    echo ""
    
    # Generate JSON report
    local results_json=""
    for result in "${results[@]}"; do
        if [ -n "$results_json" ]; then
            results_json="$results_json,"
        fi
        results_json="$results_json$result"
    done
    
    # Count blocked endpoints
    local external_blocked=0
    local internal_blocked=0
    local total_blocked=0
    
    for result in "${results[@]}"; do
        if echo "$result" | grep -q '"status":"blocked"'; then
            total_blocked=$((total_blocked + 1))
            if echo "$result" | grep -q '"type":"external"'; then
                external_blocked=$((external_blocked + 1))
            else
                internal_blocked=$((internal_blocked + 1))
            fi
        fi
    done
    
    local overall_status="healthy"
    if [ "$total_blocked" -gt 0 ]; then
        overall_status="connectivity_issues"
    fi
    
    cat > "$OUTPUT_FILE" <<EOF
{
  "ref_tag": "$REF_TAG",
  "timestamp": "$(date -Iseconds)",
  "diagnostics_type": "firewall_connectivity",
  "test_results": [
    $results_json
  ],
  "summary": {
    "total_endpoints": ${#results[@]},
    "external_blocked": $external_blocked,
    "internal_blocked": $internal_blocked,
    "overall_status": "$overall_status"
  }
}
EOF
    
    echo "Diagnostics report generated: $OUTPUT_FILE"
}

# Function to suggest firewall fixes
suggest_firewall_fixes() {
    echo ""
    echo "=== Firewall Configuration Suggestions ==="
    echo ""
    echo "For external agent communication, ensure these iptables rules are in place:"
    echo ""
    
    for endpoint in "${!EXTERNAL_APIS[@]}"; do
        local port="${EXTERNAL_APIS[$endpoint]}"
        echo "# Allow outbound to $endpoint"
        echo "iptables -A OUTPUT -d $endpoint -p tcp --dport $port -j ACCEPT"
    done
    
    echo ""
    echo "For internal infrastructure access:"
    echo ""
    
    for endpoint in "${!INTERNAL_ENDPOINTS[@]}"; do
        local port="${INTERNAL_ENDPOINTS[$endpoint]}"
        # Skip .locus.internal domains for now as they are simulated
        if [[ "$endpoint" != *.locus.internal ]]; then
            echo "# Allow internal access to $endpoint"
            echo "iptables -A INPUT -s 192.168.1.0/24 -d $endpoint -p tcp --dport $port -j ACCEPT"
        fi
    done
    
    echo ""
    echo "Alternative: Configure HTTP proxy for external API access"
    echo "export https_proxy=your-proxy-server:port"
    echo "export http_proxy=your-proxy-server:port"
}

# Function to check common firewall issues
check_common_issues() {
    echo ""
    echo "=== Common Firewall Issue Checks ==="
    echo ""
    
    # Check if we can resolve DNS
    echo -n "DNS Resolution Test ... "
    if nslookup github.com >/dev/null 2>&1; then
        echo "✓ DNS working"
    else
        echo "✗ DNS resolution failed"
    fi
    
    # Check if curl is available and working
    echo -n "HTTP Client Test ... "
    if command -v curl >/dev/null && curl -I -s -m 5 http://httpbin.org/status/200 >/dev/null 2>&1; then
        echo "✓ Basic HTTP working"
    else
        echo "✗ HTTP client issues"
    fi
    
    # Check proxy environment variables
    echo -n "Proxy Configuration ... "
    if [ -n "${https_proxy:-}" ] || [ -n "${http_proxy:-}" ]; then
        echo "✓ Proxy configured (https_proxy=${https_proxy:-none}, http_proxy=${http_proxy:-none})"
    else
        echo "ℹ No proxy configured"
    fi
}

# Function to enable offline mode for scripts
enable_offline_mode() {
    local offline_flag_file="/tmp/locus_offline_mode"
    
    echo ""
    echo "=== Enabling Offline Mode ==="
    echo ""
    echo "Creating offline mode flag for Locus automation scripts..."
    
    cat > "$offline_flag_file" <<EOF
{
  "ref_tag": "$REF_TAG",
  "enabled_at": "$(date -Iseconds)",
  "enabled_by": "firewall_diagnostics",
  "reason": "external_api_connectivity_blocked",
  "affected_scripts": [
    "freshness_loop.sh",
    "heartbeat_monitor.sh",
    "capture_context.sh"
  ],
  "fallback_mode": "local_only"
}
EOF
    
    echo "✓ Offline mode enabled"
    echo "  Flag file: $offline_flag_file"
    echo "  Scripts will now operate in local-only mode"
    echo ""
    echo "To disable offline mode: rm $offline_flag_file"
}

# Main function
main() {
    local action="${1:-check}"
    
    case "$action" in
        "check")
            perform_connectivity_tests
            check_common_issues
            ;;
        "fix")
            perform_connectivity_tests
            suggest_firewall_fixes
            ;;
        "offline")
            enable_offline_mode
            ;;
        "report")
            perform_connectivity_tests
            check_common_issues
            suggest_firewall_fixes
            ;;
        *)
            echo "Usage: $0 [check|fix|offline|report]"
            echo ""
            echo "  check   - Test connectivity and report issues"
            echo "  fix     - Test connectivity and suggest fixes"
            echo "  offline - Enable offline mode for blocked environments"
            echo "  report  - Generate comprehensive diagnostics report"
            exit 1
            ;;
    esac
}

# Run main function if script is executed directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    main "$@"
fi