# 🎬 JIRA Automation Demo - Complete Index

> **Your navigation hub for all demo materials**

---

## 🚀 Quick Start

**New here?** Pick your path:

```
┌─────────────────────────────────────────────────────────┐
│  I want to...                    →  Start with...       │
├─────────────────────────────────────────────────────────┤
│  🎮 Try it now                   →  jira-test          │
│  👀 Watch demo                   →  demo-interactive.sh │
│  📖 Read full guide              →  DEMO.md            │
│  📋 Quick reference              →  QUICK-REFERENCE.md  │
│  🎤 Prepare presentation         →  DEMO-SUMMARY.md    │
│  🔧 Set up the system            →  QUICKSTART.md      │
└─────────────────────────────────────────────────────────┘
```

---

## 📚 Documentation Structure

### 🎬 Demo Materials (Start Here!)

| Document | Purpose | Duration | Audience |
|----------|---------|----------|----------|
| **[DEMO.md](DEMO.md)** | Complete demo walkthrough with diagrams | 20 min read | Everyone |
| **[DEMO-QUICK-REFERENCE.md](DEMO-QUICK-REFERENCE.md)** | One-page reference for presentations | 5 min read | Presenters |
| **[DEMO-SUMMARY.md](DEMO-SUMMARY.md)** | Package overview and guide | 10 min read | Presenters |
| **[DEMO-INDEX.md](DEMO-INDEX.md)** | This file - navigation hub | 2 min read | Everyone |

### 🎮 Interactive Demo

| Resource | Type | Command | Duration |
|----------|------|---------|----------|
| **Interactive Script** | Executable | `scripts/demo-interactive.sh` | 10 min |
| **Live Commands** | CLI | `jira-test`, `jira-epic`, `jira-story` | 5 min |
| **Natural Language** | Claude Code | "Create an epic for X" | 1 min |

### 📖 User Guides

| Document | Purpose | Length | Audience |
|----------|---------|--------|----------|
| **[README.md](README.md)** | Project overview | 1 page | Everyone |
| **[QUICKSTART.md](QUICKSTART.md)** | 5-minute getting started | 2 pages | New users |
| **[docs/JIRA-SKILL-GUIDE.md](docs/JIRA-SKILL-GUIDE.md)** | Complete user guide | 20+ pages | All users |
| **[docs/QUICK-REFERENCE.md](docs/QUICK-REFERENCE.md)** | Command reference | 2 pages | Regular users |

### 🎨 Visual Assets

| Diagram | Shows | File |
|---------|-------|------|
| **Architecture** | 3-layer system design | `docs/diagrams/architecture.png` |
| **Components** | Component breakdown | `docs/diagrams/component-architecture.png` |
| **Data Flow** | End-to-end process | `docs/diagrams/data-flow.png` |
| **Epic Workflow** | Epic creation steps | `docs/diagrams/epic-workflow.png` |
| **Epic Suggestion** | Smart linking process | `docs/diagrams/story-epic-suggestion.png` |

### 📄 Examples & Templates

| Resource | Purpose | Location |
|----------|---------|----------|
| **Sample Plan** | Implementation plan example | `examples/sample-implementation-plan.md` |
| **Epic Template** | Epic YAML template | `templates/epic.yml` |
| **Story Template** | Story YAML template | `templates/story.yml` |
| **Subtask Template** | Subtask YAML template | `templates/subtask.yml` |

---

## 🎯 Use Case Matrix

**Pick your scenario:**

### I'm a Presenter

**Goal**: Demo the system to stakeholders

**Start with**:
1. Read [DEMO-SUMMARY.md](DEMO-SUMMARY.md) (overview)
2. Review [DEMO-QUICK-REFERENCE.md](DEMO-QUICK-REFERENCE.md) (talking points)
3. Practice with `scripts/demo-interactive.sh`
4. Read [DEMO.md](DEMO.md) for deep knowledge

**Show**:
- Diagrams from `docs/diagrams/`
- Live demo or interactive script
- Time savings metrics

### I'm a New User

**Goal**: Start creating JIRA issues

**Start with**:
1. Read [QUICKSTART.md](QUICKSTART.md) (5 minutes)
2. Run `jira-test` (test connection)
3. Run `jira-epic` (create first epic)
4. Read [docs/JIRA-SKILL-GUIDE.md](docs/JIRA-SKILL-GUIDE.md) for details

**Try**:
- Create an epic
- Create a story (watch epic suggestion!)
- Create a subtask

### I'm Learning the System

**Goal**: Understand how it works

**Start with**:
1. Read [DEMO.md](DEMO.md) (comprehensive guide)
2. View diagrams in `docs/diagrams/`
3. Run `scripts/demo-interactive.sh` (see it in action)
4. Read [docs/JIRA-SKILL-GUIDE.md](docs/JIRA-SKILL-GUIDE.md) (user guide)

