# 🤖 AI JIRA Automation

> **Automate JIRA Epic, Story, and Subtask creation from implementation plans**

Transform implementation plans into JIRA issues in minutes. Create 20+ issues in 10 minutes vs 3 hours manual work.

If this saves you time, a ⭐ on the repo helps others find it.

---

## 🚀 Quick Start

### 1. Install Dependencies

**macOS**:
```bash
brew install jq curl git
```

**Ubuntu/Debian**:
```bash
sudo apt-get install jq curl git
```

### 2. Set JIRA Token

Get token from: https://id.atlassian.com/manage-profile/security/api-tokens

Add to `~/.zshrc` or `~/.bashrc`:
```bash
export JIRA_API_TOKEN="your_token_here"
source ~/.zshrc
```

### 3. Test Connection

```bash
src/jira-auto test-connection
# ✓ Connected to JIRA as: your-email@company.com
```

### 4. Create Issues

```bash
src/jira-auto create-epic       # Create an epic
src/jira-auto create-story      # Create a story
src/jira-auto create-subtask    # Create a subtask
```

---

## ✨ Features

- **Interactive Creation** - Prompts for details, preview before creation
- **Smart Epic Linking** - Automatically suggests relevant epics
- **Professional Templates** - JIRA wiki markup with comprehensive sections
- **Validation** - Built-in error handling with clear messages
- **Audit Trail** - JSON output for tracking

---

## 📁 Project Structure

```
ai-data-jira-automation/
├── src/
│   ├── jira-auto                    # Main entry point
│   ├── config/*.yml                 # JIRA connection & field mappings
│   ├── templates/*.yml              # Epic/Story/Subtask templates
│   └── scripts/                     # Core automation logic
├── documentation/                   # Complete guides & examples
└── outputs/                         # Generated audit trails
```

---

## 🛠️ Commands

```bash
src/jira-auto help                   # Show help
src/jira-auto test-connection        # Test JIRA connection
src/jira-auto create-epic            # Create an epic
src/jira-auto create-story           # Create a story  
src/jira-auto create-subtask         # Create a subtask
src/jira-auto validate               # Validate config (requires yq)
```

---

## ⚙️ Configuration

### JIRA Connection
Default configured for `jira.ops.expertcity.com` with project `DATA`.

Override if needed:
```bash
export JIRA_URL="https://your-jira.atlassian.net"
export JIRA_PROJECT="YOUR_PROJECT"
```

### Custom Fields (Verified 2026-04-11)

Field IDs verified for `jira.ops.expertcity.com`:
- **Epic Name**: `customfield_12131`
- **Epic Link**: `customfield_12130`
- **Story Points**: `customfield_10033`
- **Sprint**: `customfield_11430`

For different JIRA instances, update field IDs in:
- `src/config/field-mappings.yml`
- `src/scripts/lib/jira-api.sh`
- `src/scripts/lib/template-engine.sh`

### Find Your Field IDs
```bash
curl -H "Authorization: Bearer $JIRA_API_TOKEN" \
  https://your-jira.com/rest/api/2/field | \
  jq '.[] | select(.custom==true) | {id, name}'
```

---

## 🌍 Adapting for Your Environment

This tool ships with defaults for a specific internal JIRA setup. Five things require manual adjustment before it works on any other instance.

---

### 1. Authentication — Atlassian Cloud vs Server/Data Center

The scripts use **Bearer token auth**, which is Jira **Server / Data Center** syntax. If your JIRA URL ends in `.atlassian.net`, you are on **Atlassian Cloud** and need Basic Auth instead.

**Atlassian Cloud — change the auth header in `src/scripts/lib/jira-api.sh`:**

Every `curl` call uses:
```bash
-H "Authorization: Bearer $JIRA_TOKEN"
```

Replace each occurrence with:
```bash
-u "$JIRA_EMAIL:$JIRA_TOKEN" \
-H "Authorization: Basic $(echo -n "$JIRA_EMAIL:$JIRA_TOKEN" | base64)"
```

Then export your email alongside the token:
```bash
export JIRA_EMAIL="you@yourcompany.com"
export JIRA_API_TOKEN="your_atlassian_cloud_token"
```

Cloud tokens are created at: https://id.atlassian.com/manage-profile/security/api-tokens

