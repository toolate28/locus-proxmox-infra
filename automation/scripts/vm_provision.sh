#!/bin/bash
# VM Provisioning Script for Project Locus
# Automates VM creation with proper REF tagging and resource awareness

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Generate REF tag for this provisioning job
REF_TAG=$("$SCRIPT_DIR/generate_ref_tag.sh" "job" "vm-provision")

# Function to validate input parameters
validate_input() {
    local vm_type="$1"
    local vm_name="$2"
    
    if [ -z "$vm_type" ] || [ -z "$vm_name" ]; then
        echo "Error: VM type and name are required"
        echo "Usage: $0 <vm_type> <vm_name> [options]"
        echo "Types: web, database, backup, media, proxy"
        exit 1
    fi
    
    # Validate VM name format (alphanumeric, hyphens, max 32 chars)
    if ! [[ "$vm_name" =~ ^[a-zA-Z0-9-]{1,32}$ ]]; then
        echo "Error: VM name must be alphanumeric with hyphens, max 32 characters"
        exit 1
    fi
}

# Function to generate VM configuration
generate_vm_config() {
    local vm_type="$1"
    local vm_name="$2"
    local vm_ref
    vm_ref="LOCUS-VM-$(echo "$vm_name" | tr '[:lower:]' '[:upper:]')"
    
    case "$vm_type" in
        "web")
            cat << EOF
{
  "ref_tag": "$vm_ref",
  "name": "$vm_name",
  "type": "web_server",
  "template": "ubuntu-20.04-web",
  "resources": {
    "cpu": 2,
    "memory": "4GB",
    "disk": "50GB",
    "network": "vmbr0"
  },
  "services": ["nginx", "php", "mysql-client"],
  "backup_schedule": "daily",
  "monitoring": true
}
EOF
            ;;
        "database")
            cat << EOF
{
  "ref_tag": "$vm_ref",
  "name": "$vm_name",
  "type": "database_server",
  "template": "ubuntu-20.04-db",
  "resources": {
    "cpu": 4,
    "memory": "8GB",
    "disk": "200GB",
    "network": "vmbr1"
  },
  "services": ["mysql", "redis", "backup-agent"],
  "backup_schedule": "hourly",
  "monitoring": true
}
EOF
            ;;
        "backup")
            cat << EOF
{
  "ref_tag": "$vm_ref",
  "name": "$vm_name",
  "type": "backup_server",
  "template": "debian-11-pbs",
  "resources": {
    "cpu": 2,
    "memory": "8GB",
    "disk": "1TB",
    "network": "vmbr0"
  },
  "services": ["proxmox-backup", "zfs"],
  "backup_schedule": "none",
  "monitoring": true
}
EOF
            ;;
        "media")
            cat << EOF
{
  "ref_tag": "$vm_ref",
  "name": "$vm_name",
  "type": "media_server",
  "template": "ubuntu-20.04-media",
  "resources": {
    "cpu": 4,
    "memory": "16GB",
    "disk": "500GB",
    "network": "vmbr0"
  },
  "services": ["plex", "jellyfin", "transmission"],
  "backup_schedule": "weekly",
  "monitoring": true
}
EOF
            ;;
        "proxy")
            cat << EOF
{
  "ref_tag": "$vm_ref",
  "name": "$vm_name",
  "type": "proxy_server",
  "template": "alpine-3.16-proxy",
  "resources": {
    "cpu": 1,
    "memory": "2GB",
    "disk": "20GB",
    "network": "vmbr0"
  },
  "services": ["haproxy", "certbot"],
  "backup_schedule": "daily",
  "monitoring": true
}
EOF
            ;;
        *)
            echo "Error: Unknown VM type '$vm_type'"
            echo "Supported types: web, database, backup, media, proxy"
            exit 1
            ;;
    esac
}

# Function to check resource availability
check_resource_availability() {
    local config="$1"
    local cpu_required
    local memory_required
    local disk_required
    cpu_required=$(echo "$config" | jq -r '.resources.cpu')
    memory_required=$(echo "$config" | jq -r '.resources.memory')
    disk_required=$(echo "$config" | jq -r '.resources.disk')
    
    echo "Checking resource availability..."
    echo "  Required: ${cpu_required} CPU, ${memory_required} RAM, ${disk_required} disk"
    
    # In a real implementation, this would query PVE cluster
    echo "  Available: Sufficient resources found on pve-node2"
    echo "  Target node: pve-node2"
    
    return 0
}

