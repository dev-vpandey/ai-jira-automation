# 🚀 Quick Start Guide - AI JIRA Automation

## Installation Complete! ✅

Your AI-powered JIRA automation system is ready to use.

## 🎯 5-Minute Quick Start

### Step 1: Test Connection (30 seconds)

```bash
jira-test
```

This verifies your JIRA connection is working.

### Step 2: Create Your First Epic (2 minutes)

```bash
jira-epic
```

Follow the prompts:
- **Epic Name**: `DATA-PIPELINE-MOD` (uppercase, hyphens, no spaces)
- **Epic Summary**: `Data Pipeline Modernization Initiative`
- **Overview**: Brief description of the epic
- **Business Value**: Why this matters
- **Goals**: What you want to achieve
- **Success Criteria**: How you'll measure success
- **Priority**: `Medium` (or High/Low)

### Step 3: Create a Story (2 minutes)

```bash
jira-story
```

Follow the prompts:
- **Story Summary**: `Implement real-time data ingestion layer`
- **User Type**: `data engineer`
- **Goal**: `ingest data in real-time from multiple sources`
- **Benefit**: `downstream analytics can access fresh data within minutes`
- **Detailed Description**: Explain the feature
- **Acceptance Criteria**: List what defines "done"
- **Epic Link**: Paste the epic key from Step 2 (e.g., `DATA-12345`)
- **Priority**: `Medium`
- **Story Points**: `8`

### Step 4: Add a Subtask (1 minute)

```bash
jira-subtask
```

Follow the prompts:
- **Parent Story Key**: Paste the story key from Step 3 (e.g., `DATA-12346`)
- **Subtask Summary**: `Set up Kafka cluster infrastructure`
- **Task Description**: What needs to be done
- **Implementation Steps**: List the steps
- **Definition of Done**: Checklist for completion

---

## 📋 Available Commands

| Command | Description | Example |
|---------|-------------|---------|
| `jira-auto help` | Show help | `jira-auto help` |
| `jira-test` | Test JIRA connection | `jira-test` |
| `jira-epic` | Create an epic | `jira-epic` |
| `jira-story` | Create a story | `jira-story` |
| `jira-subtask` | Create a subtask | `jira-subtask` |

## 🎨 Using Templates

Templates are located in:
```
~/bitbucket/ai-data-jira-automation/templates/
├── epic.yml      # Epic template with full structure
├── story.yml     # Story template with user story format
└── subtask.yml   # Subtask template with DoD checklist
```

### Customizing Templates

1. **Edit the template**:
   ```bash
   nano ~/bitbucket/ai-data-jira-automation/templates/epic.yml
   ```

2. **Modify sections** using JIRA wiki markup:
   - `h1.` = Heading 1
   - `h2.` = Heading 2
   - `*bold*` = bold text
   - `* item` = bullet list
   - `# item` = numbered list

3. **Add variables** using `{{variable.name}}` syntax

4. **Test** with `jira-epic` command

## ⚙️ Configuration

Configuration files are in:
```
~/bitbucket/ai-data-jira-automation/config/
├── jira-config.yml      # JIRA connection
├── field-mappings.yml   # Custom field IDs
└── defaults.yml         # Default values
```

### Common Customizations

**Change default priority:**
```bash
nano ~/bitbucket/ai-data-jira-automation/config/defaults.yml
# Edit: epic.priority: "High"
```

**Update custom field IDs:**
```bash
nano ~/bitbucket/ai-data-jira-automation/config/field-mappings.yml
# Edit custom field IDs if they differ in your JIRA
```

**Change project:**
```bash
# Edit jira-config.yml or set environment variable
export JIRA_PROJECT="YOUR-PROJECT"
```

## 🏗️ Typical Workflow

### For a New Initiative

1. **Create Epic** (high-level initiative)
   ```bash
   jira-epic
   ```
   Epic Name: `AI-RECOMMENDATION-ENGINE`
   
