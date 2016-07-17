#!/usr/bin/env bash
#
# symlink installs things.

cd "$(dirname "$0")/."
dotfiles=$(pwd -P)
#dotfiles=$HOME/dotfiles

set -e
# custom prompt
p=">"

echo ''

info () {
  printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

user () {
  printf "\r  [ \033[0;33m??\033[0m ] $1 $p \n"
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo ''
  exit
}

setup_gitconfig () {
  if ! [ -f git/gitconfig.local.symlink ]
  then
    info 'setup gitconfig'

    git_credential='cache'
    if [ "$(uname -s)" == "Darwin" ]
    then
      git_credential='osxkeychain'
    fi

    user ' - What is your github author name?'
    read -e git_authorname
    user ' - What is your github author email?'
    read -e git_authoremail

    sed -e "s/AUTHORNAME/$git_authorname/g" -e "s/AUTHOREMAIL/$git_authoremail/g" -e "s/GIT_CREDENTIAL_HELPER/$git_credential/g" git/gitconfig.local.symlink.example > git/gitconfig.local.symlink

    success 'gitconfig'
  fi
}


link_file () {
  local src=$1 dst=$2

  local overwrite= backup= skip=
  local action=

  # ensure that parent folder(s) exist
  mkdir -p $(dirname "$dst")

  if [ -f "$dst" -o -d "$dst" -o -L "$dst" ]
  then

    if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]
    then

      local currentSrc="$(readlink $dst)"

      if [ "$currentSrc" == "$src" ]
      then

        skip=true;

      else

        user "File already exists: $dst ($(basename "$src")), what do you want to do?\n\
        [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
        read -n 1 action

        case "$action" in
          o )
            overwrite=true;;
          O )
            overwrite_all=true;;
          b )
            backup=true;;
          B )
            backup_all=true;;
          s )
            skip=true;;
          S )
            skip_all=true;;
          * )
            ;;
        esac

      fi

    fi
    

    overwrite=${overwrite:-$overwrite_all}
    backup=${backup:-$backup_all}
    skip=${skip:-$skip_all}

    if [ "$overwrite" == "true" ]
    then
      rm -rf "$dst"
      success "removed $dst"
    fi

    if [ "$backup" == "true" ]
    then
      mv "$dst" "${dst}.backup"
      success "moved $dst to ${dst}.backup"
    fi

    if [ "$skip" == "true" ]
    then
      success "skipped $src"
    fi
  fi

  if [ "$skip" != "true" ]  # "false" or empty
  then
    ln -s "$1" "$2"
    success "linked $1 to $2"
  fi
}

link_content() {
  local src_dir=$1 dst_dir=$2
  
  for src in $($src_dir/*)
  do
     dst="$dst_dir/$(basename "$src")"
     echo "unzipping dir: link from $dst to original $src"
     link_file "$src" "$dst"
  done
  
}

install_dotfiles () {
  info 'installing dotfiles'

  local overwrite_all=false backup_all=false skip_all=false

  #TODO automate symlinking
  #for src in $(find -H "$DOTFILES_ROOT" -maxdepth 2 -name '*.symlink' -not -path '*.git*')
  #do
  #  dst="$HOME/.$(basename "${src%.*}")"
  #  link_file "$src" "$dst"
  #done

  # manually link for now

  # compton
  link_file "$dotfiles/compton/compton.conf" "$HOME/.compton.conf"

  # dunst
  link_file "$dotfiles/dunst/dunstrc" "$HOME/.config/dunst/dunstrc"

  # gtk
  link_file "$dotfiles/gtk/gtk-2.0" "$HOME/.gtkrc-2.0"
  link_file "$dotfiles/gtk/gtk-3.0" "$HOME/.config/gtk-3.0/settings.ini"

  # i3
  link_file "$dotfiles/i3/config" "$dotfiles/themer/templates/i3/i3.tpl"

  # scripts
  link_file "$dotfiles/scripts" "$HOME/scripts"

  # termite
  link_file "$dotfiles/termite/config" "$HOME/.config/termite/config"
  link_file "$dotfiles/termite/dircolors" "$HOME/.dircolors"

  # themer
  link_content "$dotfiles/themer" "$HOME/.config/themer"
  link_file "$HOME/.config/themer/current/i3.conf" "$HOME/.config/i3/config"
  link_file "$HOME/.config/themer/current/Xresources" "$HOME/.Xresources"
  link_file "$HOME/.config/themer/current/yabar.conf" "$HOME/.config/yabar/yabar.conf"

  # tmux
  link_file "$dotfiles/tmux/tmux.conf" "$HOME/.tmux.conf"
  link_content "$dotfiles/tmux/tmuxinator" "$HOME/.tmuxinator"
  link_file "$dotfiles/tmux/tmux_powerline.json" "$HOME/.config/powerline/themes/tmux/default.json"

  # vim
  link_file "$dotfiles/vim/vimrc" "$HOME/.vimrc"
  link_content "$dotfiles/vim/vim" "$HOME/.vim"
  
  # xfluxd
  link_file "$dotfiles/xfluxd/xfluxd.conf" "/etc/xfluxd.conf"

  # xorg
  link_file "$dotfiles/xorg/xinitrc" "$HOME/.xinitrc"
  link_file "$dotfiles/xorg/Xmodmap" "$HOME/.Xmodmap"
  link_file "$dotfiles/xorg/Xresources" "$dotfiles/themer/templates/i3/Xresources.tpl"
  #link_content "$dotfiles/xorg/xorg.conf.d" "/etc/X11/xorg.conf.d"

  # yabar
  link_file "$dotfiles/yabar/yabar.conf" "$dotfiles/themer/templates/i3/yabar.tpl"

  # zsh
  link_file "$dotfiles/zsh/zshrc" "$HOME/.zshrc"
}

#TODO add git support
#setup_gitconfig
install_dotfiles

#TODO linuxbrew for package installation
# If we're on a Mac, let's install and setup homebrew.
#if [ "$(uname -s)" == "Darwin" ]
#then
#  info "installing dependencies"
#  if source bin/dot > /tmp/dotfiles-dot 2>&1
#  then
#    success "dependencies installed"
#  else
#    fail "error installing dependencies"
#  fi
#fi

echo ''
echo '  All installed!'
