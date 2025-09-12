#!/bin/bash
# Locus-Rivet GitHub Dashboard Startup Script
# REF: LOCUS-RIVET-GITHUB-DASH-20250912-004

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "🚀 Starting Locus-Rivet GitHub Integration Dashboard"
echo "📍 Project Root: $PROJECT_ROOT"
echo "📋 REF: LOCUS-RIVET-GITHUB-DASH-20250912-004"
echo ""

# Generate REF tag for this dashboard session
REF_TAG=$("$PROJECT_ROOT/automation/scripts/generate_ref_tag.sh" dashboard "startup-$(date +%s)")
echo "🏷️ Dashboard Session REF: $REF_TAG"

# Check dependencies
echo "🔍 Checking dependencies..."
if ! command -v node &> /dev/null; then
    echo "❌ Node.js not found. Please install Node.js 18+"
    exit 1
fi

if ! command -v npm &> /dev/null; then
    echo "❌ npm not found. Please install npm"
    exit 1
fi

echo "✅ Node.js $(node --version) found"
echo "✅ npm $(npm --version) found"

# Check if dependencies are installed
if [ ! -d "$PROJECT_ROOT/node_modules" ]; then
    echo "📦 Installing dependencies..."
    cd "$PROJECT_ROOT"
    npm install --no-fund --no-audit
    echo "✅ Dependencies installed"
else
    echo "✅ Dependencies already installed"
fi

# Set environment variables if not set
export GITHUB_REPOSITORY=${GITHUB_REPOSITORY:-"toolate28/locus-proxmox-infra"}
export NODE_ENV=${NODE_ENV:-"development"}

echo ""
echo "🌍 Environment:"
echo "   Repository: $GITHUB_REPOSITORY"
echo "   Node Env: $NODE_ENV"
echo "   GitHub Token: ${GITHUB_TOKEN:+✅ Configured}${GITHUB_TOKEN:-❌ Not set (some features will be limited)}"

echo ""
echo "🎯 Dashboard will be available at:"
echo "   Web Interface: http://localhost:3000"
echo "   ASCII View: http://localhost:3000/api/dashboard/ascii"
echo "   API Status: http://localhost:3000/api/status"
echo ""

# Generate context receipt for dashboard startup
"$PROJECT_ROOT/automation/scripts/generate_context_receipt.sh" "$REF_TAG" "dashboard_startup" "{\"mode\":\"github_integration\",\"features\":[\"real_time_monitoring\",\"workflow_coordination\",\"ascii_dashboard\"]}"

echo "📊 Starting dashboard server..."
echo "   Press Ctrl+C to stop"
echo "   Use 'G' key for GitHub shortcuts when dashboard is focused"
echo ""

# Start the dashboard
cd "$PROJECT_ROOT"
exec node automation/scripts/github_dashboard.js