# dotfiles

## BASH
To use the .bashrc file within this directory, place the following in either `~/.bashrc` or `~/.bash_profile`

```
source /path/to/dotifles/bash/.bashrc
```

## ZSH
To use the .zshrc file within this directory, place the following your `~/.zshrc`

```
source /path/to/dotfiles/zsh/.zshrc
```

## VIM
To use the .vimrc file within this directory, move the following file into your `$HOME` directory

```
mv /path/to/dotfiles/.vimrc ~/
```

To note, this file assumes that [vim-plug](https://github.com/junegunn/vim-plug) is installed in order to take advantage of the plugins used.
Run the following if vim-plug is not installed

```
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

Once vim-plug is installed, run the following command within a vim session

```
:PlugInstall
```

## Configuration Files
Move the following into your `$HOME` directory in order for their settings to be applied

```
mv /path/to/dotfiles/.ansiweatherrc ~/
mv /path/to/dotfiles/.gitconfig ~/
mv /path/to/dotfiles/.ignore ~/
```
