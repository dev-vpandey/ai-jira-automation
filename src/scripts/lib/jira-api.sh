#!/bin/bash

# JIRA API Library
# Provides functions for interacting with JIRA REST API

# Bash safety flags
set -euo pipefail
IFS=$'\n\t'

# Use PROJECT_ROOT if already set, otherwise calculate it
if [ -z "${PROJECT_ROOT:-}" ]; then
    # Load shell utilities for cross-shell compatibility
    # Get this script's directory first, before sourcing shell-utils.sh
    if [ -n "${BASH_SOURCE:-}" ]; then
        SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    elif [ -n "${ZSH_VERSION:-}" ]; then
        SCRIPT_DIR="$(cd "$(dirname "${(%):-%x}")" && pwd)"
    else
        SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
    fi

    # Now source shell-utils.sh (functions will be available)
    source "$SCRIPT_DIR/shell-utils.sh"

    PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
fi

# Load configuration
JIRA_CONFIG="$PROJECT_ROOT/config/jira-config.yml"
FIELD_MAPPINGS="$PROJECT_ROOT/config/field-mappings.yml"

# JIRA connection details (loaded from config or env)
JIRA_URL="${JIRA_URL:-https://jira.ops.expertcity.com}"
JIRA_TOKEN="${JIRA_API_TOKEN:-}"
JIRA_PROJECT="${JIRA_PROJECT:-DATA}"

# API endpoints
API_BASE="/rest/api/2"
API_ISSUE="$API_BASE/issue"
API_SEARCH="$API_BASE/search"
API_USER="$API_BASE/myself"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ============================================================================
# Authentication & Connection
# ============================================================================

# Check if JIRA token is set
check_jira_auth() {
    if [ -z "$JIRA_TOKEN" ]; then
        echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${RED}✗ JIRA_API_TOKEN not set${NC}"
        echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo ""
        echo -e "${YELLOW}To fix this:${NC}"
        echo -e "  1. Get your token: ${BLUE}https://id.atlassian.com/manage-profile/security/api-tokens${NC}"
        echo -e "  2. Set environment variable: ${BLUE}export JIRA_API_TOKEN='your-token-here'${NC}"
        echo -e "  3. Or add to ~/.zshrc: ${BLUE}echo 'export JIRA_API_TOKEN=\"your-token\"' >> ~/.zshrc${NC}"
        echo ""
        return 1
    fi
    return 0
}

# Test JIRA connection
test_jira_connection() {
    check_jira_auth || return 1

    echo -e "${BLUE}Testing JIRA connection...${NC}"

    response=$(curl -s -w "\n%{http_code}" \
        -H "Authorization: Bearer $JIRA_TOKEN" \
        -H "Content-Type: application/json" \
        "$JIRA_URL$API_USER")

    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | sed '$d')

    if [ "$http_code" == "200" ]; then
        user_email=$(echo "$body" | jq -r '.emailAddress // "unknown"')
        echo -e "${GREEN}✓ Connected to JIRA as: $user_email${NC}"
        return 0
    else
        echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${RED}✗ Failed to connect to JIRA (HTTP $http_code)${NC}"
        echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo ""

        case "$http_code" in
            401)
                echo -e "${YELLOW}Authentication failed:${NC}"
                echo -e "  • Check your JIRA_API_TOKEN is correct"
                echo -e "  • Token may have expired - generate a new one"
                echo -e "  • URL: ${BLUE}https://id.atlassian.com/manage-profile/security/api-tokens${NC}"
                ;;
            403)
                echo -e "${YELLOW}Permission denied:${NC}"
                echo -e "  • Your account may not have permission to access this JIRA instance"
                echo -e "  • Contact your JIRA administrator"
                ;;
            404)
                echo -e "${YELLOW}JIRA URL not found:${NC}"
                echo -e "  • Check JIRA_URL is correct: ${BLUE}$JIRA_URL${NC}"
                echo -e "  • Override with: ${BLUE}export JIRA_URL='https://your-instance.atlassian.net'${NC}"
                ;;
            *)
                echo -e "${YELLOW}Unexpected error:${NC}"
                echo "$body" | jq '.' 2>/dev/null || echo "$body"
                ;;
        esac
        echo ""
        return 1
    fi
}

# ============================================================================
# Issue Creation
# ============================================================================

