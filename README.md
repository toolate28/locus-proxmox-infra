# Project Locus: Multi-Agent Proxmox Infrastructure

🚀 **Institutional scaffolding for multi-agent orchestration and resource-aware automation**

> **Status:** ✅ Copilot Space ACTIVE | **Agents:** Claude Pro, Perplexity Pro, Proton Lumo

---

## 🗺️ Choose Your Path

**Start here** → Find your role and jump to the right place:

```mermaid
graph TD
    A[👋 I'm new to Project Locus] --> B{What's your role?}
    B -->|🔰 New Contributor| C[📚 Start Here: Quick Onboarding]
    B -->|🏗️ Infrastructure Team| D[⚙️ Infrastructure Setup Guide]
    B -->|👨‍💻 Developer/Agent| E[🤖 Agent Integration Guide]
    B -->|🔍 Just Exploring| F[📖 Project Overview]
    
    C --> G[✅ 2.5hr Onboarding Path]
    D --> H[🏃‍♂️ Quick Deploy Guide]
    E --> I[🔧 Multi-Agent Workflows]
    F --> J[🎯 Architecture Deep-Dive]
    
    G --> K["📋 docs/onboarding_playbook.md<br/>🔗 docs/connector_guide.md<br/>📖 docs/user-ai-directive-guide.md"]
    H --> L["⚙️ config/resource_config.json<br/>🔍 automation/resource_check.sh<br/>📊 automation/status_report.sh"]
    I --> M["🤖 CLAUDE.md<br/>📋 docs/user-ai-directive-guide.md<br/>🔄 automation/agent_handover.py"]
    J --> N["🏗️ Architecture Overview ↓<br/>📁 Repository Structure ↓<br/>🔐 Security & Compliance ↓"]

    style A fill:#e1f5fe
    style C fill:#f3e5f5
    style D fill:#fff3e0
    style E fill:#e8f5e8
    style F fill:#fce4ec
```

**ASCII Navigation for Terminal Users:**
```
👋 New to Project Locus?
    ├── 🔰 New Contributor ──→ 📚 Quick Onboarding (2.5hr path)
    ├── 🏗️ Infrastructure Team ──→ ⚙️ Setup Guide (Quick deploy)
    ├── 👨‍💻 Developer/Agent ──→ 🤖 Agent Integration (Multi-agent workflows)
    └── 🔍 Just Exploring ──→ 📖 Project Overview (Architecture deep-dive)
```

---

## 🏗️ Architecture Overview

### Multi-Agent Orchestration
- **Claude Pro (LOCUS-CLAUDE-001):** Code analysis, infrastructure planning, automation scripting
- **Perplexity Pro (LOCUS-PERPLEXITY-001):** Real-time research, monitoring reports, trend analysis
- **Proton Lumo (LOCUS-LUMO-001):** Secure communications, encrypted storage, VPN management

### Infrastructure Targets
- **Proxmox VE (PVE):** Virtualization cluster management
- **Proxmox Backup Server (PBS):** Backup verification and monitoring  
- **Proxmox Mail Gateway (PMS):** Container and mail security
- **Cloud Resources:** CDN, storage, and DNS monitoring

## 🚀 Quick Start Paths

### 🔰 For New Contributors *(2.5 hour path)*
```mermaid
graph LR
    A[📖 Read Onboarding] --> B[⚙️ Setup Tools]
    B --> C[🧪 Test Scripts]
    C --> D[👥 Join Team]
    
    A -.-> A1["docs/onboarding_playbook.md<br/>(45 min read)"]
    B -.-> B1["docs/connector_guide.md<br/>(30 min setup)"]
    C -.-> C1["automation/ scripts<br/>(15 min testing)"]
    D -.-> D1["Agent assignment<br/>(90 min integration)"]
```

**Quick Commands for Contributors:**
```bash
# 1. Test your environment (< 30 seconds total)
./automation/generate_ref_tag.sh task "onboarding-test"
./automation/resource_check.sh
./automation/status_report.sh

# 2. Study multi-agent workflows
cat docs/user-ai-directive-guide.md | grep -A 10 "Workflow Patterns"

# 3. Try Claude MCP integration
cat CLAUDE.md | head -50
```

