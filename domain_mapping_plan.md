# Domain Mapping Plan - Project Locus Infrastructure

**REF Tag:** LOCUS-TASK20250906-114155-002  
**Document Version:** 1.0.0  
**Last Updated:** 2025-01-06T11:41:55Z  
**Owner:** Project Locus Infrastructure Team  

## Overview

This document provides a comprehensive mapping of all domains, subdomains, and network endpoints used within the Project Locus multi-agent Proxmox infrastructure. It serves as the authoritative reference for DNS configuration, network topology, and service routing across the entire ecosystem.

## Domain Architecture

### Primary Domain Structure

```
locus.internal (Internal Infrastructure Domain)
├── pve.locus.internal          # Proxmox Virtual Environment
├── pbs.locus.internal          # Proxmox Backup Server
├── pms.locus.internal          # Proxmox Mail Server/Media Server
├── monitor.locus.internal      # Infrastructure Monitoring
├── hooks.locus.internal        # Webhook/Notification Services
└── agents.locus.internal       # Multi-Agent Communication Hub
```

### Service-Specific Subdomains

```
agents.locus.internal
├── claude-agent.locus.internal      # Claude Pro Agent Endpoint
├── perplexity-agent.locus.internal  # Perplexity Pro Agent Endpoint
└── lumo-agent.locus.internal        # Proton Lumo Agent Endpoint

support.locus.internal
├── infra.locus.internal             # Infrastructure Team Contact
├── oncall.locus.internal            # On-Call Emergency Contact
└── emergency.locus.internal         # Emergency Response Contact
```

## Endpoint Mapping

### Core Infrastructure Services

| Service | Domain | Port | Protocol | Purpose |
|---------|--------|------|----------|---------|
| Proxmox VE API | `pve.locus.internal` | 8006 | HTTPS | Virtual environment management |
| Proxmox Backup Server | `pbs.locus.internal` | 8007 | HTTPS | Backup and restore operations |
| Infrastructure Monitor | `monitor.locus.internal` | 443 | HTTPS | Resource monitoring dashboard |
| Webhook Service | `hooks.locus.internal` | 443 | HTTPS | Agent notifications and alerts |

### Multi-Agent Communication

| Agent | Endpoint | Purpose | Authentication |
|-------|----------|---------|----------------|
| Claude Pro | `claude-agent@locus.internal` | Code analysis, documentation, planning | GitHub Secret: CLAUDE_API_KEY |
| Perplexity Pro | `perplexity-agent@locus.internal` | Research, monitoring, reports | GitHub Secret: PERPLEXITY_API_KEY |
| Proton Lumo | `lumo-agent@locus.internal` | Secure communications, VPN | GitHub Secret: PROTON_LUMO_TOKEN |

### Operational Contacts

| Service | Email Domain | Purpose | Escalation Level |
|---------|--------------|---------|------------------|
| Infrastructure | `infra@locus.internal` | General infrastructure issues | Standard |
| On-Call | `oncall@locus.internal` | Urgent issues requiring immediate attention | High |
| Emergency | `emergency@locus.internal` | Critical system failures | Critical |

## Network Topology

### Internal Network Structure

```
┌─────────────────────────────────────────────────────────────┐
│                    locus.internal                           │
├─────────────────────────────────────────────────────────────┤
│ DMZ Zone (External Access)                                  │
│ ├── reverse-proxy.locus.internal                            │
│ └── external-api.locus.internal                             │
├─────────────────────────────────────────────────────────────┤
│ Infrastructure Zone (Internal Access)                       │
│ ├── pve.locus.internal (192.168.1.10)                      │
│ ├── pbs.locus.internal (192.168.1.20)                      │
│ ├── monitor.locus.internal (192.168.1.30)                  │
│ └── hooks.locus.internal (192.168.1.40)                    │
├─────────────────────────────────────────────────────────────┤
│ Agent Communication Zone (Secure)                           │
│ ├── claude-agent.locus.internal (Agent Bridge)             │
│ ├── perplexity-agent.locus.internal (Agent Bridge)         │
│ └── lumo-agent.locus.internal (Secure Tunnel)              │
└─────────────────────────────────────────────────────────────┘
```

### DNS Configuration

#### Internal DNS Records (Bind9/Unbound)

```dns
; Primary domain
$ORIGIN locus.internal.
$TTL 300

; Core infrastructure
pve             IN  A       192.168.1.10
pbs             IN  A       192.168.1.20
monitor         IN  A       192.168.1.30
hooks           IN  A       192.168.1.40

; Agent communication (CNAME to external services)
claude-agent    IN  CNAME   api.anthropic.com.
perplexity-agent IN CNAME   api.perplexity.ai.
lumo-agent      IN  CNAME   lumo.proton.me.

; Support contacts (MX records)
infra           IN  MX  10  mail.locus.internal.
oncall          IN  MX  10  mail.locus.internal.
emergency       IN  MX  5   mail.locus.internal.
```

## Security and Access Control

### Certificate Management

| Domain | Certificate Type | Renewal Method | Wildcard Support |
|--------|------------------|----------------|------------------|
| `*.locus.internal` | Self-signed CA | Automated (cert-manager) | Yes |
| `pve.locus.internal` | Internal CA | 90-day rotation | No |
| `pbs.locus.internal` | Internal CA | 90-day rotation | No |

