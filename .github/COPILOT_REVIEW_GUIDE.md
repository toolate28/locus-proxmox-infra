# Copilot Review Guidelines for Project Locus

This document provides guidance for GitHub Copilot when reviewing pull requests in the Project Locus infrastructure automation repository.

## Repository Context

Project Locus is a **bash-based infrastructure automation system** for multi-agent orchestration of Proxmox environments. This is NOT a traditional software application but an infrastructure automation toolkit using shell scripts.

## Review Focus Areas

### 1. Shell Scripts (Priority: High)
- **Location**: `automation/scripts/*.sh`, `scripts/*.sh`
- **Critical checks**:
  - REF tag generation compliance (`generate_ref_tag.sh` usage)
  - Script execution time (must complete in <10 seconds)
  - Error handling and graceful failure modes
  - No hardcoded secrets or credentials
  - Proper variable quoting and error checking

### 2. JSON Configuration Files (Priority: High)
- **Location**: `config/*.json`, `context/*.json`
- **Critical checks**:
  - Valid JSON syntax
  - Required fields present
  - No credentials embedded
  - Schema compliance with existing patterns

### 3. Documentation (Priority: Medium)
- **Location**: `docs/*.md`, `README.md`, `*.md`
- **Focus areas**:
  - Accuracy of technical procedures
  - Consistency with project standards
  - REF tag documentation requirements
  - Security considerations

### 4. Python Scripts (Priority: Medium)
- **Location**: `*.py`, `validation/*.py`, `monitoring/*.py`
- **Review points**:
  - Integration with bash automation scripts
  - REF tag generation usage
  - Error handling and logging
  - No hardcoded secrets

## Security Requirements (Critical)

1. **No Secrets in Code**: All credentials must use GitHub Secrets
2. **REF Tag Compliance**: All operations must generate traceable REF tags
3. **Script Permissions**: Executable permissions on automation scripts
4. **Audit Trail**: Complete traceability for infrastructure changes

## Performance Requirements

- All automation scripts must complete within 10 seconds
- No long-running operations in the main scripts
- Efficient resource usage for infrastructure checks

## Common Issues to Flag

1. **Missing REF tags**: Scripts not using `generate_ref_tag.sh`
2. **Hardcoded credentials**: Any API keys, passwords, or tokens in code
3. **Script permissions**: Non-executable automation scripts
4. **JSON syntax errors**: Invalid configuration files
5. **Long execution times**: Scripts that may exceed 10-second limit
6. **Missing error handling**: Scripts without proper error checking

## Validation Commands

When reviewing changes, these commands should pass:
```bash
# Shell syntax validation
shellcheck automation/scripts/*.sh scripts/*.sh

# JSON validation
jq empty config/*.json context/*.json

# REF tag generation test
./automation/scripts/generate_ref_tag.sh task "validation"

# Script execution test (should complete quickly)
time ./automation/scripts/resource_check.sh
```

## Approval Criteria

✅ **Approve when**:
- All scripts pass shellcheck (warnings acceptable, errors not)
- JSON files are valid
- REF tag compliance maintained
- No secrets in code
- Documentation is accurate
- Changes align with infrastructure automation goals

❌ **Request changes when**:
- Shellcheck errors present
- Invalid JSON configuration
- Missing REF tag generation
- Hardcoded secrets found
- Scripts likely to exceed 10-second execution limit
- Breaking changes to existing automation workflows

## Repository-Specific Patterns

- **REF Tag Format**: `LOCUS-{TYPE}{TIMESTAMP}-{COUNTER}`
- **Output Files**: `/tmp/locus_*.json` for temporary data
- **Audit Logging**: `/tmp/locus_ref_audit.log` for REF tag tracking
- **Agent Integration**: Uses Claude Pro, Perplexity Pro, and Proton Lumo APIs

This repository prioritizes operational reliability, security, and audit compliance over traditional software development metrics.