# Create a JIRA issue from JSON payload
# Usage: create_jira_issue <json_payload>
create_jira_issue() {
    local json_payload="${1:-}"

    if [ -z "$json_payload" ]; then
        echo -e "${RED}✗ Error: json_payload is required${NC}" >&2
        return 1
    fi

    check_jira_auth || return 1

    response=$(curl -s -w "\n%{http_code}" \
        -X POST \
        -H "Authorization: Bearer $JIRA_TOKEN" \
        -H "Content-Type: application/json" \
        -d "$json_payload" \
        "$JIRA_URL$API_ISSUE")

    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | sed '$d')

    if [ "$http_code" == "201" ]; then
        issue_key=$(echo "$body" | jq -r '.key')
        issue_id=$(echo "$body" | jq -r '.id')
        echo -e "${GREEN}✓ Created: $issue_key${NC}"
        echo "$body"
        return 0
    else
        echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${RED}✗ Failed to create issue (HTTP $http_code)${NC}"
        echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo ""

        # Try to extract error message from response
        local error_msg=$(echo "$body" | jq -r '.errorMessages[]? // .errors? // empty' 2>/dev/null)

        case "$http_code" in
            400)
                echo -e "${YELLOW}Invalid request:${NC}"
                if echo "$body" | jq -e '.errors' >/dev/null 2>&1; then
                    echo -e "${YELLOW}Field errors:${NC}"
                    echo "$body" | jq -r '.errors | to_entries[] | "  • \(.key): \(.value)"' 2>/dev/null

                    # Check for common issues
                    if echo "$body" | grep -q "customfield"; then
                        echo ""
                        echo -e "${YELLOW}Custom field issue detected:${NC}"
                        echo -e "  • Run validation: ${BLUE}src/jira-auto validate${NC}"
                        echo -e "  • Check field-mappings.yml has correct custom field IDs"
                    fi
                fi
                ;;
            401)
                echo -e "${YELLOW}Authentication failed - check your JIRA_API_TOKEN${NC}"
                ;;
            403)
                echo -e "${YELLOW}Permission denied:${NC}"
                echo -e "  • You may not have permission to create this issue type"
                echo -e "  • Check project permissions in JIRA"
                ;;
            *)
                echo -e "${YELLOW}Error details:${NC}"
                echo "$body" | jq '.' 2>/dev/null || echo "$body"
                ;;
        esac
        echo ""
        return 1
    fi
}

# Create an Epic
# Usage: create_epic <summary> <epic_name> <description> [priority] [component] [labels]
create_epic() {
    local summary="${1:-}"
    local epic_name="${2:-}"
    local description="${3:-}"
    local priority="${4:-P1}"
    local component="${5:-DATA-BFRM}"
    local labels="${6:-ai-generated,epic}"

    if [ -z "$summary" ] || [ -z "$epic_name" ] || [ -z "$description" ]; then
        echo -e "${RED}✗ Error: summary, epic_name, and description are required${NC}" >&2
        return 1
    fi

    # Convert comma-separated labels to JSON array
    local labels_json=$(echo "$labels" | jq -R 'split(",") | map(gsub("^\\s+|\\s+$"; ""))')

    local payload=$(cat <<EOF
{
  "fields": {
    "project": {
      "key": "$JIRA_PROJECT"
    },
    "summary": "$summary",
    "description": "$description",
    "issuetype": {
      "name": "Epic"
    },
    "priority": {
      "name": "$priority"
    },
    "components": [
      {
        "name": "$component"
      }
    ],
    "labels": $labels_json,
    "customfield_12131": "$epic_name"
  }
}
EOF
)

    create_jira_issue "$payload"
}

