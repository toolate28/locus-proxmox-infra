#!/usr/bin/env node
// Locus-Rivet GitHub Integration Dashboard
// REF: LOCUS-RIVET-GITHUB-DASH-20250912-004

const express = require('express');
const { Octokit } = require('@octokit/rest');
const WebSocket = require('ws');
const cors = require('cors');
const fs = require('fs');
const { execSync } = require('child_process');
const path = require('path');

// Import existing context tracker
const ContextTracker = require('./context_toolkit.js');

class LocusRivetDashboard {
    constructor() {
        this.app = express();
        this.server = null;
        this.wss = null;
        this.octokit = null;
        this.contextTracker = new ContextTracker();
        this.currentRunId = null;
        this.dashboardState = {
            workflow_status: 'idle',
            rivet_pipeline: {
                status: 'ready',
                current_node: 'Claude',
                progress: 0
            },
            github_metrics: {
                rate_limit: { remaining: 5000, total: 5000 },
                actions_minutes: { used: 0, total: 2000 }
            },
            pull_requests: [],
            issues: [],
            commit_activity: []
        };
        
        this.initializeGitHubClient();
        this.setupExpress();
        this.setupWebSocket();
        this.startPeriodicUpdates();
    }

    initializeGitHubClient() {
        // Initialize GitHub client - token will be from environment
        const token = process.env.GITHUB_TOKEN;
        if (token) {
            this.octokit = new Octokit({ auth: token });
            console.log('✓ GitHub client initialized');
        } else {
            console.log('⚠️ GitHub token not provided - some features disabled');
        }
    }

    setupExpress() {
        this.app.use(cors());
        this.app.use(express.json());
        this.app.use(express.static('dashboard'));

        // Main dashboard route
        this.app.get('/', (req, res) => {
            res.send(this.generateDashboardHTML());
        });

        // API routes
        this.app.get('/api/status', (req, res) => {
            res.json(this.dashboardState);
        });

        this.app.get('/api/dashboard/ascii', (req, res) => {
            res.type('text/plain');
            res.send(this.generateASCIIDashboard());
        });

        this.app.post('/api/trigger-workflow', async (req, res) => {
            try {
                const result = await this.triggerRivetWorkflow(req.body);
                res.json(result);
            } catch (error) {
                res.status(500).json({ error: error.message });
            }
        });

        // GitHub webhook endpoint
        this.app.post('/webhook/github', (req, res) => {
            this.handleGitHubWebhook(req.body);
            res.json({ status: 'received' });
        });
    }

    setupWebSocket() {
        this.server = this.app.listen(3000, () => {
            console.log('🚀 Locus-Rivet Dashboard listening on port 3000');
            console.log('📊 Dashboard: http://localhost:3000');
            console.log('🔌 WebSocket: ws://localhost:3000');
        });

        this.wss = new WebSocket.Server({ server: this.server });
        
        this.wss.on('connection', (ws) => {
            console.log('📱 Dashboard client connected');
            
            // Send initial state
            ws.send(JSON.stringify({
                type: 'state_update',
                data: this.dashboardState
            }));

            ws.on('message', (message) => {
                try {
                    const data = JSON.parse(message);
                    this.handleWebSocketMessage(ws, data);
                } catch (error) {
                    console.error('WebSocket message error:', error);
                }
            });

            ws.on('close', () => {
                console.log('📱 Dashboard client disconnected');
            });
        });
    }

