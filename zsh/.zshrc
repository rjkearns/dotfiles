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
. "$PWD/shared/.aliases"
. "$PWD/shared/.getnews"
. "$PWD/shared/.methods"
. "$dot_dir/.prompt"