# Create a Story
# Usage: create_story <summary> <description> [epic_link] [priority] [component] [story_points] [labels]
create_story() {
    local summary="${1:-}"
    local description="${2:-}"
    local epic_link="${3:-}"
    local priority="${4:-P1}"
    local component="${5:-DATA-BFRM}"
    local story_points="${6:-}"
    local labels="${7:-ai-generated,story}"

    if [ -z "$summary" ] || [ -z "$description" ]; then
        echo -e "${RED}✗ Error: summary and description are required${NC}" >&2
        return 1
    fi

    # Convert comma-separated labels to JSON array
    local labels_json=$(echo "$labels" | jq -R 'split(",") | map(gsub("^\\s+|\\s+$"; ""))')

    # Build payload with optional fields
    local payload='{
  "fields": {
    "project": {"key": "'"$JIRA_PROJECT"'"},
    "summary": "'"$summary"'",
    "description": "'"$description"'",
    "issuetype": {"name": "Story"},
    "priority": {"name": "'"$priority"'"},
    "components": [{"name": "'"$component"'"}],
    "labels": '"$labels_json"

    # Add epic link if provided
    if [ -n "$epic_link" ]; then
        payload="$payload"',
    "customfield_12130": "'"$epic_link"'"'
    fi

    # Add story points if provided
    if [ -n "$story_points" ]; then
        payload="$payload"',
    "customfield_10033": '"$story_points"
    fi

    payload="$payload"'
  }
}'

    create_jira_issue "$payload"
}

# Create a Subtask
# Usage: create_subtask <summary> <description> <parent_key> [priority] [component] [labels]
create_subtask() {
    local summary="${1:-}"
    local description="${2:-}"
    local parent_key="${3:-}"
    local priority="${4:-P1}"
    local component="${5:-DATA-BFRM}"
    local labels="${6:-ai-generated,subtask}"

    if [ -z "$summary" ] || [ -z "$description" ] || [ -z "$parent_key" ]; then
        echo -e "${RED}✗ Error: summary, description, and parent_key are required${NC}" >&2
        return 1
    fi

    # Convert comma-separated labels to JSON array
    local labels_json=$(echo "$labels" | jq -R 'split(",") | map(gsub("^\\s+|\\s+$"; ""))')

    local payload=$(cat <<EOF
{
  "fields": {
    "project": {
      "key": "$JIRA_PROJECT"
    },
    "summary": "$summary",
    "description": "$description",
    "issuetype": {
      "name": "Sub-task"
    },
    "parent": {
      "key": "$parent_key"
    },
    "priority": {
      "name": "$priority"
    },
    "components": [
      {
        "name": "$component"
      }
    ],
    "labels": $labels_json
  }
}
EOF
)

    create_jira_issue "$payload"
}

# ============================================================================
# Issue Retrieval
# ============================================================================

# Get issue details
# Usage: get_jira_issue <issue_key>
get_jira_issue() {
    local issue_key="${1:-}"

    if [ -z "$issue_key" ]; then
        echo -e "${RED}✗ Error: issue_key is required${NC}" >&2
        return 1
    fi

    check_jira_auth || return 1

    response=$(curl -s -w "\n%{http_code}" \
        -H "Authorization: Bearer $JIRA_TOKEN" \
        -H "Content-Type: application/json" \
        "$JIRA_URL$API_ISSUE/$issue_key")

    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | sed '$d')

    if [ "$http_code" == "200" ]; then
        echo "$body"
        return 0
    else
        echo -e "${RED}✗ Failed to get issue $issue_key (HTTP $http_code)${NC}" >&2
        return 1
    fi
}

# Search for issues
# Usage: search_jira_issues <jql>
search_jira_issues() {
    local jql="${1:-}"

    if [ -z "$jql" ]; then
        echo -e "${RED}✗ Error: jql is required${NC}" >&2
        return 1
    fi

    check_jira_auth || return 1

    local payload=$(cat <<EOF
{
  "jql": "$jql",
  "maxResults": 50,
  "fields": ["summary", "status", "issuetype", "priority", "assignee"]
}
EOF
)

    response=$(curl -s -w "\n%{http_code}" \
        -X POST \
        -H "Authorization: Bearer $JIRA_TOKEN" \
        -H "Content-Type: application/json" \
        -d "$payload" \
        "$JIRA_URL$API_SEARCH")

    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | sed '$d')

    if [ "$http_code" == "200" ]; then
        echo "$body"
        return 0
    else
        echo -e "${RED}✗ Search failed (HTTP $http_code)${NC}" >&2
        return 1
    fi
}

# ============================================================================
# Issue Updates
# ============================================================================

