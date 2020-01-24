#!/bin/zsh

######################
#      Exportin'     #
######################
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="$HOME/.bin:$PATH"
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export NVM_DIR="$HOME/.nvm"
export EDITOR=vim
export EXECJS_RUNTIME=Node
export DIFFTOOL=opendiff
export USE_TERMINAL_THEMES=1
export BAT_CONFIG_PATH="$PWD/bat/bat.conf"
export FZF_CTRL_T_COMMAND='ag --hidden --ignore .git -g ""'
export FZF_CTRL_T_OPTS="--ansi --preview-window 'right:80%' --preview 'bat --color=always {}'"
export FZF_DEFAULT_OPTS="--ansi --height 100% --layout=reverse --border"
export CLICOLOR=cons25
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
eval "$(rbenv init -)"
{ eval `ssh-agent`; ssh-add -A; } &>/dev/null
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

######################
#  History settings  #
######################
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000
SAVEHIST=10000000
setopt BANG_HIST
setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt HIST_BEEP
zle_highlight+=(paste:none)

######################
#      Sourcin'      #
######################
dot_dir=${0:a:h}
. "$dot_dir/.aliases"
. "$dot_dir/.prompt"
. "$dot_dir/.getnews"

startmyday () {
  echo "Good morning, Bobby."
  echo "\nThe weather right now:"
  ansiweather
  echo "\nUpdating Homebrew..."
  brew update && brew upgrade
  echo "\nNews from Hacker News:"
  gethackernews
}

######################
# Directory commands #
######################
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

cd() {
  builtin cd "$@" && ls -lA
}

######################
#    VIM commands    #
######################
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

######################
#    GIT commands    "
######################
fbr() {
  git fetch
  local branches branch
  branches=$(git branch -a) &&
  branch=$(echo "$branches" | fzf +s +m -e) &&
  git checkout $(echo "$branch" | sed "s:.* remotes/origin/::" | sed "s:.* ::")
}