**Jira Server / Data Center** (on-premise, custom domain) — no change needed. Bearer token works as-is. Generate a Personal Access Token from your JIRA profile page.

---

### 2. Custom Field IDs — Must Be Updated for Every JIRA Instance

Custom field IDs (`customfield_XXXXX`) are unique per JIRA installation. The defaults in this repo will return HTTP 400 errors on any other instance.

**Step 1 — Fetch your instance's field IDs:**
```bash
# Atlassian Cloud:
curl -u "you@company.com:$JIRA_API_TOKEN" \
  "https://yourcompany.atlassian.net/rest/api/2/field" | \
  jq '.[] | select(.custom==true) | {id, name}'

# Jira Server / DC:
curl -H "Authorization: Bearer $JIRA_API_TOKEN" \
  "https://your-jira.com/rest/api/2/field" | \
  jq '.[] | select(.custom==true) | {id, name}'
```

**Step 2 — Look for these four fields in the output:**

| Field Purpose | What to search for in `name` |
|---|---|
| Epic Name | `Epic Name` |
| Epic Link | `Epic Link` |
| Story Points | `Story Points` or `Story point estimate` |
| Sprint | `Sprint` |

**Step 3 — Update the IDs in three places:**

`src/config/field-mappings.yml` — update the `custom_fields` block:
```yaml
custom_fields:
  epic_name:
    id: "customfield_XXXXX"   # your Epic Name field ID
  epic_link:
    id: "customfield_XXXXX"   # your Epic Link field ID
  story_points:
    id: "customfield_XXXXX"   # your Story Points field ID
  sprint:
    id: "customfield_XXXXX"   # your Sprint field ID
```

`src/scripts/lib/jira-api.sh` — search for the four hardcoded IDs and replace:
- `customfield_12131` → your Epic Name ID (in `create_epic`, around line 236)
- `customfield_12130` → your Epic Link ID (in `create_story`, around line 277)
- `customfield_10033` → your Story Points ID (in `create_story`, around line 283)

`src/templates/epic.yml` — update at the bottom:
```yaml
customfield_10011: "{{epic.name}}"   # replace 10011 with your Epic Name ID
```

> **Note:** Some JIRA Cloud instances (NextGen / team-managed projects) do not have a separate Epic Name field — epics use only `summary`. If Epic Name is absent from your field list, remove the `customfield_*` line from the epic payload entirely.

---

### 3. Priority System

The default priority scheme (`P0 / P1 / P2 / P3 / Unprioritized`) is specific to this project. Most JIRA instances use `Highest / High / Medium / Low / Lowest` or `Critical / Major / Minor / Trivial`.

**Check what your instance accepts:**
```bash
curl -H "Authorization: Bearer $JIRA_API_TOKEN" \
  "https://your-jira.com/rest/api/2/priority" | jq '.[].name'
```

Then update the defaults in two places:

`src/config/defaults.yml` — change `priority` under each issue type:
```yaml
epic:
  priority: "High"   # use a value returned by the command above
story:
  priority: "High"
subtask:
  priority: "Medium"
```

`src/config/field-mappings.yml` — update `allowed_values` and `default` under `standard_fields.priority`:
```yaml
priority:
  allowed_values: ["Highest", "High", "Medium", "Low", "Lowest"]
  default: "High"
```

The interactive CLI prompts (`create-epic`, `create-story`, `create-subtask`) display the default in brackets — they accept any text you type, so you can always override at runtime. The config changes just make the suggested default accurate.

---

### 4. Components

The default component `DATA-BFRM` is org-specific and will cause a 400 error if it does not exist in your project.

**Check what components your project has:**
```bash
curl -H "Authorization: Bearer $JIRA_API_TOKEN" \
  "https://your-jira.com/rest/api/2/project/YOUR_PROJECT/components" | \
  jq '.[].name'
```

If your project has no components (or you do not use them), remove the `components` block from the API payload. In `src/scripts/lib/jira-api.sh`, delete these lines inside `create_epic`, `create_story`, and `create_subtask`:
```json
"components": [{"name": "$component"}],
```

If your project has components, update the default in `src/config/defaults.yml`:
```yaml
epic:
  component: "YOUR-COMPONENT"
```

---

### 5. Claude Code Skill — Update Path After Cloning

If you are using the Claude Code skill (natural language JIRA creation via `"Create a JIRA epic for..."`), the skill file must point to where you cloned this repo.

