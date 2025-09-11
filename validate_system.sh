#!/bin/bash
# LOCUS System Validation Script
# Comprehensive testing of all notification & context tracking components

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_test() {
    echo -e "${BLUE}🧪 Testing: $1${NC}"
}

print_pass() {
    echo -e "${GREEN}✅ PASS: $1${NC}"
}

print_fail() {
    echo -e "${RED}❌ FAIL: $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ️  INFO: $1${NC}"
}

# Test counter
TESTS_RUN=0
TESTS_PASSED=0

run_test() {
    local test_name="$1"
    local test_command="$2"
    
    TESTS_RUN=$((TESTS_RUN + 1))
    print_test "$test_name"
    
    if eval "$test_command" >/dev/null 2>&1; then
        print_pass "$test_name"
        TESTS_PASSED=$((TESTS_PASSED + 1))
        return 0
    else
        print_fail "$test_name"
        return 1
    fi
}

echo "╔════════════════════════════════════════════════════════════════════╗"
echo "║                LOCUS SYSTEM VALIDATION SUITE                      ║"
echo "╠════════════════════════════════════════════════════════════════════╣"
echo "║ Enhanced Notification & Context Tracking Framework v1.0.0         ║"
echo "╚════════════════════════════════════════════════════════════════════╝"
echo ""

print_info "Starting comprehensive system validation..."
echo ""

# Test 1: CLI Interface
print_test "Unified CLI Interface"
if [ -x "$SCRIPT_DIR/locus" ]; then
    if "$SCRIPT_DIR/locus" version >/dev/null 2>&1; then
        print_pass "CLI interface operational"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        print_fail "CLI version command failed"
    fi
else
    print_fail "locus CLI not executable"
fi
TESTS_RUN=$((TESTS_RUN + 1))

# Test 2: REF Tag Generation
run_test "REF Tag Generation" \
    "$SCRIPT_DIR/automation/scripts/generate_ref_tag.sh notify 'validation-test'"

# Test 3: Context Receipt System
print_test "Context Receipt Generation"
if REF_TAG=$("$SCRIPT_DIR/automation/scripts/generate_ref_tag.sh" validate "receipt-test" 2>/dev/null); then
    if "$SCRIPT_DIR/automation/scripts/generate_context_receipt.sh" "$REF_TAG" "validation_test" '{"test":true}' >/dev/null 2>&1; then
        print_pass "Context receipt generation"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        print_fail "Context receipt generation failed"
    fi
else
    print_fail "REF tag generation for receipt test failed"
fi
TESTS_RUN=$((TESTS_RUN + 1))

# Test 4: Visual Monitoring
run_test "Visual Context Monitor" \
    "$SCRIPT_DIR/automation/scripts/visual_context_monitor.sh health"

# Test 5: JavaScript Toolkit
if command -v node >/dev/null 2>&1; then
    run_test "JavaScript Context Toolkit" \
        "node $SCRIPT_DIR/automation/scripts/context_toolkit.js validate 'js-test' '{\"js_test\":true}'"
else
    print_info "Node.js not available, skipping JavaScript toolkit test"
fi

# Test 6: Python Toolkit
if command -v python3 >/dev/null 2>&1; then
    run_test "Python Context Toolkit" \
        "python3 $SCRIPT_DIR/automation/scripts/context_toolkit.py validate --trigger 'py-test' --changes '{\"py_test\":true}'"
else
    print_info "Python3 not available, skipping Python toolkit test"
fi

# Test 7: Status Reporting
run_test "Status Report Generation" \
    "$SCRIPT_DIR/automation/scripts/status_report.sh"

# Test 8: Health Monitoring
run_test "Health Monitoring System" \
    "$SCRIPT_DIR/locus health"

# Test 9: Notification System
run_test "System Notification" \
    "$SCRIPT_DIR/locus notify 'Validation test notification'"

# Test 10: Research Event
run_test "Research Event Generation" \
    "$SCRIPT_DIR/locus research 'Validation research test'"

# Test 11: Dashboard Update
run_test "Dashboard Update" \
    "$SCRIPT_DIR/locus dash 'Validation dashboard test'"

