# 🎬 JIRA Automation Demo - Complete Walkthrough

> **Transform implementation plans into JIRA issues in minutes, not hours**

---

## 📋 Table of Contents

1. [Quick Demo Overview](#quick-demo-overview)
2. [System Architecture](#system-architecture)
3. [Live Demo Walkthrough](#live-demo-walkthrough)
4. [Feature Showcase](#feature-showcase)
5. [Workflow Diagrams](#workflow-diagrams)
6. [User Guide Integration](#user-guide-integration)
7. [Try It Yourself](#try-it-yourself)

---

## Quick Demo Overview

### What You'll See

In this demo, we'll transform a complete implementation plan into structured JIRA issues:
- **1 Epic** with comprehensive business context
- **5 Stories** with user stories and acceptance criteria
- **20+ Subtasks** with implementation steps

**Time Required**:
- ⏱️ **Manual Creation**: ~3 hours
- ⚡ **With AI Automation**: ~10 minutes

### What Makes This Special

✨ **Intelligent Epic Linking** - Automatically suggests relevant epics  
✨ **Natural Language** - Just describe what you want  
✨ **Professional Templates** - JIRA wiki markup built-in  
✨ **Multiple Interfaces** - CLI commands, natural language, or programmatic API  
✨ **Project Standards** - Follows DATA project conventions (P0-P3, DATA-BFRM)

---

## System Architecture

### The 3-Layer Design

![Architecture Diagram](docs/diagrams/architecture.png)

The system is built on three distinct layers:

#### **Layer 1: User Interfaces**
Choose how you want to interact:
- **Natural Language** - Talk to Claude Code: "Create an epic for data pipeline modernization"
- **Shell Commands** - Direct commands: `jira-epic`, `jira-story`, `jira-subtask`
- **Programmatic API** - Script it: `create_epic()`, `create_story()`

#### **Layer 2: Workflow Orchestration**
The intelligence layer that:
- Collects structured input through interactive prompts
- **Searches and suggests relevant epics** (the secret sauce!)
- Processes templates with JIRA wiki markup
- Validates fields and formats
- Shows preview before creating

#### **Layer 3: JIRA Integration**
Direct integration with JIRA:
- REST API communication
- Custom field mapping (epic name, epic link, story points)
- Automatic hierarchy linking (Epic → Story → Subtask)

### Component Architecture

![Component Architecture](docs/diagrams/component-architecture.png)

**Key Components**:
- `jira-api.sh` - Direct JIRA REST API functions
- `template-engine.sh` - Template processing and JSON payload generation
- `jira-workflow.sh` - Main orchestrator for user interaction
- Claude Code Skill - Natural language interface

---

## Live Demo Walkthrough

### Scenario: Data Pipeline Modernization Project

We have an [implementation plan](examples/sample-implementation-plan.md) for modernizing our data pipeline. Let's create JIRA issues for it!

### Step 1: Test Connection ⚡ (30 seconds)

```bash
jira-test
```

**Output**:
```
Testing JIRA connection...
✓ Connected to JIRA as: vicky.pandey@goto.com
✓ Project: DATA
✓ Components: DATA-BFRM (verified)
✓ Priorities: P0, P1, P2, P3 (verified)
```

✅ **Success!** We're ready to create issues.

---

### Step 2: Create Epic 🎯 (2 minutes)

#### Option A: Natural Language (Recommended)

```
You: "Create an epic for Data Pipeline Modernization with goals to migrate from 
      batch to real-time processing, reduce latency from 4 hours to 15 minutes, 
      and achieve 40% cost reduction. This is P1 priority."

Claude: I'll create that epic for you...
```

**Claude automatically**:
1. Extracts structure from your description
2. Applies the epic template
3. Adds JIRA wiki markup formatting
4. Sets DATA-BFRM component and P1 priority
5. Creates the epic

**Result**:
```
✅ Epic created: DATA-67800
   Summary: Data Pipeline Modernization Initiative
   Epic Name: DATA-PIPE-MOD
   Priority: P1
   Component: DATA-BFRM
   URL: https://jira.ops.expertcity.com/browse/DATA-67800
```

#### Option B: Interactive Command

```bash
jira-epic
```

**Interactive Prompts**:
```
Epic Name: DATA-PIPE-MOD
Epic Summary: Data Pipeline Modernization Initiative

Epic Overview (Ctrl+D when done):
Modernize legacy data pipeline infrastructure to support real-time 
processing, improve data quality, and reduce latency from hours to minutes.
[Ctrl+D]

Business Value (Ctrl+D when done):
- Cost Reduction: Reduce infrastructure costs by 40%
- Performance: Decrease processing time from 4h to 15min
- Scalability: Support 10x data volume growth
- Reliability: Achieve 99.9% uptime
[Ctrl+D]

Goals (one per line, Ctrl+D when done):
- Migrate from batch to real-time streaming
- Implement automated data quality validation
- Reduce operational overhead
- Enable self-service analytics
[Ctrl+D]

Success Criteria (one per line, Ctrl+D when done):
- All pipelines migrated to new architecture
- Data latency under 15 minutes
- Zero data loss during migration
- 40% cost savings within 6 months
- 95% reduction in manual quality issues
[Ctrl+D]

Priority [P1]: P1
Component [DATA-BFRM]: DATA-BFRM

Preview:
{
  "fields": {
    "project": {"key": "DATA"},
    "summary": "Data Pipeline Modernization Initiative",
    "description": "h1. 📋 Overview\n...",
    "issuetype": {"name": "Epic"},
    "priority": {"name": "P1"},
    "components": [{"name": "DATA-BFRM"}],
    "customfield_12131": "DATA-PIPE-MOD"
  }
}

Create this epic? (y/n): y

✅ Epic created: DATA-67800
```

![Epic Workflow](docs/diagrams/epic-workflow.png)

---

### Step 3: Create Story with Epic Suggestion ✨ (2 minutes)

**This is where the magic happens!**

#### Natural Language Example

```
You: "Create a story for implementing real-time data ingestion using Kafka. 
      We need to support 100k events/second with under 2 minute latency. 
      Estimate this at 8 story points."

Claude: I'll create that story. Let me search for relevant epics...
        
        Found 3 epics in DATA-BFRM:
        1. DATA-67800 - Data Pipeline Modernization Initiative [To Do]
        2. DATA-66186 - Delta Table Retention & Vacuum Strategy [To Do]
        3. DATA-66100 - Real-time Data Platform Phase 2 [In Progress]
        
        Based on your description, DATA-67800 (Data Pipeline Modernization) 
        seems like the best match. Should I link this story to that epic?

You: Yes

Claude: Creating story linked to DATA-67800...

        ✅ Story created: DATA-67801
           Summary: Implement Real-Time Data Ingestion Layer
           Linked to: DATA-67800 (Data Pipeline Modernization Initiative)
           Story Points: 8
           Priority: P1
           Component: DATA-BFRM
           URL: https://jira.ops.expertcity.com/browse/DATA-67801
```

#### How Epic Suggestion Works

![Story Epic Suggestion Flow](docs/diagrams/story-epic-suggestion.png)

**The Process**:
1. **Detect**: No epic link provided in request
2. **Search**: Query JIRA for active epics in DATA-BFRM component
3. **Analyze**: Match story keywords with epic summaries
4. **Rank**: Score epics by relevance
5. **Suggest**: Present top matches to user
6. **Confirm**: User selects or provides epic key manually
7. **Link**: Story created with epic link

**Smart Matching**:
- Keyword matching: "Kafka ingestion" → "Data Pipeline"
- Recent epics prioritized (updated DESC)
- Only shows active epics (To Do, In Progress)
- Component-aware (DATA-BFRM only)

---

### Step 4: Create Subtask 📝 (1 minute)

```bash
jira-subtask
```

**Prompts**:
```
Parent Story Key: DATA-67801

Subtask Summary: Set up Kafka cluster infrastructure

Task Description (Ctrl+D when done):
Deploy production-ready Kafka cluster with 3 brokers and ZooKeeper 
ensemble for high availability and fault tolerance.
[Ctrl+D]

Implementation Steps (one per line, Ctrl+D when done):
1. Provision 3 EC2 instances for Kafka brokers
2. Install and configure Kafka 3.x
3. Set up ZooKeeper ensemble (3 nodes)
4. Configure broker settings for performance
5. Enable SSL/SASL authentication
6. Test cluster connectivity and failover
[Ctrl+D]

Definition of Done (one per line, Ctrl+D when done):
- 3-broker cluster operational
- ZooKeeper ensemble healthy
- SSL/SASL authentication working
- Monitoring dashboards created
- Runbook documented
[Ctrl+D]

Priority [P1]: P1
Component [DATA-BFRM]: DATA-BFRM

Create this subtask? (y/n): y

✅ Subtask created: DATA-67802
   Under parent: DATA-67801
   URL: https://jira.ops.expertcity.com/browse/DATA-67802
```

---

### Step 5: Bulk Creation from Plan 🚀 (10 minutes)

**The Power Move**: Create everything at once from your implementation plan!

```
You: "Create JIRA issues from this implementation plan: [paste plan]"

Claude: I'll parse this plan and create a complete issue hierarchy...

        Analyzing plan structure:
        - 1 Epic: Data Pipeline Modernization Initiative
        - 5 Stories: Ingestion, Quality, Processing, Storage, Analytics
        - 20 Subtasks: Implementation tasks for each story

        Creating in order:
        
        ✅ Epic: DATA-67800 - Data Pipeline Modernization Initiative
        
        ✅ Story: DATA-67801 - Implement Real-Time Data Ingestion Layer
           → Linked to Epic: DATA-67800
           → Story Points: 8
           
           ✅ Subtask: DATA-67802 - Set up Kafka cluster infrastructure
           ✅ Subtask: DATA-67803 - Configure Schema Registry
           ✅ Subtask: DATA-67804 - Implement source connectors
           ✅ Subtask: DATA-67805 - Build dead letter queue
           ✅ Subtask: DATA-67806 - Create monitoring dashboards
           
        ✅ Story: DATA-67807 - Build Data Quality Validation Framework
           → Linked to Epic: DATA-67800
           → Story Points: 5
           
           ✅ Subtask: DATA-67808 - Design validation rule schema
           ✅ Subtask: DATA-67809 - Implement Great Expectations integration
           ✅ Subtask: DATA-67810 - Create validation rules
           ✅ Subtask: DATA-67811 - Build metrics collection service
           
        ✅ Story: DATA-67812 - Develop Stream Processing Layer
           → Linked to Epic: DATA-67800
           → Story Points: 13
           
        [... continues for all stories and subtasks ...]

        Summary:
        ✅ Created 1 epic
        ✅ Created 5 stories (all linked to epic)
        ✅ Created 20 subtasks (all linked to stories)
        
        Total: 26 issues in ~10 minutes
        (vs ~3 hours manual creation)
        
        View epic hierarchy: https://jira.ops.expertcity.com/browse/DATA-67800
```

---

## Feature Showcase

### 1. Professional Templates

All issues use **JIRA wiki markup** for professional formatting:

#### Epic Template Structure
```
h1. 📋 Overview
{{epic.overview}}

h1. 💼 Business Value
{{epic.business_value}}

h1. 🎯 Goals & Objectives
{{epic.goals}}

h1. ✅ Success Criteria
{{epic.success_criteria}}

h1. 🔍 Scope
h2. In Scope
* {{epic.in_scope}}

h2. Out of Scope
* {{epic.out_of_scope}}

h1. 🔗 Dependencies
{{epic.dependencies}}

h1. 📊 Metrics & KPIs
{{epic.metrics}}
```

**Result in JIRA**: Properly formatted with headings, bullets, sections

#### Story Template Structure
```
h1. 📖 User Story
*As a* {{story.user_type}}
*I want* {{story.goal}}
*So that* {{story.benefit}}

h1. 📝 Description
{{story.description}}

h1. ✅ Acceptance Criteria
{{story.acceptance_criteria}}

h1. 🔧 Technical Requirements
{{story.technical_requirements}}

h1. 📋 Implementation Notes
{{story.implementation_notes}}

h1. 🧪 Testing Strategy
{{story.testing_strategy}}
```

### 2. Intelligent Field Mapping

**Custom Fields Handled**:
- `customfield_12131` - Epic Name (e.g., "DATA-PIPE-MOD")
- `customfield_12130` - Epic Link (links story to epic)
- `customfield_10004` - Story Points (1, 2, 3, 5, 8, 13, 21)

**Standard Fields**:
- Priority: P0, P1, P2, P3, Unprioritized
- Component: DATA-BFRM (default)
- Labels: `ai-generated`, custom labels

**Automatic Defaults**:
```yaml
epic:
  priority: "P1"
  component: "DATA-BFRM"
  labels: ["ai-generated", "epic"]

story:
  priority: "P1"
  component: "DATA-BFRM"
  labels: ["ai-generated", "story"]
```

### 3. Epic Search Intelligence

![Data Flow](docs/diagrams/data-flow.png)

**Search Algorithm**:
```bash
# JQL Query
project = DATA 
AND issuetype = Epic 
AND component = "DATA-BFRM" 
AND status IN ('To Do', 'In Progress')
ORDER BY updated DESC
LIMIT 10

# Keyword Matching
story_keywords = ["kafka", "ingestion", "real-time"]
epic_summary = "Data Pipeline Modernization"

# Scoring
score = 0
for keyword in story_keywords:
    if keyword in epic_summary.lower():
        score += 1

# Ranking
epics_sorted_by_score_and_recency
```

**Result**: Most relevant, recently updated epics shown first

### 4. Validation & Error Handling

**Validation Rules**:
```bash
# Epic Name Format
[A-Z]+-[A-Z-]+
✅ DATA-PIPE-MOD
❌ data pipe mod

# Summary Length
1-255 characters
✅ "Implement Real-Time Data Ingestion"
❌ "" (empty)

# Priority Values
P0, P1, P2, P3, Unprioritized
✅ P1
❌ High (wrong format)

# Epic Link Format
[A-Z]+-\d+
✅ DATA-67800
❌ 67800 (missing project key)
```

**Error Messages**:
```bash
❌ Error: Epic name must be uppercase with hyphens
   Example: DATA-PIPELINE-MOD
   
❌ Error: Epic link DATA-99999 not found
   Available epics:
   - DATA-67800
   - DATA-66186
   
❌ Error: Story points must be a number (1,2,3,5,8,13,21)
   Provided: "large"
```

---

## Workflow Diagrams

### Complete Data Flow

![Complete Data Flow](docs/diagrams/data-flow.png)

**Flow Steps**:
1. **User Input** → Natural language, shell command, or API call
2. **Structure Extraction** → Parse into fields (summary, description, priority)
3. **Epic Search** → Find relevant epics (if story/subtask)
4. **Template Processing** → Apply JIRA wiki markup templates
5. **Field Mapping** → Map to JIRA field IDs (custom + standard)
6. **Validation** → Check required fields, formats
7. **Preview** → Show user what will be created
8. **Confirmation** → User approves
9. **JIRA API** → POST to /rest/api/2/issue
10. **Response** → Issue key, URL returned
11. **Output** → Display to user, save to outputs/

### Epic Creation Workflow

![Epic Workflow](docs/diagrams/epic-workflow.png)

### Story Creation with Epic Suggestion

![Story Epic Suggestion](docs/diagrams/story-epic-suggestion.png)

---

## User Guide Integration

### Quick Reference

| Task | Command | Time | Natural Language |
|------|---------|------|------------------|
| **Test Connection** | `jira-test` | 5s | "Test JIRA connection" |
| **Create Epic** | `jira-epic` | 2m | "Create epic for [description]" |
| **Create Story** | `jira-story` | 2m | "Create story for [description]" |
| **Create Subtask** | `jira-subtask` | 1m | "Add subtask to [story-key]" |
| **From Plan** | - | 10m | "Create issues from plan: [paste]" |

### Best Practices

#### Epic Naming
✅ **Good Examples**:
- `AI-RECOMMENDATION-ENGINE` - Clear, specific
- `DATA-PIPELINE-MOD` - Action-oriented
- `ML-MODEL-TRAINING-V2` - Versioned

❌ **Bad Examples**:
- `new project` - Too vague
- `data stuff` - Not professional
- `Project 1` - Not descriptive

#### Story Points Estimation

| Points | Complexity | Time | Example |
|--------|-----------|------|---------|
| **1-2** | Simple | 1-2 days | Update config, add logging |
| **3-5** | Moderate | 3-5 days | New API endpoint, simple feature |
| **8** | Complex | 1-2 weeks | Integration, multiple components |
| **13** | Very Complex | 2-3 weeks | New service, architecture change |
| **21+** | Too Large | - | **Break it down!** |

#### Acceptance Criteria Format

**Use Given-When-Then**:
```
Given: A user with valid OAuth credentials
When: They submit the login form
Then: They should be redirected to the dashboard
  And see a welcome message with their name
  And have session token stored securely

Given: A user with invalid credentials
When: They submit the login form
Then: They should see an error message
  And remain on the login page
  And not be granted access
```

#### Priority Guidelines

| Priority | Impact | Response Time | Examples |
|----------|--------|---------------|----------|
| **P0** | **CRITICAL** | Immediate | Production down, data loss, security breach |
| **P1** | **HIGH** | Same day | Blocking work, critical bugs, time-sensitive |
| **P2** | **MEDIUM** | This week | Important features, moderate bugs |
| **P3** | **LOW** | This month | Nice to have, tech debt, optimizations |
| **Unprioritized** | **TBD** | - | Needs triage, unclear priority |

---

## Try It Yourself

### Setup (5 minutes)

Already done if you have access to the repository!

1. **Verify Installation**:
   ```bash
   jira-test
   ```

2. **Check Configuration**:
   ```bash
   echo $JIRA_API_TOKEN  # Should show token
   cat ~/bitbucket/ai-data-jira-automation/config/jira-config.yml
   ```

3. **Review Templates**:
   ```bash
   ls ~/bitbucket/ai-data-jira-automation/templates/
   # epic.yml, story.yml, subtask.yml
   ```

### Demo 1: Single Epic (2 minutes)

```bash
jira-epic
```

Fill in:
- Epic Name: `DEMO-TEST-EPIC`
- Summary: `Demo Epic for Testing`
- Overview: `This is a demo epic to test the automation`
- Business Value: `Testing the system works correctly`
- Goals: `Verify epic creation`, `Test template formatting`
- Success Criteria: `Epic created successfully`, `Formatted correctly in JIRA`
- Priority: `P3`
- Component: `DATA-BFRM`

**Expected Result**: ✅ Epic created with key like DATA-xxxxx

### Demo 2: Story with Epic Suggestion (3 minutes)

```bash
jira-story
```

Fill in:
- Summary: `Test story creation with epic linking`
- User Type: `developer`
- Goal: `test the story creation workflow`
- Benefit: `I can verify the automation works`
- Description: `Testing story creation and epic linking`
- Acceptance Criteria: `Story created successfully`, `Linked to demo epic`
- Epic Link: Press Enter (should show your demo epic from Demo 1)
- Priority: `P3`
- Story Points: `2`

**Expected Result**: ✅ Story created and linked to your demo epic

### Demo 3: Subtask Creation (1 minute)

```bash
jira-subtask
```

Fill in:
- Parent Story Key: [paste story key from Demo 2]
- Summary: `Test subtask implementation`
- Description: `Verify subtask creation works`
- Implementation Steps: `Step 1: Run command`, `Step 2: Fill in fields`, `Step 3: Verify result`
- Definition of Done: `Subtask created`, `Linked to parent story`
- Priority: `P3`

**Expected Result**: ✅ Subtask created under your demo story

### Demo 4: Natural Language (30 seconds)

In Claude Code, type:

```
Create an epic called DEMO-NATURAL-LANG for testing natural language 
creation with goals to verify AI integration and test workflow automation. 
Priority P3.
```

**Expected Result**: Claude creates the epic automatically

---

## Advanced Features

### 1. Programmatic API

Create a batch script:

```bash
#!/bin/bash
source ~/bitbucket/ai-data-jira-automation/scripts/lib/jira-api.sh

# Create epic
epic_response=$(create_epic \
  "Q2 Sprint Planning" \
  "SPRINT-Q2-2026" \
  "Planning for Q2 initiatives" \
  "P1" \
  "DATA-BFRM" \
  "ai-generated,sprint")

epic_key=$(echo "$epic_response" | jq -r '.key')
echo "Epic: $epic_key"

# Create 5 stories
for i in {1..5}; do
  story_response=$(create_story \
    "Story $i for Q2 Sprint" \
    "Implementation details for story $i" \
    "$epic_key" \
    "P1" \
    "DATA-BFRM" \
    "5" \
    "ai-generated,sprint,q2")
  
  story_key=$(echo "$story_response" | jq -r '.key')
  echo "Story: $story_key"
done

echo "✅ Created 1 epic + 5 stories"
```

### 2. Custom Templates

Edit templates for your team:

```bash
nano ~/bitbucket/ai-data-jira-automation/templates/story.yml
```

Add custom sections:
```yaml
h1. 🎯 OKRs
{{story.okrs | default:"* Objective: TBD"}}

h1. 🔐 Security Considerations
{{story.security | default:"* Review security implications"}}

h1. 📱 Mobile Considerations
{{story.mobile | default:"* N/A for backend stories"}}
```

### 3. CI/CD Integration

Automate issue creation in your pipeline:

```yaml
# .github/workflows/create-issues.yml
name: Create JIRA Issues from Plan

on:
  push:
    paths:
      - 'docs/implementation-plan.md'

jobs:
  create-issues:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Create Issues
        env:
          JIRA_API_TOKEN: ${{ secrets.JIRA_API_TOKEN }}
        run: |
          # Parse plan and create issues
          source ~/bitbucket/ai-data-jira-automation/scripts/lib/jira-api.sh
          # ... issue creation logic ...
```

---

## Troubleshooting

### Common Issues & Solutions

#### 1. "Command not found: jira-epic"

**Problem**: Aliases not loaded

**Solution**:
```bash
source ~/.zshrc
```

#### 2. "JIRA_API_TOKEN not set"

**Problem**: Environment variable not configured

**Solution**:
```bash
# Check if token exists
echo $JIRA_API_TOKEN

# If empty, reload config
source ~/.zshrc

# If still empty, add to ~/.zshrc
echo 'export JIRA_API_TOKEN="your-token-here"' >> ~/.zshrc
source ~/.zshrc
```

#### 3. "401 Unauthorized"

**Problem**: Token expired or invalid

**Solution**:
1. Go to https://jira.ops.expertcity.com/secure/ViewProfile.jspa
2. Generate new Personal Access Token
3. Update `~/.zshrc`
4. Reload: `source ~/.zshrc`

#### 4. "No epics found in DATA-BFRM"

**Problem**: No active epics in component

**Solution**:
```bash
# Create an epic first
jira-epic

# Or manually enter epic key when prompted
```

#### 5. "Custom field error"

**Problem**: Field ID different in your JIRA

**Solution**:
```bash
# Find correct field IDs
curl -H "Authorization: Bearer $JIRA_API_TOKEN" \
  https://jira.ops.expertcity.com/rest/api/2/field | \
  jq '.[] | select(.custom==true) | {id, name}'

# Update config/field-mappings.yml with correct IDs
```

---

## Summary

### What You Learned

✅ **3-Layer Architecture** - UI → Orchestration → Integration  
✅ **Multiple Interfaces** - Natural language, CLI, API  
✅ **Epic Intelligence** - Automatic search and suggestion  
✅ **Professional Templates** - JIRA wiki markup formatting  
✅ **Project Standards** - DATA conventions built-in  
✅ **Bulk Creation** - Transform plans into issues  

### Time Savings

| Task | Manual Time | Automated Time | Savings |
|------|-------------|----------------|---------|
| **1 Epic** | 15 min | 30 sec | **96%** |
| **1 Story** | 10 min | 45 sec | **92%** |
| **1 Subtask** | 5 min | 20 sec | **93%** |
| **20 Issues** | 3 hours | 10 min | **94%** |

### Quality Improvements

✅ **Consistency** - All issues follow same template structure  
✅ **Completeness** - No missing sections or fields  
✅ **Formatting** - Professional JIRA wiki markup  
✅ **Linking** - Automatic epic → story → subtask hierarchy  
✅ **Standards** - DATA project conventions enforced  

---

## Next Steps

### 1. Try the Demo
```bash
jira-test           # Test connection
jira-epic           # Create your first epic
jira-story          # Create a story with epic suggestion
```

### 2. Read the Documentation
- [User Guide](docs/JIRA-SKILL-GUIDE.md) - Complete guide
- [Quick Start](QUICKSTART.md) - 5-minute guide
- [README](README.md) - Overview

### 3. Customize for Your Team
- Edit templates in `templates/`
- Update field mappings in `config/field-mappings.yml`
- Adjust defaults in `config/defaults.yml`

### 4. Integrate into Workflow
- Use natural language in Claude Code
- Add to CI/CD pipelines
- Create bulk automation scripts

---

## Resources

### Documentation
- 📖 [Complete User Guide](docs/JIRA-SKILL-GUIDE.md)
- 🚀 [Quick Start Guide](QUICKSTART.md)
- 📋 [Quick Reference](docs/QUICK-REFERENCE.md)
- 📝 [README](README.md)

### Examples
- 📄 [Sample Implementation Plan](examples/sample-implementation-plan.md)
- 📊 [Example Outputs](examples/example-outputs/)

### Diagrams
- 🏗️ [Architecture](docs/diagrams/architecture.png)
- 🔧 [Component Architecture](docs/diagrams/component-architecture.png)
- 📈 [Data Flow](docs/diagrams/data-flow.png)
- 🎯 [Epic Workflow](docs/diagrams/epic-workflow.png)
- ✨ [Story Epic Suggestion](docs/diagrams/story-epic-suggestion.png)

### Configuration
- ⚙️ [JIRA Config](config/jira-config.yml)
- 🗺️ [Field Mappings](config/field-mappings.yml)
- 🎨 [Defaults](config/defaults.yml)
- 📝 [Epic Template](templates/epic.yml)
- 📖 [Story Template](templates/story.yml)
- 📋 [Subtask Template](templates/subtask.yml)

---

## Questions?

- ❓ Run `jira-auto help` for command help
- 📚 Check [docs/](docs/) for detailed guides
- 🔍 Review [examples/](examples/) for samples
- 💬 Ask Claude Code: "Help me create a JIRA epic"

---

**🎉 Ready to automate your JIRA workflow?**

```bash
jira-epic  # Start here!
```

Or tell Claude:
```
"Create an epic for [your project description]"
```

---

**Version**: 1.0  
**Last Updated**: 2026-04-06  
**Status**: ✅ Production Ready  
**Demo Duration**: 20 minutes  
**Complexity**: Beginner-friendly
