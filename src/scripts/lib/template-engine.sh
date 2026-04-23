#!/bin/bash

# Template Engine Library
# Processes YAML templates and replaces variables

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

# Template directory
TEMPLATE_DIR="$PROJECT_ROOT/templates"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# ============================================================================
# Template Loading
# ============================================================================

# Load template file
# Usage: load_template <template_type>
load_template() {
    local template_type="${1:-}"

    if [ -z "$template_type" ]; then
        echo -e "${RED}✗ Error: template_type is required${NC}" >&2
        return 1
    fi

    local template_file="$TEMPLATE_DIR/${template_type}.yml"

    if [ ! -f "$template_file" ]; then
        echo -e "${RED}Error: Template not found: $template_file${NC}" >&2
        return 1
    fi

    cat "$template_file"
}

# Get template field
# Usage: get_template_field <template_type> <field_path>
get_template_field() {
    local template_type="${1:-}"
    local field_path="${2:-}"

    if [ -z "$template_type" ]; then
        echo -e "${RED}✗ Error: template_type is required${NC}" >&2
        return 1
    fi

    if [ -z "$field_path" ]; then
        echo -e "${RED}✗ Error: field_path is required${NC}" >&2
        return 1
    fi

    load_template "$template_type" | yq eval ".${field_path}" -
}

# ============================================================================
# Variable Replacement
# ============================================================================

# Replace template variables in text
# Usage: replace_variables <template_text> <values_json>
replace_variables() {
    local template_text="${1:-}"
    local values_json="${2:-}"

    if [ -z "$template_text" ]; then
        echo -e "${RED}✗ Error: template_text is required${NC}" >&2
        return 1
    fi

    if [ -z "$values_json" ]; then
        echo -e "${RED}✗ Error: values_json is required${NC}" >&2
        return 1
    fi

    # Start with the original template
    local result="$template_text"

    # Get current timestamp
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    # Replace {{timestamp}}
    result=$(echo "$result" | sed "s/{{timestamp}}/$timestamp/g")

    # Extract all {{variable}} patterns
    local variables=$(echo "$template_text" | grep -o '{{[^}]*}}' | sort -u)

    # Replace each variable
    while IFS= read -r var_pattern; do
        if [ -z "$var_pattern" ]; then
            continue
        fi

        # Extract variable name (remove {{ and }})
        local var_name=$(echo "$var_pattern" | sed 's/{{//g; s/}}//g')

        # Check for default value (variable | default:"value")
        local default_value=""
        if [[ "$var_name" =~ \|[[:space:]]*default: ]]; then
            default_value=$(echo "$var_name" | sed 's/.*default:[[:space:]]*"\([^"]*\)".*/\1/')
            var_name=$(echo "$var_name" | sed 's/[[:space:]]*|[[:space:]]*default:.*//')
        fi

        # Get value from JSON
        local json_path=$(echo "$var_name" | sed 's/\./\./g')
        local value=$(echo "$values_json" | jq -r ".$json_path // empty")

        # Use default if value is empty
        if [ -z "$value" ]; then
            value="$default_value"
        fi

        # Escape special characters for sed
        local escaped_value=$(echo "$value" | sed 's/[\/&]/\\&/g; s/$/\\/')
        escaped_value=${escaped_value%\\}

        # Replace in result
        result=$(echo "$result" | sed "s|$var_pattern|$escaped_value|g")
    done <<< "$variables"

    echo "$result"
}

# ============================================================================
# Template Processing
# ============================================================================

# Process epic template
# Usage: process_epic_template <values_json>
process_epic_template() {
    local values_json="${1:-}"

    if [ -z "$values_json" ]; then
        echo -e "${RED}✗ Error: values_json is required${NC}" >&2
        return 1
    fi

    local template=$(get_template_field "epic" "fields.description.template")
    replace_variables "$template" "$values_json"
}

# Process story template
# Usage: process_story_template <values_json>
process_story_template() {
    local values_json="${1:-}"

    if [ -z "$values_json" ]; then
        echo -e "${RED}✗ Error: values_json is required${NC}" >&2
        return 1
    fi

    local template=$(get_template_field "story" "fields.description.template")
    replace_variables "$template" "$values_json"
}