# Test 12: Schema Modification
run_test "Schema Modification Event" \
    "$SCRIPT_DIR/locus schema 'Validation schema test'"

# Test 13: Deployment Event
run_test "Deployment Event" \
    "$SCRIPT_DIR/locus deploy 'Validation deployment test'"

# Test 14: Audit Trail
run_test "Audit Trail Display" \
    "$SCRIPT_DIR/locus trail"

# Test 15: Context Delta
run_test "Context Delta Visualization" \
    "$SCRIPT_DIR/locus delta"

# Test 16: Timeline View
run_test "Timeline Visualization" \
    "$SCRIPT_DIR/locus timeline"

# Test 17: Receipt Inventory
run_test "Receipt Inventory" \
    "$SCRIPT_DIR/locus receipts"

# Test 18: Context Capture
run_test "Context Event Capture" \
    "$SCRIPT_DIR/locus capture validate 'capture-test' --changes '{\"captured\":true}'"

# Test 19: File Integrity
print_test "Generated File Integrity"
receipt_count=$(ls /tmp/locus_receipts/receipt_*.json 2>/dev/null | wc -l)
if [ "$receipt_count" -gt 0 ]; then
    # Check if receipts are valid JSON
    valid_receipts=0
    for receipt in /tmp/locus_receipts/receipt_*.json; do
        if jq '.' "$receipt" >/dev/null 2>&1; then
            valid_receipts=$((valid_receipts + 1))
        fi
    done
    
    if [ "$valid_receipts" -eq "$receipt_count" ]; then
        print_pass "All $receipt_count receipts are valid JSON"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        print_fail "Some receipts have invalid JSON format"
    fi
else
    print_fail "No receipts found"
fi
TESTS_RUN=$((TESTS_RUN + 1))

# Test 20: Security Features
print_test "Cryptographic Security Features"
if latest_receipt=$(ls -t /tmp/locus_receipts/receipt_*.json 2>/dev/null | head -1); then
    if jq -e '.validation.cryptographic_signature' "$latest_receipt" >/dev/null 2>&1 && \
       jq -e '.validation.audit_fingerprint' "$latest_receipt" >/dev/null 2>&1 && \
       jq -e '.security.signature_algorithm' "$latest_receipt" >/dev/null 2>&1; then
        print_pass "Cryptographic security features present"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        print_fail "Security features missing in receipts"
    fi
else
    print_fail "No receipts available for security validation"
fi
TESTS_RUN=$((TESTS_RUN + 1))

echo ""
echo "╔════════════════════════════════════════════════════════════════════╗"
echo "║                    VALIDATION RESULTS                              ║"
echo "╠════════════════════════════════════════════════════════════════════╣"
printf "║ Tests Run: %-8d | Tests Passed: %-8d | Success Rate: %5.1f%% ║\n" \
    "$TESTS_RUN" "$TESTS_PASSED" "$(echo "scale=1; $TESTS_PASSED * 100 / $TESTS_RUN" | bc -l)"
echo "╚════════════════════════════════════════════════════════════════════╝"
echo ""

# Final assessment
if [ "$TESTS_PASSED" -eq "$TESTS_RUN" ]; then
    echo -e "${GREEN}🎉 ALL TESTS PASSED - SYSTEM FULLY OPERATIONAL${NC}"
    echo ""
    echo "✅ Enhanced Notification & Context Tracking Framework is ready for production use"
    echo "✅ All components validated and functioning correctly"
    echo "✅ Security and compliance features active"
    echo "✅ Multi-agent coordination visibility operational"
    exit 0
elif [ "$TESTS_PASSED" -gt $((TESTS_RUN * 80 / 100)) ]; then
    echo -e "${YELLOW}⚠️  MOSTLY OPERATIONAL - Some minor issues detected${NC}"
    echo ""
    echo "ℹ️  System is functional but some components may need attention"
    exit 1
else
    echo -e "${RED}❌ SYSTEM ISSUES DETECTED - Manual intervention required${NC}"
    echo ""
    echo "⚠️  Multiple test failures indicate system problems"
    exit 2
fi