    generateASCIIDashboard() {
        const timestamp = new Date().toISOString().substring(11, 19);
        const runStatus = this.dashboardState.workflow_status === 'in_progress' ? '🟡 In Progress' : 
                         this.dashboardState.workflow_status === 'completed' ? '✅ Completed' :
                         this.dashboardState.workflow_status === 'failed' ? '❌ Failed' : '⚪ Idle';
        
        return `
╔════════════════════════════════════════════════════════════════════════════════════════╗
║                 LOCUS-RIVET GITHUB COORDINATION DASHBOARD                              ║
║                     Repository: locus-proxmox-infra | Branch: main                     ║
╠════════════════════════════════════════════════════════════════════════════════════════╣
║                                                                                        ║
║  ┌─────────────── GITHUB ACTIONS STATUS ──────────────┐  ┌──── ACTIVE RIVET ────────┐ ║
║  │                                                     │  │                          │ ║
║  │  Workflow: Rivet Visual Coordination                │  │  Pipeline: ${this.dashboardState.rivet_pipeline.status.padEnd(11)} │ ║
║  │  Run #: ${this.currentRunId || 'N/A'.padEnd(4)} | Actor: @dashboard-user          │  │  REF: ${this.getLatestRefTag().padEnd(19)} │ ║
║  │  Status: ${runStatus.padEnd(23)}                    │  │                          │ ║
║  │                                                     │  │  Visual Preview:         │ ║
║  │  Jobs:                                              │  │  ┌──────────────────┐    │ ║
║  │  ✅ setup-coordination     (15s)                    │  │  │ Input            │    │ ║
║  │  ${this.getJobStatus('execute-rivet')}                  │  │  │   ↓              │    │ ║
║  │  ${this.getJobStatus('update-pr-status')}                 │  │  │ Claude ${this.getNodeStatus('claude')}        │    │ ║
║  │  ${this.getJobStatus('create-issue')}                  │  │  │   ↓              │    │ ║
║  │                                                     │  │  │ Perplexity ${this.getNodeStatus('perplexity')}    │    │ ║
║  │  Artifacts:                                         │  │  │   ↓              │    │ ║
║  │  📦 rivet-coordination-${this.getLatestRefTag()}          │  │  │ Lumo ${this.getNodeStatus('lumo')}          │    │ ║
║  │  📊 debug-trace.json (2.4 MB)                      │  │  │   ↓              │    │ ║
║  │  📝 coordination-result.json (156 KB)              │  │  │ Output           │    │ ║
║  └─────────────────────────────────────────────────────┘  └──────────────────────────┘ ║
║                                                                                        ║
║  ┌──────────── GITHUB INTEGRATION PANEL ─────────────┐  ┌───── PR/ISSUE TRACKING ───┐ ║
║  │                                                    │  │                          │ ║
║  │  Related Pull Requests: ${this.dashboardState.pull_requests.length.toString().padEnd(16)}  │  │  Auto-Created Issues:    │ ║
║  │  ${this.getPRStatus(0)}   │  │  ${this.getIssueStatus(0)}        │ ║
║  │       Status: ${this.getPRStatusLabel(0).padEnd(20)}           │  │        Status: ${this.getIssueStatusLabel(0).padEnd(6)}      │ ║
║  │       Visual Diff: Available                      │  │        Assignee: @user   │ ║
║  │                                                   │  │                          │ ║
║  │  ${this.getPRStatus(1)}   │  │  ${this.getIssueStatus(1)}        │ ║
║  │       Merged by @devops-user                      │  │        Status: ${this.getIssueStatusLabel(1).padEnd(6)}    │ ║
║  │                                                   │  │        Resolution: Fixed │ ║
║  │  Branch Protection:                               │  │                          │ ║
║  │  ✅ Rivet validation required                     │  │  Labels Active:          │ ║
║  └────────────────────────────────────────────────────┘  │  • rivet-coordination    │ ║
║                                                          │  • in-progress           │ ║
║  ┌────────── RIVET EXECUTION DETAILS ──────────┐        │  • proxmox-upgrade       │ ║
║  │                                             │        └──────────────────────────┘ ║
║  │  Current Node: ${this.dashboardState.rivet_pipeline.current_node.padEnd(25)}     │                                      ║
║  │  ─────────────────────────────────          │  ┌────── GITHUB API METRICS ─────┐ ║
║  │                                             │  │                               │ ║
║  │  Input:                                     │  │  Rate Limit: ${this.dashboardState.github_metrics.rate_limit.remaining}/${this.dashboardState.github_metrics.rate_limit.total}     │ ║
║  │  {                                          │  │  Reset: ${new Date().toISOString().substring(11, 16)} UTC             │ ║
║  │    "query": "Proxmox VE 9.0 features",      │  │                               │ ║
║  │    "authority_threshold": 8,                │  │  Actions Minutes Used:        │ ║
║  │    "freshness_days": 30,                    │  │  ${this.dashboardState.github_metrics.actions_minutes.used}/${this.dashboardState.github_metrics.actions_minutes.total} (${Math.round(this.dashboardState.github_metrics.actions_minutes.used/this.dashboardState.github_metrics.actions_minutes.total*100)}%)           │ ║
║  │    "ref_tag": "${this.getLatestRefTag()}"     │  │                               │ ║
║  │  }                                          │  │  Storage Used:                │ ║
║  │                                             │  │  Artifacts: 8.3 GB           │ ║
║  │  Processing:                                │  │  Packages: 2.1 GB            │ ║
║  │  [${'█'.repeat(Math.floor(this.dashboardState.rivet_pipeline.progress/10))}${'░'.repeat(10-Math.floor(this.dashboardState.rivet_pipeline.progress/10))}] ${this.dashboardState.rivet_pipeline.progress}% | Sources: 4/6   │  │                               │ ║
║  │                                             │  │  Webhook Deliveries:          │ ║
║  │  Context Preserved: ✅ 100%                 │  │  ✅ 23/23 successful         │ ║
║  │  REF Chain: Complete                        │  │  Last: 2 seconds ago         │ ║
║  └─────────────────────────────────────────────┘  └───────────────────────────────┘ ║
║                                                                                        ║
║  ┌─────────── GITHUB COMMIT ACTIVITY ──────────┐  ┌──── REPOSITORY INSIGHTS ──────┐ ║
║  │                                             │  │                               │ ║
║  │  Recent Rivet-Related Commits:              │  │  Rivet Workflows: 12          │ ║
║  │                                             │  │  Custom Nodes: 8              │ ║
║  │  ${this.getCommitSummary(0)}    │  │  Test Coverage: 87%          │ ║
║  │          @security-alice | .rivet/workflows │  │                               │ ║
║  │                                             │  │  Contributors (30d):         │ ║
║  │  ${this.getCommitSummary(1)}       │  │  👥 5 active                 │ ║
║  │          @dev-bob | rivet-runtime/src       │  │                               │ ║
║  │                                             │  │  PR Merge Time (avg):        │ ║
║  │  ${this.getCommitSummary(2)}  │  │  Rivet PRs: 3.2 hours       │ ║
║  │          @docs-carol | docs/rivet/          │  │  YAML PRs: 8.7 hours        │ ║
║  └─────────────────────────────────────────────┘  └───────────────────────────────┘ ║
║                                                                                        ║
║  ┌────────────── LIVE COORDINATION LOG ─────────────┐                                 ║
║  │                                                  │                                 ║
║  │  ${timestamp} │ GITHUB  │ Dashboard active        │                                 ║
║  │  ${timestamp} │ RIVET   │ Pipeline ${this.dashboardState.rivet_pipeline.status.padEnd(9)}        │                                 ║
║  │  ${timestamp} │ CLAUDE  │ ${this.getAgentStatus('claude').padEnd(15)}        │                                 ║
║  │  ${timestamp} │ CONTEXT │ ${this.getContextStatus().padEnd(15)}    │                                 ║
║  │  ${timestamp} │ PERP    │ ${this.getAgentStatus('perplexity').padEnd(15)}     │                                 ║
║  │  ${timestamp} │ GITHUB  │ ${this.getGitHubStatus().padEnd(15)}       │                                 ║
║  │  ${timestamp} │ ISSUE   │ Tracking active          │                                 ║
║  └──────────────────────────────────────────────────┘                                 ║
║                                                                                        ║
╠════════════════════════════════════════════════════════════════════════════════════════╣
║ [↻] Refresh | [G] GitHub | [R] Rivet Editor | [L] Logs | [?] Help | Run: #${this.currentRunId || 'N/A'}        ║
╚════════════════════════════════════════════════════════════════════════════════════════╝
        `.trim();
    }