### 🏗️ For Infrastructure Teams *(Quick deployment)*
```mermaid
graph LR
    A[📝 Configure] --> B[🚀 Deploy]
    B --> C[📊 Monitor]
    C --> D[🔄 Automate]
    
    A -.-> A1["config/resource_config.json<br/>Update endpoints"]
    B -.-> B1["automation/vm_provision.sh<br/>Deploy infrastructure"]
    C -.-> C1["automation/heartbeat_monitor.sh<br/>Track agents"]
    D -.-> D1["CI/CD integration<br/>Workflow automation"]
```

**Essential Infrastructure Commands:**
```bash
# Generate REF tags for traceability
./automation/generate_ref_tag.sh task "infrastructure-update"

# Monitor infrastructure resources  
./automation/resource_check.sh

# Generate status reports
./automation/status_report.sh

# Check agent heartbeats
./automation/heartbeat_monitor.sh

# Run freshness validation
./automation/freshness_loop.sh

# Provision new VMs with automation
./automation/vm_provision.sh web myapp-frontend
```

### 👨‍💻 For Developers & Agents *(Integration focus)*
```mermaid
graph TD
    A[🤖 Choose Agent Type] --> B{Agent Platform}
    B -->|Claude Pro| C[📖 CLAUDE.md]
    B -->|Perplexity Pro| D[🔍 Perplexity Integration]
    B -->|Proton Lumo| E[🔐 Security Protocols]
    
    C --> F[🔧 MCP Integration]
    D --> G[📊 Research Workflows]
    E --> H[🛡️ Secure Communications]
    
    F --> I[🎯 Multi-Agent Coordination]
    G --> I
    H --> I
```

## 📁 Project Discovery Map

**Navigate the codebase** → Follow the discovery paths:

```mermaid
graph TD
    A[🏠 Project Root] --> B[📂 Core Directories]
    
    B --> C[🤖 automation/]
    B --> D[📖 docs/]
    B --> E[⚙️ config/]
    B --> F[🔍 context/]
    
    C --> C1[🏷️ generate_ref_tag.sh<br/>📊 resource_check.sh<br/>🤖 agent_handover.py]
    D --> D1[📚 onboarding_playbook.md<br/>🔗 connector_guide.md<br/>📋 user-ai-directive-guide.md]
    E --> E1[📝 resource_config.json<br/>⚙️ monitoring settings]
    F --> F1[👥 AGENT_STATUS.json<br/>🔄 handover markers]
    
    C1 --> G[🎯 Infrastructure Automation]
    D1 --> H[📖 Documentation & Guides]
    E1 --> I[⚙️ Configuration Management]
    F1 --> J[🤖 Agent Coordination]

    style A fill:#e3f2fd
    style G fill:#f3e5f5
    style H fill:#fff3e0
    style I fill:#e8f5e8
    style J fill:#fce4ec
```

### 🗂️ Directory Structure & Purpose

```
📁 Project Locus Root
├── 🤖 automation/           # Core infrastructure automation
│   ├── 🏷️ generate_ref_tag.sh    # REF tag generator for traceability
│   ├── 📊 resource_check.sh       # Infrastructure monitoring
│   ├── 📈 status_report.sh        # Comprehensive status reporting
│   ├── 🚀 vm_provision.sh         # Automated VM deployment
│   ├── 💓 heartbeat_monitor.sh    # Agent heartbeat tracking
│   ├── 🔄 freshness_loop.sh       # Perplexity-powered real-time reports
│   └── 👥 agent_handover.py       # Multi-agent coordination
│
├── 📖 docs/                 # Documentation & guides
│   ├── 📚 onboarding_playbook.md   # New contributor guide (2.5hr)
│   ├── 🔗 connector_guide.md       # Step-by-step agent setup
│   ├── 📋 user-ai-directive-guide.md # Multi-agent coordination protocols
│   ├── 🚀 copilot_space_activation.md # GitHub Copilot integration
│   └── 🔍 perplexity-integration.md # Research & knowledge management
│
├── ⚙️ config/               # Configuration management
│   └── 📝 resource_config.json     # Resource monitoring settings
│
├── 🔍 context/              # Agent coordination
│   └── 👥 AGENT_STATUS.json        # Agent registration & capabilities
│
├── 📋 handover/             # Task handover markers
│   └── 🏷️ REF-TASK20240904-01.md  # Sample handover documentation
│
└── 📖 CLAUDE.md             # Claude Pro MCP onboarding guide
```

### 🎯 Discovery Paths by Interest