2. **Create Stories** (features/requirements)
   ```bash
   jira-story  # Story 1: Build recommendation algorithm
   jira-story  # Story 2: Create API endpoints
   jira-story  # Story 3: Implement caching layer
   ```
   Link each to the epic from step 1

3. **Add Subtasks** (implementation tasks)
   ```bash
   jira-subtask  # Task 1: Write unit tests
   jira-subtask  # Task 2: Implement database schema
   jira-subtask  # Task 3: Create API documentation
   ```
   Link each to appropriate story

### From an Implementation Plan

1. **Read your plan** (e.g., `implementation-plan.md`)

2. **Identify structure**:
   - Top-level sections → Epics
   - Features/Requirements → Stories
   - Tasks/Steps → Subtasks

3. **Create hierarchy**:
   - Create epic first
   - Create stories linked to epic
   - Create subtasks linked to stories

4. **Review in JIRA** to verify hierarchy

## 📊 Output & Tracking

Created issues are tracked in:
```
~/bitbucket/ai-data-jira-automation/outputs/
```

Each creation session generates:
- JSON output with issue keys
- Timestamps
- Creation details

## 💡 Pro Tips

### 1. Use Consistent Naming

**Epics**: 
- ✅ `AI-RECOMMENDATION-ENGINE`
- ✅ `DATA-PIPELINE-MOD`
- ❌ `new project` (too vague)

**Stories**:
- ✅ `Implement user authentication with OAuth2`
- ✅ `Build real-time data ingestion layer`
- ❌ `do auth stuff` (not professional)

**Subtasks**:
- ✅ `Write unit tests for authentication service`
- ✅ `Create database migration for user table`
- ❌ `tests` (not specific enough)

### 2. Write Good Acceptance Criteria

Use Given-When-Then format:
```
* Given a user with valid credentials
  When they submit login form
  Then they should be redirected to dashboard

* Given invalid credentials
  When they submit login form
  Then they should see error message
```

### 3. Break Down Work Appropriately

- **Epic**: 2-6 months of work, multiple teams
- **Story**: 1-2 weeks of work, single team
- **Subtask**: 1-3 days of work, single developer

### 4. Link Everything

Always link:
- Stories → Epic (using Epic Link field)
- Subtasks → Story (using Parent field)
- Related items → (using Blocks/Blocked By)

### 5. Use Labels

Add labels for:
- Technology: `kafka`, `flink`, `python`
- Type: `backend`, `frontend`, `infrastructure`
- Status: `ai-generated`, `needs-review`

## 🐛 Troubleshooting

### Issue: "Command not found: jira-epic"

**Solution**: Reload your shell configuration
```bash
source ~/.zshrc
```

### Issue: "JIRA_API_TOKEN not set"

**Solution**: Check token is exported
```bash
echo $JIRA_API_TOKEN
# If empty, run:
source ~/.zshrc
```

### Issue: "403 Forbidden" or "401 Unauthorized"

**Solution**: 
1. Verify token is valid
2. Check you have permission to create issues
3. Regenerate token if needed

### Issue: Custom field error

**Solution**: Update field IDs in config
```bash
# Find correct field ID
curl -H "Authorization: Bearer $JIRA_API_TOKEN" \
  https://jira.ops.expertcity.com/rest/api/2/field | \
  jq '.[] | select(.custom==true) | {id, name}'

# Update in config/field-mappings.yml
```

## 📚 Learn More

- **Full Documentation**: `~/bitbucket/ai-data-jira-automation/docs/README.md`
- **Examples**: `~/bitbucket/ai-data-jira-automation/examples/`
- **Templates**: `~/bitbucket/ai-data-jira-automation/templates/`

## 🎉 You're Ready!

Start creating issues:
```bash
jira-epic     # Create your first epic
jira-story    # Create stories
jira-subtask  # Add subtasks
```

---

**Need Help?**
- Run: `jira-auto help`
- Read: `~/bitbucket/ai-data-jira-automation/docs/README.md`
- Check examples: `~/bitbucket/ai-data-jira-automation/examples/`