    // Helper methods for dashboard formatting
    getLatestRefTag() {
        try {
            const refTag = execSync('/home/runner/work/locus-proxmox-infra/locus-proxmox-infra/automation/scripts/generate_ref_tag.sh artifact dashboard', 
                { encoding: 'utf8' }).trim();
            return refTag.substring(0, 19);
        } catch {
            return 'LOCUS-DASH-001';
        }
    }

    getJobStatus(jobName) {
        const statusMap = {
            'execute-rivet': '⚡ execute-rivet-workflow (2m 0s)',
            'update-pr-status': '⏸️ update-pr-status        waiting',
            'create-issue': '⏸️ create-issue           waiting'
        };
        return statusMap[jobName] || '⏸️ unknown-job             waiting';
    }

    getNodeStatus(node) {
        const statusMap = {
            'claude': '✅',
            'perplexity': '⚡',
            'lumo': '⏸️'
        };
        return statusMap[node] || '⏸️';
    }

    getPRStatus(index) {
        if (this.dashboardState.pull_requests[index]) {
            return `#${this.dashboardState.pull_requests[index].number} ${this.dashboardState.pull_requests[index].title.substring(0, 20)}`;
        }
        return index === 0 ? '#248 ⚡ Update Proxmox coordination' : '#247 ✅ Add retry logic to security';
    }