| **If you want to...** | **Start here** | **Then explore** |
|----------------------|----------------|------------------|
| 🔰 **Get started quickly** | `docs/onboarding_playbook.md` | → `docs/connector_guide.md` → `automation/` scripts |
| 🏗️ **Set up infrastructure** | `config/resource_config.json` | → `automation/resource_check.sh` → `automation/vm_provision.sh` |
| 🤖 **Integrate with agents** | `CLAUDE.md` or `docs/user-ai-directive-guide.md` | → `context/AGENT_STATUS.json` → `automation/agent_handover.py` |
| 📊 **Monitor systems** | `automation/status_report.sh` | → `automation/heartbeat_monitor.sh` → `docs/` status reports |
| 🔐 **Understand security** | Security & Compliance ↓ | → REF tag enforcement → Multi-agent protocols |

## 🔐 Security & Compliance Framework

### 🔑 Required GitHub Secrets
```bash
# Agent API Access
CLAUDE_API_KEY          # 🤖 Claude Pro API access
PERPLEXITY_API_KEY      # 🔍 Perplexity Pro research engine
PROTON_LUMO_TOKEN       # 🔐 Proton Lumo secure communications
LUMO_INSTANCE_ID        # 🆔 Lumo instance identifier
```

### 🏷️ REF Tag Enforcement System
```mermaid
graph LR
    A[📝 Task Start] --> B[🏷️ Generate REF Tag]
    B --> C[📋 LOCUS-TYPE-TIMESTAMP-COUNTER]
    C --> D[🔍 Track in Audit Log]
    D --> E[✅ 100% Coverage]
    
    B -.-> F["Example:<br/>LOCUS-TASK20240906-001<br/>LOCUS-JOB20240906-002"]
```

**📊 Compliance Metrics:**
- **Format:** `LOCUS-{TYPE}{TIMESTAMP}-{COUNTER}`
- **Coverage:** 100% of jobs, tasks, and artifacts  
- **Audit Trail:** Full traceability for compliance
- **Storage:** `/tmp/locus_ref_audit.log`

### 🛡️ Governance & CI Pipeline
| **Security Layer** | **Implementation** | **Validation** |
|-------------------|-------------------|----------------|
| 🔍 **Secret Scanning** | Continuous monitoring | GitHub Actions |
| 👥 **Code Owners** | `CODEOWNERS` enforcement | Required reviews |
| 📋 **PR Templates** | Standardized process | Automated checks |
| 🤖 **Multi-Agent** | USER-AI protocols | Directive compliance |

## 📊 Resource Awareness Dashboard

### ⏱️ Monitoring Intervals
```mermaid
gantt
    title Resource Monitoring Timeline
    dateFormat  X
    axisFormat %M:%S
    
    section Real-time
    Agent Heartbeat    :active, heartbeat, 0, 60
    
    section Regular
    Resource Polling   :polling, 60, 300
    Status Reports     :reports, 300, 3600
    
    section Extended  
    Freshness Check    :freshness, 3600, 14400
```

- **⚡ Agent Heartbeat:** Every 60 seconds
- **📊 Resource Polling:** Every 5 minutes  
- **📈 Status Reports:** Hourly
- **🔄 Freshness Validation:** Every 4 hours

### 🔄 Automated Handover Flow
```mermaid
graph TD
    A[🚀 Task Initiated] --> B[🏷️ Generate REF Tag]
    B --> C[📝 Set handover_available=true]
    C --> D[📬 Generate Handover Marker]
    D --> E[🔔 Webhook Notification]
    E --> F[📦 Context Transfer]
    F --> G[✅ Audit Trail Update]
```

## 🤖 Multi-Agent Ecosystem

**Agent coordination** → Choose your collaboration pattern:

```mermaid
graph TB
    subgraph "🎯 Agent Capabilities Matrix"
        A[👨‍💻 Claude Pro<br/>LOCUS-CLAUDE-001]
        B[🔍 Perplexity Pro<br/>LOCUS-PERPLEXITY-001]  
        C[🔐 Proton Lumo<br/>LOCUS-LUMO-001]
    end
    
    subgraph "🔧 Primary Functions"
        A --> A1[📝 Code Analysis<br/>🏗️ Infrastructure Planning<br/>📖 Documentation]
        B --> B1[🔍 Real-time Research<br/>📊 Monitoring Reports<br/>📈 Trend Analysis]
        C --> C1[🔐 Secure Communications<br/>🗄️ Encrypted Storage<br/>🛡️ VPN Management]
    end
    
    subgraph "🎯 Infrastructure Targets"
        D[🖥️ Proxmox VE<br/>Virtualization clusters]
        E[💾 Proxmox Backup<br/>Backup verification]
        F[📧 Proxmox Mail<br/>Container security]
        G[☁️ Cloud Resources<br/>CDN, storage, DNS]
    end
    
    A1 --> D
    A1 --> E
    B1 --> F
    B1 --> G
    C1 --> D
    C1 --> E

    style A fill:#e3f2fd
    style B fill:#f3e5f5
    style C fill:#fff3e0
```