**Explore**:
- Templates in `templates/`
- Config in `config/`
- Scripts in `scripts/lib/`

### I'm Customizing

**Goal**: Adapt for my team

**Start with**:
1. Read [docs/JIRA-SKILL-GUIDE.md](docs/JIRA-SKILL-GUIDE.md) (customization section)
2. Edit `templates/*.yml` (your formats)
3. Update `config/field-mappings.yml` (your fields)
4. Modify `config/defaults.yml` (your defaults)

**Customize**:
- Templates
- Field mappings
- Default values
- Validation rules

---

## 📊 Feature Index

**Find documentation by feature:**

### Intelligent Epic Linking ✨
- **Demo**: [DEMO.md](DEMO.md) - Section "Step 3: Epic Suggestion"
- **Diagram**: `docs/diagrams/story-epic-suggestion.png`
- **Code**: `scripts/lib/jira-api.sh` - `search_epics_in_component()`
- **Guide**: [docs/JIRA-SKILL-GUIDE.md](docs/JIRA-SKILL-GUIDE.md) - "Epic Search"

### Professional Templates 📝
- **Examples**: [DEMO.md](DEMO.md) - "Feature Showcase"
- **Files**: `templates/epic.yml`, `templates/story.yml`
- **Customization**: [docs/JIRA-SKILL-GUIDE.md](docs/JIRA-SKILL-GUIDE.md) - "Custom Templates"
- **Sample Output**: `examples/` directory

### Multiple Interfaces 🎛️
- **Natural Language**: [docs/JIRA-SKILL-GUIDE.md](docs/JIRA-SKILL-GUIDE.md) - "Method 1"
- **CLI Commands**: [QUICKSTART.md](QUICKSTART.md) - "Commands"
- **Programmatic API**: [docs/JIRA-SKILL-GUIDE.md](docs/JIRA-SKILL-GUIDE.md) - "Method 3"
- **Demo**: `scripts/demo-interactive.sh`

### Bulk Creation 🚀
- **Demo**: [DEMO.md](DEMO.md) - "Step 5: Bulk Creation"
- **Example**: `examples/sample-implementation-plan.md`
- **Guide**: [docs/JIRA-SKILL-GUIDE.md](docs/JIRA-SKILL-GUIDE.md) - "From Plan"
- **Skill**: `~/.claude/skills/jira-automation/`

### Validation & Error Handling ✅
- **Features**: [DEMO.md](DEMO.md) - "Validation"
- **Code**: `scripts/lib/template-engine.sh` - validation functions
- **Config**: `config/field-mappings.yml` - field definitions
- **Troubleshooting**: [DEMO.md](DEMO.md) - "Troubleshooting"

---

## 🎬 Demo Scenarios

### 10-Minute Full Demo

**Script**: `scripts/demo-interactive.sh`

**Flow**:
1. Introduction (1 min) - Problem & solution
2. Architecture (1 min) - 3 layers
3. Epic creation (2 min) - Professional templates
4. Epic search (2 min) - The secret sauce!
5. Story creation (2 min) - With linking
6. Subtask creation (1 min) - Complete hierarchy
7. Wrap-up (1 min) - Value & next steps

**Materials**: All automated in script

### 5-Minute Quick Demo

**Commands**: Live CLI

**Flow**:
1. Test connection: `jira-test` (30 sec)
2. Create epic: `jira-epic` (2 min)
3. Create story: `jira-story` (2 min) - Show epic suggestion!
4. Wrap-up (30 sec) - Mention bulk creation, time savings

**Materials**: [DEMO-QUICK-REFERENCE.md](DEMO-QUICK-REFERENCE.md) for notes

### 20-Minute Deep Dive

**Format**: Presentation + demo

**Flow**:
1. Problem statement (2 min)
2. Architecture overview (3 min) - Show diagrams
3. Live demo (10 min) - All features
4. Time savings & ROI (2 min) - Show metrics
5. Q&A (3 min)

**Materials**: [DEMO.md](DEMO.md) + diagrams + live demo

---

## 📞 Quick Commands Reference

### Testing
```bash
jira-test                                      # Test connection
```

### Creating Issues
```bash
jira-epic                                      # Create epic
jira-story                                     # Create story
jira-subtask                                   # Create subtask
```

### Demo
```bash
scripts/demo-interactive.sh                    # Run automated demo
```

### Documentation
```bash
cat DEMO.md                                    # Full demo guide
cat DEMO-QUICK-REFERENCE.md                    # Quick reference
cat QUICKSTART.md                              # Getting started
cat docs/JIRA-SKILL-GUIDE.md                   # User guide
```

### Diagrams
```bash
open docs/diagrams/architecture.png            # Architecture
open docs/diagrams/story-epic-suggestion.png   # Epic suggestion
open docs/diagrams/data-flow.png               # Data flow
```

---

## 🎓 Learning Path

