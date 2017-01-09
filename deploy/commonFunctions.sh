#!/usr/bin/env bash
#

#######################
#    custom prompt    #
#######################

p=">"
set -e

info () {
  printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}
user () {
  printf "\r  [ \033[0;33m??\033[0m ] $1 \n  $p "
}
success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}
error () {
  printf "\r\033[2K  [ \033[0;31m!!\033[0m ] $1\n"
}
fail () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo ''
  exit
}
cls () {
  printf "\033c"
}



##############
#    init    #
##############

debug=${1:-false}
function debugMsg {
    if [ "$debug" = true ] ; then
        info "DEBUG: $1"
    fi
}
#debugMsg "activated!"


#########################
#    file functions     #
#########################

copy_file () {
  local src=$1 dst=$2

  local overwrite= backup= skip=
  local action=

  # ensure that parent folders exist
  mkdir -p $(dirname "$dst") 

  if [ -d $dst ]
  then
    dst="$dst$(basename $src)"
  fi


  if [ -f "$dst" -o -L "$dst" ]
  then

    if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]
    then
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
    cp "$src" "$dst"
    success "copied $src to $dst"
  fi
}


link_file () {
  local src=$1 dst=$2

  local overwrite= backup= skip=
  local action=

  # ensure that parent folders exist
  mkdir -p $(dirname "$src")
  mkdir -p $(dirname "$dst") 

  if [ -f "$dst" -o -d "$dst" -o -L "$dst" ]
  then

    if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]
    then

      # if link already points to correct src, skip the file:    
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
  local src_dir="$1/*" dst_dir=$2
  info "linking contents of $src_dir"
  for src in $src_dir
  do
     dst="$dst_dir/$(basename "$src")"
     link_file "$src" "$dst"
  done
}