# Process subtask template
# Usage: process_subtask_template <values_json>
process_subtask_template() {
    local values_json="${1:-}"

    if [ -z "$values_json" ]; then
        echo -e "${RED}✗ Error: values_json is required${NC}" >&2
        return 1
    fi

    local template=$(get_template_field "subtask" "fields.description.template")
    replace_variables "$template" "$values_json"
}

# ============================================================================
# JIRA Payload Generation
# ============================================================================

# Generate epic payload from data
# Usage: generate_epic_payload <data_json>
generate_epic_payload() {
    local data="${1:-}"

    if [ -z "$data" ]; then
        echo -e "${RED}✗ Error: data is required${NC}" >&2
        return 1
    fi

    # Extract values
    local summary=$(echo "$data" | jq -r '.epic.summary')
    local epic_name=$(echo "$data" | jq -r '.epic.name')
    local priority=$(echo "$data" | jq -r '.epic.priority // "Medium"')
    local labels=$(echo "$data" | jq -r '.epic.labels // ["ai-generated", "epic"] | join(",")')
    local project_key=$(echo "$data" | jq -r '.project_key // "DATA"')

    # Process description template
    local description=$(process_epic_template "$data")

    # Escape for JSON
    description=$(echo "$description" | jq -Rs '.')
    summary=$(echo "$summary" | jq -Rs '.' | sed 's/^"//; s/"$//')
    epic_name=$(echo "$epic_name" | jq -Rs '.' | sed 's/^"//; s/"$//')

    # Convert labels to JSON array
    local labels_json=$(echo "$labels" | jq -R 'split(",") | map(gsub("^\\s+|\\s+$"; ""))')

    # Generate payload
    cat <<EOF
{
  "fields": {
    "project": {"key": "$project_key"},
    "summary": "$summary",
    "description": $description,
    "issuetype": {"name": "Epic"},
    "priority": {"name": "$priority"},
    "labels": $labels_json,
    "customfield_12131": "$epic_name"
  }
}
EOF
}

# Generate story payload from data
# Usage: generate_story_payload <data_json>
generate_story_payload() {
    local data="${1:-}"

    if [ -z "$data" ]; then
        echo -e "${RED}✗ Error: data is required${NC}" >&2
        return 1
    fi

    # Extract values
    local summary=$(echo "$data" | jq -r '.story.summary')
    local priority=$(echo "$data" | jq -r '.story.priority // "Medium"')
    local epic_link=$(echo "$data" | jq -r '.story.epic_link // ""')
    local story_points=$(echo "$data" | jq -r '.story.story_points // ""')
    local labels=$(echo "$data" | jq -r '.story.labels // ["ai-generated", "story"] | join(",")')
    local project_key=$(echo "$data" | jq -r '.project_key // "DATA"')

    # Process description template
    local description=$(process_story_template "$data")

    # Escape for JSON
    description=$(echo "$description" | jq -Rs '.')
    summary=$(echo "$summary" | jq -Rs '.' | sed 's/^"//; s/"$//')

    # Convert labels to JSON array
    local labels_json=$(echo "$labels" | jq -R 'split(",") | map(gsub("^\\s+|\\s+$"; ""))')

    # Build payload
    local payload='{
  "fields": {
    "project": {"key": "'"$project_key"'"},
    "summary": "'"$summary"'",
    "description": '"$description"',
    "issuetype": {"name": "Story"},
    "priority": {"name": "'"$priority"'"},
    "labels": '"$labels_json"

    # Add optional fields
    if [ -n "$epic_link" ] && [ "$epic_link" != "null" ]; then
        payload="$payload"',
    "customfield_12130": "'"$epic_link"'"'
    fi

    if [ -n "$story_points" ] && [ "$story_points" != "null" ]; then
        payload="$payload"',
    "customfield_10033": '"$story_points"
    fi

    payload="$payload"'
  }
}'

    echo "$payload"
}

