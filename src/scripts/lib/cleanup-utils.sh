#!/bin/bash

# Cleanup Utilities
# Provides cleanup functions for temporary files across all scripts

# Bash safety flags
set -euo pipefail
IFS=$'\n\t'

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Temporary files tracking (global arrays)
TEMP_FILES=()
TEMP_DIRS=()

# ============================================================================
# Cleanup Functions
# ============================================================================

# Main cleanup function - removes all tracked temp files and directories
cleanup_temp_files() {
    local exit_code=$?

    # Clean up temporary files
    if [ ${#TEMP_FILES[@]} -gt 0 ]; then
        for temp_file in "${TEMP_FILES[@]}"; do
            if [ -f "$temp_file" ]; then
                rm -f "$temp_file" 2>/dev/null || true
            fi
        done
    fi

    # Clean up temporary directories
    if [ ${#TEMP_DIRS[@]} -gt 0 ]; then
        for temp_dir in "${TEMP_DIRS[@]}"; do
            if [ -d "$temp_dir" ]; then
                rm -rf "$temp_dir" 2>/dev/null || true
            fi
        done
    fi

    exit $exit_code
}

# Cleanup old orphaned temp files (older than 1 day)
cleanup_old_temp_files() {
    local pattern="${1:-jira-auto.*}"
    local max_age_days="${2:-1}"
    local temp_dir="${TMPDIR:-/tmp}"

    # Find and remove old temp files matching pattern
    find "$temp_dir" -maxdepth 1 -name "$pattern" -type f -mtime +"$max_age_days" -delete 2>/dev/null || true

    # Find and remove old temp directories matching pattern
    find "$temp_dir" -maxdepth 1 -name "$pattern" -type d -mtime +"$max_age_days" -exec rm -rf {} + 2>/dev/null || true
}

# ============================================================================
# Temp File Creation (with tracking)
# ============================================================================

# Create a tracked temporary file
# Returns: Path to the temporary file
create_temp_file() {
    local prefix="${1:-jira-auto}"
    local temp_file=$(mktemp "${TMPDIR:-/tmp}/${prefix}.XXXXXX")
    TEMP_FILES+=("$temp_file")
    echo "$temp_file"
}

# Create a tracked temporary directory
# Returns: Path to the temporary directory
create_temp_dir() {
    local prefix="${1:-jira-auto}"
    local temp_dir=$(mktemp -d "${TMPDIR:-/tmp}/${prefix}.XXXXXX")
    TEMP_DIRS+=("$temp_dir")
    echo "$temp_dir"
}

# ============================================================================
# Setup Trap
# ============================================================================

# Setup cleanup trap (call this in your script)
setup_cleanup_trap() {
    trap cleanup_temp_files EXIT INT TERM ERR
}

# ============================================================================
# Manual Cleanup
# ============================================================================

# Force cleanup now (useful for long-running scripts)
force_cleanup_now() {
    # Clean up tracked files
    for temp_file in "${TEMP_FILES[@]}"; do
        if [ -f "$temp_file" ]; then
            rm -f "$temp_file" 2>/dev/null || true
        fi
    done

    # Clean up tracked directories
    for temp_dir in "${TEMP_DIRS[@]}"; do
        if [ -d "$temp_dir" ]; then
            rm -rf "$temp_dir" 2>/dev/null || true
        fi
    done

    # Clear arrays
    TEMP_FILES=()
    TEMP_DIRS=()
}

# ============================================================================
# Functions Available After Sourcing
# ============================================================================

# Functions available after sourcing this file:
# - cleanup_temp_files, cleanup_old_temp_files
# - create_temp_file, create_temp_dir
# - setup_cleanup_trap, force_cleanup_now
#
# Note: export -f is bash-specific and doesn't work in zsh
# Functions are available in the current shell after sourcing
