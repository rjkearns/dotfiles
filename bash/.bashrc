#!/bin/bash

######################
#      Exportin'     #
######################
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export NVM_DIR=~/.nvm
export EDITOR=vim
export EXECJS_RUNTIME=Node
export DIFFTOOL=opendiff
export USE_TERMINAL_THEMES=1
export BAT_CONFIG_PATH="~/Developer/dotfiles/bat/bat.conf"
export FZF_CTRL_T_COMMAND='ag --hidden --ignore .git -g ""'
export FZF_CTRL_T_OPTS="--ansi --preview-window 'right:80%' --preview 'bat --color=always {}'"
export FZF_DEFAULT_OPTS="--ansi --height 100% --layout=reverse --border"
export CLICOLOR=cons25
export BASH_SILENCE_DEPRECATION_WARNING=1
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
eval "$(rbenv init -)"
{ eval `ssh-agent`; ssh-add -A; } &>/dev/null
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

######################
#  History settings  #
######################
export HISTFILESIZE=
export HISTSIZE=
export HISTTIMEFORMAT="%Y%m%d %T"

######################
#      Sourcin'      #
######################
source $PWD/Developer/dotfiles/shared/.aliases
source $PWD/Developer/dotfiles/shared/.methods
source $PWD/Developer/dotfiles/shared/.getnews
source $PWD/Developer/dotfiles/bash/.prompt
