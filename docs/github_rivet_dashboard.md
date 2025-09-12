# Locus-Rivet GitHub Integration Dashboard

**REF:** LOCUS-RIVET-GITHUB-DASH-20250912-004  
**Implementation Status:** ✅ COMPLETE  
**Mode:** GITHUB ACTIONS + RIVET MONITORING  
**Integration:** Real-time via GitHub API + WebSocket

## 📊 Overview

The Locus-Rivet GitHub Integration Dashboard provides real-time monitoring and coordination for multi-agent workflows within the GitHub ecosystem. It combines GitHub Actions execution tracking, visual Rivet pipeline representation, and interactive controls in a unified interface.

## 🚀 Quick Start

### Prerequisites
- Node.js 18+ installed
- GitHub repository access
- Optional: GitHub personal access token for enhanced features

### Installation
```bash
# Install dependencies
npm install

# Set environment variables (optional)
export GITHUB_TOKEN=your_github_token
export GITHUB_REPOSITORY=toolate28/locus-proxmox-infra

# Start the dashboard
npm run dashboard:start
```

### Access Dashboard
- **Web Interface:** http://localhost:3000
- **ASCII Dashboard:** http://localhost:3000/api/dashboard/ascii
- **WebSocket:** ws://localhost:3000

## 🎛️ Dashboard Components

### 1. GitHub Actions Status Panel
- **Real-time workflow monitoring** from GitHub Actions API
- **Job progression tracking** with timing metrics
- **Actor attribution** showing who triggered workflows
- **Artifact download links** for coordination results
- **Status indicators** for all workflow jobs

### 2. Active Rivet Pipeline Visualization
```
┌──────────────────┐
│ Input            │
│   ↓              │
│ Claude ✅        │
│   ↓              │
│ Perplexity ⚡    │
│   ↓              │
│ Lumo ⏸️          │
│   ↓              │
│ Output           │
└──────────────────┘
```
- **Visual workflow representation** with agent status
- **Progress indicators** for each coordination phase
- **REF tag tracking** for complete traceability
- **Context preservation status** verification

### 3. GitHub Integration Panel
- **Pull request tracking** with Rivet validation status
- **Branch protection enforcement** for Rivet workflows
- **Visual diff availability** indicators
- **Approval requirement status** and review tracking

### 4. PR/Issue Tracking
- **Auto-created issues** from Rivet coordination runs
- **Intelligent labeling** (rivet-coordination, in-progress, completed)
- **Assignee management** and status tracking
- **Resolution tracking** for completed coordinations

### 5. GitHub API Metrics
- **Rate limit monitoring** to prevent API exhaustion
- **Actions minutes tracking** for usage awareness
- **Storage utilization** for artifacts and packages
- **Webhook delivery status** monitoring

## 🔧 Technical Architecture

### Server Components
```javascript
// Main dashboard server
const dashboard = new LocusRivetDashboard();

// GitHub API client
const octokit = new Octokit({ auth: process.env.GITHUB_TOKEN });

// WebSocket server for real-time updates
const wss = new WebSocket.Server({ server });

// Express API endpoints
app.get('/api/status', handler);
app.post('/api/trigger-workflow', handler);
app.post('/webhook/github', handler);
```

### WebSocket Events
- **`state_update`** - Dashboard state changes
- **`dashboard_update`** - ASCII dashboard refresh
- **`workflow_triggered`** - New coordination started
- **`github_event`** - GitHub webhook received

### REF Tag Integration
```bash
# Generate REF tag for coordination
REF_TAG=$(./automation/scripts/generate_ref_tag.sh job "rivet-coordination")

# Create context receipt
./automation/scripts/generate_context_receipt.sh "$REF_TAG" "dashboard_trigger" '{"source":"manual"}'
```

## 📋 Workflow Integration

### Rivet Coordination Workflow
The dashboard integrates with the `rivet-coordination.yml` GitHub Actions workflow:

1. **Setup Phase** - REF tag generation and context initialization
2. **Claude Analysis** - Infrastructure planning and security review
3. **Perplexity Research** - Real-time data validation and research
4. **Lumo Security** - Secure communications and compliance validation
5. **Results Integration** - PR updates and issue creation

### Trigger Methods
- **Manual Dashboard** - Interactive trigger button
- **GitHub Push** - Automatic on main branch changes
- **Pull Request** - Automatic on PR creation/updates
- **Workflow Dispatch** - Programmatic triggering via API

## 🎮 Interactive Controls

### Keyboard Shortcuts
- **`G`** - Open current repository in GitHub
- **`R`** - Open Rivet Editor (integration point)
- **`L`** - View live logs and system status
- **`Space`** - Refresh dashboard display
- **`?`** - Show help and shortcuts

### Control Panel Actions
- **Refresh** - Manual dashboard update
- **GitHub** - Navigate to repository
- **Rivet Editor** - Open workflow editor
- **Logs** - View detailed system logs
- **Trigger Workflow** - Start new coordination

## 📈 Monitoring & Metrics

### Dashboard Metrics
```json
{
  "github_metrics": {
    "rate_limit": { "remaining": 4823, "total": 5000 },
    "actions_minutes": { "used": 1247, "total": 2000 },
    "webhook_deliveries": 23,
    "storage_used": "8.3 GB"
  },
  "rivet_metrics": {
    "workflows_active": 1,
    "coordination_success_rate": "95%",
    "avg_completion_time": "2m 15s",
    "context_preservation": "100%"
  }
}
```

### Performance Indicators
- **Coordination Latency:** < 3 minutes target
- **Context Preservation:** 100% required
- **GitHub API Usage:** < 80% rate limit
- **Webhook Success Rate:** > 95%
- **Dashboard Responsiveness:** < 2 second updates

## 🔐 Security & Compliance

### Access Control
- **GitHub OAuth integration** for authenticated access
- **Repository-scoped permissions** only
- **Webhook signature validation** for security
- **Rate limiting** to prevent abuse

### Audit Trail
- **Complete REF tag chain** for all operations
- **Context receipt generation** for compliance
- **GitHub audit log integration** for traceability
- **Immutable artifact storage** in GitHub

### Secrets Management
```bash
# Required GitHub Secrets
GITHUB_TOKEN=ghp_xxxx         # For API access
CLAUDE_API_KEY=sk-xxxx        # Claude integration (optional)
PERPLEXITY_API_KEY=pplx-xxxx  # Perplexity integration (optional)
PROTON_LUMO_TOKEN=lumo-xxxx   # Lumo integration (optional)
```

## 🚀 Deployment Options

### Local Development
```bash
# Standard development setup
npm install
npm run dashboard:start

# Development with auto-reload
npm run dashboard:dev
```

### Production Deployment
```bash
# Docker deployment (recommended)
docker build -t locus-rivet-dashboard .
docker run -p 3000:3000 -e GITHUB_TOKEN=$TOKEN locus-rivet-dashboard

# Or systemd service
sudo cp locus-dashboard.service /etc/systemd/system/
sudo systemctl enable locus-dashboard
sudo systemctl start locus-dashboard
```

### GitHub Codespaces
```yaml
# .devcontainer/devcontainer.json
{
  "name": "Locus Dashboard",
  "image": "node:18",
  "forwardPorts": [3000],
  "postCreateCommand": "npm install && npm run dashboard:start"
}
```

## 🛠️ Development

### Adding Custom Agents
```javascript
// Extend the dashboard for new agents
class CustomAgentDashboard extends LocusRivetDashboard {
    getCustomAgentStatus(agent) {
        // Custom agent status logic
        return this.queryAgentAPI(agent);
    }
    
    updateAgentVisualization(agent, status) {
        // Update visual representation
        this.dashboardState.rivet_pipeline[agent] = status;
    }
}
```

