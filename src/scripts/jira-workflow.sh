#!/bin/bash

# JIRA Workflow - Main Orchestrator
# AI-powered JIRA issue creation from implementation/architectural plans

# Bash safety flags
set -euo pipefail
IFS=$'\n\t'

# Get script directory (before sourcing shell-utils.sh)
if [ -n "${BASH_SOURCE:-}" ]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
elif [ -n "${ZSH_VERSION:-}" ]; then
    SCRIPT_DIR="$(cd "$(dirname "${(%):-%x}")" && pwd)"
else
    SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
fi
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Load shell utilities for cross-shell compatibility
source "$SCRIPT_DIR/lib/shell-utils.sh"

# Load libraries
source "$SCRIPT_DIR/lib/cleanup-utils.sh"
source "$SCRIPT_DIR/lib/jira-api.sh"
source "$SCRIPT_DIR/lib/template-engine.sh"

# Configuration
OUTPUT_DIR="$PROJECT_ROOT/outputs"
EXAMPLES_DIR="$PROJECT_ROOT/examples"

# Setup automatic cleanup
setup_cleanup_trap

# Clean up any orphaned temp files from previous runs (older than 1 day)
cleanup_old_temp_files "jira-auto.*" 1

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# ============================================================================
# Usage & Help
# ============================================================================

show_usage() {
    cat << EOF
${BOLD}JIRA Workflow - AI-Powered Issue Creation${NC}

${BOLD}USAGE:${NC}
    $(basename "$0") <command> [options]

${BOLD}COMMANDS:${NC}
    create-from-plan <file>    Parse plan and create JIRA issues
    create-epic                Create a single epic interactively
    create-story               Create a single story interactively
    create-subtask             Create a single subtask interactively
    validate                   Validate configuration and JIRA connection
    test-connection            Test JIRA connection
    help                       Show this help message

${BOLD}OPTIONS:${NC}
    --dry-run                  Preview without creating issues
    --interactive              Interactive review before creation
    --template <type>          Use specific template variation
    --output <file>            Save output to specific file
    --project <key>            Override default project key

${BOLD}EXAMPLES:${NC}
    # Create issues from implementation plan
    $(basename "$0") create-from-plan implementation-plan.md

    # Dry run to preview
    $(basename "$0") create-from-plan plan.md --dry-run

    # Interactive mode
    $(basename "$0") create-from-plan plan.md --interactive

    # Create single epic
    $(basename "$0") create-epic

    # Test connection
    $(basename "$0") test-connection

${BOLD}PLAN FILE FORMAT:${NC}
    Your plan should be in Markdown format with clear sections.
    The parser will intelligently extract:
    - Epics (high-level initiatives)
    - Stories (features/requirements)
    - Subtasks (implementation tasks)

${BOLD}CONFIGURATION:${NC}
    Edit config files in: $PROJECT_ROOT/config/
    - jira-config.yml: JIRA connection settings
    - field-mappings.yml: Custom field mappings
    - defaults.yml: Default values and behavior

${BOLD}TEMPLATES:${NC}
    Templates are located in: $PROJECT_ROOT/templates/
    - epic.yml: Epic template
    - story.yml: Story template
    - subtask.yml: Subtask template

EOF
}

# ============================================================================
# Utility Functions
# ============================================================================

log_info() {
    local message="${1:-}"
    if [ -z "$message" ]; then
        echo -e "${RED}✗ Error: message is required${NC}" >&2
        return 1
    fi
    echo -e "${BLUE}ℹ${NC} $message"
}

log_success() {
    local message="${1:-}"
    if [ -z "$message" ]; then
        echo -e "${RED}✗ Error: message is required${NC}" >&2
        return 1
    fi
    echo -e "${GREEN}✓${NC} $message"
}

log_error() {
    local message="${1:-}"
    if [ -z "$message" ]; then
        echo -e "${RED}✗ Error: message is required${NC}" >&2
        return 1
    fi
    echo -e "${RED}✗${NC} $message" >&2
}

log_warning() {
    local message="${1:-}"
    if [ -z "$message" ]; then
        echo -e "${RED}✗ Error: message is required${NC}" >&2
        return 1
    fi
    echo -e "${YELLOW}⚠${NC} $message"
}

log_header() {
    local message="${1:-}"
    if [ -z "$message" ]; then
        echo -e "${RED}✗ Error: message is required${NC}" >&2
        return 1
    fi
    echo -e "\n${BOLD}${CYAN}$message${NC}\n"
}

# ============================================================================
# Interactive Issue Creation
# ============================================================================

interactive_create_epic() {
    log_header "Create Epic Interactively"

    # Prompt for epic details
    read -p "Epic Name (e.g., AI-REC-ENGINE): " epic_name
    read -p "Epic Summary: " epic_summary

    echo "Epic Overview (press Ctrl+D when done):"
    epic_overview=$(cat)

    echo "Business Value (press Ctrl+D when done):"
    business_value=$(cat)

    echo "Goals (one per line, press Ctrl+D when done):"
    goals=$(cat)

    echo "Success Criteria (one per line, press Ctrl+D when done):"
    success_criteria=$(cat)

    read -p "Priority (P0/P1/P2/P3/Unprioritized) [P1]: " priority
    priority=${priority:-P1}

    read -p "Component [DATA-BFRM]: " component
    component=${component:-DATA-BFRM}

    # Create JSON data
    local data=$(cat <<EOF
{
  "project_key": "$JIRA_PROJECT",
  "epic": {
    "name": "$epic_name",
    "summary": "$epic_summary",
    "overview": "$epic_overview",
    "business_value": "$business_value",
    "goals": "$goals",
    "success_criteria": "$success_criteria",
    "priority": "$priority",
    "component": "$component"
  }
}
EOF
)

    # Validate
    if ! validate_epic_data "$data"; then
        log_error "Validation failed"
        return 1
    fi

    # Generate payload
    local payload=$(generate_epic_payload "$data")

    # Show preview
    log_header "Preview"
    echo "$payload" | jq '.'

    read -p "Create this epic? (y/n): " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        result=$(create_jira_issue "$payload")
        if [ $? -eq 0 ]; then
            issue_key=$(echo "$result" | jq -r '.key')
            log_success "Epic created: $issue_key"
            log_info "URL: $(get_issue_url "$issue_key")"
        fi
    else
        log_warning "Cancelled"
    fi
}

