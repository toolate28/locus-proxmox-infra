# Locus-Proxmox Infrastructure

This repository establishes the institutional scaffolding for **Project Locus**: automation, documentation, and CI/CD workflows to provision and manage Proxmox infrastructure including Proxmox VE, Proxmox Backup Server (PBS), and Proxmox Mail Gateway (PMG).

## Overview

The Locus-Proxmox infrastructure provides a comprehensive automation framework for managing Proxmox clusters with the following capabilities:

- **Automated VM Provisioning**: Script-based virtual machine deployment with customizable templates
- **Resource Monitoring**: Real-time monitoring of cluster resources with configurable thresholds
- **Status Reporting**: Comprehensive reporting on cluster health, VM status, and resource utilization
- **CI/CD Integration**: GitHub Actions workflows for infrastructure automation and validation
- **Configuration Management**: JSON schema validation for consistent configuration management

## Quick Start

### Prerequisites

- Proxmox VE cluster (version 7.0 or higher)
- SSH access to Proxmox nodes
- Git and Bash (for local development)

### Basic Setup

1. **Clone the repository**:
   ```bash
   git clone https://github.com/toolate28/locus-proxmox-infra.git
   cd locus-proxmox-infra
   ```

2. **Configure environment**:
   ```bash
   cp configs/.env.example configs/.env
   # Edit configs/.env with your Proxmox settings
   ```

3. **Test the setup**:
   ```bash
   ./tests/basic_tests.sh
   ```

### Usage Examples

**Check cluster resources**:
```bash
./scripts/resource_check.sh
```

**Provision a new VM**:
```bash
./scripts/vm_provision.sh --name web-server --cores 4 --memory 4096 --disk 50
```

**Generate status report**:
```bash
./scripts/status_report.sh --format json --output cluster-status.json
```

## Directory Structure

```
locus-proxmox-infra/
├── .github/workflows/     # GitHub Actions CI/CD workflows
│   ├── ci.yml            # Continuous Integration pipeline
│   ├── provision.yml     # VM provisioning workflow
│   └── freshness.yml     # Automated freshness checks
├── configs/              # Configuration files and examples
│   ├── .env.example      # Environment variables template
│   └── cluster.example.json  # Cluster configuration example
├── docs/                 # Documentation
│   └── qr-share.md      # QR code sharing guide
├── schemas/             # JSON schemas for validation
│   ├── vm-config.json   # VM configuration schema
│   ├── cluster-config.json  # Cluster configuration schema
│   └── monitoring-config.json  # Monitoring configuration schema
├── scripts/             # Automation scripts
│   ├── resource_check.sh    # Resource monitoring script
│   ├── vm_provision.sh      # VM provisioning script
│   ├── status_report.sh     # Status reporting script
│   └── generate_qr.sh       # QR code generation utility
├── tests/               # Test scripts
│   └── basic_tests.sh   # Basic validation tests
└── README.md           # This file
```

## Scripts

### Resource Check (`resource_check.sh`)
Monitors cluster resource utilization and generates alerts when thresholds are exceeded.

**Usage**:
```bash
./scripts/resource_check.sh
```

**Environment Variables**:
- `THRESHOLD_CPU`: CPU usage threshold (default: 80%)
- `THRESHOLD_MEMORY`: Memory usage threshold (default: 80%)
- `THRESHOLD_STORAGE`: Storage usage threshold (default: 85%)

### VM Provisioning (`vm_provision.sh`)
Automates virtual machine creation with customizable specifications.

**Usage**:
```bash
./scripts/vm_provision.sh [OPTIONS]

Options:
  -n, --name NAME         VM name (required)
  -i, --vmid VMID         VM ID (auto-generated if not specified)
  -t, --template TEMPLATE Template to use (default: ubuntu-22.04)
  -c, --cores CORES       Number of CPU cores (default: 2)
  -m, --memory MEMORY     Memory in MB (default: 2048)
  -d, --disk DISK         Disk size in GB (default: 20)
  -s, --storage STORAGE   Storage pool (default: local-lvm)
  --network NETWORK       Network bridge (default: vmbr0)
  -h, --help              Show help message
```

### Status Reporting (`status_report.sh`)
Generates comprehensive status reports for the Proxmox cluster.

**Usage**:
```bash
./scripts/status_report.sh [OPTIONS]

Options:
  -f, --format FORMAT     Output format: text, json, html (default: text)
  -o, --output FILE       Output file (default: stdout)
  -c, --cluster           Include cluster overview
  -n, --nodes             Include node details
  -v, --vms               Include VM status
  -s, --storage           Include storage information
  -b, --backup            Include backup status
  -h, --help              Show help message
```

## GitHub Actions Workflows

### CI Pipeline (`.github/workflows/ci.yml`)
Automated testing and validation pipeline that runs on code changes:
- Lints shell scripts with ShellCheck
- Validates JSON schemas and configurations
- Runs security scans with Trivy
- Tests script functionality
- Validates documentation

### Provisioning Workflow (`.github/workflows/provision.yml`)
Manual workflow for VM provisioning with validation:
- Input validation for VM specifications
- Resource availability checks
- Automated VM deployment
- Status reporting and artifact generation

### Freshness Check (`.github/workflows/freshness.yml`)
Scheduled workflow for infrastructure health monitoring:
- Daily resource utilization checks
- Backup freshness validation
- System update monitoring
- Certificate expiry tracking
- Consolidated health reporting

## Configuration

### Environment Variables
Copy `configs/.env.example` to `configs/.env` and customize:

```bash
# Proxmox Connection
PROXMOX_HOST=your-proxmox-host.local
PROXMOX_PORT=8006
PROXMOX_USER=root@pam

# Resource Thresholds
THRESHOLD_CPU=80
THRESHOLD_MEMORY=80
THRESHOLD_STORAGE=85

# Default VM Settings
DEFAULT_TEMPLATE=ubuntu-22.04
DEFAULT_STORAGE=local-lvm
DEFAULT_NETWORK=vmbr0
```

### JSON Schema Validation
All configurations are validated against JSON schemas in the `schemas/` directory:
- `vm-config.json`: VM provisioning configuration
- `cluster-config.json`: Cluster-wide settings
- `monitoring-config.json`: Monitoring and alerting configuration

## Testing

Run the test suite to validate your setup:

```bash
./tests/basic_tests.sh
```

The test script validates:
- Script permissions and syntax
- JSON schema validity
- GitHub Actions workflow syntax
- Configuration file format

## Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature-name`
3. Make your changes and test them: `./tests/basic_tests.sh`
4. Commit your changes: `git commit -m "Description of changes"`
5. Push to your fork: `git push origin feature-name`
6. Create a pull request

## Security Considerations

- **Secrets Management**: Never commit sensitive credentials to the repository
- **Access Control**: Use appropriate Proxmox user permissions
- **Network Security**: Configure firewall rules for Proxmox API access
- **Backup Security**: Ensure backup storage is properly secured

## Support

For issues and questions:
1. Check the [documentation](docs/)
2. Review existing [GitHub Issues](https://github.com/toolate28/locus-proxmox-infra/issues)
3. Create a new issue with detailed information

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Version History

- **v1.0.0** (Initial Release): Basic infrastructure setup with automation scripts, CI/CD workflows, and monitoring capabilities
