#!/bin/bash

# Installs the various dotfiles which I have here.

set -e

dotdir=`pwd`

# Links the zsh files, installing zsh and setting to default 
# shell if necessary (assumes Debian-based system)
if [[ ! -f /bin/zsh ]]
then 
  read -p "ZSH not installed. Install it? " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    sudo apt-get install zsh zsh-doc
  fi
fi
if [[ $SHELL != /bin/zsh && $SHELL != /usr/bin/zsh ]]
then 
  read -p "ZSH not default shell for this user. Set as default? " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    sudo usermod -s /bin/zsh $USER
  fi
fi
for file in .zlogin .zlogout .zprofile .zshenv .zshrc
do
  if [[ -L ~/$file ]]; then rm ~/$file; fi
  if [[ -e ~/$file ]]; then mv ~/$file ~/$file.bk; fi
  ln -s $dotdir/$file ~/$file
done

# Link content of fonts dotdirectory
if [[ ! -d ~/.fonts ]]; then mkdir ~/.fonts; fi
for file in .fonts/*
do 
  if [[ -L ~/$file ]]; then rm ~/$file; fi
  if [[ -f ~/$file ]]; then mv ~/$file ~/$file.bk; fi
  if [[ -d ~/$file ]]; then mv ~/$file ~/$file.bk; fi
  ln -s $dotdir/$file ~/$file
done

# Set up emacs plugins
if [[ -L ~/.emacs ]]; then rm ~/.emacs; fi
if [[ -f ~/.emacs ]]; then mv ~/.emacs ~/.emacs.bk; fi
ln -s $dotdir/.emacs ~/.emacs
if [[ ! -d ~/.emacs.d ]]; then mkdir ~/.emacs.d; fi
for file in .emacs.d/*
do 
  if [[ ! $file =~ ^\.emacs\.d/session\.[a-zA-Z0-9]+$ ]] 
  then
    if [[ -L ~/$file ]]; then rm ~/$file; fi
    if [[ -f ~/$file ]]; then mv ~/$file ~/$file.bk; fi
    if [[ -d ~/$file ]]; then mv ~/$file ~/$file.bk; fi
    ln -s $dotdir/$file ~/$file
  fi
done
if [[ ! -d ~/.emacs.d/.python-environments ]] 
then 
  mkdir ~/.emacs.d/.python-environments
fi
if ! virtualenv --version &> /dev/null
then
  read -p "virtualenv not installed. Install it? " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    sudo apt-get install python-virtualenv
  else
    echo 'Unable to complete setup without virtualenv.'
    exit 1
  fi
fi
if [[ ! -d ~/.emacs.d/.python-environments/default ]] 
then 
  virtualenv --system-site-packages ~/.emacs.d/.python-environments/default &> /dev/null
fi
source ~/.emacs.d/.python-environments/default/bin/activate
pip install fortpy &> fortpy_install.log || echo "Error installing Fortpy.
See fortpy_install.log for details."
pip install fortpy-el &> fortpy-el_install.log || echo "Error installing Fortpy.
See fortpy-el_install.log for details."
deactivate
