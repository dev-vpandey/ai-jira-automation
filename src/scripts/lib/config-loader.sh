#!/bin/bash

# Config Loader Library
# Dynamically loads configuration values from YAML files

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

# Configuration files
JIRA_CONFIG="$PROJECT_ROOT/config/jira-config.yml"
FIELD_MAPPINGS="$PROJECT_ROOT/config/field-mappings.yml"
DEFAULTS_CONFIG="$PROJECT_ROOT/config/defaults.yml"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# ============================================================================
# Field ID Loaders
# ============================================================================

# Get custom field ID from field-mappings.yml
# Usage: get_field_id <field_name>
# Example: get_field_id "epic_name" returns "customfield_12131"
get_field_id() {
    local field_name="${1:-}"

    if [ -z "$field_name" ]; then
        echo -e "${RED}✗ Error: field_name is required${NC}" >&2
        return 1
    fi

    if [ ! -f "$FIELD_MAPPINGS" ]; then
        echo -e "${RED}Error: Field mappings file not found: $FIELD_MAPPINGS${NC}" >&2
        return 1
    fi

    local field_id=$(yq eval ".custom_fields.${field_name}.id" "$FIELD_MAPPINGS" 2>/dev/null)

    if [ -z "$field_id" ] || [ "$field_id" == "null" ]; then
        echo -e "${YELLOW}Warning: Field ID not found for: $field_name${NC}" >&2
        return 1
    fi

    echo "$field_id"
}

# Get all custom field IDs as associative array (for bash 4+)
# Usage: load_all_field_ids
load_all_field_ids() {
    if [ ! -f "$FIELD_MAPPINGS" ]; then
        echo -e "${RED}Error: Field mappings file not found: $FIELD_MAPPINGS${NC}" >&2
        return 1
    fi

    # Export commonly used field IDs as environment variables
    export FIELD_EPIC_NAME=$(get_field_id "epic_name")
    export FIELD_EPIC_LINK=$(get_field_id "epic_link")
    export FIELD_STORY_POINTS=$(get_field_id "story_points")
    export FIELD_SPRINT=$(get_field_id "sprint")

    if [ -n "$FIELD_EPIC_NAME" ]; then
        echo -e "${GREEN}✓ Loaded custom field IDs from config${NC}"
        return 0
    else
        echo -e "${RED}✗ Failed to load custom field IDs${NC}" >&2
        return 1
    fi
}

# ============================================================================
# JIRA Config Loaders
# ============================================================================

# Get JIRA server URL
get_jira_server() {
    yq eval ".jira.server" "$JIRA_CONFIG" 2>/dev/null || echo "https://jira.ops.expertcity.com"
}

# Get JIRA project key
get_jira_project() {
    yq eval ".jira.project" "$JIRA_CONFIG" 2>/dev/null || echo "DATA"
}

# Get priority list
get_priorities() {
    yq eval ".priorities[]" "$JIRA_CONFIG" 2>/dev/null
}

# Get component list
get_components() {
    yq eval ".components[]" "$JIRA_CONFIG" 2>/dev/null
}

# ============================================================================
# Default Value Loaders
# ============================================================================

# Get default value from defaults.yml
# Usage: get_default <section> <key>
# Example: get_default "epic" "priority" returns "P1"
get_default() {
    local section="${1:-}"
    local key="${2:-}"

    if [ -z "$section" ]; then
        echo -e "${RED}✗ Error: section is required${NC}" >&2
        return 1
    fi

    if [ -z "$key" ]; then
        echo -e "${RED}✗ Error: key is required${NC}" >&2
        return 1
    fi

    if [ ! -f "$DEFAULTS_CONFIG" ]; then
        echo -e "${RED}Error: Defaults file not found: $DEFAULTS_CONFIG${NC}" >&2
        return 1
    fi

    yq eval ".${section}.${key}" "$DEFAULTS_CONFIG" 2>/dev/null
}

# Get default priority for issue type
get_default_priority() {
    local issue_type="${1:-}"  # epic, story, subtask, task, bug

    if [ -z "$issue_type" ]; then
        echo -e "${RED}✗ Error: issue_type is required${NC}" >&2
        return 1
    fi

    get_default "$issue_type" "priority"
}

# Get default component for issue type
get_default_component() {
    local issue_type="${1:-}"

    if [ -z "$issue_type" ]; then
        echo -e "${RED}✗ Error: issue_type is required${NC}" >&2
        return 1
    fi

    get_default "$issue_type" "component"
}

# Get default labels for issue type (returns JSON array)
get_default_labels() {
    local issue_type="${1:-}"

    if [ -z "$issue_type" ]; then
        echo -e "${RED}✗ Error: issue_type is required${NC}" >&2
        return 1
    fi

    yq eval -o=json ".${issue_type}.labels" "$DEFAULTS_CONFIG" 2>/dev/null
}

# ============================================================================
# Config Validation
# ============================================================================

# Validate that all required config files exist
validate_config_files() {
    local all_exist=true

    if [ ! -f "$JIRA_CONFIG" ]; then
        echo -e "${RED}✗ Missing: $JIRA_CONFIG${NC}" >&2
        all_exist=false
    fi

    if [ ! -f "$FIELD_MAPPINGS" ]; then
        echo -e "${RED}✗ Missing: $FIELD_MAPPINGS${NC}" >&2
        all_exist=false
    fi

    if [ ! -f "$DEFAULTS_CONFIG" ]; then
        echo -e "${RED}✗ Missing: $DEFAULTS_CONFIG${NC}" >&2
        all_exist=false
    fi

    if [ "$all_exist" = true ]; then
        echo -e "${GREEN}✓ All config files found${NC}"
        return 0
    else
        return 1
    fi
}

# Validate that required tools are installed
validate_dependencies() {
    local all_installed=true

    for cmd in jq yq curl; do
        if ! command -v $cmd &> /dev/null; then
            echo -e "${RED}✗ Required tool not found: $cmd${NC}" >&2
            all_installed=false
        fi
    done

    if [ "$all_installed" = true ]; then
        echo -e "${GREEN}✓ All required tools installed${NC}"
        return 0
    else
        echo -e "${YELLOW}Install missing tools: brew install jq yq curl${NC}" >&2
        return 1
    fi
}

# Run all config validations
validate_all_config() {
    echo -e "${BLUE}=== Validating Configuration ===${NC}\n"

    local valid=true

    if ! validate_dependencies; then
        valid=false
    fi

    if ! validate_config_files; then
        valid=false
    fi

    if ! load_all_field_ids; then
        valid=false
    fi

    if [ "$valid" = true ]; then
        echo -e "\n${GREEN}✓ Configuration validation passed${NC}"
        return 0
    else
        echo -e "\n${RED}✗ Configuration validation failed${NC}" >&2
        return 1
    fi
}

# ============================================================================
# Exports
# ============================================================================

# Functions available after sourcing this file:
# - get_field_id, load_all_field_ids
# - get_jira_server, get_jira_project
# - get_priorities, get_components
# - get_default, get_default_priority, get_default_component, get_default_labels
# - validate_config_files, validate_dependencies, validate_all_config
#
# Note: export -f is bash-specific and doesn't work in zsh
# Functions are available in the current shell after sourcing
