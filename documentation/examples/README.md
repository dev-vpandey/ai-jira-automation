# 📄 Examples

> **Sample data and example outputs**

---

## 📂 Contents

### [sample-implementation-plan.md](sample-implementation-plan.md)
**Real implementation plan example**

A complete implementation plan for a Data Pipeline Modernization project:
- 1 Epic with full context
- 5 Stories with user stories and acceptance criteria
- 20+ Subtasks with implementation steps

**Use this to**:
- See what a good implementation plan looks like
- Test bulk creation feature
- Learn proper structure
- Copy as template for your own plans

---

### example-outputs/
**Sample JIRA outputs**

Generated JSON outputs from issue creation:
- Epic creation responses
- Story creation with linking
- Subtask creation under stories

**Use this to**:
- See what successful responses look like
- Understand issue structure
- Debug issues

---

## 🎯 How to Use

### Learn by Example

**Read the sample plan**:
```bash
cat sample-implementation-plan.md
```

**See the structure**:
- Epic section → Full business context
- Story sections → User stories + acceptance criteria
- Subtask lists → Implementation steps

---

### Test Bulk Creation

**In Claude Code**, paste the plan:
```
"Create JIRA issues from this implementation plan:

[paste contents of sample-implementation-plan.md]
"
```

**Result**: 26 issues created with proper hierarchy!

---

### Use as Template

**Copy and modify**:
```bash
cp sample-implementation-plan.md my-project-plan.md
# Edit my-project-plan.md with your project details
```

Then create issues from your plan.

---

## 📊 What Makes a Good Plan

### Epic Section
✅ Clear overview and business value  
✅ Specific goals and success criteria  
✅ Scope definition (in/out)  
✅ Dependencies identified  

### Story Sections
✅ User story format (As a... I want... So that...)  
✅ Detailed acceptance criteria (Given-When-Then)  
✅ Technical requirements  
✅ Story point estimates  

### Subtask Lists
✅ Specific, actionable tasks  
✅ Clear implementation steps  
✅ Definition of Done  

---

## 🔗 Related Documentation

- **[../demo/](../demo/)** - See bulk creation in action
- **[../guides/](../guides/)** - Learn to create issues
- **[../../src/templates/](../../src/templates/)** - Issue templates

---

## 🚀 Quick Commands

```bash
# Read sample plan
cat sample-implementation-plan.md

# View outputs
ls -la example-outputs/

# Copy as template
cp sample-implementation-plan.md ~/my-plan.md
```

---

**Back to**: [Documentation Hub](../README.md)