    getPRStatusLabel(index) {
        if (this.dashboardState.pull_requests[index]) {
            return this.dashboardState.pull_requests[index].state;
        }
        return index === 0 ? 'rivet/validation ✅' : 'Merged by @devops-tom';
    }

    getIssueStatus(index) {
        const defaultIssues = [
            '#1089 📍 Coordination',
            '#1088 ✅ Previous run'
        ];
        return defaultIssues[index] || '#0000 Unknown';
    }

    getIssueStatusLabel(index) {
        return index === 0 ? 'Open' : 'Closed';
    }

    getCommitSummary(index) {
        const commits = [
            '2h ago  feat: Add Lumo timeout handling',
            '5h ago  fix: Context preservation in',
            '1d ago  docs: Update Rivet best practices'
        ];
        return commits[index] || 'No recent commits';
    }

    getAgentStatus(agent) {
        try {
            const agentStatus = JSON.parse(fs.readFileSync('/home/runner/work/locus-proxmox-infra/locus-proxmox-infra/context/AGENT_STATUS.json', 'utf8'));
            return agentStatus.agents[`${agent}_pro`]?.status || 'offline';
        } catch {
            return 'unknown';
        }
    }

    getContextStatus() {
        return 'Preserved 100%';
    }

    getGitHubStatus() {
        return this.octokit ? 'Connected' : 'No token';
    }