### Custom Dashboard Themes
```css
/* Dark terminal theme (default) */
.dashboard { 
    background: #000; 
    color: #00ff00; 
    font-family: 'Courier New', monospace; 
}

/* Light professional theme */
.dashboard.light { 
    background: #fff; 
    color: #333; 
    font-family: 'Helvetica', sans-serif; 
}
```

### API Extensions
```javascript
// Add custom API endpoints
app.get('/api/custom/metrics', (req, res) => {
    res.json(this.getCustomMetrics());
});

app.post('/api/custom/action', (req, res) => {
    const result = this.executeCustomAction(req.body);
    res.json(result);
});
```

## 📚 Integration Examples

### Webhook Integration
```javascript
// External system webhook handler
app.post('/webhook/external', (req, res) => {
    const event = req.body;
    
    // Generate REF tag for traceability
    const refTag = this.generateRefTag('external', event.type);
    
    // Update dashboard state
    this.updateDashboardFromExternal(event, refTag);
    
    // Broadcast to clients
    this.broadcastUpdate();
    
    res.json({ received: true, ref_tag: refTag });
});
```

### CLI Integration
```bash
# Trigger coordination from command line
curl -X POST http://localhost:3000/api/trigger-workflow \
  -H "Content-Type: application/json" \
  -d '{"trigger": "cli", "params": {"priority": "high"}}'

# Get dashboard status
curl http://localhost:3000/api/status | jq .

# Get ASCII dashboard for terminal display
curl http://localhost:3000/api/dashboard/ascii
```

## 🔍 Troubleshooting

### Common Issues

**Dashboard not connecting to GitHub:**
```bash
# Check GitHub token
echo $GITHUB_TOKEN | cut -c1-8
# Should show: ghp_xxxx

# Test GitHub API access
curl -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/rate_limit
```

**WebSocket connection failures:**
```bash
# Check port availability
netstat -tulpn | grep :3000

# Test WebSocket endpoint
wscat -c ws://localhost:3000
```

**Workflow triggering issues:**
```bash
# Verify workflow file syntax
yamllint .github/workflows/rivet-coordination.yml

# Check workflow permissions
gh workflow list
gh workflow view rivet-coordination
```

### Debug Mode
```bash
# Enable debug logging
DEBUG=locus:* npm run dashboard:start

# View detailed logs
tail -f /tmp/locus_dashboard_debug.log
```

## 📞 Support & Resources

### Documentation Links
- **GitHub Actions:** https://docs.github.com/actions
- **Octokit API:** https://octokit.github.io/rest.js/
- **WebSocket API:** https://developer.mozilla.org/docs/Web/API/WebSocket
- **Express.js:** https://expressjs.com/

### Community
- **Issues:** GitHub Issues for bug reports
- **Discussions:** GitHub Discussions for questions
- **Wiki:** GitHub Wiki for advanced configurations

---

## 🎯 Next Steps

### Planned Enhancements
- [ ] **Mobile dashboard** responsive design
- [ ] **Advanced filtering** for workflow history
- [ ] **Custom agent plugins** architecture
- [ ] **Performance analytics** dashboard
- [ ] **Multi-repository support** for organization-wide monitoring

### Integration Roadmap
- [ ] **Slack notifications** for coordination events
- [ ] **Teams integration** for collaborative monitoring
- [ ] **Prometheus metrics** export for observability
- [ ] **Grafana dashboards** for long-term analytics

---

**Dashboard Implementation:** ✅ COMPLETE  
**GitHub Integration:** ✅ OPERATIONAL  
**Real-time Coordination:** ✅ ACTIVE  
**Multi-Agent Support:** ✅ ENABLED

*The Locus-Rivet GitHub Integration Dashboard is ready for production use with full GitHub Actions coordination and real-time monitoring capabilities.*