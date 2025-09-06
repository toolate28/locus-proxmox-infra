#!/bin/bash
# Project Locus - Bootstrap Installation Script
# One-line installation and validation for Project Locus infrastructure

set -euo pipefail

# Configuration
REPO_URL="https://github.com/toolate28/locus-proxmox-infra.git"
INSTALL_DIR="${HOME}/locus-proxmox-infra"
VALIDATE_ONLY=false

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Print colored output
print_header() {
    echo -e "${PURPLE}"
    echo "██╗      ██████╗  ██████╗██╗   ██╗███████╗"
    echo "██║     ██╔═══██╗██╔════╝██║   ██║██╔════╝"
    echo "██║     ██║   ██║██║     ██║   ██║███████╗"
    echo "██║     ██║   ██║██║     ██║   ██║╚════██║"
    echo "███████╗╚██████╔╝╚██████╗╚██████╔╝███████║"
    echo "╚══════╝ ╚═════╝  ╚═════╝ ╚═════╝ ╚══════╝"
    echo -e "${NC}"
    echo -e "${CYAN}Multi-Agent Proxmox Infrastructure Orchestration${NC}"
    echo -e "${YELLOW}Bootstrap Installation Script${NC}"
    echo
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Check if running with validation flag
if [[ "${1:-}" == "--validate" ]]; then
    VALIDATE_ONLY=true
    print_info "Running in validation mode only"
fi

# Function to check prerequisites
check_prerequisites() {
    print_info "Checking system prerequisites..."
    
    local missing_deps=()
    
    # Check required commands
    for cmd in git bash jq curl; do
        if ! command -v "$cmd" &> /dev/null; then
            missing_deps+=("$cmd")
        else
            print_success "$cmd is available"
        fi
    done
    
    # Check optional but recommended commands
    for cmd in qrencode shellcheck; do
        if ! command -v "$cmd" &> /dev/null; then
            print_warning "$cmd is not installed (recommended)"
        else
            print_success "$cmd is available"
        fi
    done
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        print_error "Missing required dependencies: ${missing_deps[*]}"
        print_info "Install with: sudo apt-get update && sudo apt-get install -y ${missing_deps[*]}"
        exit 1
    fi
    
    print_success "All required prerequisites met"
}

# Function to install dependencies
install_dependencies() {
    print_info "Installing system dependencies..."
    
    # Detect package manager
    if command -v apt-get &> /dev/null; then
        print_info "Using apt package manager"
        sudo apt-get update
        sudo apt-get install -y bash jq qrencode shellcheck curl git
    elif command -v yum &> /dev/null; then
        print_info "Using yum package manager"
        sudo yum install -y bash jq qrencode shellcheck curl git
    elif command -v brew &> /dev/null; then
        print_info "Using homebrew package manager"
        brew install bash jq qrencode shellcheck curl git
    else
        print_warning "Could not detect package manager. Please install dependencies manually:"
        print_info "Required: bash jq curl git"
        print_info "Recommended: qrencode shellcheck"
    fi
}

# Function to clone repository
clone_repository() {
    print_info "Cloning Project Locus repository..."
    
    if [ -d "$INSTALL_DIR" ]; then
        print_warning "Directory $INSTALL_DIR already exists"
        read -p "Remove and re-clone? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm -rf "$INSTALL_DIR"
        else
            print_info "Using existing directory"
            cd "$INSTALL_DIR"
            git pull origin main
            return
        fi
    fi
    
    git clone "$REPO_URL" "$INSTALL_DIR"
    cd "$INSTALL_DIR"
    print_success "Repository cloned successfully"
}

# Function to setup scripts
setup_scripts() {
    print_info "Setting up automation scripts..."
    
    # Make scripts executable
    chmod +x automation/*.sh scripts/*.sh
    print_success "Scripts made executable"
    
    # Validate scripts with shellcheck if available
    if command -v shellcheck &> /dev/null; then
        print_info "Running shellcheck validation..."
        shellcheck automation/*.sh scripts/*.sh && print_success "Shellcheck validation passed" || print_warning "Shellcheck found warnings (acceptable)"
    else
        print_warning "Shellcheck not available, skipping script validation"
    fi
}

# Function to run validation tests
run_validation() {
    print_info "Running Project Locus validation tests..."
    
    local validation_start=$(date +%s)
    
    # Test REF tag generation
    print_info "Testing REF tag generation..."
    if REF_TAG=$(./automation/generate_ref_tag.sh task "bootstrap-validation" 2>/dev/null); then
        print_success "REF tag generated: $REF_TAG"
    else
        print_error "REF tag generation failed"
        return 1
    fi
    
    # Test resource check
    print_info "Testing resource check automation..."
    if timeout 10 ./automation/resource_check.sh >/dev/null 2>&1; then
        print_success "Resource check completed"
    else
        print_error "Resource check failed or timed out"
        return 1
    fi
    
    # Test status report
    print_info "Testing status report generation..."
    if timeout 10 ./automation/status_report.sh >/dev/null 2>&1; then
        print_success "Status report generated"
    else
        print_error "Status report generation failed or timed out"
        return 1
    fi
    
    # Test VM provisioning simulation
    print_info "Testing VM provisioning simulation..."
    if timeout 10 ./automation/vm_provision.sh web "bootstrap-test-vm" >/dev/null 2>&1; then
        print_success "VM provisioning simulation completed"
    else
        print_error "VM provisioning simulation failed or timed out"
        return 1
    fi
    
    # Test heartbeat monitoring
    print_info "Testing heartbeat monitoring..."
    if timeout 10 ./automation/heartbeat_monitor.sh >/dev/null 2>&1; then
        print_success "Heartbeat monitoring completed"
    else
        print_error "Heartbeat monitoring failed or timed out"
        return 1
    fi
    
    local validation_end=$(date +%s)
    local validation_time=$((validation_end - validation_start))
    
    print_success "All validation tests passed in ${validation_time} seconds"
    
    # Verify execution time requirements
    if [ $validation_time -le 15 ]; then
        print_success "Performance requirement met (all tests < 15 seconds)"
    else
        print_warning "Performance warning: tests took ${validation_time} seconds (target: <15s)"
    fi
}

# Function to display next steps
show_next_steps() {
    print_info "Installation complete! Next steps:"
    echo
    echo -e "${CYAN}📋 Quick Commands:${NC}"
    echo -e "  ${GREEN}cd $INSTALL_DIR${NC}"
    echo -e "  ${GREEN}./automation/generate_ref_tag.sh task \"my-first-task\"${NC}"
    echo -e "  ${GREEN}./automation/resource_check.sh${NC}"
    echo -e "  ${GREEN}./automation/status_report.sh${NC}"
    echo
    echo -e "${CYAN}📚 Documentation:${NC}"
    echo -e "  ${GREEN}cat README.md${NC}                     # Main documentation"
    echo -e "  ${GREEN}cat docs/onboarding_playbook.md${NC}   # Comprehensive training (2.5 hours)"
    echo -e "  ${GREEN}cat CONTRIBUTING.md${NC}               # Contribution guidelines"
    echo
    echo -e "${CYAN}🤖 Agent Setup:${NC}"
    echo -e "  ${GREEN}cat docs/connector_guide.md${NC}       # Agent integration guide"
    echo -e "  ${GREEN}cat CLAUDE.md${NC}                     # Claude Pro MCP setup"
    echo -e "  ${GREEN}cat docs/user-ai-directive-guide.md${NC} # Multi-agent workflows"
    echo
    echo -e "${CYAN}🔒 Security:${NC}"
    echo -e "  ${GREEN}cat SECURITY.md${NC}                   # Security policy and reporting"
    echo
    print_success "Welcome to Project Locus! 🚀"
}

# Main execution
main() {
    print_header
    
    # Check prerequisites first
    check_prerequisites
    
    if [ "$VALIDATE_ONLY" = true ]; then
        print_info "Validation-only mode - skipping installation steps"
        if [ -d "$INSTALL_DIR" ]; then
            cd "$INSTALL_DIR"
            run_validation
        else
            print_error "Project Locus not found at $INSTALL_DIR"
            print_info "Run without --validate flag to install first"
            exit 1
        fi
        return
    fi
    
    # Full installation flow
    install_dependencies
    clone_repository
    setup_scripts
    run_validation
    show_next_steps
}

# Error handling
trap 'print_error "Installation failed on line $LINENO"' ERR

# Run main function
main "$@"