<div align="center">

```
🔒 PROTON LUMO INTEGRATION GUIDE
┌─────────────────────────────────────────────────────────────┐
<<<<<<< HEAD
│             Secure Communications & Privacy Agent          │
│                                                             │
│  Comprehensive guide for Proton Lumo agents within the     │
│  Project Locus multi-agent infrastructure ecosystem.       │
=======
│             Secure Communications & Privacy Agent           │
│                                                             │
│  Comprehensive guide for Proton Lumo agents within the      │
│  Project Locus multi-agent infrastructure ecosystem.        │
>>>>>>> main
└─────────────────────────────────────────────────────────────┘
```

[![Proton Lumo](https://img.shields.io/badge/Proton_Lumo-Secure_Ready-success?style=for-the-badge&logo=protonmail&logoColor=white)](https://proton.me)
[![Security Protocol](https://img.shields.io/badge/Security-End_to_End_Encrypted-blue?style=for-the-badge&logo=shield&logoColor=white)](#-security-capabilities)
[![Agent Status](https://img.shields.io/badge/Agent_Status-LOCUS--LUMO--001-purple?style=for-the-badge&logo=robot&logoColor=white)](#-agent-registration)

</div>

---

## 🎯 **Proton Lumo Agent Overview**

### 🔒 **Primary Capabilities**

<div align="center">

<<<<<<< HEAD
| 🎯 **Capability** | 📊 **Proficiency** | 🔧 **Use Cases** |
|:---:|:---:|:---:|
| **Secure Communications** | ⭐⭐⭐⭐⭐ | End-to-end encrypted messaging, secure handovers |
| **Encrypted Storage** | ⭐⭐⭐⭐⭐ | Sensitive data protection, secure archiving |
| **VPN Management** | ⭐⭐⭐⭐⭐ | Network security, remote access, traffic routing |
| **Privacy Enforcement** | ⭐⭐⭐⭐⭐ | Data anonymization, privacy compliance, GDPR |
| **Secure Tunneling** | ⭐⭐⭐⭐⭐ | Secure agent communications, network isolation |
=======
| 🎯 **Capability**         | 📊 **Proficiency** | 🔧 **Pipelines**                         |
|:-------------------------:|:-----------------:|:-----------------------------------------:|
| **Secure Communications** | ⭐⭐⭐⭐⭐           | End-to-end encrypted messaging, secure handovers  |
| **Encrypted Storage**     | ⭐⭐⭐⭐⭐ | Sensitive data protection, secure archiving       |
| **VPN Management**        | ⭐⭐⭐⭐⭐ | Network security, remote access, traffic routing  |
| **Privacy Enforcement**   | ⭐⭐⭐⭐⭐ | Data anonymization, privacy compliance, GDPR      |
| **Secure Tunneling**      | ⭐⭐⭐⭐⭐ | Secure agent communications, network isolation    |
>>>>>>> main

</div>

### 🎭 **Agent Identity**

```yaml
agent_profile:
  ref_tag: "LOCUS-LUMO-001"
  status: "registered"
  api_endpoint: "https://lumo.proton.me/api"
  auth_method: "github_secret:PROTON_LUMO_TOKEN"
  instance_id_secret: "github_secret:LUMO_INSTANCE_ID"
  heartbeat_interval: 60
  session_type: "secure_api_integration"
  capabilities:
    - secure_communications
    - encrypted_storage
    - vpn_management
    - privacy_enforcement
    - secure_tunneling
    - constitutional_compliance
    - emergency_secure_halt
```

---

## 🏷️ REF Tag Schema & Standards

### Lumo-Specific REF Tags
```
LOCUS-SECURE<TIMESTAMP>-<COUNTER>    # Security operations
LOCUS-VPN<TIMESTAMP>-<COUNTER>       # VPN management
LOCUS-ENCRYPT<TIMESTAMP>-<COUNTER>   # Encryption tasks
LOCUS-PRIVACY<TIMESTAMP>-<COUNTER>   # Privacy compliance
LOCUS-TUNNEL<TIMESTAMP>-<COUNTER>    # Secure tunneling
```

### REF Tag Generation for Lumo Operations
```bash
# Generate security-specific REF tags
./automation/scripts/generate_ref_tag.sh secure "encrypted-handover"
./automation/scripts/generate_ref_tag.sh vpn "network-isolation"
./automation/scripts/generate_ref_tag.sh encrypt "sensitive-data-protection"
./automation/scripts/generate_ref_tag.sh privacy "gdpr-compliance-check"
./automation/scripts/generate_ref_tag.sh tunnel "agent-secure-comms"
```

---

## 🚀 Quick Start for Proton Lumo Agents

### Prerequisites
- Proton Lumo API access (`PROTON_LUMO_TOKEN` in GitHub Secrets)
- Lumo Instance ID (`LUMO_INSTANCE_ID` in GitHub Secrets)
- Basic understanding of Project Locus security architecture
- Access to repository automation scripts

### Initial Setup

#### For Secure API Integration (Primary Method)
```bash
# 1. Verify Proton Lumo API access
curl -X GET https://lumo.proton.me/api/status \
  -H "Authorization: Bearer $PROTON_LUMO_TOKEN" \
  -H "Instance-ID: $LUMO_INSTANCE_ID"

# 2. Generate agent REF tag
REF_TAG=$(./automation/scripts/generate_ref_tag.sh agent "lumo-secure-setup")
echo "Your Lumo Agent REF: $REF_TAG"

# 3. Initialize secure communications
./automation/scripts/invoke_agent.sh lumo HIGH "secure-channel-init" "first-setup"

# 4. Test VPN management capabilities
./automation/scripts/invoke_agent.sh lumo MEDIUM "vpn-status-check" "connectivity-test"
```

#### Constitutional Compliance Integration
```bash
# 1. Validate constitutional framework compliance
./automation/scripts/emergency_halt.sh --status

<<<<<<< HEAD
# 2. Test emergency secure halt procedures
./automation/scripts/emergency_halt.sh --test-secure-halt

=======
# 2. Test emergency secure halt procedures (FUTURE ENHANCEMENT - Not Yet Implemented)
# ./automation/scripts/emergency_halt.sh --test-secure-halt
>>>>>>> main
# 3. Initialize cross-machine security propagation
./automation/scripts/coordinate_agents.sh lumo "claude,perplexity" "security-framework-sync"
```

---

## 🔒 Security Capabilities & Use Cases

### Primary Strengths
<<<<<<< HEAD
- **End-to-End Encryption:** All communications secured with military-grade encryption
- **Privacy-First Design:** Zero-knowledge architecture, no data logging
- **Constitutional Compliance:** Automated enforcement of security principles
- **Secure Agent Handovers:** Encrypted context transfer between agents
- **Emergency Security Response:** Rapid isolation and secure halt capabilities
=======
- **End-to-End Encryption:       ** All communications secured with military-grade encryption
- **Privacy-First Design:        ** Zero-knowledge architecture, no data logging
- **Constitutional Compliance:   ** Automated enforcement of security principles
- **Secure Agent Handovers:      ** Encrypted context transfer between agents
- **Emergency Security Response: ** Rapid isolation and secure halt capabilities
>>>>>>> main

### Optimal Task Types
1. **Secure Communications**
   ```bash
   LUMO CRITICAL SECURE agent-handover-encryption CONFIDENTIAL-DATA
   ```

2. **Privacy Compliance**
   ```bash
   LUMO HIGH PRIVACY gdpr-data-protection COMPLIANCE-AUDIT
   ```

3. **Network Security**
   ```bash
   LUMO HIGH VPN infrastructure-isolation NETWORK-SEGMENTATION
   ```

4. **Emergency Response**
   ```bash
   LUMO CRITICAL EMERGENCY constitutional-violation SYSTEM-HALT
   ```

---

## 🛡️ Constitutional Framework Integration

### Emergency Halt Procedures
Proton Lumo is the designated executor for constitutional violation responses:
<<<<<<< HEAD

```bash
# Constitutional violation detection and response
./automation/scripts/emergency_halt.sh --halt "resource_exhaustion" critical

# Cross-machine security propagation
./automation/scripts/emergency_halt.sh --propagate "security_violation" emergency

# Secure state preservation during halt
./automation/scripts/emergency_halt.sh --secure-preserve $REF_TAG
=======
```bash
# Constitutional violation detection and response (IMPLEMENTED)
./automation/scripts/emergency_halt.sh --halt "resource_exhaustion" critical

# Cross-machine security propagation (FUTURE ENHANCEMENT - Not Yet Implemented)
# ./automation/scripts/emergency_halt.sh --propagate "security_violation" emergency

# Secure state preservation during halt (FUTURE ENHANCEMENT - Not Yet Implemented)  
# ./automation/scripts/emergency_halt.sh --secure-preserve $REF_TAG
>>>>>>> main
```

### Privacy and Security Enforcement
```json
{
  "constitutional_compliance": {
    "privacy_enforcement": {
      "data_minimization": "automatic",
      "consent_management": "strict",
      "right_to_erasure": "immediate",
      "data_portability": "encrypted_export"
    },
    "security_principles": {
      "zero_trust_architecture": true,
      "principle_of_least_privilege": true,
      "defense_in_depth": true,
      "secure_by_default": true
    },
    "emergency_protocols": {
      "automatic_isolation": true,
      "secure_state_preservation": true,
      "encrypted_audit_trails": true,
      "human_escalation": "immediate"
    }
  }
}
```

---

## 🔄 Multi-Agent Coordination

### Lumo as Security Lead
When Lumo leads security-focused operations:
<<<<<<< HEAD

=======
>>>>>>> main
```bash
# Coordinate security review with other agents
LUMO_TASK="infrastructure-security-audit"
CLAUDE_ANALYSIS="code-security-review"
PERPLEXITY_RESEARCH="threat-intelligence"

# Sequence: Lumo → Claude → Perplexity → Lumo (security synthesis)
```

### Lumo as Security Validator
When supporting other agents with security oversight:
<<<<<<< HEAD

=======
>>>>>>> main
```bash
# Supporting Claude with security validation
CLAUDE_LEAD="infrastructure-deployment"
LUMO_SECURITY="security-compliance-check"

# Supporting Perplexity with privacy review
PERPLEXITY_LEAD="data-research"
LUMO_PRIVACY="privacy-impact-assessment"
```

### Secure Handover Protocols
```bash
# Create encrypted handover between agents
python3 ./automation/scripts/agent_handover.py create claude lumo "security-review-required" \
  --encryption=enabled --classification=confidential

# Secure context transfer
./automation/scripts/capture_context.sh lumo $REF_TAG --encrypt --secure-store
```

---

## 🔐 VPN & Network Security Management

### VPN Integration Workflows
```bash
# Activate secure tunnel for agent communications
./automation/scripts/invoke_agent.sh lumo HIGH "vpn-activate" "agent-secure-tunnel"

# Monitor VPN status and security metrics
./automation/scripts/invoke_agent.sh lumo MEDIUM "vpn-monitor" "security-health-check"

# Rotate VPN credentials and keys
./automation/scripts/invoke_agent.sh lumo HIGH "vpn-rotate-keys" "security-maintenance"
```

### Network Isolation Protocols
```bash
<<<<<<< HEAD
# Isolate compromised systems
./automation/scripts/emergency_halt.sh --network-isolate "security-breach" critical
=======
# Isolate compromised systems (FUTURE ENHANCEMENT - Not Yet Implemented)
# ./automation/scripts/emergency_halt.sh --network-isolate "security-breach" critical
>>>>>>> main

# Implement network segmentation
./automation/scripts/invoke_agent.sh lumo HIGH "network-segment" "zero-trust-implementation"

# Monitor network traffic for anomalies
./automation/scripts/invoke_agent.sh lumo MEDIUM "network-monitor" "threat-detection"
```

---

## 🔧 Operational Procedures

### Daily Tasks
```bash
# Generate security status report
./automation/scripts/invoke_agent.sh lumo MEDIUM "security-report" "daily-brief"

# Monitor VPN and encryption status
./automation/scripts/invoke_agent.sh lumo LOW "security-health" "routine-check"

# Validate constitutional compliance
./automation/scripts/invoke_agent.sh lumo HIGH "constitutional-check" "compliance-audit"
```

### Weekly Tasks
```bash
# Generate REF tag for weekly security review
REF_TAG=$(./automation/scripts/generate_ref_tag.sh secure "weekly-lumo-security-review")

# Comprehensive security assessment
./automation/scripts/coordinate_agents.sh lumo "claude,perplexity" "security-assessment"

# Security key rotation and maintenance
./automation/scripts/invoke_agent.sh lumo HIGH "security-maintenance" "key-rotation"
```

### Monthly Tasks
```bash
# Generate comprehensive security report
REF_TAG=$(./automation/scripts/generate_ref_tag.sh secure "monthly-security-audit")

# Cross-agent security coordination
./automation/scripts/coordinate_agents.sh lumo "claude,perplexity" "comprehensive-security-review"

# Constitutional framework validation
./automation/scripts/invoke_agent.sh lumo CRITICAL "constitutional-audit" "monthly-compliance"
```

---

## 📋 Decision Log & Best Practices

### Lumo Agent Decision Framework
1. **Security Assessment:** Evaluate all operations for security implications
2. **Privacy Impact:** Assess data handling and privacy compliance requirements  
3. **Constitutional Adherence:** Ensure all actions align with governance principles
4. **Risk Mitigation:** Identify and address potential security vulnerabilities

### Best Practices for Lumo Agents
- ✅ Always use end-to-end encryption for sensitive communications
- ✅ Implement zero-trust principles in all network interactions
- ✅ Maintain comprehensive security audit trails with REF tags
- ✅ Enforce privacy-by-design in all data handling operations
- ✅ Validate constitutional compliance before high-impact actions
- ✅ Implement secure-by-default configurations

### Common Security Pitfalls to Avoid
- ❌ Transmitting sensitive data over unencrypted channels
- ❌ Storing credentials or keys in plaintext or logs
- ❌ Bypassing security controls for convenience
- ❌ Ignoring privacy regulations and compliance requirements
- ❌ Failing to validate security certificates and connections
- ❌ Disabling security features without proper authorization

---

## 🔗 Secure Context Sharing & Handover Protocols

### Secure Context Structure
```json
{
  "ref_tag": "LOCUS-SECURE20250907-001",
  "agent_type": "proton_lumo",
  "session_type": "secure_api_integration",
  "security_context": {
    "classification_level": "confidential",
    "encryption_standard": "AES-256-GCM",
    "key_rotation_schedule": "daily",
    "access_controls": ["multi_factor_auth", "device_certificate"],
    "data_retention": "constitutional_compliance"
  },
  "privacy_context": {
    "data_minimization": "active",
    "consent_tracking": "granular",
    "anonymization": "automatic",
    "right_to_erasure": "immediate_compliance"
  },
  "threat_assessment": {
    "current_threat_level": "low",
    "active_monitoring": true,
    "incident_response": "automated",
    "escalation_procedures": "defined"
  },
  "constitutional_compliance": {
    "principles_validated": true,
    "emergency_procedures": "tested",
    "audit_trail": "complete",
    "human_oversight": "maintained"
  }
}
```

### Encrypted Handover Procedures
```bash
# Create secure handover with encryption
python3 ./automation/scripts/agent_handover.py create lumo claude "security-validated-task" \
  --security-level=high --encryption=mandatory

# Verify handover security
./automation/scripts/invoke_agent.sh lumo HIGH "handover-security-check" $HANDOVER_REF

# Complete secure handover with audit
python3 ./automation/scripts/agent_handover.py complete $HANDOVER_REF \
  "Security validation completed, audit trail preserved"
```

---

## 🚨 Emergency Procedures & Incident Response

### Security Incident Response
```bash
# Immediate security incident response
./automation/scripts/emergency_halt.sh --halt "security_breach" critical

# Secure forensic data collection
./automation/scripts/invoke_agent.sh lumo CRITICAL "forensic-collect" "security-incident"

# Coordinate emergency response with all agents
./automation/scripts/coordinate_agents.sh lumo "claude,perplexity" "emergency-security-response"
```

### Constitutional Violation Response
```bash
<<<<<<< HEAD
# Constitutional violation detection and response
./automation/scripts/emergency_halt.sh --constitutional-violation $VIOLATION_TYPE critical
=======
# Constitutional violation detection and response (FUTURE ENHANCEMENT - Not Yet Implemented)
# ./automation/scripts/emergency_halt.sh --constitutional-violation $VIOLATION_TYPE critical
>>>>>>> main

# Cross-machine principle propagation
./automation/scripts/invoke_agent.sh lumo CRITICAL "principle-propagate" "violation-response"

# Secure state preservation during constitutional emergency
./automation/scripts/capture_context.sh lumo $REF_TAG --constitutional-emergency
```

---

## 🔍 Troubleshooting & Security Validation

### Common Security Issues
1. **VPN Connection Failures**
   - Check network connectivity and firewall rules
   - Validate VPN credentials and certificates
   - Monitor for DNS leaks and IP exposure

2. **Encryption Key Problems**  
   - Verify key rotation schedules and procedures
   - Check for expired or compromised certificates
   - Validate secure key storage and access controls

3. **Constitutional Compliance Failures**
   - Review violation logs and audit trails
   - Validate emergency response procedures
   - Check cross-machine communication integrity

### Security Validation Procedures
```bash
# Comprehensive security validation
./automation/scripts/invoke_agent.sh lumo HIGH "security-validate" "full-system-check"

# VPN and network security test
./automation/scripts/invoke_agent.sh lumo MEDIUM "network-security-test" "connectivity-validation"

# Constitutional compliance audit
./automation/scripts/invoke_agent.sh lumo CRITICAL "constitutional-audit" "compliance-validation"
```

---

## 📊 Security Monitoring & Metrics

### Key Security Metrics
- **Encryption Coverage:** Percentage of communications encrypted end-to-end
- **Privacy Compliance:** GDPR/privacy regulation adherence score
- **Incident Response Time:** Average time from detection to containment
- **Constitutional Adherence:** Compliance with governance principles

### Monitoring Commands
```bash
# Real-time security monitoring
./automation/scripts/invoke_agent.sh lumo LOW "security-monitor" "continuous-surveillance"

# Generate security metrics report
./automation/scripts/invoke_agent.sh lumo MEDIUM "security-metrics" "performance-analysis"

# Constitutional compliance monitoring
./automation/scripts/invoke_agent.sh lumo HIGH "constitutional-monitor" "governance-tracking"
```

---

## 🎓 Advanced Security Features

### Zero-Trust Architecture Implementation
```bash
# Implement zero-trust network access
./automation/scripts/invoke_agent.sh lumo HIGH "zero-trust-implement" "network-security"

# Device certificate management
./automation/scripts/invoke_agent.sh lumo MEDIUM "device-cert-manage" "access-control"

# Continuous security validation
./automation/scripts/invoke_agent.sh lumo LOW "continuous-validation" "security-posture"
```

### Advanced Threat Protection
```bash
# Threat intelligence integration
./automation/scripts/coordinate_agents.sh lumo perplexity "threat-intelligence-sync"

# Advanced persistent threat detection
./automation/scripts/invoke_agent.sh lumo HIGH "apt-detection" "advanced-threats"

# Security orchestration and response
./automation/scripts/invoke_agent.sh lumo CRITICAL "security-orchestration" "automated-response"
```

---

**Document REF:** LOCUS-DOC-LUMO-ONBOARDING  
**Version:** 1.0  
**Last Updated:** 2025-09-07T08:45:00Z  
**Next Review:** 2025-10-07T08:45:00Z

**Integration Status:**
- ✅ Security Protocol Defined
- ✅ Constitutional Framework Integration
- ✅ Emergency Response Procedures  
- ✅ Multi-Agent Coordination Ready
- ✅ Privacy Compliance Framework
- ✅ REF Tag Schema Integrated
- 🔄 API Integration Implementation (Pending)
- 🔄 VPN Management Dashboard (Planned)
- 🔄 Advanced Threat Detection Pipeline (Future)