# JIRA Automation - Quick Reference Card

**Fast lookup for common operations**

---

## 🚀 Quick Commands

| What | Command | Time |
|------|---------|------|
| Test Connection | `jira-test` | 5s |
| Create Epic | `jira-epic` | 30s |
| Create Story | `jira-story` | 45s |
| Create Subtask | `jira-subtask` | 20s |
| View Help | `jira-auto help` | - |

---

## 💬 Natural Language Examples

### Epic Creation
```
"Create an epic for data pipeline modernization with goals to 
 improve performance and reduce costs"
```

### Story Creation
```
"Create a story for implementing Kafka ingestion, 8 points, 
 link to DATA-12345"
```

### From Plan
```
"Create JIRA issues from this implementation plan: [paste plan]"
```

---

## 📋 Default Values

| Field | Default | Options |
|-------|---------|---------|
| Priority | **P1** | P0, P1, P2, P3, Unprioritized |
| Component | **DATA-BFRM** | DATA-BFRM, DATA-INFRA, DATA-PIPE, DATA-QUAL |
| Labels | ai-generated | Comma-separated |

---

## 🎯 Priority Guide

| Priority | Meaning | Use When |
|----------|---------|----------|
| **P0** | Critical | Production down, data loss |
| **P1** | High | Blocking work, time-sensitive |
| **P2** | Medium | Important but not urgent |
| **P3** | Low | Tech debt, nice-to-have |

---

## 🔗 Epic Linking

**When creating story without epic link:**

1. Press Enter at "Epic Link" prompt
2. System shows active epics in DATA-BFRM
3. Select from list or enter manually
4. Or skip (leave blank)

**Example:**
```
Epic Link: [Enter]

→ Found 3 epics:
  1  DATA-66186 - Delta Table Retention [To Do]
  2  DATA-66100 - Data Pipeline [In Progress]
  3  DATA-65900 - Analytics [To Do]

Enter Epic Link: 1
```

---

## 📝 Template Structure

### Epic Template Sections
- Overview
- Business Value
- Goals & Objectives
- Success Criteria
- Scope (In/Out)
- Dependencies
- Architecture
- Stakeholders
- Timeline
- Risks

### Story Template Sections
- User Story (As a... I want... So that...)
- Description
- Acceptance Criteria (Given-When-Then)
- Technical Requirements
- Testing Strategy
- Dependencies

### Subtask Template Sections
- Task Description
- Implementation Steps
- Definition of Done
- Files to Modify
- Testing Requirements

---

## 🔧 Function Signatures

### Create Epic
```bash
create_epic \
  <summary> \
  <epic_name> \
  <description> \
  [priority=P1] \
  [component=DATA-BFRM] \
  [labels]
```

### Create Story
```bash
create_story \
  <summary> \
  <description> \
  [epic_link] \
  [priority=P1] \
  [component=DATA-BFRM] \
  [story_points] \
  [labels]
```

### Create Subtask
```bash
create_subtask \
  <summary> \
  <description> \
  <parent_key> \
  [priority=P1] \
  [component=DATA-BFRM] \
  [labels]
```

---

## 🐛 Troubleshooting

| Issue | Solution |
|-------|----------|
| Token not set | `source ~/.zshrc` |
| 401 Unauthorized | Regenerate token at JIRA profile |
| No epics found | Create an epic first with `jira-epic` |
| Component error | Verify component exists in DATA project |
| Custom field error | Update field ID in `config/field-mappings.yml` |

---

## 📂 Key Files

| Purpose | Location |
|---------|----------|
| Main Commands | `jira-epic`, `jira-story`, `jira-subtask` |
| Configuration | `~/bitbucket/ai-data-jira-automation/config/` |
| Templates | `~/bitbucket/ai-data-jira-automation/templates/` |
| Documentation | `~/bitbucket/ai-data-jira-automation/docs/` |
| Skill | `~/.claude/skills/jira-automation/` |

---

## 🎓 Best Practices

### DO ✅
- Link stories to epics
- Use Given-When-Then for acceptance criteria
- Include business value in epics
- Estimate story points
- Define clear DoD for subtasks

### DON'T ❌
- Create epics for small tasks
- Skip acceptance criteria
- Forget epic linking
- Create subtasks >3 days
- Use vague titles

---

## 📊 Story Points Guide

| Points | Complexity | Time | Example |
|--------|------------|------|---------|
| 1-2 | Simple | 1-2 days | Add logging, update config |
| 3-5 | Moderate | 3-5 days | New API endpoint, UI component |
| 8 | Complex | 1 week | Service integration, feature |
| 13+ | Very Complex | 2+ weeks | Break down into smaller stories |

---

## 🔍 Epic Search

**Auto-searches when:**
- Creating story without epic link
- Pressing Enter at epic link prompt

**Shows:**
- Up to 10 recent active epics
- In DATA-BFRM component (default)
- Sorted by last updated
- Only non-Done status

**You can:**
- Select from numbered list
- Enter different epic key
- Skip (leave blank)

---

## 💡 Pro Tips

1. **Use natural language**: Faster than interactive prompts
2. **Let system suggest epics**: Saves JIRA searching time
3. **Create epic first**: Then stories flow naturally
4. **Use templates**: Professional formatting built-in
5. **Batch operations**: Create from plans for speed
6. **Check defaults**: P1 + DATA-BFRM automatic

---

## 🆘 Getting Help

```bash
# Test connection
jira-test

# Show full help
jira-auto help

# Read full guide
cat ~/bitbucket/ai-data-jira-automation/docs/JIRA-SKILL-GUIDE.md

# View examples
ls ~/bitbucket/ai-data-jira-automation/examples/
```

---

## 🎯 Common Workflows

### New Feature
```
1. jira-epic (create epic)
2. jira-story (create stories, link to epic)
3. jira-subtask (add tasks to stories)
```

### From Plan
```
"Create issues from this plan: [paste]"
→ Automatic epic, stories, subtasks
```

### Quick Story
```
"Create story for X, Y points, link to DATA-123"
→ 30 seconds, done
```

---

**Print this card** • **Bookmark this file** • **Share with team**

Last Updated: 2026-04-03