# Update issue field
# Usage: update_jira_issue <issue_key> <json_update>
update_jira_issue() {
    local issue_key="${1:-}"
    local json_update="${2:-}"

    if [ -z "$issue_key" ] || [ -z "$json_update" ]; then
        echo -e "${RED}✗ Error: issue_key and json_update are required${NC}" >&2
        return 1
    fi

    check_jira_auth || return 1

    response=$(curl -s -w "\n%{http_code}" \
        -X PUT \
        -H "Authorization: Bearer $JIRA_TOKEN" \
        -H "Content-Type: application/json" \
        -d "$json_update" \
        "$JIRA_URL$API_ISSUE/$issue_key")

    http_code=$(echo "$response" | tail -n1)

    if [ "$http_code" == "204" ]; then
        echo -e "${GREEN}✓ Updated: $issue_key${NC}"
        return 0
    else
        body=$(echo "$response" | sed '$d')
        echo -e "${RED}✗ Failed to update $issue_key (HTTP $http_code)${NC}"
        echo "$body" | jq '.' 2>/dev/null || echo "$body"
        return 1
    fi
}

# Add comment to issue
# Usage: add_comment <issue_key> <comment_text>
add_comment() {
    local issue_key="${1:-}"
    local comment_text="${2:-}"

    if [ -z "$issue_key" ] || [ -z "$comment_text" ]; then
        echo -e "${RED}✗ Error: issue_key and comment_text are required${NC}" >&2
        return 1
    fi

    local payload=$(cat <<EOF
{
  "body": "$comment_text"
}
EOF
)

    check_jira_auth || return 1

    response=$(curl -s -w "\n%{http_code}" \
        -X POST \
        -H "Authorization: Bearer $JIRA_TOKEN" \
        -H "Content-Type: application/json" \
        -d "$payload" \
        "$JIRA_URL$API_ISSUE/$issue_key/comment")

    http_code=$(echo "$response" | tail -n1)

    if [ "$http_code" == "201" ]; then
        echo -e "${GREEN}✓ Comment added to $issue_key${NC}"
        return 0
    else
        echo -e "${RED}✗ Failed to add comment (HTTP $http_code)${NC}"
        return 1
    fi
}

# Add attachment to issue
# Usage: add_attachment <issue_key> <file_path>
add_attachment() {
    local issue_key="${1:-}"
    local file_path="${2:-}"

    if [ -z "$issue_key" ] || [ -z "$file_path" ]; then
        echo -e "${RED}✗ Error: issue_key and file_path are required${NC}" >&2
        return 1
    fi

    if [ ! -f "$file_path" ]; then
        echo -e "${RED}✗ Error: file not found: $file_path${NC}" >&2
        return 1
    fi

    check_jira_auth || return 1

    if [ ! -f "$file_path" ]; then
        echo -e "${RED}✗ File not found: $file_path${NC}"
        return 1
    fi

    response=$(curl -s -w "\n%{http_code}" \
        -X POST \
        -H "Authorization: Bearer $JIRA_TOKEN" \
        -H "X-Atlassian-Token: no-check" \
        -F "file=@$file_path" \
        "$JIRA_URL$API_ISSUE/$issue_key/attachments")

    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | sed '$d')

    if [ "$http_code" == "200" ]; then
        local filename=$(echo "$body" | jq -r '.[0].filename')
        echo -e "${GREEN}✓ Attached $filename to $issue_key${NC}"
        echo "$body"
        return 0
    else
        echo -e "${RED}✗ Failed to add attachment (HTTP $http_code)${NC}"
        echo "$body" | jq '.' 2>/dev/null || echo "$body"
        return 1
    fi
}

# ============================================================================
# Epic Search & Suggestion
# ============================================================================

# Search for epics in DATA-BFRM component
# Usage: search_epics_in_component [component]
search_epics_in_component() {
    local component="${1:-DATA-BFRM}"

    check_jira_auth || return 1

    local jql="project = DATA AND issuetype = Epic AND component = \"$component\" AND status != Done ORDER BY updated DESC"

    local payload=$(cat <<EOF
{
  "jql": "$jql",
  "maxResults": 10,
  "fields": ["summary", "status", "customfield_12131"]
}
EOF
)

    response=$(curl -s -w "\n%{http_code}" \
        -X POST \
        -H "Authorization: Bearer $JIRA_TOKEN" \
        -H "Content-Type: application/json" \
        -d "$payload" \
        "$JIRA_URL$API_SEARCH")

    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | sed '$d')

    if [ "$http_code" == "200" ]; then
        echo "$body"
        return 0
    else
        echo -e "${RED}✗ Epic search failed (HTTP $http_code)${NC}" >&2
        return 1
    fi
}

