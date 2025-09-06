#!/bin/bash
# Deployment Script for LOCUS Testing Forks
# Deploys Fork A, B, and C testing environments

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Generate REF tag for deployment
REF_TAG=$("$SCRIPT_DIR/automation/generate_ref_tag.sh" "job" "fork-deployment")

# Function to deploy Fork A
deploy_fork_a() {
    echo "=== Deploying Fork A: Core Coordination Validation ==="
    echo "REF: LOCUS-FORK-A-001"
    echo "Deployment REF: $REF_TAG"
    
    # Core Machine Setup
    echo "Setting up core machine..."
    ./automation/sync_ref_state.sh --init-core
    
    # Test basic functionality
    echo "Testing core coordination..."
    python3 ./validation/coordination_test.py
    
    echo "✓ Fork A deployment completed"
    echo "Usage: ./automation/sync_ref_state.sh --sync [target_machine]"
    echo "       python3 ./automation/agent_handover.py create <from> <to> <task>"
}

# Function to deploy Fork B
deploy_fork_b() {
    echo "=== Deploying Fork B: Constitutional Constraint Validation ==="
    echo "REF: LOCUS-FORK-B-001"
    echo "Deployment REF: $REF_TAG"
    
    # Start principle monitoring
    echo "Starting constitutional monitoring..."
    python3 ./monitoring/principle_tracker.py
    
    # Test constitutional enforcement
    echo "Testing constitutional constraints..."
    python3 ./validation/constitutional_test.py
    
    echo "✓ Fork B deployment completed"
    echo "Usage: python3 ./monitoring/principle_tracker.py --start-monitoring"
    echo "       ./automation/emergency_halt.sh --halt <reason> <severity>"
}

# Function to deploy Fork C
deploy_fork_c() {
    echo "=== Deploying Fork C: Community Template Discovery ==="
    echo "REF: LOCUS-FORK-C-001"
    echo "Deployment REF: $REF_TAG"
    
    # Index templates
    echo "Indexing community templates..."
    python3 ./discovery/template_matcher.py list
    
    # Test template matching
    echo "Testing template discovery..."
    python3 ./validation/community_impact_test.py
    
    echo "✓ Fork C deployment completed"
    echo "Usage: python3 ./discovery/template_matcher.py match <user_type> [needs...]"
    echo "       python3 ./integration/tool_coordinator.py"
}

# Function to run comprehensive validation
run_comprehensive_validation() {
    echo "=== Running Comprehensive Cross-Fork Validation ==="
    echo "Deployment REF: $REF_TAG"
    
    python3 ./validation/cross_fork_validation.py
    
    echo "✓ Comprehensive validation completed"
}

# Function to show usage
usage() {
    echo "Usage: $0 [fork-a|fork-b|fork-c|all|validate]"
    echo ""
    echo "Commands:"
    echo "  fork-a    Deploy Fork A: Core Coordination Validation"
    echo "  fork-b    Deploy Fork B: Constitutional Constraint Validation"
    echo "  fork-c    Deploy Fork C: Community Template Discovery"
    echo "  all       Deploy all three forks sequentially"
    echo "  validate  Run comprehensive cross-fork validation"
    echo ""
    echo "Examples:"
    echo "  $0 fork-a"
    echo "  $0 all"
    echo "  $0 validate"
}

# Main execution
main() {
    case "${1:-}" in
        "fork-a")
            deploy_fork_a
            ;;
        "fork-b")
            deploy_fork_b
            ;;
        "fork-c")
            deploy_fork_c
            ;;
        "all")
            echo "=== LOCUS Testing Forks: Complete Deployment ==="
            echo "Deployment REF: $REF_TAG"
            echo "Started: $(date -Iseconds)"
            echo ""
            
            deploy_fork_a
            echo ""
            deploy_fork_b
            echo ""
            deploy_fork_c
            echo ""
            
            echo "=== All Forks Deployed Successfully ==="
            echo "Ready for validation testing"
            ;;
        "validate")
            run_comprehensive_validation
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