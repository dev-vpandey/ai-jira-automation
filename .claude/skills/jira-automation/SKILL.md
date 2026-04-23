---
name: jira-automation
description: |
  Create JIRA epics, stories, and subtasks from implementation plans or prompts. Add comments, attachments, and change status of existing JIRA tickets.
  
  Triggers: "create JIRA epic/story/subtask", "add to JIRA", "create tickets from plan", "add comment to JIRA", "comment on ticket", "upload attachment", "attach file", "change status", "mark as Done"
  Examples: "Create epic for AI project", "Add these stories to JIRA", "Add comment to DATA-123", "Upload file to DATA-123", "Change DATA-123 to Done"
---

# JIRA Automation Skill

Create JIRA issues using natural language. System location: `~/Projects/ai-jira-automation/`

> **If you cloned this repo to a different path**, update the three path references in this file to match your clone location before installing the skill.

## Commands

### Create Epic
`<create-epic epic_name="NAME" summary="TITLE" overview="DESC" goals="GOALS" priority="Medium"/>`

### Create Story  
`<create-story summary="TITLE" user_story="As X I want Y" acceptance_criteria="CRITERIA" epic_link="DATA-123" story_points="5" priority="Medium"/>`

### Create Subtask
`<create-subtask summary="TITLE" parent="DATA-123" description="DESC" steps="STEPS" priority="Medium"/>`

### From Plan
`<create-from-plan type="epic|story|subtask" plan_text="PLAN"/>`

### Add Comment
`<add-comment issue_key="DATA-123" comment="Comment text here"/>`

### Add Attachment
`<add-attachment issue_key="DATA-123" file_path="path/to/file.xlsx"/>`

### Change Status
`<transition-with-subtasks issue_key="DATA-123" status="Done"/>`

Transitions issue to specified status. Automatically handles subtasks if present.

## Default Behavior

- **Stories**: Link to epics via epic_link (ask user if not provided)
- **Subtasks**: ALWAYS link to stories via parent (use story key, NOT epic key)
- **Comments**: Use REST API via add_comment function from jira-api.sh
- **Attachments**: Use REST API via add_attachment function from jira-api.sh

## Usage Patterns

Delegate all JIRA operations to `~/Projects/ai-jira-automation/src/scripts/lib/jira-api.sh`

## Implementation

All functions are in `~/Projects/ai-jira-automation/src/scripts/lib/jira-api.sh`:
- `create_epic`, `create_story`, `create_subtask` - Create issues via REST API
- `add_comment` - Add comment to existing ticket
- `add_attachment` - Upload attachment to existing ticket
- `transition_issue`, `transition_with_subtasks` - Change issue status
- `suggest_epic_link` - Search and suggest epics for stories

Source the library and call functions directly. Requires `JIRA_API_TOKEN` env var.
