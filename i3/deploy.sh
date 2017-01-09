#!/bin/bash
source $(dirname "$0")/../deploy/commonFunctions.sh
source $(dirname "$0")/../deploy/outputSelection.sh

cd "$(dirname "$0")/."
i3files=$(pwd -P)
debugMsg "folder with i3 dotfiles: $i3files"

deploy_i3 () {
  cls
  info 'Installing i3'
  local overwrite_all=false backup_all=false skip_all=false

  ##################
  # COPY RESOURCES #
  ################## 

  copy_file "$i3files/resources/lock3.png" "$HOME/.i3/local.d/lock.png"
  copy_file "$i3files/resources/wallpaper.jpg" "$HOME/.i3/local.d/"
  #TODO fonts!
  


  #####################
  # BUILD ENVIRONMENT #
  #####################
 
  cls
  info "Building local config for this computer..."

  #TODO read environment variable from file, so you only need to set it once
  local environment='desktop'
  local input
  user "Do you want to use notebook specific templates instead of desktop settings? (y/N)"
  read -n 1 input
  case "$input" in
    y|Y )
      environment='notebook';;
    * )
      ;;
  esac
  cls

  #TODO this is temp! Delete after implementing below's TODO
  #rm "$HOME/.i3/local.d/environment.cfg"
 
  #TODO: 
  #local skipEnvironment
  local environmentFile="$HOME/.i3/local.d/environment.cfg"
  #if [ -f "$environmentFile" -o -L "$environmentFile" ]
  #then
  #  skipEnvironment=handle_duplicate "$environmentFile"
  #fi
  #
  #if [ "$skipEnvironment" != "true" ] # "false" or empty
  #then
  #  build environment like below


  #TODO this setup should be in outputSelection.sh and have a parameter for the number of outputs
  input="run setup"
  local primary= secondary= projector=

  while [ "$input" == "run setup" ]
  do
    primary=""
    secondary=""
    projector=""

    cls
    info "### MONITOR SETUP ###"
    info "To see your current setup, execute xrandr in another terminal\n"

    select_output primary
    if [ "$environment" == "desktop" ] ; then 
      select_output secondary
    fi
    select_output projector

    display_outputs
    user "Do you want to save this layout? Otherwise, the setup will run again. (Y/n)"
    read -n 1 input
    case "$input" in
      n|N )
        input="run setup"
        ;;
      * )
        ;;
    esac
    cls
  done
  primary="${outputs[$primary]}"
  secondary="${outputs[$secondary]}"
  projector="${outputs[$projector]}"


  cat << EOF > "$environmentFile"
# THIS FILE AFFECTS THE LOCAL SETTINGS!
# Run ~/.i3/scripts/build.sh (Shortcut [Win]+[Shift]+[C])
# to apply changes and create a new config file.
 
 
EOF
  
  echo "# monitor setup" >> "$environmentFile"
  echo "set \$outputPrimary $primary" >> "$environmentFile"
  if [ "$environment" == "notebook" ] ; then
    secondary="$projector"
  fi
  echo "set \$outputSecondary $secondary" >> "$environmentFile"
  echo "set \$outputProjector $projector" >> "$environmentFile"
  echo "" >> "$environmentFile"

  cat "$i3files/templates/$environment/environment.tpl" >> "$environmentFile"
  
  info "Done building environment config.\nCheck $environmentFile for further adjustments"



  ###########################
  # COPY LOCAL CONFIG FILES #
  ###########################

  copy_file "$i3files/templates/$environment/autostart.tpl" "$HOME/.i3/local.d/autostart.cfg"
  copy_file "$i3files/templates/$environment/i3blocks.tpl" "$HOME/.i3/local.d/i3blocks.cfg"


  ##########################
  # SYMLINK OTHER DOTFILES #
  ##########################

  link_file "$i3files/blocklets" "$HOME/.i3/blocklets"
  link_file "$i3files/scripts" "$HOME/.i3/scripts"

  link_file "$i3files/README.TXT" "$HOME/.i3/README.TXT"
  link_file "$i3files/base.cfg" "$HOME/.i3/base.cfg"
  link_file "$i3files/theme.cfg" "$HOME/.i3/theme.cfg"


  ##############################
  # CREATE FINAL 'config' FILE #
  ##############################

  . "$HOME/.i3/scripts/build.sh"
}

deploy_i3
