# AUTOCONFIG
# Terminal configuration
# ------------------------------------------------------------------------------------------------------------
# bash theme - partly inspired by https://github.com/ohmyzsh/ohmyzsh/blob/master/themes/robbyrussell.zsh-theme

__bash_prompt() {
    local userpart='`export XIT=$?; \
        if [ ! -z "${GITHUB_USER}" ]; then \
            echo -n "\[\033[0;32m\]\u@\h"; \
        else \
            echo -n "\[\033[0;32m\]\u@\h"; \
        fi; \
        if [ "$XIT" -ne "0" ]; then \
            echo -n "\[\033[1;31m\]:"; \
        else \
            echo -n "\[\033[0m\]:"; \
        fi`'
    local gitbranch='`\
        if [ "$(git config --get devcontainers-theme.hide-status 2>/dev/null)" != 1 ] && \
           [ "$(git config --get codespaces-theme.hide-status 2>/dev/null)" != 1 ]; then \
            export BRANCH=$(git --no-optional-locks symbolic-ref --short HEAD 2>/dev/null || git --no-optional-locks rev-parse --short HEAD 2>/dev/null); \
            if [ "${BRANCH}" != "" ]; then \
                echo -n " \[\033[0;36m\](\[\033[1;31m\]${BRANCH}"; \
                if git --no-optional-locks ls-files --error-unmatch -m --directory --no-empty-directory -o --exclude-standard ":/*" > /dev/null 2>&1; then \
                    echo -n " \[\033[1;33m\]✗"; \
                fi; \
                echo -n "\[\033[0;36m\])"; \
            fi; \
        fi`'
    local lightblue='\[\033[1;34m\]'
    local removecolor='\[\033[0m\]'
    PS1="${userpart}${lightblue}\w${gitbranch}${removecolor}\$ "
    unset -f __bash_prompt
}

__bash_prompt
export PROMPT_DIRTRIM=4
# ------------------------------------------------------------------------------------------------------------
# END AUTOCONFIG