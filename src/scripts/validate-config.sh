#!/bin/bash

# Configuration Validation Script
# Validates all configuration files and JIRA connection before running automation

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
source "$SCRIPT_DIR/lib/config-loader.sh"
source "$SCRIPT_DIR/lib/jira-api.sh"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# Setup automatic cleanup
setup_cleanup_trap

# Clean up any orphaned temp files from previous runs
cleanup_old_temp_files "jira-auto.*" 1

# ============================================================================
# Validation Functions
# ============================================================================

print_header() {
    local message="${1:-}"
    if [ -z "$message" ]; then
        echo -e "${RED}✗ Error: message is required${NC}" >&2
        return 1
    fi
    echo -e "\n${BOLD}${CYAN}=== $message ===${NC}\n"
}

print_check() {
    local message="${1:-}"
    if [ -z "$message" ]; then
        echo -e "${RED}✗ Error: message is required${NC}" >&2
        return 1
    fi
    echo -e "${BLUE}→${NC} $message"
}

print_success() {
    local message="${1:-}"
    if [ -z "$message" ]; then
        echo -e "${RED}✗ Error: message is required${NC}" >&2
        return 1
    fi
    echo -e "${GREEN}  ✓${NC} $message"
}

print_error() {
    local message="${1:-}"
    if [ -z "$message" ]; then
        echo -e "${RED}✗ Error: message is required${NC}" >&2
        return 1
    fi
    echo -e "${RED}  ✗${NC} $message"
}

print_warning() {
    local message="${1:-}"
    if [ -z "$message" ]; then
        echo -e "${RED}✗ Error: message is required${NC}" >&2
        return 1
    fi
    echo -e "${YELLOW}  ⚠${NC} $message"
}

# Validate environment variables
validate_environment() {
    print_header "Environment Variables"
    local valid=true

    print_check "Checking JIRA_API_TOKEN..."
    if [ -z "${JIRA_API_TOKEN:-}" ]; then
        print_error "JIRA_API_TOKEN is not set"
        echo -e "   ${YELLOW}Set it with: export JIRA_API_TOKEN='your-token'${NC}"
        echo -e "   ${YELLOW}Get token from: https://id.atlassian.com/manage-profile/security/api-tokens${NC}"
        valid=false
    else
        print_success "JIRA_API_TOKEN is set"
    fi

    print_check "Checking optional overrides..."
    if [ -n "${JIRA_URL:-}" ]; then
        print_success "JIRA_URL override: $JIRA_URL"
    else
        print_success "Using default JIRA_URL from config"
    fi

    if [ -n "${JIRA_PROJECT:-}" ]; then
        print_success "JIRA_PROJECT override: $JIRA_PROJECT"
    else
        print_success "Using default JIRA_PROJECT from config"
    fi

    [ "$valid" = true ]
}

# Validate custom field IDs are consistent
validate_field_consistency() {
    print_header "Custom Field ID Consistency"
    local valid=true

    print_check "Checking field ID consistency across files..."

    # Get field IDs from config
    local epic_name_config=$(yq eval '.custom_fields.epic_name.id' "$FIELD_MAPPINGS" | tr -d '"')
    local epic_link_config=$(yq eval '.custom_fields.epic_link.id' "$FIELD_MAPPINGS" | tr -d '"')
    local story_points_config=$(yq eval '.custom_fields.story_points.id' "$FIELD_MAPPINGS" | tr -d '"')

    # Check jira-api.sh
    local jira_api_epic=$(grep -o 'customfield_[0-9]*.*epic_name' "$SCRIPT_DIR/lib/jira-api.sh" | grep -o 'customfield_[0-9]*' | head -1)
    local jira_api_link=$(grep -o 'customfield_[0-9]*.*epic_link' "$SCRIPT_DIR/lib/jira-api.sh" | grep -o 'customfield_[0-9]*' | head -1)
    local jira_api_points=$(grep -o 'customfield_[0-9]*.*story_points' "$SCRIPT_DIR/lib/jira-api.sh" | grep -o 'customfield_[0-9]*' | head -1)

    # Check template-engine.sh
    local template_epic=$(grep -o 'customfield_[0-9]*.*epic_name' "$SCRIPT_DIR/lib/template-engine.sh" | grep -o 'customfield_[0-9]*' | head -1)
    local template_link=$(grep -o 'customfield_[0-9]*.*epic_link' "$SCRIPT_DIR/lib/template-engine.sh" | grep -o 'customfield_[0-9]*' | head -1)
    local template_points=$(grep -o 'customfield_[0-9]*.*story_points' "$SCRIPT_DIR/lib/template-engine.sh" | grep -o 'customfield_[0-9]*' | head -1)

    # Validate Epic Name field
    if [ "$epic_name_config" = "$jira_api_epic" ] && [ "$epic_name_config" = "$template_epic" ]; then
        print_success "Epic Name field consistent: $epic_name_config"
    else
        print_error "Epic Name field INCONSISTENT:"
        echo -e "     Config: $epic_name_config | jira-api: $jira_api_epic | template: $template_epic"
        valid=false
    fi

    # Validate Epic Link field
    if [ "$epic_link_config" = "$jira_api_link" ] && [ "$epic_link_config" = "$template_link" ]; then
        print_success "Epic Link field consistent: $epic_link_config"
    else
        print_error "Epic Link field INCONSISTENT:"
        echo -e "     Config: $epic_link_config | jira-api: $jira_api_link | template: $template_link"
        valid=false
    fi

    # Validate Story Points field
    if [ "$story_points_config" = "$jira_api_points" ] && [ "$story_points_config" = "$template_points" ]; then
        print_success "Story Points field consistent: $story_points_config"
    else
        print_error "Story Points field INCONSISTENT:"
        echo -e "     Config: $story_points_config | jira-api: $jira_api_points | template: $template_points"
        valid=false
    fi

    [ "$valid" = true ]
}

