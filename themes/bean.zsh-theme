#
# Based on Geoffrey Grosenbach's peepcode zsh theme from
# https://github.com/topfunky/zsh-simple
#

## TODO
# (x) Remove blank lines if user is not currently in git tree
#   git rev-parse --is-inside-work-tree

#use extended color palette if available
if [[ $TERM = (*256color|*rxvt*) ]]; then
  turquoise="%{${(%):-"%F{81}"}%}"
  orange="%{${(%):-"%F{166}"}%}"
  purple="%{${(%):-"%F{135}"}%}"
  hotpink="%{${(%):-"%F{161}"}%}"
  limegreen="%{${(%):-"%F{118}"}%}"
else
  turquoise="%{${(%):-"%F{cyan}"}%}"
  orange="%{${(%):-"%F{yellow}"}%}"
  purple="%{${(%):-"%F{magenta}"}%}"
  hotpink="%{${(%):-"%F{red}"}%}"
  limegreen="%{${(%):-"%F{green}"}%}"
fi

root_warning() {
  local whoami=$(whoami)
  if [[ "$whoami" = "root" ]]; then
    echo "%{$fg_bold[red]%}root %{$reset_color%}"
  fi
}

root_warning_color() {
  local whoami=$(whoami)
  if [[ "$whoami" = "root" ]]; then
    echo "red"
    return
  fi
  echo "blue"
}

git_repo_path() {
  command git rev-parse --git-dir 2>/dev/null
}

git_commit_id() {
  command git rev-parse --short HEAD 2>/dev/null
}

git_tags_at_head() {
  local tags=$(git tag --points-at HEAD)
  if [[ -n "$tags" ]]; then
    echo "tags: $tags"
  fi
}

git_mode() {
  if [[ -e "$repo_path/BISECT_LOG" ]]; then
    echo "+bisect"
  elif [[ -e "$repo_path/MERGE_HEAD" ]]; then
    echo "+merge"
  elif [[ -e "$repo_path/rebase" || -e "$repo_path/rebase-apply" || -e "$repo_path/rebase-merge" || -e "$repo_path/../.dotest" ]]; then
    echo "+rebase"
  fi
}

git_dirty() {
  if [[ "$repo_path" != '.' && -n "$(command git ls-files -m)" ]]; then
    echo " %{$fg_bold[yellow]%}✘%{$reset_color%}"
  fi
}

get_user() {
  local whoami=$(whoami)
  if [[ "$whoami" = "root" ]]; then
    echo "%{$fg_bold[red]%}$whoami%{$reset_color%}"
    return
  fi
  echo "%{$fg_bold[green]%}$whoami%{$reset_color%}"
}

git_prompt() {
  local cb=$(git_current_branch)
  if [[ -n "$cb" ]]; then
    local repo_path=$(git_repo_path)
    echo "git:// %{$fg_bold[green]%}$cb %{$fg[white]%}$(git_commit_id)%{$reset_color%} $(git_mode)$(git_dirty) $(git_tags_at_head)"
  fi
}

## Helpful characters
# ⚡ λ ❯ 🐄 🐮 ☺ ☹

# Finals
previous_result='%(?.%F{green}☺  good%f.%F{red}☹  bad %f)'
PR_RST="%{${reset_color}%}"

# Left prompt
PROMPT='
%F{$(root_warning_color)}┌──────────────────────
%F{$(root_warning_color)}| $(root_warning)$(hostname) %F{white}$(ruby_prompt_info) %{$reset_color%}%F{white}$(date +"%Y-%m-%dT%H:%M:%SZ")%{$reset_color%}
%F{$(root_warning_color)}| %{$reset_color%}$(git_prompt) $(git_remote_status) %{$reset_color%}
%F{$(root_warning_color)}└─%{$reset_color%}$previous_result ${limegreen}$(basename "$PWD")/ ❯${PR_RST} '

# Right prompt
RPROMPT='${VIRTUAL_ENV:+"($VIRTUAL_ENV) "}%~ %(?..%{$fg[red]%}%?%{$reset_color%}) 🐄 $(date +"%H:%M:%S") $(get_user)%F{$(root_warning_color)}%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[green]%} %{$fg[yellow]%}⚡%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE="%{$fg_bold[magenta]%}↓%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE="%{$fg_bold[magenta]%}↑%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIVERGED_REMOTE="%{$fg_bold[magenta]%}↕%{$reset_color%}"

# Disable automatic virtualenv prompt change
export VIRTUAL_ENV_DISABLE_PROMPT=1
