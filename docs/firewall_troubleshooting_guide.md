# Firewall Troubleshooting Guide - Project Locus

## Overview

This guide addresses firewall connectivity issues that can block Project Locus multi-agent coordination functionality. When external API endpoints (api.anthropic.com, api.perplexity.ai, lumo.proton.me) are blocked by firewall rules, the system provides fallback mechanisms and diagnostic tools.

## Quick Diagnosis

### 1. Run Firewall Diagnostics

```bash
# Quick connectivity check
./automation/scripts/firewall_diagnostics.sh check

# Comprehensive report with fixes
./automation/scripts/firewall_diagnostics.sh report
```

### 2. Check Specific Endpoints

```bash
# Test Claude API
curl -I -s -m 5 https://api.anthropic.com

# Test Perplexity API  
curl -I -s -m 5 https://api.perplexity.ai

# Test Proton Lumo
curl -I -s -m 5 https://lumo.proton.me
```

## Common Firewall Issues

### 1. External API Endpoints Blocked

**Symptoms:**
- Scripts report "Connection blocked/failed"
- External API connectivity tests fail
- Multi-agent coordination features unavailable

**Solution Options:**

#### Option A: Configure Firewall Rules (Recommended)
```bash
# Allow outbound HTTPS to agent APIs
iptables -A OUTPUT -d api.anthropic.com -p tcp --dport 443 -j ACCEPT
iptables -A OUTPUT -d api.perplexity.ai -p tcp --dport 443 -j ACCEPT  
iptables -A OUTPUT -d lumo.proton.me -p tcp --dport 443 -j ACCEPT

# Save rules (distribution-specific)
# Ubuntu/Debian: iptables-save > /etc/iptables/rules.v4
# RHEL/CentOS: service iptables save
```

#### Option B: Configure HTTP Proxy
```bash
# Set proxy environment variables
export https_proxy=your-proxy-server:port
export http_proxy=your-proxy-server:port

# Make permanent in ~/.bashrc or /etc/environment
echo 'export https_proxy=your-proxy-server:port' >> ~/.bashrc
```

#### Option C: Enable Offline Mode
```bash
# Enable offline mode for restricted environments
./automation/scripts/firewall_diagnostics.sh offline

# Scripts will operate in local-only mode
# Verify offline mode is working
./automation/scripts/freshness_loop.sh
./automation/scripts/heartbeat_monitor.sh
```

### 2. DNS Resolution Issues

**Symptoms:**
- DNS resolution test fails in diagnostics
- "Name or service not known" errors

**Solution:**
```bash
# Check DNS configuration
cat /etc/resolv.conf

# Test DNS resolution
nslookup api.anthropic.com
dig api.anthropic.com

# Configure public DNS if needed
echo 'nameserver 8.8.8.8' >> /etc/resolv.conf
echo 'nameserver 1.1.1.1' >> /etc/resolv.conf
```

### 3. Corporate/Enterprise Firewall

**Symptoms:**
- All external connectivity blocked
- Proxy required for internet access
- Certificate validation errors

**Solution:**
```bash
# Configure corporate proxy
export https_proxy=corporate-proxy.company.com:8080
export http_proxy=corporate-proxy.company.com:8080

# Configure proxy authentication if required
export https_proxy=username:password@proxy.company.com:8080

# Add corporate CA certificates
cp corporate-ca.crt /usr/local/share/ca-certificates/
update-ca-certificates

# Request firewall exceptions for:
# - api.anthropic.com:443
# - api.perplexity.ai:443  
# - lumo.proton.me:443
```

## Offline Mode Operations

When external APIs are blocked, Project Locus can operate in offline mode:

### Enable Offline Mode
```bash
./automation/scripts/firewall_diagnostics.sh offline
```