### Access Control Matrix

| Zone | Internal Access | External Access | Agent Access | Authentication |
|------|----------------|-----------------|--------------|----------------|
| Infrastructure | ✅ Full | ❌ Blocked | 🔒 API Only | mTLS + API Keys |
| Monitoring | ✅ Full | 🔒 VPN Required | ✅ Read-Only | Token-based |
| Agent Communication | ❌ Blocked | ✅ Direct | ✅ Full | GitHub Secrets |

## Implementation Guidelines

### DNS Server Configuration

1. **Primary DNS (Internal)**
   - Configure Unbound or Bind9 for `.locus.internal` zone
   - Set up conditional forwarding for external agent domains
   - Implement DNS-over-TLS for external queries

2. **Secondary DNS (Backup)**
   - Mirror configuration on backup DNS server
   - Implement zone transfer for redundancy
   - Configure health checking

### Routing and Load Balancing

```yaml
# HAProxy/Nginx configuration example
upstream pve_cluster {
    server 192.168.1.10:8006 weight=3;
    server 192.168.1.11:8006 weight=2 backup;
}

upstream pbs_cluster {
    server 192.168.1.20:8007 weight=3;
    server 192.168.1.21:8007 weight=2 backup;
}
```

### Firewall Rules

```bash
# Internal infrastructure access
iptables -A INPUT -s 192.168.1.0/24 -d 192.168.1.10 -p tcp --dport 8006 -j ACCEPT
iptables -A INPUT -s 192.168.1.0/24 -d 192.168.1.20 -p tcp --dport 8007 -j ACCEPT

# Agent communication (external API access)
iptables -A OUTPUT -d api.anthropic.com -p tcp --dport 443 -j ACCEPT
iptables -A OUTPUT -d api.perplexity.ai -p tcp --dport 443 -j ACCEPT
iptables -A OUTPUT -d lumo.proton.me -p tcp --dport 443 -j ACCEPT
```

## Monitoring and Health Checks

### Domain Health Monitoring

| Domain | Check Type | Frequency | Alert Threshold |
|--------|------------|-----------|-----------------|
| `pve.locus.internal` | HTTPS + API | 60s | 3 consecutive failures |
| `pbs.locus.internal` | HTTPS + API | 60s | 3 consecutive failures |
| `monitor.locus.internal` | HTTPS | 30s | 2 consecutive failures |
| `hooks.locus.internal` | HTTPS | 30s | 2 consecutive failures |

### REF Tag Integration

All domain-related operations must include proper REF tagging:

```bash
# Generate REF tag for domain operations
REF_TAG=$(./automation/scripts/generate_ref_tag.sh "job" "domain-config")

# Example domain configuration change
echo "Updating DNS configuration for domain mapping - REF: $REF_TAG" >> /var/log/locus/domain-changes.log
```

## Troubleshooting Guide

### Common Issues

1. **DNS Resolution Failures**
   ```bash
   # Check internal DNS resolution
   nslookup pve.locus.internal 192.168.1.1
   
   # Verify zone file
   named-checkzone locus.internal /etc/bind/db.locus.internal
   ```

2. **Certificate Validation Errors**
   ```bash
   # Check certificate validity
   openssl s_client -connect pve.locus.internal:8006 -servername pve.locus.internal
   
   # Verify certificate chain
   openssl verify -CAfile /etc/ssl/locus-ca.crt /etc/ssl/pve.locus.internal.crt
   ```

3. **Agent Communication Issues**
   ```bash
   # Test external API connectivity
   curl -v https://api.anthropic.com/v1/health
   curl -v https://api.perplexity.ai/health
   
   # Check proxy configuration
   ./automation/scripts/heartbeat_monitor.sh
   ```

## Compliance and Auditing

### Audit Requirements

- All domain changes must be logged with REF tags
- Certificate renewals must trigger security team notifications
- Access logs must be retained for 90 days minimum
- DNS query logs must be monitored for suspicious activity

### Compliance Checklist

- [ ] All internal domains use `.locus.internal` format
- [ ] Certificate management follows 90-day rotation policy
- [ ] Agent communication uses GitHub Secrets only
- [ ] DNS configuration includes proper SOA and NS records
- [ ] Firewall rules implement least-privilege access
- [ ] Monitoring covers all critical endpoints
- [ ] Backup DNS server is properly configured
- [ ] Documentation is updated with all domain changes

## Future Considerations

### Planned Expansions

1. **Geographic Distribution**
   - `us-east.locus.internal` for US East Coast services
   - `eu-west.locus.internal` for European operations

2. **Service Mesh Integration**
   - Istio/Consul service discovery
   - mTLS for all internal communication

3. **External API Gateway**
   - `api.locus.external` for public-facing services
   - Rate limiting and authentication

---

**Document Control:**
- **Created by:** Project Locus Infrastructure Team
- **Reviewed by:** Security Team, Network Team
- **Next Review:** 2025-04-06
- **Version History:** See git log for detailed changes

**Emergency Contact:** For urgent domain-related issues, contact `emergency@locus.internal`