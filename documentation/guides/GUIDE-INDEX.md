# AI JIRA Automation - Documentation

## 🎯 Overview

The AI JIRA Automation system is a professional, enterprise-grade workflow for creating JIRA issues (Epics, Stories, and Subtasks) from implementation and architectural plans. It uses intelligent parsing, flexible templates, and JIRA best practices to streamline your project management workflow.

## ✨ Key Features

- 🤖 **AI-Powered Parsing**: Intelligently extract structure from implementation plans
- 📝 **Flexible Templates**: YAML-based templates with JIRA wiki markup
- 🔧 **Configurable Fields**: Easy field mapping without code changes
- 👀 **Dry Run Mode**: Preview before creating issues
- 💬 **Interactive Mode**: Review and edit before submission
- 🔗 **Automatic Linking**: Epics → Stories → Subtasks hierarchy
- 📊 **Output Tracking**: JSON reports for audit trail
- ✅ **Validation**: Built-in validation rules
- 🎨 **Best Practices**: JIRA-optimized templates and workflows

## 🚀 Quick Start

### Prerequisites

- Bash shell (macOS/Linux)
- `jq` (JSON processor)
- `yq` (YAML processor) - optional but recommended
- JIRA API token set in environment

### Installation

```bash
# Clone or navigate to the project
cd ~/bitbucket/ai-data-jira-automation

# Set your JIRA API token (should already be in your .zshrc)
export JIRA_API_TOKEN="your-token-here"

# Test connection
./scripts/jira-workflow.sh test-connection
```

### Create Your First Epic

```bash
# Interactive mode
./scripts/jira-workflow.sh create-epic
```

### Create a Story

```bash
# Interactive mode
./scripts/jira-workflow.sh create-story
```

### Create a Subtask

```bash
# Interactive mode
./scripts/jira-workflow.sh create-subtask
```

## 📁 Project Structure

```
ai-data-jira-automation/
├── config/                      # Configuration files
│   ├── jira-config.yml         # JIRA connection settings
│   ├── field-mappings.yml      # Custom field mappings
│   └── defaults.yml            # Default values
├── templates/                   # Issue templates
│   ├── epic.yml                # Epic template
│   ├── story.yml               # Story template
│   └── subtask.yml             # Subtask template
├── scripts/                     # Executable scripts
│   ├── jira-workflow.sh        # Main CLI
│   └── lib/                    # Library functions
│       ├── jira-api.sh         # JIRA API functions
│       └── template-engine.sh  # Template processing
├── examples/                    # Example plans
│   └── sample-implementation-plan.md
├── outputs/                     # Output reports (auto-generated)
└── docs/                       # Documentation
    ├── README.md               # This file
    ├── USAGE.md                # Detailed usage guide
    ├── TEMPLATES.md            # Template customization
    └── FIELD-MAPPING.md        # Field mapping guide
```

## 🎨 Templates

Templates use YAML format with JIRA wiki markup for descriptions. Variables are replaced using `{{variable.name}}` syntax.

### Epic Template Structure

```yaml
fields:
  summary: "{{epic.summary}}"
  description: |
    h1. {{epic.name}}
    
    h2. Overview
    {{epic.overview}}
    
    h2. Business Value
    {{epic.business_value}}
    
    h2. Goals
    {{epic.goals}}
```

### Customizing Templates

1. Edit the template file: `templates/epic.yml`
2. Add/modify sections
3. Use JIRA wiki markup for formatting
4. Use `{{variable}}` for placeholders
5. Test with dry-run mode

See [TEMPLATES.md](TEMPLATES.md) for detailed guide.

## ⚙️ Configuration

### JIRA Connection

Edit `config/jira-config.yml`:

```yaml
jira:
  server: "https://jira.ops.expertcity.com"
  project: "DATA"
  auth:
    type: "bearer"
    token_env_var: "JIRA_API_TOKEN"
```

### Field Mappings

Edit `config/field-mappings.yml` to map custom fields:

```yaml
custom_fields:
  epic_name:
    id: "customfield_10011"
    type: "string"
    applies_to: ["Epic"]
    required: true
```

**Finding Custom Field IDs:**

```bash
# Use JIRA API
curl -H "Authorization: Bearer $JIRA_API_TOKEN" \
  https://jira.ops.expertcity.com/rest/api/2/field | jq '.[] | select(.custom==true)'
```

See [FIELD-MAPPING.md](FIELD-MAPPING.md) for detailed guide.

### Defaults

Edit `config/defaults.yml` to set default values:

```yaml
epic:
  priority: "Medium"
  labels:
    - "ai-generated"
    - "epic"
```

## 📖 Usage Examples

### Example 1: Create Epic Interactively

```bash
./scripts/jira-workflow.sh create-epic
```