# Validate against actual JIRA instance
validate_jira_fields() {
    print_header "JIRA Instance Field Validation"

    if [ -z "${JIRA_API_TOKEN:-}" ]; then
        print_warning "Skipping JIRA validation (no token set)"
        return 0
    fi

    print_check "Fetching custom fields from JIRA..."

    local jira_url="${JIRA_URL:-https://jira.ops.expertcity.com}"
    local response=$(curl -s -w "\n%{http_code}" \
        -H "Authorization: Bearer $JIRA_API_TOKEN" \
        -H "Content-Type: application/json" \
        "$jira_url/rest/api/2/field" 2>/dev/null || echo "error\n000")

    local http_code=$(echo "$response" | tail -n1)
    local body=$(echo "$response" | sed '$d')

    if [ "$http_code" != "200" ]; then
        print_error "Failed to fetch fields from JIRA (HTTP $http_code)"
        return 1
    fi

    print_success "Connected to JIRA successfully"

    # Extract field IDs from JIRA
    local jira_epic_name=$(echo "$body" | jq -r '.[] | select(.name=="Epic Name") | .id' 2>/dev/null)
    local jira_epic_link=$(echo "$body" | jq -r '.[] | select(.name=="Epic Link") | .id' 2>/dev/null)
    local jira_story_points=$(echo "$body" | jq -r '.[] | select(.name=="Story Points") | .id' 2>/dev/null)

    # Get configured field IDs
    local config_epic_name=$(yq eval '.custom_fields.epic_name.id' "$FIELD_MAPPINGS" | tr -d '"')
    local config_epic_link=$(yq eval '.custom_fields.epic_link.id' "$FIELD_MAPPINGS" | tr -d '"')
    local config_story_points=$(yq eval '.custom_fields.story_points.id' "$FIELD_MAPPINGS" | tr -d '"')

    local valid=true

    # Compare
    if [ "$jira_epic_name" = "$config_epic_name" ]; then
        print_success "Epic Name matches JIRA: $config_epic_name"
    else
        print_error "Epic Name mismatch! Config: $config_epic_name | JIRA: $jira_epic_name"
        valid=false
    fi

    if [ "$jira_epic_link" = "$config_epic_link" ]; then
        print_success "Epic Link matches JIRA: $config_epic_link"
    else
        print_error "Epic Link mismatch! Config: $config_epic_link | JIRA: $jira_epic_link"
        valid=false
    fi

    if [ "$jira_story_points" = "$config_story_points" ]; then
        print_success "Story Points matches JIRA: $config_story_points"
    else
        print_error "Story Points mismatch! Config: $config_story_points | JIRA: $jira_story_points"
        valid=false
    fi

    [ "$valid" = true ]
}

# Validate templates exist
validate_templates() {
    print_header "Template Files"
    local valid=true

    for template in epic story subtask; do
        print_check "Checking ${template}.yml..."
        if [ -f "$PROJECT_ROOT/templates/${template}.yml" ]; then
            print_success "${template}.yml exists"
        else
            print_error "${template}.yml NOT FOUND"
            valid=false
        fi
    done

    [ "$valid" = true ]
}

# ============================================================================
# Main Validation
# ============================================================================

main() {
    echo -e "${BOLD}${BLUE}"
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║        JIRA Automation - Configuration Validator          ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"

    local all_valid=true

    # Run validations
    validate_dependencies || all_valid=false
    validate_config_files || all_valid=false
    validate_environment || all_valid=false
    validate_field_consistency || all_valid=false
    validate_templates || all_valid=false
    validate_jira_fields || all_valid=false

    # Summary
    print_header "Validation Summary"

    if [ "$all_valid" = true ]; then
        echo -e "${GREEN}${BOLD}✓ All validations passed!${NC}"
        echo -e "\n${GREEN}Your configuration is ready to use.${NC}"
        echo -e "${CYAN}Run: src/jira-auto test${NC} to test JIRA connection"
        return 0
    else
        echo -e "${RED}${BOLD}✗ Validation failed!${NC}"
        echo -e "\n${RED}Please fix the errors above before using the automation.${NC}"
        return 1
    fi
}

# Run main
main "$@"