# Suggest epic link based on story summary
# Usage: suggest_epic_link <story_summary> [component]
suggest_epic_link() {
    local story_summary="${1:-}"
    local component="${2:-DATA-BFRM}"

    if [ -z "$story_summary" ]; then
        echo -e "${RED}✗ Error: story_summary is required${NC}" >&2
        return 1
    fi

    echo -e "${BLUE}Searching for relevant epics in $component...${NC}"

    local epics=$(search_epics_in_component "$component")

    if [ $? -ne 0 ]; then
        echo -e "${YELLOW}Could not search epics. Please enter epic link manually.${NC}"
        return 1
    fi

    local epic_count=$(echo "$epics" | jq '.total')

    if [ "$epic_count" -eq 0 ]; then
        echo -e "${YELLOW}No active epics found in $component component.${NC}"
        return 1
    fi

    echo -e "${GREEN}Found $epic_count epic(s):${NC}\n"

    # Display epics
    echo "$epics" | jq -r '.issues[] | "\(.key) - \(.fields.summary) [\(.fields.status.name)]"' | nl

    echo ""
    return 0
}

# ============================================================================
# Issue Transitions
# ============================================================================

# Get available transitions for an issue
# Usage: get_transitions <issue_key>
get_transitions() {
    local issue_key="${1:-}"

    if [ -z "$issue_key" ]; then
        echo -e "${RED}✗ Error: issue_key is required${NC}" >&2
        return 1
    fi

    check_jira_auth || return 1

    response=$(curl -s -w "\n%{http_code}" \
        -H "Authorization: Bearer $JIRA_TOKEN" \
        -H "Content-Type: application/json" \
        "$JIRA_URL$API_ISSUE/$issue_key/transitions")

    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | sed '$d')

    if [ "$http_code" == "200" ]; then
        echo "$body"
        return 0
    else
        echo -e "${RED}✗ Failed to get transitions for $issue_key (HTTP $http_code)${NC}" >&2
        return 1
    fi
}

# Transition issue to a new status
# Usage: transition_issue <issue_key> <status_name>
transition_issue() {
    local issue_key="${1:-}"
    local status_name="${2:-}"

    if [ -z "$issue_key" ] || [ -z "$status_name" ]; then
        echo -e "${RED}✗ Error: issue_key and status_name are required${NC}" >&2
        return 1
    fi

    check_jira_auth || return 1

    # Get available transitions
    local transitions=$(get_transitions "$issue_key")
    if [ $? -ne 0 ]; then
        return 1
    fi

    # Find transition ID for the target status
    local transition_id=$(echo "$transitions" | jq -r ".transitions[] | select(.to.name == \"$status_name\") | .id" | head -1)

    if [ -z "$transition_id" ]; then
        echo -e "${RED}✗ Status '$status_name' is not available for $issue_key${NC}" >&2
        echo -e "${YELLOW}Available transitions:${NC}" >&2
        echo "$transitions" | jq -r '.transitions[] | "  • \(.name)"' >&2
        return 1
    fi

    local payload=$(cat <<EOF
{
  "transition": {
    "id": "$transition_id"
  }
}
EOF
)

    response=$(curl -s -w "\n%{http_code}" \
        -X POST \
        -H "Authorization: Bearer $JIRA_TOKEN" \
        -H "Content-Type: application/json" \
        -d "$payload" \
        "$JIRA_URL$API_ISSUE/$issue_key/transitions")

    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | sed '$d')

    if [ "$http_code" == "204" ]; then
        echo -e "${GREEN}✓ Transitioned $issue_key to '$status_name'${NC}"
        return 0
    else
        echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${RED}✗ Failed to transition $issue_key (HTTP $http_code)${NC}"
        echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo ""

        case "$http_code" in
            400)
                local error_msg=$(echo "$body" | jq -r '.errorMessages[]? // empty' 2>/dev/null)
                if [ -n "$error_msg" ]; then
                    echo -e "${YELLOW}Error:${NC} $error_msg"

                    # Check if it's a subtask blocker issue
                    if echo "$error_msg" | grep -q "workflow operation"; then
                        echo ""
                        echo -e "${YELLOW}This may be caused by:${NC}"
                        echo -e "  • Incomplete subtasks (parent issues require all subtasks to be Done)"
                        echo -e "  • Workflow validation rules not met"
                        echo -e "  • Issue state changed since last check"
                    fi
                fi
                ;;
            401)
                echo -e "${YELLOW}Authentication failed - check your JIRA_API_TOKEN${NC}"
                ;;
            403)
                echo -e "${YELLOW}Permission denied:${NC}"
                echo -e "  • You may not have permission to transition this issue"
                echo -e "  • Check project permissions in JIRA"
                ;;
            404)
                echo -e "${YELLOW}Issue not found:${NC}"
                echo -e "  • Check that $issue_key exists"
                ;;
            *)
                echo -e "${YELLOW}Error details:${NC}"
                echo "$body" | jq '.' 2>/dev/null || echo "$body"
                ;;
        esac
        echo ""
        return 1
    fi
}