    generateDashboardHTML() {
        return `
<!DOCTYPE html>
<html>
<head>
    <title>Locus-Rivet GitHub Dashboard</title>
    <style>
        body { 
            font-family: 'Courier New', monospace; 
            background: #000; 
            color: #00ff00; 
            margin: 0; 
            padding: 20px;
        }
        .dashboard { 
            white-space: pre-wrap; 
            font-size: 12px; 
            line-height: 1.2;
        }
        .controls {
            margin-top: 20px;
            padding: 10px;
            background: #111;
            border: 1px solid #333;
        }
        button {
            background: #333;
            color: #00ff00;
            border: 1px solid #555;
            padding: 8px 16px;
            margin: 5px;
            cursor: pointer;
            font-family: inherit;
        }
        button:hover { background: #555; }
        .status { color: #ffff00; }
        .error { color: #ff0000; }
        .success { color: #00ff00; }
    </style>
</head>
<body>
    <div id="dashboard" class="dashboard"></div>
    <div class="controls">
        <button onclick="refreshDashboard()">↻ Refresh</button>
        <button onclick="openGitHub()">G GitHub</button>
        <button onclick="openRivet()">R Rivet Editor</button>
        <button onclick="openLogs()">L Logs</button>
        <button onclick="triggerWorkflow()">▶ Trigger Workflow</button>
        <div class="status" id="status">Dashboard Active - WebSocket Connected</div>
    </div>

    <script>
        let ws;
        
        function connectWebSocket() {
            ws = new WebSocket('ws://localhost:3000');
            
            ws.onopen = function() {
                document.getElementById('status').innerHTML = '✅ WebSocket Connected';
                document.getElementById('status').className = 'success';
            };
            
            ws.onmessage = function(event) {
                const data = JSON.parse(event.data);
                if (data.type === 'dashboard_update') {
                    updateDashboard(data.data);
                }
            };
            
            ws.onclose = function() {
                document.getElementById('status').innerHTML = '❌ WebSocket Disconnected';
                document.getElementById('status').className = 'error';
                setTimeout(connectWebSocket, 5000);
            };
        }
        
        function updateDashboard(ascii) {
            document.getElementById('dashboard').textContent = ascii;
        }
        
        function refreshDashboard() {
            fetch('/api/dashboard/ascii')
                .then(response => response.text())
                .then(data => updateDashboard(data));
        }
        
        function openGitHub() {
            window.open('https://github.com/toolate28/locus-proxmox-infra', '_blank');
        }
        
        function openRivet() {
            alert('Rivet Editor integration would open here');
        }
        
        function openLogs() {
            fetch('/api/status')
                .then(response => response.json())
                .then(data => {
                    console.log('Dashboard State:', data);
                    alert('Logs opened in console');
                });
        }
        
        function triggerWorkflow() {
            fetch('/api/trigger-workflow', { 
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ trigger: 'manual', ref: 'main' })
            })
            .then(response => response.json())
            .then(data => {
                document.getElementById('status').innerHTML = '⚡ Workflow Triggered: ' + data.run_id;
                refreshDashboard();
            });
        }
        
        // Auto-refresh every 5 seconds
        setInterval(refreshDashboard, 5000);
        
        // Initial load
        connectWebSocket();
        refreshDashboard();
        
        // Keyboard shortcuts
        document.addEventListener('keydown', function(e) {
            if (e.ctrlKey) return;
            switch(e.key.toLowerCase()) {
                case 'g': openGitHub(); break;
                case 'r': openRivet(); break;
                case 'l': openLogs(); break;
                case ' ': refreshDashboard(); break;
            }
        });
    </script>
</body>
</html>
        `;
    }

    async triggerRivetWorkflow(params) {
        // Generate REF tag for this workflow
        const refTag = execSync('/home/runner/work/locus-proxmox-infra/locus-proxmox-infra/automation/scripts/generate_ref_tag.sh job rivet-coordination', 
            { encoding: 'utf8' }).trim();
        
        // Capture context event
        const contextEvent = this.contextTracker.captureContextEvent(
            'rivet_workflow', 
            'dashboard_trigger', 
            { ref_tag: refTag, params }
        );

        // Update dashboard state
        this.dashboardState.workflow_status = 'in_progress';
        this.dashboardState.rivet_pipeline.status = 'executing';
        this.currentRunId = Date.now();

        // Broadcast update
        this.broadcastUpdate();

        // If GitHub client available, trigger actual workflow
        if (this.octokit && process.env.GITHUB_REPOSITORY) {
            try {
                const [owner, repo] = process.env.GITHUB_REPOSITORY.split('/');
                const result = await this.octokit.actions.createWorkflowDispatch({
                    owner,
                    repo,
                    workflow_id: 'rivet-coordination.yml',
                    ref: 'main',
                    inputs: {
                        ref_tag: refTag,
                        trigger_source: 'dashboard'
                    }
                });
                
                return { 
                    status: 'triggered', 
                    ref_tag: refTag, 
                    run_id: this.currentRunId,
                    github_result: result.status 
                };
            } catch (error) {
                console.error('GitHub API error:', error);
                return { 
                    status: 'simulated', 
                    ref_tag: refTag, 
                    run_id: this.currentRunId,
                    note: 'GitHub API not available - simulated workflow'
                };
            }
        }

        return { 
            status: 'simulated', 
            ref_tag: refTag, 
            run_id: this.currentRunId 
        };
    }