### 🔄 Collaboration Workflows

| **Pattern** | **When to Use** | **Agent Flow** | **Output** |
|-------------|-----------------|----------------|------------|
| 🔀 **Sequential** | Simple tasks, clear handoffs | Claude → Perplexity → Lumo | Structured deliverable |
| 🤝 **Collaborative** | Complex analysis needed | Claude ↔ Perplexity ↔ Lumo | Integrated solution |
| ⚡ **Parallel** | Large projects, tight deadlines | Claude \|\| Perplexity \|\| Lumo | Concurrent outputs |

**💡 Quick Workflow Trigger:**
```bash
# Sequential processing example
REF_TAG=$(./automation/generate_ref_tag.sh task "multi-agent-analysis")
./automation/agent_handover.py create claude_pro perplexity_pro "Infrastructure analysis" $REF_TAG
```

## 🚀 Development Roadmap

**Project evolution timeline** → See what's coming next:

```mermaid
gantt
    title Project Locus Development Timeline
    dateFormat  YYYY-MM-DD
    axisFormat %m/%d
    
    section Week 1 🏃‍♂️
    Production API Setup    :active, api, 2024-09-06, 3d
    Infrastructure Integration :infra, after api, 2d
    Team Onboarding        :onboard, 2024-09-06, 5d
    
    section Month 1 🔧
    Advanced Automation    :auto, after onboard, 7d
    Custom Dashboard       :dash, after auto, 5d
    Performance Optimization :perf, after dash, 3d
    
    section Quarter 1 🚀
    AI Capacity Planning   :ai, after perf, 14d
    Predictive Maintenance :pred, after ai, 10d
    Cross-Platform Integration :cross, after pred, 7d
```

### 🎯 Milestone Overview

| **Phase** | **Duration** | **Key Deliverables** | **Success Metrics** |
|-----------|--------------|---------------------|-------------------|
| **🏃‍♂️ Immediate** | Week 1 | Production credentials, real infrastructure, team ready | ✅ 100% agent connectivity |
| **🔧 Expansion** | Month 1 | Advanced workflows, dashboards, optimizations | 📈 50% efficiency improvement |
| **🚀 Innovation** | Quarter 1 | AI planning, predictive systems, platform integration | 🎯 Full autonomous operation |

## 🆘 Support & Contact

**Need help?** → Find the right resource:

```mermaid
graph TD
    A[❓ Need Help?] --> B{What type of issue?}
    
    B -->|📖 Documentation| C[📚 docs/ directory]
    B -->|🏗️ Infrastructure| D[📧 infra@locus.internal]
    B -->|🔐 Security| E[🛡️ security@locus.internal]
    B -->|🚨 Emergency| F[📞 oncall@locus.internal]
    
    C --> G[🔍 Search existing guides]
    D --> H[⚙️ Infrastructure team]
    E --> I[🔐 Security team]
    F --> J[🚨 24/7 on-call support]

    style F fill:#ffebee
    style J fill:#ffebee
```

### 📞 Contact Directory
- **📖 Documentation:** Browse complete guides in `docs/` directory
- **🏗️ Infrastructure:** infra@locus.internal  
- **🔐 Security:** security@locus.internal  
- **🚨 On-Call:** oncall@locus.internal

### 🔗 Quick Links
- **📋 Issue Templates:** `.github/ISSUE_TEMPLATE/`
- **🔄 PR Templates:** `.github/PULL_REQUEST_TEMPLATE.md`  
- **👥 Code Owners:** `CODEOWNERS`
- **📊 Project Board:** [GitHub Projects](https://github.com/toolate28/locus-proxmox-infra/projects)

---

## 📊 Repository Status

**🏷️ REF:** LOCUS-REPO-README-001  
**🤖 Multi-Agent Orchestration:** ✅ Active  
**📊 Resource Awareness:** ✅ Enabled  
**🚀 Copilot Space:** ✅ Activated  
**🔐 Security Compliance:** ✅ 100%  

> 🎯 **Last Updated:** Auto-generated via `automation/status_report.sh`