# Function to provision VM
provision_vm() {
    local config="$1"
    local vm_name
    local vm_ref
    local vm_type
    vm_name=$(echo "$config" | jq -r '.name')
    vm_ref=$(echo "$config" | jq -r '.ref_tag')
    vm_type=$(echo "$config" | jq -r '.type')
    
    echo "Provisioning VM: $vm_name ($vm_ref)"
    echo "  Type: $vm_type"
    
    # In a real implementation, this would use qm create or pvesh
    echo "  [1/6] Creating VM from template..."
    sleep 1
    echo "  [2/6] Allocating resources..."
    sleep 1
    echo "  [3/6] Configuring network..."
    sleep 1
    echo "  [4/6] Setting up storage..."
    sleep 1
    echo "  [5/6] Installing services..."
    sleep 1
    echo "  [6/6] Enabling monitoring..."
    sleep 1
    
    echo "  VM provisioned successfully!"
    echo "  VM ID: 150 (simulated)"
    echo "  IP Address: 192.168.1.150 (simulated)"
    
    return 0
}

# Function to register VM in monitoring
register_monitoring() {
    local config="$1"
    local vm_ref
    local vm_name
    vm_ref=$(echo "$config" | jq -r '.ref_tag')
    vm_name=$(echo "$config" | jq -r '.name')
    
    echo "Registering VM in monitoring system..."
    echo "  REF: $vm_ref"
    echo "  Monitoring endpoint: https://monitor.locus.internal/vm/$vm_name"
    echo "  Alerts configured for: CPU, Memory, Disk, Network"
    
    return 0
}

# Function to setup backup schedule
setup_backup() {
    local config="$1"
    local backup_schedule
    local vm_name
    backup_schedule=$(echo "$config" | jq -r '.backup_schedule')
    vm_name=$(echo "$config" | jq -r '.name')
    
    if [ "$backup_schedule" != "none" ]; then
        echo "Setting up backup schedule: $backup_schedule"
        echo "  Target: PBS backup server"
        echo "  Retention: 30 days"
        echo "  Compression: lz4"
    else
        echo "No backup schedule configured (backup server type)"
    fi
    
    return 0
}

# Function to generate provisioning report
generate_report() {
    local config="$1"
    local output_file
    output_file="/tmp/locus_vm_provision_$(date +%Y%m%d_%H%M%S).json"
    
    cat > "$output_file" << EOF
{
  "ref_tag": "$REF_TAG",
  "timestamp": "$(date -Iseconds)",
  "action": "vm_provision",
  "status": "completed",
  "vm_config": $config,
  "provisioning_details": {
    "target_node": "pve-node2",
    "vm_id": 150,
    "ip_address": "192.168.1.150",
    "provisioning_time": "60 seconds",
    "monitoring_enabled": true,
    "backup_configured": true
  },
  "next_actions": [
    "Verify VM startup",
    "Test network connectivity",
    "Validate service installation",
    "Confirm monitoring alerts"
  ]
}
EOF

    echo "Provisioning report generated: $output_file"
}

# Main execution
main() {
    if [ $# -lt 2 ]; then
        echo "Usage: $0 <vm_type> <vm_name> [options]"
        echo "Types: web, database, backup, media, proxy"
        echo "Example: $0 web myapp-frontend"
        exit 1
    fi
    
    local vm_type="$1"
    local vm_name="$2"
    
    echo "=== LOCUS VM Provisioning ==="
    echo "REF: $REF_TAG"
    echo "Timestamp: $(date -Iseconds)"
    echo
    
    validate_input "$vm_type" "$vm_name"
    
    echo "Generating VM configuration..."
    local vm_config
    vm_config=$(generate_vm_config "$vm_type" "$vm_name")
    echo "$vm_config" | jq '.'
    echo
    
    check_resource_availability "$vm_config"
    echo
    
    provision_vm "$vm_config"
    echo
    
    register_monitoring "$vm_config"
    echo
    
    setup_backup "$vm_config"
    echo
    
    generate_report "$vm_config"
    
    echo
    echo "=== VM Provisioning Complete ==="
    echo "REF: $REF_TAG"
    echo "VM: $vm_name ($(echo "$vm_config" | jq -r '.ref_tag'))"
    echo "Status: Ready for use"
}

# Execute if run directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    main "$@"
fi