#!/usr/bin/env zsh
# SPDX-License-Identifier: MIT
# Copyright (c) 2026 John Unland
# Copyright (c) 2024 Sergei Kolesnikov

export VIRTUAL_ENV_DISABLE_PROMPT=true
setopt PROMPT_SUBST

aphrodite_get_prompt() {
        if [[ -n "$VIRTUAL_ENV" ]]; then
                local venv_name
                venv_name="${VIRTUAL_ENV##*/}"
                echo -n "%F{7}[${venv_name}]%f "
        fi

        echo -n "%F{6}%n"
        echo -n "%F{8}@"
        echo -n "%F{12}%m"
        echo -n "%F{8}:"
        echo -n "%f%~"
        echo -n " "

        local git_branch
        git_branch=$(git --no-optional-locks rev-parse --abbrev-ref HEAD 2> /dev/null)
        if [[ -n "$git_branch" ]]; then
                if git --no-optional-locks status --porcelain -u no 2> /dev/null | grep -q .; then
                        echo -n "%F{11}"
                else
                        echo -n "%F{10}"
                fi
                echo -n "‹${git_branch}›%f"
        fi

        if (( ${+APHRODITE_THEME_SHOW_TIME} )); then
                echo -n "%F{8} [%D{%H:%M:%S}]%f"
        fi

        echo  # new line

        echo -n "%(?.%f.%F{1})"  # if retcode == 0 ? reset : red
        echo -n "%(!.#.$)%f "  # if is_root_user ? # : $
}

export PROMPT='$(aphrodite_get_prompt)'