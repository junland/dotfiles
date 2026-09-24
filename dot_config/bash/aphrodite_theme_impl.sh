#!/usr/bin/env bash
# SPDX-License-Identifier: MIT
# Copyright (c) 2026 John Unland
# Copyright (c) 2024 Sergei Kolesnikov

export VIRTUAL_ENV_DISABLE_PROMPT=true

# Cache ANSI terminal escape codes once at startup to avoid spawning subshells on every prompt render
__aphrodite_c_reset='\[\e[0m\]'
__aphrodite_c_white='\[\e[37m\]'
__aphrodite_c_cyan='\[\e[36m\]'
__aphrodite_c_grey='\[\e[90m\]'
__aphrodite_c_blue='\[\e[94m\]'
__aphrodite_c_clean='\[\e[32m\]'   # Green
__aphrodite_c_dirty='\[\e[33m\]'   # Yellow
__aphrodite_c_error='\[\e[31m\]'   # Red

# Update prompt data before each prompt render
__aphrodite_update_prompt_data() {
    local RETVAL=$?

    # Virtual Environment
    __aphrodite_venv=''
    [[ -n "$VIRTUAL_ENV" ]] && __aphrodite_venv="[${VIRTUAL_ENV##*/}] "

    # Git Status
    __aphrodite_git=''
    __aphrodite_git_color="$__aphrodite_c_clean"
    local git_branch
    local git_status
    git_branch=$(git --no-optional-locks rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [[ -n "$git_branch" ]]; then
        if [[ "$git_branch" == "HEAD" ]]; then
            git_branch=$(git --no-optional-locks rev-parse --short HEAD 2>/dev/null)
        fi
        if [[ -n "$git_branch" ]]; then
            git_status=$(git --no-optional-locks status --porcelain -u no 2>/dev/null)
            if [[ -n "$git_status" ]]; then
                __aphrodite_git_color="$__aphrodite_c_dirty"
            fi
            __aphrodite_git="‹${git_branch}›"
        fi
    fi

    # Exit Status Color
    __aphrodite_prompt_symbol_color="$__aphrodite_c_reset"
    [[ "$RETVAL" -ne 0 ]] && __aphrodite_prompt_symbol_color="$__aphrodite_c_error"

    # Optional Time Display
    __aphrodite_time=''
    [[ -n "$APHRODITE_THEME_SHOW_TIME" ]] && __aphrodite_time="[\t]"

    return $RETVAL
}

# Fix PROMPT_COMMAND append logic and prevent duplicate registration
__aphrodite_prompt_command_decl=''
__aphrodite_prompt_command_arrays_supported=false
if (( BASH_VERSINFO[0] > 5 || (BASH_VERSINFO[0] == 5 && BASH_VERSINFO[1] >= 1) )); then
    __aphrodite_prompt_command_arrays_supported=true
fi
if $__aphrodite_prompt_command_arrays_supported && __aphrodite_prompt_command_decl=$(declare -p PROMPT_COMMAND 2>/dev/null); then
    if [[ "$__aphrodite_prompt_command_decl" == "declare -a"* ]]; then
        __aphrodite_has_prompt_hook=false
        for __aphrodite_prompt_hook in "${PROMPT_COMMAND[@]}"; do
            if [[ "$__aphrodite_prompt_hook" == "__aphrodite_update_prompt_data" ]]; then
                __aphrodite_has_prompt_hook=true
                break
            fi
        done
        if ! $__aphrodite_has_prompt_hook; then
            PROMPT_COMMAND+=(__aphrodite_update_prompt_data)
        fi
        unset __aphrodite_has_prompt_hook __aphrodite_prompt_hook
    elif [[ "$__aphrodite_prompt_command_decl" == "declare -A"* ]]; then
        __aphrodite_has_prompt_hook=false
        for __aphrodite_prompt_hook in "${!PROMPT_COMMAND[@]}"; do
            if [[ "$__aphrodite_prompt_hook" == "__aphrodite_update_prompt_data" || "${PROMPT_COMMAND[$__aphrodite_prompt_hook]}" == "__aphrodite_update_prompt_data" ]]; then
                __aphrodite_has_prompt_hook=true
                break
            fi
        done
        if ! $__aphrodite_has_prompt_hook; then
            PROMPT_COMMAND[__aphrodite_update_prompt_data]="__aphrodite_update_prompt_data"
        fi
        unset __aphrodite_has_prompt_hook __aphrodite_prompt_hook
    elif [[ ";$PROMPT_COMMAND;" != *";__aphrodite_update_prompt_data;"* ]]; then
        if [[ -n "$PROMPT_COMMAND" ]]; then
            PROMPT_COMMAND="${PROMPT_COMMAND%;}; __aphrodite_update_prompt_data"
        else
            PROMPT_COMMAND="__aphrodite_update_prompt_data"
        fi
    fi
else
    PROMPT_COMMAND="__aphrodite_update_prompt_data"
fi
unset __aphrodite_prompt_command_arrays_supported __aphrodite_prompt_command_decl

# Assemble static PS1 structure using direct Bash expansion variables
PS1=''
PS1+="${__aphrodite_c_white}\${__aphrodite_venv}${__aphrodite_c_reset}"
PS1+="${__aphrodite_c_cyan}\u"
PS1+="${__aphrodite_c_grey}@"
PS1+="${__aphrodite_c_blue}\h"
PS1+="${__aphrodite_c_grey}:"
PS1+="${__aphrodite_c_reset}\w "
PS1+="\${__aphrodite_git_color}\${__aphrodite_git}${__aphrodite_c_reset} "
PS1+="${__aphrodite_c_grey}\${__aphrodite_time}${__aphrodite_c_reset}\n"
PS1+="\${__aphrodite_prompt_symbol_color}\\$${__aphrodite_c_reset} "
