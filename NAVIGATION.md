# 🗺️ Quick Navigation Guide

> **Find what you need instantly in the reorganized structure**

---

## 🎯 I Want To...

### 🚀 Get Started
**→ Go to**: [documentation/getting-started/QUICKSTART.md](documentation/getting-started/QUICKSTART.md)

Quick 5-minute guide to create your first issues.

---

### 📖 Learn the System
**→ Go to**: [documentation/guides/JIRA-SKILL-GUIDE.md](documentation/guides/JIRA-SKILL-GUIDE.md)

Complete 1000+ line user guide with everything you need.

---

### 🎬 Present/Demo
**→ Go to**: [documentation/demo/](documentation/demo/)

All demo materials, scripts, and presentation guides.

**Quick start**:
```bash
documentation/demo/demo-interactive.sh
cat documentation/demo/DEMO-QUICK-REFERENCE.md
```

---

### 🏗️ Understand Architecture
**→ Go to**: [documentation/architecture/](documentation/architecture/)

System design, diagrams, and technical details.

**View diagrams**:
```bash
open documentation/architecture/diagrams/architecture.png
```

---

### 📄 See Examples
**→ Go to**: [documentation/examples/sample-implementation-plan.md](documentation/examples/sample-implementation-plan.md)

Real implementation plan example with epic, stories, and subtasks.

---

### 💻 Use the System
**→ Go to**: `src/`

Run commands:
```bash
src/jira-auto help
src/jira-auto test
src/jira-auto epic
```

---

### ⚙️ Configure/Customize
**→ Go to**: `src/config/` and `src/templates/`

Edit:
- `src/config/jira-config.yml` - JIRA settings
- `src/config/field-mappings.yml` - Custom fields
- `src/templates/*.yml` - Issue templates

**Guide**: [documentation/guides/JIRA-SKILL-GUIDE.md](documentation/guides/JIRA-SKILL-GUIDE.md) - Customization section

---

## 📂 Project Structure

```
ai-data-jira-automation/
├── README.md                         ← Project overview (start here)
├── NAVIGATION.md                     ← This file
│
├── src/                              ← SOURCE CODE
│   ├── jira-auto                     ← Main entry point
│   ├── config/                       ← Configuration
│   ├── scripts/                      ← Core scripts
│   └── templates/                    ← Issue templates
│
├── documentation/                    ← ALL DOCUMENTATION
│   ├── README.md                     ← Documentation hub
│   ├── getting-started/              ← Quick starts
│   ├── guides/                       ← User guides
│   ├── demo/                         ← Presentations
│   ├── architecture/                 ← Technical docs
│   └── examples/                     ← Sample data
│
└── outputs/                          ← Generated outputs
```

---

## 🗂️ Documentation Hub

**Entry Point**: [documentation/README.md](documentation/README.md)

Complete navigation for all documentation with:
- Quick navigation by need
- Learning paths (4 levels)
- Topic index
- Use case guides

---

## 📋 Common Tasks

### First Time Setup
```bash
# 1. Read quick start
cat documentation/getting-started/QUICKSTART.md

# 2. Test connection
src/jira-auto test

# 3. Try creating an epic
src/jira-auto epic
```

---

### Daily Usage
```bash
# Quick command reference
cat documentation/guides/QUICK-REFERENCE.md

# Create issues
src/jira-auto epic
src/jira-auto story
src/jira-auto subtask
```

---

### Preparing Presentation
```bash
# Read overview
cat documentation/demo/DEMO-SUMMARY.md

# Get talking points
cat documentation/demo/DEMO-QUICK-REFERENCE.md

# Practice
documentation/demo/demo-interactive.sh
```

---

### Troubleshooting
```bash
# Check guide
cat documentation/guides/JIRA-SKILL-GUIDE.md
# Go to "Troubleshooting" section

# Test connection
src/jira-auto test
```

---

## 🎓 Learning Paths

### Beginner (30 min)
1. [README.md](README.md) - Project overview
2. [documentation/getting-started/QUICKSTART.md](documentation/getting-started/QUICKSTART.md)
3. Run `documentation/demo/demo-interactive.sh`

### Intermediate (2 hours)
1. [documentation/demo/DEMO.md](documentation/demo/DEMO.md)
2. [documentation/guides/JIRA-SKILL-GUIDE.md](documentation/guides/JIRA-SKILL-GUIDE.md)
3. Try all features

### Advanced (4 hours)
1. [documentation/architecture/](documentation/architecture/)
2. Review `src/scripts/lib/`
3. Customize templates

---

## 💡 Quick Tips

✅ **Every folder has README.md** - Always check for local navigation  
✅ **Documentation hub** - Start at `documentation/README.md` if lost  
✅ **Root README** - Project overview and quick start  
✅ **Source isolated** - All code in `src/`  
✅ **Docs organized** - By purpose (getting-started, guides, demo, architecture, examples)  

---

## 🔗 Quick Links

| Need | Location |
|------|----------|
| **Project Overview** | [README.md](README.md) |
| **Documentation Hub** | [documentation/README.md](documentation/README.md) |
| **Quick Start** | [documentation/getting-started/QUICKSTART.md](documentation/getting-started/QUICKSTART.md) |
| **Complete Guide** | [documentation/guides/JIRA-SKILL-GUIDE.md](documentation/guides/JIRA-SKILL-GUIDE.md) |
| **Command Reference** | [documentation/guides/QUICK-REFERENCE.md](documentation/guides/QUICK-REFERENCE.md) |
| **Demo Materials** | [documentation/demo/](documentation/demo/) |
| **Architecture** | [documentation/architecture/](documentation/architecture/) |
| **Examples** | [documentation/examples/](documentation/examples/) |
| **Source Code** | [src/](src/) |

---

## ❓ Still Lost?

**Start here**: [documentation/README.md](documentation/README.md)

Complete navigation hub with:
- Clear paths for all use cases
- Learning paths by level
- Topic index
- Use case guides

---

**Version**: 2.0  
**Last Updated**: 2026-04-06  
**Purpose**: Quick navigation for reorganized structure
