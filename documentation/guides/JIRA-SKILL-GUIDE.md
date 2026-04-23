# JIRA Automation Skill - Complete Guide

**Enterprise-grade JIRA automation with AI-powered workflows**

---

## 📖 Table of Contents

1. [Overview](#overview)
2. [Why This Was Built](#why-this-was-built)
3. [How It Works](#how-it-works)
4. [Architecture](#architecture)
5. [User Guide](#user-guide)
6. [Advanced Usage](#advanced-usage)
7. [Troubleshooting](#troubleshooting)
8. [Best Practices](#best-practices)

---

## Overview

The JIRA Automation Skill is a comprehensive system that lets you create JIRA issues (Epics, Stories, Subtasks) using:
- **Natural language** via Claude Code conversations
- **Interactive shell commands** for direct control
- **Programmatic APIs** for scripting and automation

### What Makes It Special

✨ **Intelligent Epic Linking** - Automatically suggests relevant epics when creating stories
✨ **Professional Templates** - JIRA wiki markup with best practices built-in
✨ **Flexible Configuration** - Easy field mapping without code changes
✨ **Natural Language** - Just describe what you want, Claude creates it
✨ **Standards-Compliant** - Follows DATA project conventions (P0-P3 priorities, DATA-BFRM component)

---

## Why This Was Built

### The Problem

Creating JIRA issues manually is time-consuming:
- Navigate to JIRA web interface
- Fill in multiple fields
- Remember epic keys for linking
- Copy/paste structured descriptions
- Ensure consistent formatting
- Follow team conventions (priorities, components)

**Time per issue**: 5-10 minutes
**For a project with 20+ issues**: 2+ hours of repetitive work

### The Solution

**AI-powered automation that:**
1. Creates issues from natural language descriptions
2. Suggests epic links automatically
3. Uses professional templates
4. Follows project standards
5. Works in your development environment

**Time per issue**: 30 seconds
**For a project with 20+ issues**: 10 minutes

### The Benefits

| Before | After |
|--------|-------|
| Manual form filling | Natural language or quick commands |
| Search JIRA for epic keys | Auto-suggested from context |
| Remember field formats | Templates with JIRA wiki markup |
| Copy conventions manually | Defaults follow DATA standards |
| Context switching (IDE → JIRA) | Stay in terminal/Claude Code |

---

## How It Works

### The 3-Layer Architecture

```
┌─────────────────────────────────────────────────────────────┐
│  LAYER 1: USER INTERFACES                                    │
├─────────────────────────────────────────────────────────────┤
│  • Natural Language (Claude Code Skill)                      │
│  • Shell Commands (jira-epic, jira-story, jira-subtask)     │
│  • Programmatic API (Bash functions)                         │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│  LAYER 2: WORKFLOW ORCHESTRATION                             │
├─────────────────────────────────────────────────────────────┤
│  • Interactive Prompts (collect user input)                  │
│  • Epic Search & Suggestion (find relevant epics)            │
│  • Template Processing (apply JIRA templates)                │
│  • Validation (check required fields, formats)               │
│  • Preview & Confirmation (show before creating)             │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│  LAYER 3: JIRA INTEGRATION                                   │
├─────────────────────────────────────────────────────────────┤
│  • JIRA REST API (direct API calls)                          │
│  • Field Mapping (standard + custom fields)                  │
│  • Issue Creation (create epics, stories, subtasks)          │
│  • Issue Linking (epic → story → subtask hierarchy)          │
└─────────────────────────────────────────────────────────────┘
```

### The Workflow Flow

#### Creating an Epic

```
User Request
    │
    ├─ Natural Language: "Create epic for data pipeline"
    │  └─> Skill extracts: name, summary, goals, priority
    │
    ├─ Shell Command: jira-epic
    │  └─> Interactive prompts for each field
    │
    └─ API Call: create_epic(...)
       └─> Direct function call with parameters

    ↓
Orchestration Layer
    │
    ├─ Apply defaults (Priority: P1, Component: DATA-BFRM)
    ├─ Process epic template (wiki markup formatting)
    ├─ Validate fields (epic name format, summary length)
    └─> Generate JIRA JSON payload

    ↓
JIRA Integration
    │
    ├─> POST to /rest/api/2/issue
    ├─> Receive response (issue key: DATA-12345)
    └─> Return success + URL

    ↓
User Sees
    │
    └─> ✅ Epic: DATA-12345 - Data Pipeline Modernization
        URL: https://jira.ops.expertcity.com/browse/DATA-12345
```

#### Creating a Story (with Epic Suggestion)

```
User Request
    │
    └─ "Create story for implementing Kafka ingestion"
        (No epic link mentioned)

    ↓
Orchestration Layer
    │
    ├─ Extract story details from description
    ├─ Notice: No epic link provided
    └─> Trigger Epic Search

Epic Search Process
    │
    ├─ Query JIRA: Find active epics in DATA-BFRM
    │   JQL: project=DATA AND type=Epic AND component=DATA-BFRM
    │        AND status!=Done ORDER BY updated DESC
    │
    ├─ Receive: List of 5-10 recent active epics
    │
    ├─ Analyze: Match "Kafka ingestion" keywords with epic summaries
    │   • DATA-66186: "Delta Table Retention" → No match
    │   • DATA-66100: "Real-time Data Pipeline" → MATCH! (keyword: pipeline)
    │   • DATA-65900: "Analytics Dashboard" → No match
    │
    └─> Suggest: DATA-66100 as closest match

User Interaction
    │
    ├─ Show list:
    │   1  DATA-66100 - Real-time Data Pipeline [In Progress]
    │   2  DATA-66186 - Delta Table Retention [To Do]
    │   3  DATA-65900 - Analytics Dashboard [To Do]
    │
    └─ User selects: DATA-66100 (or enters manually)

    ↓
Continue Story Creation
    │
    ├─ Apply story template
    ├─ Add epic link: customfield_12130 = "DATA-66100"
    ├─> Create story via JIRA API

    ↓
Result
    │
    └─> ✅ Story: DATA-67800 (→ DATA-66100)
        Summary: Implement Kafka ingestion layer
        URL: https://jira.ops.expertcity.com/browse/DATA-67800
```

---

## Architecture

### Component Overview

```
ai-data-jira-automation/
│
├── 🎯 ENTRY POINTS
│   ├── jira-auto (main wrapper)
│   └── Shell aliases (jira-epic, jira-story, jira-subtask)
│
├── ⚙️ CONFIGURATION
│   ├── config/
│   │   ├── jira-config.yml (connection, priorities, components)
│   │   ├── field-mappings.yml (custom field IDs)
│   │   └── defaults.yml (default values, behavior)
│   │
│   └── templates/
│       ├── epic.yml (epic template structure)
│       ├── story.yml (story template structure)
│       └── subtask.yml (subtask template structure)
│
├── 🔧 CORE LOGIC
│   ├── scripts/
│   │   ├── jira-workflow.sh (main orchestrator)
│   │   └── lib/
│   │       ├── jira-api.sh (JIRA REST API functions)
│   │       └── template-engine.sh (template processing)
│   │
│   └── Skills integration via ~/.claude/skills/jira-automation/
│
├── 📚 DOCUMENTATION
│   └── docs/ (guides, examples, references)
│
└── 📊 OUTPUTS
    └── outputs/ (created issues, logs, audit trail)
```

### Key Components Explained

#### 1. JIRA API Library (`scripts/lib/jira-api.sh`)

**Purpose**: Direct communication with JIRA REST API

**Functions**:
- `create_epic()` - Create epic with custom fields
- `create_story()` - Create story with epic linking
- `create_subtask()` - Create subtask under parent story
- `search_epics_in_component()` - Search for active epics
- `suggest_epic_link()` - Display epic suggestions
- `get_jira_issue()` - Fetch issue details
- `update_jira_issue()` - Update existing issue

**Why**: Encapsulates all JIRA API interactions in reusable functions

#### 2. Template Engine (`scripts/lib/template-engine.sh`)

**Purpose**: Process templates and generate JIRA payloads

**Functions**:
- `process_epic_template()` - Apply epic template
- `process_story_template()` - Apply story template
- `process_subtask_template()` - Apply subtask template
- `generate_epic_payload()` - Create JIRA JSON for epic
- `generate_story_payload()` - Create JIRA JSON for story
- `validate_epic_data()` - Validate epic fields

**Why**: Separates template logic from API logic, makes templates easy to customize

#### 3. Workflow Orchestrator (`scripts/jira-workflow.sh`)

**Purpose**: Main entry point, orchestrates user interaction

**Functions**:
- `interactive_create_epic()` - Guided epic creation
- `interactive_create_story()` - Guided story creation with epic suggestion
- `interactive_create_subtask()` - Guided subtask creation

**Why**: Provides consistent, user-friendly interface across all operations

#### 4. Claude Code Skill (`~/.claude/skills/jira-automation/`)

**Purpose**: Enable natural language issue creation

**Components**:
- `SKILL.md` - Skill definition (80 lines, optimized)
- `templates/` - Input templates for each issue type
  - `epic-input.md` - Epic field structure
  - `story-input.md` - Story field structure
  - `subtask-input.md` - Subtask field structure
  - `plan-parsing.md` - Guidelines for parsing plans

**Why**: Bridges natural language (Claude Code) with structured JIRA creation

### Data Flow

```
┌──────────────┐
│  User Input  │
│ (NL/Shell)   │
└──────┬───────┘
       │
       ├─ Natural Language → Claude Code Skill
       │                     └─> Extracts structured data
       │
       └─ Shell Command → Interactive Prompts
                          └─> Collects structured data
       
       ↓
       
┌──────────────────────┐
│  Structured Data     │
│  {                   │
│    summary: "...",   │
│    priority: "P1",   │
│    component: "..."  │
│  }                   │
└──────────┬───────────┘
           │
           ├─> Apply Templates (template-engine.sh)
           │   └─> Add JIRA wiki markup
           │       Add standard sections
           │       Fill placeholders
           │
           ├─> Validate Fields (field-mappings.yml)
           │   └─> Check required fields
           │       Validate formats
           │       Apply defaults
           │
           └─> Generate JSON Payload
               └─> Map to JIRA field IDs
                   Add custom fields
                   Structure for API

           ↓
           
┌──────────────────────┐
│  JIRA JSON Payload   │
│  {                   │
│    "fields": {       │
│      "project": {...}│
│      "summary": "..." │
│      "customfield_   │
│       12131": "..."  │
│    }                 │
│  }                   │
└──────────┬───────────┘
           │
           └─> POST to JIRA API
               (jira-api.sh)

           ↓
           
┌──────────────────────┐
│  JIRA Response       │
│  {                   │
│    "key": "DATA-123" │
│    "id": "67890"     │
│    "self": "..."     │
│  }                   │
└──────────┬───────────┘
           │
           └─> Format Response
               Show issue key
               Generate URL
               Save to outputs/

           ↓
           
┌──────────────────────┐
│  User Output         │
│  ✅ Epic: DATA-123   │
│  URL: https://...    │
└──────────────────────┘
```

---

## User Guide

### Getting Started

#### Prerequisites Check

```bash
# 1. Verify JIRA token is set
echo $JIRA_API_TOKEN

# 2. Test connection
jira-test

# Expected output:
# Testing JIRA connection...
# ✓ Connected to JIRA as: vicky.pandey@goto.com
```

If token not set:
```bash
source ~/.zshrc
```

### Method 1: Natural Language (Claude Code)

**Best for**: Quick creation, bulk operations, plan-based creation

#### Create an Epic

```
You: "Create an epic for modernizing the data pipeline with goals to 
      improve performance, reduce costs, and enable real-time processing"

Claude:
1. Extracts:
   - Epic Name: DATA-PIPE-MOD
   - Summary: Data Pipeline Modernization
   - Goals: performance, cost reduction, real-time
   - Priority: P1 (default)
   - Component: DATA-BFRM (default)

2. Creates epic: DATA-67800

3. Shows:
   ✅ Epic: DATA-67800 - Data Pipeline Modernization
   URL: https://jira.ops.expertcity.com/browse/DATA-67800
```

#### Create a Story (with Epic Suggestion)

```
You: "Create a story for implementing Kafka-based real-time ingestion, 
      estimate 8 points"

Claude:
1. Extracts:
   - Summary: Implement Kafka-based real-time ingestion
   - Story Points: 8
   - Priority: P1 (default)
   - Component: DATA-BFRM (default)
   - Epic Link: Not specified

2. Searches epics:
   Found 5 epics in DATA-BFRM:
   1. DATA-67800 - Data Pipeline Modernization [To Do]
   2. DATA-66186 - Delta Table Retention [To Do]
   3. DATA-66100 - Real-time Data Platform [In Progress]

3. Suggests:
   "I found epic DATA-67800 (Data Pipeline Modernization) which seems 
    related to your story. Should I link it?"

4. You confirm: "Yes"

5. Creates story: DATA-67801

6. Shows:
   ✅ Story: DATA-67801 (→ DATA-67800)
   Summary: Implement Kafka-based real-time ingestion
   Story Points: 8
   URL: https://jira.ops.expertcity.com/browse/DATA-67801
```

#### Create from Implementation Plan

```
You: "Create JIRA issues from this implementation plan:

# Data Pipeline Modernization

## Epic: Real-time Data Processing

### Overview
Migrate from batch to real-time streaming...

### Goals
- Sub-second latency
- 10x throughput
- Cost reduction

## Story 1: Implement Kafka Ingestion
- Deploy Kafka cluster
- Create connectors
- Set up monitoring

### Subtask 1.1: Deploy Kafka Cluster
- Provision infrastructure
- Configure brokers
- Test connectivity
"

Claude:
1. Parses plan structure:
   - 1 Epic: Real-time Data Processing
   - 1 Story: Implement Kafka Ingestion
   - 1 Subtask: Deploy Kafka Cluster

2. Creates in order:
   a) Epic: DATA-67802
   b) Story: DATA-67803 (linked to DATA-67802)
   c) Subtask: DATA-67804 (under DATA-67803)

3. Shows hierarchy:
   ✅ Epic: DATA-67802 - Real-time Data Processing
      └─ ✅ Story: DATA-67803 - Implement Kafka Ingestion
         └─ ✅ Subtask: DATA-67804 - Deploy Kafka Cluster

4. Summary:
   Created 3 issues with proper linking
   All URLs: [list of URLs]
```

### Method 2: Interactive Shell Commands

**Best for**: Step-by-step creation, full control, learning

#### Create Epic Interactively

```bash
jira-epic

# Prompts and responses:

Epic Name (e.g., AI-REC-ENGINE): DATA-QUALITY
Epic Summary: Data Quality Framework Implementation

Epic Overview (press Ctrl+D when done):
Build comprehensive data quality validation framework
[Ctrl+D]

Business Value (press Ctrl+D when done):
Reduce data errors by 80%, improve trust in analytics
[Ctrl+D]

Goals (one per line, press Ctrl+D when done):
- Automated validation rules
- Real-time quality monitoring
- Data quality SLA enforcement
[Ctrl+D]

Success Criteria (one per line, press Ctrl+D when done):
- 80% reduction in data quality incidents
- <5 minute detection time
- 99% validation coverage
[Ctrl+D]

Priority (P0/P1/P2/P3/Unprioritized) [P1]: P1
Component [DATA-BFRM]: DATA-BFRM

Preview:
{
  "fields": {
    "project": {"key": "DATA"},
    "summary": "Data Quality Framework Implementation",
    "issuetype": {"name": "Epic"},
    "priority": {"name": "P1"},
    "components": [{"name": "DATA-BFRM"}],
    "customfield_12131": "DATA-QUALITY"
  }
}

Create this epic? (y/n): y

✅ Epic created: DATA-67805
URL: https://jira.ops.expertcity.com/browse/DATA-67805
```

#### Create Story with Epic Suggestion

```bash
jira-story

# Prompts:

Story Summary: Implement automated data validation rules

User Type (e.g., data analyst): data engineer
Goal (I want to...): define and enforce validation rules automatically
Benefit (So that...): data quality issues are caught before reaching production

Detailed Description (press Ctrl+D when done):
Build a rule engine for data validation with support for custom rules
[Ctrl+D]

Acceptance Criteria (one per line, press Ctrl+D when done):
Given: Data arrives in staging
When: Validation rules execute
Then: Invalid data is flagged and quarantined

Given: Validation rule fails
When: Issue threshold exceeded
Then: Alert sent to data team
[Ctrl+D]

Epic Link (press Enter to see suggestions): [Enter]

Searching for relevant epics in DATA-BFRM...
Found 3 epic(s):

  1  DATA-67805 - Data Quality Framework Implementation [To Do]
  2  DATA-67800 - Data Pipeline Modernization [To Do]
  3  DATA-66186 - Delta Table Retention & Vacuum Strategy [To Do]

Enter Epic Link from above list: DATA-67805

Priority (P0/P1/P2/P3/Unprioritized) [P1]: P1
Story Points [optional]: 8
Component [DATA-BFRM]: DATA-BFRM

Preview:
{...}

Create this story? (y/n): y

✅ Story created: DATA-67806
   Linked to epic: DATA-67805
URL: https://jira.ops.expertcity.com/browse/DATA-67806
```

#### Create Subtask

```bash
jira-subtask

Parent Story Key (e.g., DATA-12345): DATA-67806

Subtask Summary: Design validation rule schema

Task Description (press Ctrl+D when done):
Design JSON schema for validation rules with support for:
- Field-level validations
- Cross-field validations
- Business rule validations
[Ctrl+D]

Implementation Steps (one per line, press Ctrl+D when done):
1. Research existing validation frameworks
2. Draft schema structure
3. Create sample rules
4. Review with team
5. Finalize schema
[Ctrl+D]

Definition of Done (one per line, press Ctrl+D when done):
- Schema documented
- Sample rules created
- Team review completed
- Schema versioned in git
[Ctrl+D]

Priority (P0/P1/P2/P3/Unprioritized) [P1]: P1
Component [DATA-BFRM]: DATA-BFRM

Preview:
{...}

Create this subtask? (y/n): y

✅ Subtask created: DATA-67807
   Under parent: DATA-67806
URL: https://jira.ops.expertcity.com/browse/DATA-67807
```

### Method 3: Programmatic API

**Best for**: Automation scripts, batch operations, CI/CD integration

#### Basic Usage

```bash
# Source the library
source ~/bitbucket/ai-data-jira-automation/scripts/lib/jira-api.sh

# Create epic
create_epic \
  "Data Quality Framework" \
  "DATA-QUALITY" \
  "Build comprehensive validation framework" \
  "P1" \
  "DATA-BFRM" \
  "ai-generated,quality"

# Create story
create_story \
  "Implement validation rules engine" \
  "Build rule engine with custom validation support" \
  "DATA-67805" \
  "P1" \
  "DATA-BFRM" \
  "8" \
  "ai-generated,validation"

# Create subtask
create_subtask \
  "Design validation rule schema" \
  "Create JSON schema for validation rules" \
  "DATA-67806" \
  "P1" \
  "DATA-BFRM" \
  "ai-generated,schema"
```

#### Bulk Creation Script

```bash
#!/bin/bash
source ~/bitbucket/ai-data-jira-automation/scripts/lib/jira-api.sh

# Create epic
epic_response=$(create_epic \
  "Q2 2026 Data Platform Improvements" \
  "DATA-Q2-2026" \
  "Quarterly improvements to data platform" \
  "P1" \
  "DATA-BFRM" \
  "ai-generated,quarterly")

epic_key=$(echo "$epic_response" | jq -r '.key')
echo "Created epic: $epic_key"

# Create stories
stories=(
  "Implement data quality framework:8"
  "Migrate to Delta Lake:13"
  "Add real-time monitoring:5"
  "Optimize query performance:8"
)

for story in "${stories[@]}"; do
  IFS=':' read -r summary points <<< "$story"
  
  story_response=$(create_story \
    "$summary" \
    "Story details for $summary" \
    "$epic_key" \
    "P1" \
    "DATA-BFRM" \
    "$points" \
    "ai-generated,q2-2026")
  
  story_key=$(echo "$story_response" | jq -r '.key')
  echo "Created story: $story_key ($points points)"
done

echo "✅ Created 1 epic and ${#stories[@]} stories"
```

---

## Advanced Usage

### Custom Templates

Edit templates to match your team's needs:

```bash
# Edit epic template
nano ~/bitbucket/ai-data-jira-automation/templates/epic.yml

# Add custom section:
h2. 🎯 OKRs
{{epic.okrs | default:"* Objective 1\n* Key Result 1"}}
```

### Custom Field Mapping

Add new fields without code changes:

```bash
# Edit field mappings
nano ~/bitbucket/ai-data-jira-automation/config/field-mappings.yml

# Add new custom field:
custom_fields:
  sprint:
    id: "customfield_10001"
    type: "number"
    description: "Sprint number"
    applies_to: ["Story", "Task"]
    required: false
```

### Epic Search Customization

Modify search criteria:

```bash
# Edit jira-api.sh
nano ~/bitbucket/ai-data-jira-automation/scripts/lib/jira-api.sh

# Find search_epics_in_component function
# Modify JQL query:
local jql="project = DATA AND issuetype = Epic AND component = \"$component\" AND status IN ('To Do', 'In Progress') ORDER BY priority DESC, updated DESC"
```

### Integration with CI/CD

```yaml
# .github/workflows/create-jira-tickets.yml
name: Create JIRA Tickets

on:
  workflow_dispatch:
    inputs:
      implementation_plan:
        description: 'Path to implementation plan'
        required: true

jobs:
  create-tickets:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Setup JIRA CLI
        run: |
          # Install dependencies
          sudo apt-get install -y jq curl
          
      - name: Create JIRA Issues
        env:
          JIRA_API_TOKEN: ${{ secrets.JIRA_API_TOKEN }}
        run: |
          source ~/bitbucket/ai-data-jira-automation/scripts/lib/jira-api.sh
          # Parse plan and create issues
          # ...
```

---

## Troubleshooting

### Common Issues

#### 1. "JIRA_API_TOKEN not set"

**Problem**: Environment variable not loaded

**Solution**:
```bash
source ~/.zshrc
echo $JIRA_API_TOKEN  # Verify it's set
```

#### 2. "401 Unauthorized"

**Problem**: Token expired or invalid

**Solution**:
1. Go to https://jira.ops.expertcity.com/secure/ViewProfile.jspa
2. Generate new Personal Access Token
3. Update in `~/.zshrc`:
   ```bash
   export JIRA_API_TOKEN="new-token-here"
   ```
4. Reload: `source ~/.zshrc`

#### 3. "Custom field error: customfield_XXXXX"

**Problem**: Field ID different in your JIRA instance

**Solution**:
```bash
# Find correct field ID
curl -H "Authorization: Bearer $JIRA_API_TOKEN" \
  https://jira.ops.expertcity.com/rest/api/2/field | \
  jq '.[] | select(.custom==true) | {id, name}'

# Update config/field-mappings.yml
```

#### 4. "No epics found in DATA-BFRM"

**Problem**: No active epics in component or search issue

**Solution**:
```bash
# Verify epics exist
curl -H "Authorization: Bearer $JIRA_API_TOKEN" \
  "https://jira.ops.expertcity.com/rest/api/2/search?jql=project=DATA+AND+type=Epic+AND+component=DATA-BFRM"

# If none exist, create an epic first
jira-epic
```

#### 5. "Component DATA-BFRM not found"

**Problem**: Component doesn't exist or name is wrong

**Solution**:
```bash
# List available components
curl -H "Authorization: Bearer $JIRA_API_TOKEN" \
  https://jira.ops.expertcity.com/rest/api/2/project/DATA/components

# Update defaults.yml with correct component name
```

### Debug Mode

Enable detailed logging:

```bash
# Set debug flag
export JIRA_DEBUG=1

# Run command
jira-story

# Check logs
tail -f ~/bitbucket/ai-data-jira-automation/outputs/jira.log
```

---

## Best Practices

### Epic Creation

✅ **DO**:
- Use clear, action-oriented names (e.g., "DATA-PIPELINE-MOD")
- Include business value and ROI
- Define measurable success criteria
- Set realistic timelines
- Identify dependencies upfront

❌ **DON'T**:
- Create epics for small tasks
- Use vague names ("New Project")
- Skip business value explanation
- Set unrealistic expectations

### Story Creation

✅ **DO**:
- Write clear user stories (As a... I want... So that...)
- Use Given-When-Then for acceptance criteria
- Link to epics for context
- Estimate story points realistically
- Include technical requirements

❌ **DON'T**:
- Write technical tasks as stories (use subtasks)
- Create stories without acceptance criteria
- Forget to link to epics
- Underestimate complexity

### Subtask Creation

✅ **DO**:
- Make subtasks specific and actionable
- Include implementation steps
- Define clear "Definition of Done"
- List files to modify
- Set reasonable time estimates

❌ **DON'T**:
- Create subtasks larger than 3 days
- Make subtasks too abstract
- Skip DoD checklist
- Create subtasks without parent story

### Priority Guidelines

| Priority | When to Use | Examples |
|----------|-------------|----------|
| **P0** | Production down, data loss, security breach | "Fix critical data corruption bug" |
| **P1** | High impact, blocking work, time-sensitive | "Implement OAuth before launch" |
| **P2** | Medium impact, important but not urgent | "Add logging to service" |
| **P3** | Low impact, nice to have, tech debt | "Refactor helper functions" |
| **Unprioritized** | Needs triage, unclear priority | "Investigate performance issue" |

### Component Guidelines

| Component | Purpose | Examples |
|-----------|---------|----------|
| **DATA-BFRM** | Bangalore Framework (default) | Retention, ETL, data processing |
| **DATA-INFRA** | Infrastructure | Kafka, databases, cloud resources |
| **DATA-PIPE** | Data Pipeline | Ingestion, transformation, loading |
| **DATA-QUAL** | Data Quality | Validation, monitoring, governance |

---

## Summary

### The Journey

**You started with**: Manual JIRA creation taking hours

**You built**: AI-powered automation with intelligent workflows

**You now have**:
- ✅ Natural language issue creation
- ✅ Intelligent epic linking
- ✅ Professional templates
- ✅ Multiple interfaces (NL, shell, API)
- ✅ DATA project standards compliance
- ✅ Complete documentation

### Quick Reference

| What | Command | Time |
|------|---------|------|
| Create Epic | `jira-epic` or "Create epic for X" | 30s |
| Create Story | `jira-story` or "Create story for X" | 45s |
| Create Subtask | `jira-subtask` or "Add subtask to X" | 20s |
| From Plan | "Create issues from plan: [paste]" | 2min |
| Test Connection | `jira-test` | 5s |

### What You Learned

1. **Architecture**: 3-layer design (UI → Orchestration → Integration)
2. **Workflow**: How data flows from request to JIRA
3. **Epic Suggestion**: Intelligent linking saves time
4. **Templates**: Professional formatting built-in
5. **Flexibility**: Multiple ways to create issues
6. **Standards**: DATA project conventions enforced

---

## Next Steps

### Getting Started
1. ✅ Test connection: `jira-test`
2. ✅ Create first epic: `jira-epic`
3. ✅ Create story with suggestion: `jira-story`
4. ✅ Try natural language: "Create epic for X"

### Customization
1. Edit templates for your team
2. Add custom fields in field-mappings.yml
3. Adjust defaults in defaults.yml
4. Create team-specific components

### Advanced
1. Build automation scripts
2. Integrate with CI/CD
3. Create batch operations
4. Extend with new issue types

---

**Need Help?**
- Full docs: `~/bitbucket/ai-data-jira-automation/docs/`
- Examples: `~/bitbucket/ai-data-jira-automation/examples/`
- Quick start: `~/bitbucket/ai-data-jira-automation/QUICKSTART.md`

**Ready to create your first issue?**
```bash
jira-epic
```

Or just tell me: *"Create an epic for improving data quality"* 🚀

---

**Document Version**: 1.0
**Last Updated**: 2026-04-03
**Status**: ✅ Complete
