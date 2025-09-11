#!/bin/bash
# REF Tag Generator for Project Locus
# Usage: ./generate_ref_tag.sh <type> [description]

set -euo pipefail

# Configuration
REF_PREFIX="LOCUS"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
COUNTER_FILE="/tmp/locus_ref_counter"

# Initialize counter file if it doesn't exist
if [ ! -f "$COUNTER_FILE" ]; then
    echo "001" > "$COUNTER_FILE"
fi

# Function to generate REF tag
generate_ref_tag() {
    local type="$1"
    local description="${2:-}"
    
    # Read and increment counter
    local counter
    local next_counter
    counter=$(cat "$COUNTER_FILE")
    next_counter=$(printf "%03d" $((10#$counter + 1)))
    echo "$next_counter" > "$COUNTER_FILE"
    
    # Generate REF tag based on type
    case "$type" in
        "task")
            echo "${REF_PREFIX}-TASK${TIMESTAMP}-${counter}"
            ;;
        "agent")
            echo "${REF_PREFIX}-AGENT-${counter}"
            ;;
        "resource")
            echo "${REF_PREFIX}-RES-${counter}"
            ;;
        "job")
            echo "${REF_PREFIX}-JOB${TIMESTAMP}-${counter}"
            ;;
        "artifact")
            echo "${REF_PREFIX}-ART${TIMESTAMP}-${counter}"
            ;;
        "notify")
            echo "${REF_PREFIX}-NOTIFY-${TIMESTAMP}-${counter}"
            ;;
        "research")
            echo "${REF_PREFIX}-RESEARCH-${TIMESTAMP}-${counter}"
            ;;
        "dash")
            echo "${REF_PREFIX}-DASH-${TIMESTAMP}-${counter}"
            ;;
        "dashboard")
            echo "${REF_PREFIX}-DASH-${TIMESTAMP}-${counter}"
            ;;
        "schema")
            echo "${REF_PREFIX}-SCHEMA-${TIMESTAMP}-${counter}"
            ;;
        "validate")
            echo "${REF_PREFIX}-VALIDATE-${TIMESTAMP}-${counter}"
            ;;
        "deploy")
            echo "${REF_PREFIX}-DEPLOY-${TIMESTAMP}-${counter}"
            ;;
        *)
            echo "${REF_PREFIX}-${type^^}${TIMESTAMP}-${counter}"
            ;;
    esac
    
    # Log generation for audit trail
    echo "$(date -Iseconds): Generated REF tag ${REF_PREFIX}-${type^^}${TIMESTAMP}-${counter} ${description}" >> /tmp/locus_ref_audit.log
}

# Main execution
if [ $# -lt 1 ]; then
    echo "Usage: $0 <type> [description]"
    echo "Types: task, agent, resource, job, artifact, notify, research, dash, schema, validate, deploy, or custom"
    echo "Example: $0 task 'VM provisioning handover'"
    echo "Example: $0 notify 'System-wide notification'"
    echo "Example: $0 research 'Infrastructure analysis'"
    exit 1
fi

TYPE="$1"
DESCRIPTION="${2:-}"

REF_TAG=$(generate_ref_tag "$TYPE" "$DESCRIPTION")
echo "$REF_TAG"

# Optional: Export to environment for scripting
export LOCUS_CURRENT_REF="$REF_TAG"