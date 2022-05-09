PROMPT="%(?:%{$fg_bold[green]%}💩 »:%{$fg_bold[red]%}🚽 »)"
PROMPT+=' %{$reset_color%}[%{$fg_bold[yellow]%}%c%{$reset_color%}] $(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[white]%}🐖 » [%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[white]%}] %{$fg[yellow]%}🍼"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[white]%}]"