# Transition issue with its subtasks to a status
# Usage: transition_with_subtasks <issue_key> <status_name>
transition_with_subtasks() {
    local issue_key="${1:-}"
    local status_name="${2:-}"

    if [ -z "$issue_key" ] || [ -z "$status_name" ]; then
        echo -e "${RED}✗ Error: issue_key and status_name are required${NC}" >&2
        return 1
    fi

    check_jira_auth || return 1

    echo -e "${BLUE}Checking for subtasks...${NC}"

    # Get issue with subtasks
    response=$(curl -s -w "\n%{http_code}" \
        -H "Authorization: Bearer $JIRA_TOKEN" \
        -H "Content-Type: application/json" \
        "$JIRA_URL$API_ISSUE/$issue_key?fields=subtasks,issuetype,status")

    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | sed '$d')

    if [ "$http_code" != "200" ]; then
        echo -e "${RED}✗ Failed to get issue $issue_key (HTTP $http_code)${NC}" >&2
        return 1
    fi

    local subtask_keys=$(echo "$body" | jq -r '.fields.subtasks[]?.key // empty')
    local issue_type=$(echo "$body" | jq -r '.fields.issuetype.name')

    if [ -n "$subtask_keys" ]; then
        local subtask_count=$(echo "$subtask_keys" | wc -l | tr -d ' ')
        echo -e "${GREEN}Found $subtask_count subtask(s) for $issue_key:${NC}"
        echo "$subtask_keys" | while read -r subtask; do
            echo "  • $subtask"
        done
        echo ""

        # Transition each subtask
        local failed=0
        echo "$subtask_keys" | while read -r subtask; do
            transition_issue "$subtask" "$status_name"
            if [ $? -ne 0 ]; then
                failed=$((failed + 1))
            fi
        done

        if [ $failed -gt 0 ]; then
            echo -e "${YELLOW}⚠ Some subtasks failed to transition${NC}"
        fi
        echo ""
    else
        echo -e "${BLUE}No subtasks found for $issue_key${NC}"
        echo ""
    fi

    # Transition the parent issue
    echo -e "${BLUE}Transitioning parent $issue_type $issue_key...${NC}"
    transition_issue "$issue_key" "$status_name"
}

# ============================================================================
# Utility Functions
# ============================================================================

# Validate issue key format
validate_issue_key() {
    local issue_key="${1:-}"

    if [ -z "$issue_key" ]; then
        echo -e "${RED}✗ Error: issue_key is required${NC}" >&2
        return 1
    fi

    if [[ ! "$issue_key" =~ ^[A-Z]+-[0-9]+$ ]]; then
        echo -e "${RED}Invalid issue key format: $issue_key${NC}" >&2
        echo "Expected format: PROJECT-123" >&2
        return 1
    fi
    return 0
}

# Get issue URL
get_issue_url() {
    local issue_key="${1:-}"

    if [ -z "$issue_key" ]; then
        echo -e "${RED}✗ Error: issue_key is required${NC}" >&2
        return 1
    fi
    echo "$JIRA_URL/browse/$issue_key"
}

# Functions available after sourcing this file:
# - check_jira_auth, test_jira_connection, create_jira_issue
# - create_epic, create_story, create_subtask
# - get_jira_issue, search_jira_issues, update_jira_issue
# - add_comment, add_attachment, get_transitions
# - transition_issue, transition_with_subtasks
# - validate_issue_key, get_issue_url
#
# Note: export -f is bash-specific and doesn't work in zsh
# Functions are available in the current shell after sourcing
