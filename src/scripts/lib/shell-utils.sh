#!/bin/bash

# Shell Utilities
# Provides cross-shell compatibility functions (bash/zsh)

# Enable bash compatibility mode in zsh
if [ -n "${ZSH_VERSION:-}" ]; then
    emulate bash 2>/dev/null || true
fi

# ============================================================================
# Shell Detection & Compatibility
# ============================================================================

# Get the directory of the currently sourced/executed script
# Works in both bash and zsh, whether sourced or executed
# Usage: SCRIPT_DIR=$(get_script_dir)
get_script_dir() {
    local script_path

    # Detect shell and use appropriate source variable
    if [ -n "${BASH_SOURCE:-}" ]; then
        # Bash
        script_path="${BASH_SOURCE[0]}"
    elif [ -n "${ZSH_VERSION:-}" ]; then
        # Zsh - use parameter expansion to get script path
        script_path="${(%):-%x}"
    else
        # Fallback: try to use $0 (works when script is executed, not sourced)
        script_path="$0"
    fi

    # Get the directory
    (cd "$(dirname "$script_path")" && pwd)
}

# Get the directory of the calling script (one level up in the call stack)
# This is useful when sourcing shell-utils.sh from another script
# Usage: CALLING_SCRIPT_DIR=$(get_calling_script_dir)
get_calling_script_dir() {
    local script_path

    # Detect shell and use appropriate source variable
    if [ -n "${BASH_SOURCE:-}" ]; then
        # Bash - get the caller's script (BASH_SOURCE[1])
        script_path="${BASH_SOURCE[1]}"
    elif [ -n "${ZSH_VERSION:-}" ]; then
        # Zsh - use parameter expansion to get script path
        script_path="${(%):-%x}"
    else
        # Fallback: try to use $0
        script_path="$0"
    fi

    # Get the directory
    (cd "$(dirname "$script_path")" && pwd)
}

# Detect current shell
# Returns: "bash", "zsh", or "unknown"
detect_shell() {
    if [ -n "${BASH_VERSION:-}" ]; then
        echo "bash"
    elif [ -n "${ZSH_VERSION:-}" ]; then
        echo "zsh"
    else
        echo "unknown"
    fi
}

# ============================================================================
# Exports
# ============================================================================

# Note: export -f is bash-specific and doesn't work in zsh
# These functions are available after sourcing this file