Follow the prompts to enter:
- Epic Name (e.g., AI-DATA-PIPELINE)
- Epic Summary
- Overview
- Business Value
- Goals
- Success Criteria
- Priority

### Example 2: Create Story with Epic Link

```bash
./scripts/jira-workflow.sh create-story
```

Follow the prompts to enter:
- Story Summary
- User Story (As a... I want... So that...)
- Acceptance Criteria
- Epic Link (e.g., DATA-12345)
- Story Points
- Priority

### Example 3: Create Subtask

```bash
./scripts/jira-workflow.sh create-subtask
```

Follow the prompts to enter:
- Parent Story Key
- Subtask Summary
- Task Description
- Implementation Steps
- Definition of Done

## 🔧 Advanced Usage

### Using Library Functions Directly

```bash
# Source the libraries
source scripts/lib/jira-api.sh
source scripts/lib/template-engine.sh

# Test connection
test_jira_connection

# Create epic using API function
create_epic "Epic Summary" "EPIC-NAME" "Description" "High" "label1,label2"

# Get issue details
get_jira_issue "DATA-12345"
```

### Creating Issues from JSON

```bash
# Prepare JSON payload
payload='{
  "fields": {
    "project": {"key": "DATA"},
    "summary": "My Epic",
    "issuetype": {"name": "Epic"},
    "customfield_10011": "MY-EPIC"
  }
}'

# Create issue
source scripts/lib/jira-api.sh
create_jira_issue "$payload"
```

## 🎯 Workflow Best Practices

### 1. Start with Epics

Create high-level epics first that represent major initiatives or milestones.

**Good Epic Examples:**
- "AI-Powered Recommendation Engine"
- "Data Pipeline Modernization Initiative"
- "Customer Analytics Dashboard v2.0"

**Bad Epic Examples:**
- "Fix bugs" (too vague)
- "Update config file" (too small)

### 2. Break Down into Stories

Each epic should contain 5-15 stories that represent concrete deliverables.

**Good Story Examples:**
- "Implement real-time data ingestion layer"
- "Build data quality validation framework"
- "Create self-service analytics portal"

**Bad Story Examples:**
- "Do data work" (too vague)
- "Fix typo in README" (too small for a story)

### 3. Add Subtasks for Implementation

Break stories into subtasks representing specific development tasks.

**Good Subtask Examples:**
- "Write unit tests for authentication service"
- "Implement database migration for user table"
- "Create API documentation"

### 4. Use Consistent Naming

- **Epics**: Start with component/initiative name
- **Stories**: Use action verbs (Implement, Build, Create, Add)
- **Subtasks**: Be specific about the action

### 5. Link Everything

- Link stories to epics using Epic Link field
- Link subtasks to parent stories
- Use "Blocks/Blocked By" for dependencies

## 🐛 Troubleshooting

### Connection Issues

```bash
# Test connection
./scripts/jira-workflow.sh test-connection

# Check token
echo $JIRA_API_TOKEN

# Verify token works with curl
curl -H "Authorization: Bearer $JIRA_API_TOKEN" \
  https://jira.ops.expertcity.com/rest/api/2/myself
```

### Custom Field Errors

If you get errors about custom fields:

1. Find the correct field ID:
```bash
curl -H "Authorization: Bearer $JIRA_API_TOKEN" \
  https://jira.ops.expertcity.com/rest/api/2/field | jq '.[] | select(.custom==true)'
```

2. Update `config/field-mappings.yml` with correct IDs

3. Test with a simple creation

### Template Errors

If templates aren't rendering correctly:

1. Check YAML syntax: `yq eval templates/epic.yml`
2. Verify variable names match your data
3. Test with minimal template first

### Permission Issues

If you get 403/401 errors:

1. Verify token is valid and not expired
2. Check you have permission to create issues in the project
3. Verify project key is correct

## 📚 Additional Resources

- [USAGE.md](USAGE.md) - Detailed usage guide
- [TEMPLATES.md](TEMPLATES.md) - Template customization
- [FIELD-MAPPING.md](FIELD-MAPPING.md) - Field mapping guide
- [Example Plans](../examples/) - Sample implementation plans

## 🤝 Contributing

To extend this system:

1. Add new templates in `templates/`
2. Add new library functions in `scripts/lib/`
3. Update field mappings in `config/field-mappings.yml`
4. Update documentation

## 📞 Support

For issues or questions:

1. Check documentation in `docs/`
2. Review example plans in `examples/`
3. Test with dry-run mode first
4. Check JIRA API documentation

## 🎉 Success Tips

✅ **DO:**
- Use dry-run mode first
- Review generated issues before bulk creation
- Keep templates updated
- Document your field mappings
- Use consistent naming conventions

❌ **DON'T:**
- Create issues without reviewing
- Ignore validation errors
- Hard-code values in scripts
- Skip testing connection first
- Forget to link issues properly

---

**Happy JIRA Automation! 🚀**