# Generate subtask payload from data
# Usage: generate_subtask_payload <data_json>
generate_subtask_payload() {
    local data="${1:-}"

    if [ -z "$data" ]; then
        echo -e "${RED}✗ Error: data is required${NC}" >&2
        return 1
    fi

    # Extract values
    local summary=$(echo "$data" | jq -r '.subtask.summary')
    local parent=$(echo "$data" | jq -r '.subtask.parent')
    local priority=$(echo "$data" | jq -r '.subtask.priority // "Medium"')
    local labels=$(echo "$data" | jq -r '.subtask.labels // ["ai-generated", "subtask"] | join(",")')
    local project_key=$(echo "$data" | jq -r '.project_key // "DATA"')

    # Process description template
    local description=$(process_subtask_template "$data")

    # Escape for JSON
    description=$(echo "$description" | jq -Rs '.')
    summary=$(echo "$summary" | jq -Rs '.' | sed 's/^"//; s/"$//')

    # Convert labels to JSON array
    local labels_json=$(echo "$labels" | jq -R 'split(",") | map(gsub("^\\s+|\\s+$"; ""))')

    # Generate payload
    cat <<EOF
{
  "fields": {
    "project": {"key": "$project_key"},
    "summary": "$summary",
    "description": $description,
    "issuetype": {"name": "Sub-task"},
    "parent": {"key": "$parent"},
    "priority": {"name": "$priority"},
    "labels": $labels_json
  }
}
EOF
}

# ============================================================================
# Validation
# ============================================================================

# Validate epic data
validate_epic_data() {
    local data="${1:-}"

    if [ -z "$data" ]; then
        echo -e "${RED}✗ Error: data is required${NC}" >&2
        return 1
    fi

    local summary=$(echo "$data" | jq -r '.epic.summary // ""')
    local epic_name=$(echo "$data" | jq -r '.epic.name // ""')

    if [ -z "$summary" ]; then
        echo -e "${RED}Error: epic.summary is required${NC}" >&2
        return 1
    fi

    if [ -z "$epic_name" ]; then
        echo -e "${RED}Error: epic.name is required${NC}" >&2
        return 1
    fi

    if [ ${#summary} -lt 10 ]; then
        echo -e "${RED}Error: epic.summary must be at least 10 characters${NC}" >&2
        return 1
    fi

    return 0
}

# Validate story data
validate_story_data() {
    local data="${1:-}"

    if [ -z "$data" ]; then
        echo -e "${RED}✗ Error: data is required${NC}" >&2
        return 1
    fi

    local summary=$(echo "$data" | jq -r '.story.summary // ""')

    if [ -z "$summary" ]; then
        echo -e "${RED}Error: story.summary is required${NC}" >&2
        return 1
    fi

    if [ ${#summary} -lt 10 ]; then
        echo -e "${RED}Error: story.summary must be at least 10 characters${NC}" >&2
        return 1
    fi

    return 0
}

# Validate subtask data
validate_subtask_data() {
    local data="${1:-}"

    if [ -z "$data" ]; then
        echo -e "${RED}✗ Error: data is required${NC}" >&2
        return 1
    fi

    local summary=$(echo "$data" | jq -r '.subtask.summary // ""')
    local parent=$(echo "$data" | jq -r '.subtask.parent // ""')

    if [ -z "$summary" ]; then
        echo -e "${RED}Error: subtask.summary is required${NC}" >&2
        return 1
    fi

    if [ -z "$parent" ]; then
        echo -e "${RED}Error: subtask.parent is required${NC}" >&2
        return 1
    fi

    if ! [[ "$parent" =~ ^[A-Z]+-[0-9]+$ ]]; then
        echo -e "${RED}Error: Invalid parent key format: $parent${NC}" >&2
        return 1
    fi

    return 0
}

# Functions available after sourcing this file:
# - load_template, get_template_field, replace_variables
# - process_epic_template, process_story_template, process_subtask_template
# - generate_epic_payload, generate_story_payload, generate_subtask_payload
# - validate_epic_data, validate_story_data, validate_subtask_data
#
# Note: export -f is bash-specific and doesn't work in zsh
# Functions are available in the current shell after sourcing