### Level 1: Beginner (30 minutes)

1. ✅ Read [QUICKSTART.md](QUICKSTART.md) (5 min)
2. ✅ Run `jira-test` (1 min)
3. ✅ Run `jira-epic` (2 min)
4. ✅ Run `jira-story` (2 min)
5. ✅ Read [DEMO.md](DEMO.md) - Quick Start section (10 min)
6. ✅ Run `scripts/demo-interactive.sh` (10 min)

**Goal**: Can create basic issues

### Level 2: Intermediate (2 hours)

1. ✅ Read [DEMO.md](DEMO.md) in full (30 min)
2. ✅ Read [docs/JIRA-SKILL-GUIDE.md](docs/JIRA-SKILL-GUIDE.md) (45 min)
3. ✅ Try natural language in Claude Code (15 min)
4. ✅ Review templates in `templates/` (15 min)
5. ✅ Create issues from sample plan (15 min)

**Goal**: Can use all features confidently

### Level 3: Advanced (4 hours)

1. ✅ Read all architecture docs (1 hour)
2. ✅ Review code in `scripts/lib/` (1 hour)
3. ✅ Customize templates (30 min)
4. ✅ Update field mappings (30 min)
5. ✅ Write automation scripts (1 hour)

**Goal**: Can customize and extend

### Level 4: Expert (Ongoing)

1. ✅ Contribute new features
2. ✅ Optimize workflows
3. ✅ Train others
4. ✅ Share best practices

**Goal**: System expert and evangelist

---

## 🔍 Find What You Need

### By Topic

| Topic | Primary Resource | Supporting Resources |
|-------|-----------------|----------------------|
| **Overview** | [README.md](README.md) | [DEMO.md](DEMO.md) |
| **Quick Start** | [QUICKSTART.md](QUICKSTART.md) | [DEMO.md](DEMO.md) - Quick Start |
| **Demo** | `scripts/demo-interactive.sh` | [DEMO.md](DEMO.md), [DEMO-QUICK-REFERENCE.md](DEMO-QUICK-REFERENCE.md) |
| **Architecture** | [DEMO.md](DEMO.md) - Architecture | `docs/diagrams/architecture.png` |
| **Epic Linking** | [DEMO.md](DEMO.md) - Feature Showcase | `docs/diagrams/story-epic-suggestion.png` |
| **Templates** | `templates/*.yml` | [docs/JIRA-SKILL-GUIDE.md](docs/JIRA-SKILL-GUIDE.md) - Templates |
| **Configuration** | `config/*.yml` | [docs/JIRA-SKILL-GUIDE.md](docs/JIRA-SKILL-GUIDE.md) - Configuration |
| **Commands** | [docs/QUICK-REFERENCE.md](docs/QUICK-REFERENCE.md) | [QUICKSTART.md](QUICKSTART.md) |
| **Natural Language** | [docs/JIRA-SKILL-GUIDE.md](docs/JIRA-SKILL-GUIDE.md) - Method 1 | [DEMO.md](DEMO.md) - Examples |
| **Troubleshooting** | [DEMO.md](DEMO.md) - Troubleshooting | [docs/JIRA-SKILL-GUIDE.md](docs/JIRA-SKILL-GUIDE.md) - Troubleshooting |

### By File Type

**Markdown Documentation**:
- Core: README.md, QUICKSTART.md
- Demo: DEMO.md, DEMO-QUICK-REFERENCE.md, DEMO-SUMMARY.md, DEMO-INDEX.md
- Guides: docs/JIRA-SKILL-GUIDE.md, docs/QUICK-REFERENCE.md
- Examples: examples/sample-implementation-plan.md

**Scripts**:
- Demo: scripts/demo-interactive.sh
- Core: scripts/jira-workflow.sh
- Libraries: scripts/lib/jira-api.sh, scripts/lib/template-engine.sh

**Configuration**:
- JIRA: config/jira-config.yml
- Fields: config/field-mappings.yml
- Defaults: config/defaults.yml

**Templates**:
- Epic: templates/epic.yml
- Story: templates/story.yml
- Subtask: templates/subtask.yml

**Diagrams**:
- All in: docs/diagrams/*.png

---

## 🎉 Success!

You now have:
- ✅ Complete navigation of all demo materials
- ✅ Clear learning paths for all levels
- ✅ Quick access to all resources
- ✅ Feature-specific documentation pointers

**Ready to get started?**

```bash
# Quick test
jira-test

# Watch demo
scripts/demo-interactive.sh

# Read guide
cat DEMO.md

# Start creating
jira-epic
```

---

**Questions?** Check [DEMO-SUMMARY.md](DEMO-SUMMARY.md) or ask Claude!

---

**Version**: 1.0  
**Created**: 2026-04-06  
**Purpose**: Navigation hub for all demo materials  
**Maintenance**: Update when adding new documentation