interactive_create_story() {
    log_header "Create Story Interactively"

    # Prompt for story details
    read -p "Story Summary: " story_summary

    read -p "User Type (e.g., data analyst): " user_type
    read -p "Goal (I want to...): " goal
    read -p "Benefit (So that...): " benefit

    echo "Detailed Description (press Ctrl+D when done):"
    detailed_description=$(cat)

    echo "Acceptance Criteria (one per line, press Ctrl+D when done):"
    acceptance_criteria=$(cat)

    # Epic link with suggestion
    read -p "Epic Link (e.g., DATA-12345) [press Enter to see suggestions]: " epic_link

    if [ -z "$epic_link" ]; then
        suggest_epic_link "$story_summary" "DATA-BFRM"
        read -p "Enter Epic Link from above list (or leave blank): " epic_link
    fi

    read -p "Priority (P0/P1/P2/P3/Unprioritized) [P1]: " priority
    priority=${priority:-P1}

    read -p "Story Points [optional]: " story_points

    read -p "Component [DATA-BFRM]: " component
    component=${component:-DATA-BFRM}

    # Create JSON data
    local data=$(cat <<EOF
{
  "project_key": "$JIRA_PROJECT",
  "story": {
    "summary": "$story_summary",
    "user_type": "$user_type",
    "goal": "$goal",
    "benefit": "$benefit",
    "detailed_description": "$detailed_description",
    "acceptance_criteria": "$acceptance_criteria",
    "epic_link": "$epic_link",
    "priority": "$priority",
    "component": "$component",
    "story_points": $story_points
  }
}
EOF
)

    # Validate
    if ! validate_story_data "$data"; then
        log_error "Validation failed"
        return 1
    fi

    # Generate payload
    local payload=$(generate_story_payload "$data")

    # Show preview
    log_header "Preview"
    echo "$payload" | jq '.'

    read -p "Create this story? (y/n): " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        result=$(create_jira_issue "$payload")
        if [ $? -eq 0 ]; then
            issue_key=$(echo "$result" | jq -r '.key')
            log_success "Story created: $issue_key"
            log_info "URL: $(get_issue_url "$issue_key")"
        fi
    else
        log_warning "Cancelled"
    fi
}

interactive_create_subtask() {
    log_header "Create Subtask Interactively"

    # Prompt for subtask details
    read -p "Parent Story Key (e.g., DATA-12345): " parent_key

    if ! validate_issue_key "$parent_key"; then
        return 1
    fi

    read -p "Subtask Summary: " subtask_summary

    echo "Task Description (press Ctrl+D when done):"
    task_description=$(cat)

    echo "Implementation Steps (one per line, press Ctrl+D when done):"
    implementation_steps=$(cat)

    echo "Definition of Done (one per line, press Ctrl+D when done):"
    done_criteria=$(cat)

    read -p "Priority (P0/P1/P2/P3/Unprioritized) [P1]: " priority
    priority=${priority:-P1}

    read -p "Component [DATA-BFRM]: " component
    component=${component:-DATA-BFRM}

    # Create JSON data
    local data=$(cat <<EOF
{
  "project_key": "$JIRA_PROJECT",
  "subtask": {
    "summary": "$subtask_summary",
    "parent": "$parent_key",
    "detailed_description": "$task_description",
    "implementation_steps": "$implementation_steps",
    "definition_of_done": "$done_criteria",
    "priority": "$priority"
  }
}
EOF
)

    # Validate
    if ! validate_subtask_data "$data"; then
        log_error "Validation failed"
        return 1
    fi

    # Generate payload
    local payload=$(generate_subtask_payload "$data")

    # Show preview
    log_header "Preview"
    echo "$payload" | jq '.'

    read -p "Create this subtask? (y/n): " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        result=$(create_jira_issue "$payload")
        if [ $? -eq 0 ]; then
            issue_key=$(echo "$result" | jq -r '.key')
            log_success "Subtask created: $issue_key"
            log_info "URL: $(get_issue_url "$issue_key")"
        fi
    else
        log_warning "Cancelled"
    fi
}

# ============================================================================
# Main Command Router
# ============================================================================

main() {
    local command="${1:-}"
    [ $# -gt 0 ] && shift

    case "$command" in
        create-epic)
            interactive_create_epic
            ;;
        create-story)
            interactive_create_story
            ;;
        create-subtask)
            interactive_create_subtask
            ;;
        test-connection)
            test_jira_connection
            ;;
        validate)
            "$SCRIPT_DIR/validate-config.sh"
            ;;
        help|--help|-h)
            show_usage
            ;;
        *)
            if [ -z "$command" ]; then
                show_usage
            else
                log_error "Unknown command: $command"
                echo ""
                show_usage
                exit 1
            fi
            ;;
    esac
}

# Run main
main "$@"
