# Exportin'
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export NVM_DIR=~/.nvm
export EDITOR=vim
export EXECJS_RUNTIME=Node
export DIFFTOOL=opendiff
export USE_TERMINAL_THEMES=1
export HISTFILESIZE=
export HISTSIZE=
export HISTTIMEFORMAT="%Y%m%d %T"
export BAT_CONFIG_PATH="~/Developer/dotfiles/bat/bat.conf"
export FZF_CTRL_T_COMMAND='ag --hidden --ignore .git -g ""'
export FZF_CTRL_T_OPTS="--ansi --preview-window 'right:80%' --preview 'bat --color=always {}'"
export FZF_DEFAULT_OPTS="--ansi --height 100% --layout=reverse --border"
export CLICOLOR=cons25
export BASH_SILENCE_DEPRECATION_WARNING=1
source ~/.nvm/nvm.sh
eval "$(rbenv init -)"
{ eval `ssh-agent`; ssh-add -A; } &>/dev/null
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Prompt Colors
cyan=$'\e[1;36m'
green=$'\e[1;32m'
magenta=$'\e[1;35m'
white=$'\e[m'

# Personal Aliases
alias cat='bat'
alias ag='ag --path-to-ignore ~/Developer/dotfiles/.ignore'
alias berc='bundle exec rails c'
alias bers='bundle exec rails s'
alias bert='bundle exec rake test'
alias fs='foreman start'
alias tags='ctags -R --exclude=.git --exclude=node_modules --exclude=test'

# Directory shortcuts
alias home='cd ~/'
alias developer='cd ~/Developer/'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

devloper() {
  DIR=`find ~/Developer/* -maxdepth 0 -type d -print 2> /dev/null | fzf-tmux` && cd "$DIR"
}

dirr() {
  DIR=`find * -maxdepth 0 -type d -print 2> /dev/null | fzf-tmux` && cd "$DIR"
}

fd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

# VIM
alias vi='mvim -v'
alias vimrc='vi ~/.vimrc'

vif() {
  vim "$(fzf)"
}

vg() {
  local file line
  read -r file line <<<"$(ag --nobreak --noheading $@ | fzf -0 -1 | awk -F: '{print $1, $2}')"

  if [[ -n $file ]]
  then
     vim $file +$line
  fi
}

# Git shortcuts
alias gb='git branch'
alias gco='git checkout'
alias gcm='git checkout master'
alias gup='git smart-pull'
alias gm='git smart-merge'
alias gl='git smart-log'
alias gfc='git log -1 --graph --decorate --oneline'
alias sha='git rev-parse HEAD'
alias glgg='git log --graph --decorate'
alias glg='git log --graph --decorate --oneline'
alias gds='git diff --staged'
alias gst='git status'
alias gss='git status -sb'

fbr() {
  git fetch
  local branches branch
  branches=$(git branch -a) &&
  branch=$(echo "$branches" | fzf +s +m -e) &&
  git checkout $(echo "$branch" | sed "s:.* remotes/origin/::" | sed "s:.* ::")
}


git_prompt() {
  export git_branch=''
  rev_parse_directory=`git rev-parse --show-toplevel 2> /dev/null`
  if [ -f "$rev_parse_directory/.git/HEAD" ]; then
    export git_branch="$magenta(`git rev-parse --abbrev-ref HEAD` `git diff --numstat | wc -l | xargs`$white|$green`git diff --staged --numstat | wc -l | xargs`$magenta)"
  fi
}
# refresh your current directory on every command, in case you are in a directory that has moved or been renamed, etc
PROMPT_COMMAND='cd "`pwd`"'
PROMPT_COMMAND="git_prompt; $PROMPT_COMMAND"

PS1="\$git_branch \\[$cyan\]\u 🦊 \\[$green\]\W\[$white\] "
