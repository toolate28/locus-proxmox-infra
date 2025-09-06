#!/bin/bash
# Basic test script for Locus-Proxmox infrastructure scripts

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "Running basic tests for Locus-Proxmox infrastructure..."

# Test 1: Check if all scripts are executable
echo -e "${YELLOW}Test 1: Checking script permissions...${NC}"
failed=0
for script in "$PROJECT_ROOT"/scripts/*.sh; do
    if [[ -f "$script" ]]; then
        if [[ -x "$script" ]]; then
            echo "✓ $(basename "$script") is executable"
        else
            echo -e "${RED}✗ $(basename "$script") is not executable${NC}"
            failed=1
        fi
    fi
done

# Test 2: Check if scripts have valid shebang
echo -e "${YELLOW}Test 2: Checking script shebangs...${NC}"
for script in "$PROJECT_ROOT"/scripts/*.sh; do
    if [[ -f "$script" ]]; then
        if head -n1 "$script" | grep -q "^#!/bin/bash"; then
            echo "✓ $(basename "$script") has valid shebang"
        else
            echo -e "${RED}✗ $(basename "$script") missing or invalid shebang${NC}"
            failed=1
        fi
    fi
done

# Test 3: Test script help functions
echo -e "${YELLOW}Test 3: Testing script help functions...${NC}"
for script in "$PROJECT_ROOT"/scripts/vm_provision.sh "$PROJECT_ROOT"/scripts/status_report.sh; do
    if [[ -f "$script" ]]; then
        if "$script" --help >/dev/null 2>&1; then
            echo "✓ $(basename "$script") help function works"
        else
            echo -e "${RED}✗ $(basename "$script") help function failed${NC}"
            failed=1
        fi
    fi
done

# Test 4: Validate JSON schemas
echo -e "${YELLOW}Test 4: Validating JSON schemas...${NC}"
for schema in "$PROJECT_ROOT"/schemas/*.json; do
    if [[ -f "$schema" ]]; then
        if python3 -m json.tool "$schema" >/dev/null 2>&1; then
            echo "✓ $(basename "$schema") is valid JSON"
        else
            echo -e "${RED}✗ $(basename "$schema") is invalid JSON${NC}"
            failed=1
        fi
    fi
done

# Test 5: Validate example configurations
echo -e "${YELLOW}Test 5: Validating example configurations...${NC}"
for config in "$PROJECT_ROOT"/configs/*.example.json; do
    if [[ -f "$config" ]]; then
        if python3 -m json.tool "$config" >/dev/null 2>&1; then
            echo "✓ $(basename "$config") is valid JSON"
        else
            echo -e "${RED}✗ $(basename "$config") is invalid JSON${NC}"
            failed=1
        fi
    fi
done

# Test 6: Check GitHub Actions workflows
echo -e "${YELLOW}Test 6: Checking GitHub Actions workflows...${NC}"
workflow_files=("ci.yml" "provision.yml" "freshness.yml")
for workflow in "${workflow_files[@]}"; do
    workflow_path="$PROJECT_ROOT/.github/workflows/$workflow"
    if [[ -f "$workflow_path" ]]; then
        echo "✓ $workflow exists"
        # Basic YAML validation (check if it's parseable)
        if python3 -c "import yaml; yaml.safe_load(open('$workflow_path'))" 2>/dev/null; then
            echo "✓ $workflow is valid YAML"
        else
            echo -e "${RED}✗ $workflow is invalid YAML${NC}"
            failed=1
        fi
    else
        echo -e "${RED}✗ $workflow not found${NC}"
        failed=1
    fi
done

# Summary
echo ""
if [[ $failed -eq 0 ]]; then
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}Some tests failed. Please fix the issues above.${NC}"
    exit 1
fi