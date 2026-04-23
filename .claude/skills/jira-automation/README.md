# JIRA Automation Skill

**Optimized Claude Code skill for creating JIRA issues via natural language**

---

## 📖 Complete Guide

**→ See [SKILL-README.md](SKILL-README.md) for the complete user guide**

Quick highlights:
- Natural language issue creation
- Smart epic linking with automatic suggestions
- Professional templates (11 sections for epics)
- Bulk creation from implementation plans
- 95% time savings

---

## ⚙️ Prerequisites

Before using this skill, you need:

### 1. JIRA Automation System Installed

Location: `~/bitbucket/ai-data-jira-automation/`

**Installation Guide**: [~/bitbucket/ai-data-jira-automation/documentation/getting-started/QUICKSTART.md](~/bitbucket/ai-data-jira-automation/documentation/getting-started/QUICKSTART.md)

### 2. JIRA Personal Access Token

**Get Token**:
1. Go to your JIRA server: https://jira.ops.expertcity.com
2. Navigate to: **Profile** → **Personal Access Tokens**
3. Click **"Create Token"** and copy it

**Configure Token**:
```bash
# Add to ~/.zshrc or ~/.bashrc
export JIRA_API_TOKEN="your-token-here"
source ~/.zshrc
```

### 3. Verify Setup

```bash
~/bitbucket/ai-data-jira-automation/src/jira-auto test
```

**See [SKILL-README.md](SKILL-README.md) for detailed setup instructions.**

---

## Structure

```
~/.claude/skills/jira-automation/
├── SKILL.md                    # Main skill (80 lines - optimized!)
├── README.md                   # This file
└── templates/                  # Separate templates for extensibility
    ├── epic-input.md          # Epic field structure & examples
    ├── story-input.md         # Story field structure & examples
    ├── subtask-input.md       # Subtask field structure & examples
    └── plan-parsing.md        # How to parse implementation plans
```

## Commands

Each command is independent and can be used separately:

### 1. Create Epic
```
"Create a JIRA epic called X with goals Y and Z"
```

### 2. Create Story
```
"Create a story for implementing feature X, linked to epic DATA-123"
```

### 3. Create Subtask
```
"Add a subtask to DATA-456 for writing unit tests"
```

### 4. From Plan
```
"Create JIRA issues from this implementation plan: [paste plan]"
```

## Template System

Each template is a separate file for easy extension:

- **epic-input.md**: Required/optional fields for epics, examples, command format
- **story-input.md**: Required/optional fields for stories, examples, command format
- **subtask-input.md**: Required/optional fields for subtasks, examples, command format
- **plan-parsing.md**: Guidelines for extracting issues from markdown plans

### Adding New Fields

To add a new field (e.g., "sprint"):

1. Edit relevant template (e.g., `story-input.md`)
2. Add field to "Optional Fields" section
3. Add example showing the field
4. Update command format if needed

### Adding New Issue Types

To support a new type (e.g., "Task"):

1. Create `task-input.md` template
2. Define required/optional fields
3. Add examples and command format
4. Update `SKILL.md` with new command

## Backend Integration

The skill uses the JIRA automation system at:
`~/bitbucket/ai-data-jira-automation/`

Libraries:
- `src/scripts/lib/jira-api.sh` - JIRA REST API functions
- `src/scripts/lib/template-engine.sh` - Template processing

Functions:
```bash
create_epic "Summary" "NAME" "Desc" "Priority" "labels"
create_story "Summary" "Desc" "EPIC-123" "Priority" "points" "labels"
create_subtask "Summary" "Desc" "STORY-456" "Priority" "labels"
```

## Usage Examples

### Example 1: Simple Epic
```
You: "Create an epic for AI recommendation engine"

Claude extracts:
- epic_name: AI-REC-ENGINE
- summary: AI Recommendation Engine
- Creates epic with defaults
```

### Example 2: Detailed Story
```
You: "Create a story for implementing OAuth2 authentication. 
      As a user, I want to log in with Google so that I don't need 
      another password. Link to epic DATA-123, estimate 8 points."

Claude extracts:
- summary: Implement OAuth2 authentication
- user_type: user
- goal: log in with Google
- benefit: don't need another password
- epic_link: DATA-123
- story_points: 8
```

### Example 3: From Plan
```
You: "Create JIRA issues from this plan: [implementation plan]"

Claude:
1. Parses plan using plan-parsing.md guidelines
2. Identifies epics, stories, subtasks
3. Creates hierarchy
4. Links everything properly
5. Shows results with issue keys
```

## Benefits of This Structure

✅ **Optimized**: Main skill only 80 lines (vs 260 before)
✅ **Modular**: Each command independent
✅ **Extensible**: Easy to add fields/types via templates
✅ **Maintainable**: Templates separate from logic
✅ **Documented**: Each template has examples
✅ **Flexible**: Works with both simple requests and complex plans

## Extending the Skill

### Add Custom Field (e.g., Sprint)

Edit `story-input.md`:
```markdown
- **sprint**: Sprint ID (e.g., "Sprint 42")
```

Add to example:
```
sprint: Sprint 42
```

### Add New Command

Create `templates/task-input.md`:
```markdown
# Task Input Template

## Required Fields
- summary
- description

## Optional Fields
- assignee
- priority
...
```

Update `SKILL.md`:
```markdown
### Create Task
`<create-task summary="TITLE" description="DESC" priority="Medium"/>`
```

### Customize Plan Parsing

Edit `plan-parsing.md`:
- Add new keywords for detection
- Update extraction patterns
- Add examples for your plan format

## Testing

Test the skill by saying:
```
"Create a JIRA epic for data pipeline modernization"
"Create a story for real-time ingestion with 5 points"
"Add subtasks to DATA-123 for: setup, testing, docs"
```

Claude will trigger the skill automatically and create the issues.