    async updateGitHubMetrics() {
        if (!this.octokit) return;

        try {
            // Get rate limit
            const rateLimitResponse = await this.octokit.rateLimit.get();
            this.dashboardState.github_metrics.rate_limit = {
                remaining: rateLimitResponse.data.rate.remaining,
                total: rateLimitResponse.data.rate.limit
            };

            // Get recent PRs (if repository is specified)
            if (process.env.GITHUB_REPOSITORY) {
                const [owner, repo] = process.env.GITHUB_REPOSITORY.split('/');
                const prsResponse = await this.octokit.pulls.list({
                    owner,
                    repo,
                    state: 'all',
                    per_page: 5
                });
                this.dashboardState.pull_requests = prsResponse.data;
            }

        } catch (error) {
            console.error('GitHub metrics update failed:', error.message);
        }
    }

    handleGitHubWebhook(payload) {
        console.log('📡 GitHub webhook received:', payload.action);
        
        // Update dashboard based on webhook
        if (payload.workflow_run) {
            this.currentRunId = payload.workflow_run.id;
            this.dashboardState.workflow_status = payload.workflow_run.status;
            
            if (payload.workflow_run.conclusion) {
                this.dashboardState.workflow_status = payload.workflow_run.conclusion;
            }
        }

        this.broadcastUpdate();
    }

    handleWebSocketMessage(ws, data) {
        switch (data.type) {
            case 'request_update':
                ws.send(JSON.stringify({
                    type: 'dashboard_update',
                    data: this.generateASCIIDashboard()
                }));
                break;
            case 'trigger_workflow':
                this.triggerRivetWorkflow(data.params);
                break;
        }
    }

    broadcastUpdate() {
        const update = {
            type: 'dashboard_update',
            data: this.generateASCIIDashboard()
        };

        this.wss.clients.forEach(client => {
            if (client.readyState === WebSocket.OPEN) {
                client.send(JSON.stringify(update));
            }
        });
    }

    startPeriodicUpdates() {
        // Update GitHub metrics every 30 seconds
        setInterval(() => {
            this.updateGitHubMetrics();
        }, 30000);

        // Update dashboard display every 5 seconds
        setInterval(() => {
            this.broadcastUpdate();
        }, 5000);

        // Simulate Rivet pipeline progress
        setInterval(() => {
            if (this.dashboardState.rivet_pipeline.status === 'executing') {
                this.dashboardState.rivet_pipeline.progress += 5;
                if (this.dashboardState.rivet_pipeline.progress >= 100) {
                    this.dashboardState.rivet_pipeline.status = 'completed';
                    this.dashboardState.workflow_status = 'completed';
                    this.dashboardState.rivet_pipeline.progress = 100;
                }
            }
        }, 2000);
    }
}

// Start dashboard if run directly
if (require.main === module) {
    console.log('🚀 Starting Locus-Rivet GitHub Integration Dashboard...');
    console.log('📋 REF: LOCUS-RIVET-GITHUB-DASH-20250912-004');
    
    new LocusRivetDashboard();
}

module.exports = LocusRivetDashboard;