### Offline Mode Features
- ✅ Local infrastructure monitoring
- ✅ Resource checks and reporting
- ✅ VM provisioning simulation
- ✅ Status report generation
- ✅ REF tag management
- ❌ External research via Perplexity
- ❌ Real-time agent coordination
- ❌ External data enrichment

### Disable Offline Mode
```bash
# Remove offline mode flag
rm /tmp/locus_offline_mode

# Verify external connectivity restored
./automation/scripts/firewall_diagnostics.sh check
```

## Validation Workflow

After implementing firewall fixes:

### 1. Test Connectivity
```bash
./automation/scripts/firewall_diagnostics.sh check
```

### 2. Validate Agent Operations
```bash
# Remove offline mode if enabled
rm -f /tmp/locus_offline_mode

# Test agent heartbeat
./automation/scripts/heartbeat_monitor.sh

# Test research functionality  
./automation/scripts/freshness_loop.sh
```

### 3. Run Full Validation
```bash
# Complete validation sequence
./automation/scripts/generate_ref_tag.sh task "validation-post-firewall-fix"
./automation/scripts/resource_check.sh
./automation/scripts/vm_provision.sh web "test-firewall-fix"
./automation/scripts/status_report.sh
./automation/scripts/heartbeat_monitor.sh
./automation/scripts/freshness_loop.sh
```

## Network Requirements Summary

### Required Outbound Access
| Endpoint | Port | Purpose | Critical |
|----------|------|---------|----------|
| api.anthropic.com | 443 | Claude Pro API | Yes |
| api.perplexity.ai | 443 | Research API | Yes |  
| lumo.proton.me | 443 | Secure Communications | Yes |
| github.com | 443 | Repository Access | No* |
| raw.githubusercontent.com | 443 | Asset Downloads | No* |

*Required for development/updates only

### Internal Network Access
| Endpoint | Port | Purpose |
|----------|------|---------|
| pve.locus.internal | 8006 | Proxmox VE API |
| pbs.locus.internal | 8007 | Proxmox Backup Server |
| monitor.locus.internal | 443 | Monitoring Dashboard |
| hooks.locus.internal | 443 | Webhook Service |

## Emergency Procedures

### Immediate Firewall Block Resolution
```bash
# 1. Enable offline mode immediately
./automation/scripts/firewall_diagnostics.sh offline

# 2. Generate emergency report
REF=$(./automation/scripts/generate_ref_tag.sh emergency "firewall-block")
echo "Emergency REF: $REF"

# 3. Document the issue
./automation/scripts/firewall_diagnostics.sh report > "/tmp/firewall_emergency_$REF.txt"

# 4. Continue critical operations in offline mode
./automation/scripts/resource_check.sh
./automation/scripts/status_report.sh
```

### Contact Information
- **Network Team:** network@locus.internal
- **Security Team:** security@locus.internal  
- **Infrastructure Team:** infra@locus.internal
- **Emergency:** emergency@locus.internal

## Monitoring and Alerting

### Automated Monitoring
The system automatically detects firewall issues:
- Heartbeat monitor tests external API connectivity
- Freshness loop falls back to offline mode
- Status reports include connectivity warnings

### Manual Monitoring
```bash
# Daily connectivity check
./automation/scripts/firewall_diagnostics.sh check

# Weekly comprehensive report
./automation/scripts/firewall_diagnostics.sh report > weekly_firewall_report.txt
```

## Prevention

### Firewall Change Management
1. Test connectivity before implementing firewall changes
2. Use staging environment for firewall rule testing
3. Document all firewall exceptions with REF tags
4. Maintain firewall rule backup and rollback procedures

### Monitoring Integration
```bash
# Add to cron for automated monitoring
# 0 */6 * * * /path/to/locus/automation/scripts/firewall_diagnostics.sh check
```

---

**Document REF:** [Generate with: `./automation/scripts/generate_ref_tag.sh doc "firewall-guide"`]  
**Last Updated:** 2025-09-08  
**Contact:** infra@locus.internal