**Install the skill:**
```bash
mkdir -p ~/.claude/skills/jira-automation
cp -r .claude/skills/jira-automation/* ~/.claude/skills/jira-automation/
```

**Update the path in `~/.claude/skills/jira-automation/SKILL.md`** — change the three occurrences of the repo path to your actual clone location:
```
# Find and replace in SKILL.md:
# ~/Projects/ai-jira-automation/  →  ~/your/actual/clone/path/
```

The skill also references `jira-api.sh` for implementation — that path must resolve correctly or Claude will not be able to source the library.

---

### 6. `create-from-plan` CLI Command

`src/jira-auto help` lists `create-from-plan <file>` as a command. This is a **Claude Code skill feature only** — it works when you paste an implementation plan and ask Claude to create issues from it. The standalone CLI command is not implemented.

Use the Claude skill interface instead:
```
"Create JIRA issues from this implementation plan: [paste plan here]"
```

---

## 🐛 Troubleshooting

**Token not set**:
```bash
echo $JIRA_API_TOKEN    # Should show your token
source ~/.zshrc         # Reload shell config
```

**Connection failed**:
- Verify token at: https://id.atlassian.com/manage-profile/security/api-tokens
- Check JIRA URL is correct
- Ensure you have JIRA access permissions

**Custom field errors**:
- Field IDs are correct for `jira.ops.expertcity.com`
- For other JIRA instances, fetch and update field IDs (see Configuration above)

---

## 📚 Documentation

| Topic | Location |
|-------|----------|
| **Quick Start Guide** | [documentation/getting-started/QUICKSTART.md](documentation/getting-started/QUICKSTART.md) |
| **Complete User Guide** | [documentation/guides/JIRA-SKILL-GUIDE.md](documentation/guides/JIRA-SKILL-GUIDE.md) |
| **Command Reference** | [documentation/guides/QUICK-REFERENCE.md](documentation/guides/QUICK-REFERENCE.md) |
| **Demo & Examples** | [documentation/demo/](documentation/demo/) |
| **Architecture** | [documentation/architecture/](documentation/architecture/) |
| **Release Notes** | [release-notes/](release-notes/) |
| **Navigation Index** | [NAVIGATION.md](NAVIGATION.md) |

---

## 🔧 Advanced Features (Optional)

### Config Validation Script

Requires `yq` (optional dependency):
```bash
brew install yq
src/jira-auto validate
```

Validates:
- Config file consistency
- Field IDs against JIRA API
- JIRA connection and permissions

**Note**: Core automation works without `yq`. This is only for advanced validation.

---

## ✅ Production Status

**Version**: 2.1.0  
**Last Verified**: 2026-04-11  
**Status**: Production Ready

**Verified for**: `jira.ops.expertcity.com` (DATA project)

**Recent Improvements**:
- ✅ Custom field IDs verified and corrected
- ✅ Enhanced error handling with actionable messages  
- ✅ Bash safety flags added (`set -euo pipefail`)
- ✅ Improved authentication error guidance

**See**: [Release Notes v2.1.0](release-notes/v2.1.0.md) for complete details

---

## 📋 Use Cases

### Create from Implementation Plan
```
# In Claude Code:
"Create JIRA issues from this implementation plan: [paste plan]"
```

### New Project Initiative
```bash
src/jira-auto create-epic          # Create project epic
src/jira-auto create-story         # Add features as stories
src/jira-auto create-subtask       # Break into implementation tasks
```

### Sprint Planning
Create stories and subtasks for sprint work, with automatic epic linking and validation.

---

## 🎯 Example Workflow

1. **Create Epic**: "AI Recommendation Engine"
2. **Create Stories**: Features like "Build ML Model", "Create API Endpoint"
3. **System suggests epic**: Based on keywords in story description
4. **Create Subtasks**: Implementation tasks for each story
5. **Audit**: Review JSON output in `outputs/` directory

---

## 📞 Need Help?

- **Built-in help**: `src/jira-auto help`
- **Ask Claude**: "Help me create a JIRA epic"
- **Documentation**: [documentation/README.md](documentation/README.md)
- **Issues**: Check [CHANGELOG.md](CHANGELOG.md) for recent fixes

---

**🚀 Ready to automate your JIRA workflow!**
