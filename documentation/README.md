# 📚 JIRA Automation - Documentation Hub

## Prequesite

- Install the Jira-cli using this link [JIRA-Cli](https://github.com/ankitpokhrel/jira-cli)

> **Complete documentation navigation for the JIRA automation system**

---

## 🗺️ Quick Navigation

```
┌─────────────────────────────────────────────────────────┐
│  I want to...                    →  Go to...            │
├─────────────────────────────────────────────────────────┤
│  🚀 Get started quickly          →  getting-started/    │
│  📖 Learn to use the system      →  guides/             │
│  🎬 See demos & presentations    →  demo/               │
│  🏗️  Understand architecture     →  architecture/       │
│  📄 See examples                 →  examples/           │
└─────────────────────────────────────────────────────────┘
```

---

## 📂 Documentation Structure

### 🚀 [getting-started/](getting-started/)
**Start here if you're new!**

Files:
- **QUICKSTART.md** - 5-minute getting started guide
- **README.md** - Getting started navigation

**When to use**: First time setup, quick reference

---

### 📖 [guides/](guides/)
**Complete user guides and references**

Files:
- **JIRA-SKILL-GUIDE.md** - Comprehensive 1000+ line user guide
- **QUICK-REFERENCE.md** - Command reference card
- **GUIDE-INDEX.md** - Guide navigation and structure
- **README.md** - Guides overview

**When to use**: Learning features, troubleshooting, reference

---

### 🎬 [demo/](demo/)
**Demo materials and presentations**

Files:
- **DEMO.md** - Complete 20-page walkthrough
- **DEMO-QUICK-REFERENCE.md** - One-page presentation cheat sheet
- **DEMO-SUMMARY.md** - Demo package overview
- **DEMO-INDEX.md** - Demo navigation hub
- **demo-interactive.sh** - Executable 10-minute demo
- **README.md** - Demo package guide

**When to use**: Presenting, learning through demos, practice

---

### 🏗️ [architecture/](architecture/)
**System architecture and technical details**

Files:
- **CONFIGURATION_UPDATE.md** - Configuration changes history
- **IMPLEMENTATION_SUMMARY.md** - Implementation details
- **SKILL_OPTIMIZATION.md** - Skill optimization notes
- **STORY_TEMPLATE_UPDATE.md** - Template update history
- **diagrams/** - All architecture diagrams
  - architecture.png
  - component-architecture.png
  - data-flow.png
  - epic-workflow.png
  - story-epic-suggestion.png

**When to use**: Understanding system design, extending features

---

### 📄 [examples/](examples/)
**Sample data and templates**

Files:
- **sample-implementation-plan.md** - Real implementation plan example
- **example-outputs/** - Sample JIRA outputs

**When to use**: Learning by example, testing bulk creation

---

## 🎯 Quick Access by Use Case

### I'm a New User
**Path**: getting-started/ → guides/ → demo/

1. Read [getting-started/QUICKSTART.md](getting-started/QUICKSTART.md)
2. Run demo: `demo/demo-interactive.sh`
3. Try it: `cd ../src && jira-auto help`
4. Learn more: [guides/JIRA-SKILL-GUIDE.md](guides/JIRA-SKILL-GUIDE.md)

---

### I'm Presenting
**Path**: demo/ → architecture/diagrams/

1. Read [demo/DEMO-SUMMARY.md](demo/DEMO-SUMMARY.md)
2. Review [demo/DEMO-QUICK-REFERENCE.md](demo/DEMO-QUICK-REFERENCE.md)
3. Practice [demo/demo-interactive.sh](demo/demo-interactive.sh)
4. Show diagrams from [architecture/diagrams/](architecture/diagrams/)

---

### I'm Learning the System
**Path**: demo/ → guides/ → architecture/

1. Watch [demo/demo-interactive.sh](demo/demo-interactive.sh)
2. Read [demo/DEMO.md](demo/DEMO.md)
3. Study [guides/JIRA-SKILL-GUIDE.md](guides/JIRA-SKILL-GUIDE.md)
4. Review [architecture/diagrams/](architecture/diagrams/)

---

### I'm Customizing/Extending
**Path**: guides/ → architecture/ → ../src/

1. Read [guides/JIRA-SKILL-GUIDE.md](guides/JIRA-SKILL-GUIDE.md) - Customization section
2. Review [architecture/IMPLEMENTATION_SUMMARY.md](architecture/IMPLEMENTATION_SUMMARY.md)
3. Check [architecture/diagrams/](architecture/diagrams/)
4. Edit files in `../src/templates/` and `../src/config/`

---

## 📊 Documentation Map

```
documentation/
│
├── README.md                          👈 You are here!
│
├── getting-started/                   🚀 Start here
│   ├── QUICKSTART.md                  (5-minute guide)
│   └── README.md                      (Navigation)
│
├── guides/                            📖 User guides
│   ├── JIRA-SKILL-GUIDE.md            (Complete guide)
│   ├── QUICK-REFERENCE.md             (Command reference)
│   ├── GUIDE-INDEX.md                 (Guide navigation)
│   └── README.md                      (Overview)
│
├── demo/                              🎬 Presentations
│   ├── DEMO.md                        (Full walkthrough)
│   ├── DEMO-QUICK-REFERENCE.md        (Cheat sheet)
│   ├── DEMO-SUMMARY.md                (Overview)
│   ├── DEMO-INDEX.md                  (Navigation)
│   ├── demo-interactive.sh            (Executable demo)
│   └── README.md                      (Demo guide)
│
├── architecture/                      🏗️ Technical docs
│   ├── diagrams/                      (Visual assets)
│   │   ├── architecture.png
│   │   ├── component-architecture.png
│   │   ├── data-flow.png
│   │   ├── epic-workflow.png
│   │   └── story-epic-suggestion.png
│   ├── CONFIGURATION_UPDATE.md
│   ├── IMPLEMENTATION_SUMMARY.md
│   ├── SKILL_OPTIMIZATION.md
│   └── STORY_TEMPLATE_UPDATE.md
│
└── examples/                          📄 Sample data
    ├── sample-implementation-plan.md
    └── example-outputs/
```

---

## 🔗 Related Resources

### Source Code
- **../src/** - All source code
  - config/ - Configuration files
  - scripts/ - Core automation scripts
  - templates/ - Issue templates
  - jira-auto - Main entry point

### Project Root
- **../README.md** - Project overview
- **../outputs/** - Generated outputs

---

## 🎓 Learning Paths

### Level 1: Beginner (30 min)
1. ✅ [getting-started/QUICKSTART.md](getting-started/QUICKSTART.md)
2. ✅ [demo/demo-interactive.sh](demo/demo-interactive.sh)
3. ✅ Try: `cd ../src && jira-auto test`

### Level 2: Intermediate (2 hours)
1. ✅ [demo/DEMO.md](demo/DEMO.md)
2. ✅ [guides/JIRA-SKILL-GUIDE.md](guides/JIRA-SKILL-GUIDE.md)
3. ✅ Try all features

### Level 3: Advanced (4 hours)
1. ✅ [architecture/IMPLEMENTATION_SUMMARY.md](architecture/IMPLEMENTATION_SUMMARY.md)
2. ✅ Review [architecture/diagrams/](architecture/diagrams/)
3. ✅ Customize templates in `../src/templates/`

### Level 4: Expert (Ongoing)
1. ✅ Extend features in `../src/scripts/`
2. ✅ Contribute improvements
3. ✅ Train others

---

## 📞 Quick Commands

### Documentation
```bash
# Navigate to documentation
cd documentation/

# Read guides
cat getting-started/QUICKSTART.md
cat guides/JIRA-SKILL-GUIDE.md
cat demo/DEMO.md

# Run demo
demo/demo-interactive.sh

# View diagrams
open architecture/diagrams/architecture.png
```

### Source Code
```bash
# Navigate to source
cd ../src/

# Run commands (from project root)
cd ..
src/jira-auto help
src/jira-auto test
```

---

## 🎯 Find What You Need

### By Topic

| Topic | Location | File |
|-------|----------|------|
| **Getting Started** | getting-started/ | QUICKSTART.md |
| **Complete Guide** | guides/ | JIRA-SKILL-GUIDE.md |
| **Command Reference** | guides/ | QUICK-REFERENCE.md |
| **Demos** | demo/ | DEMO.md |
| **Architecture** | architecture/ | IMPLEMENTATION_SUMMARY.md |
| **Diagrams** | architecture/diagrams/ | *.png |
| **Examples** | examples/ | sample-implementation-plan.md |

### By Audience

| Audience | Start With | Then Read |
|----------|-----------|-----------|
| **New Users** | getting-started/ | guides/ → demo/ |
| **Presenters** | demo/ | architecture/diagrams/ |
| **Developers** | guides/ | architecture/ → ../src/ |
| **Learners** | demo/ | guides/ → examples/ |

---

## 💡 Tips

✅ **Organized by purpose** - Each folder has a clear role  
✅ **README in each folder** - Navigation help everywhere  
✅ **Cross-linked** - Easy to find related content  
✅ **Separate from code** - Clean documentation structure  
✅ **Logical progression** - Natural learning path  

---

## 🎉 Ready to Learn!

**Start your journey**:

```bash
# For new users
cat getting-started/QUICKSTART.md

# For presenters
cat demo/DEMO-QUICK-REFERENCE.md

# For deep dive
cat guides/JIRA-SKILL-GUIDE.md

# For architecture
open architecture/diagrams/architecture.png
```

---

**Questions?** Check the README.md in each subfolder for specific navigation!

---

**Version**: 2.0  
**Last Updated**: 2026-04-06  
**Structure**: Clean separation of docs from code  
**Purpose**: Navigation hub for all documentation
