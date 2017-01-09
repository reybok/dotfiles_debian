#!/bin/bash
source $(dirname "$0")/../deploy/commonFunctions.sh

outputs=(`xrandr | grep -o '[[:alpha:]]*-[[:digit:]]'`)
numberOfOutputs=${#outputs[*]}

print_unavailable_output () { #int index, String reason
  printf "\r     \033[00;30m[$1]\033[0m ${outputs[$1]} (\033[00;32m$2\033[0m)\n"
}
print_available_output () { #int index
  printf "\r     [\033[00;33m$1\033[0m] ${outputs[$1]}\n"
}

display_outputs () {  
  for (( i=0; i<$numberOfOutputs; i++ ))
  do 
    if [ "$primary" == "$i" ] ; then
      print_unavailable_output "$i" "PRIMARY" 
    elif [ "$secondary" == "$i" ] ; then
      print_unavailable_output "$i" "SECONDARY"
    elif [ "$projector" == "$i" ] ; then
      print_unavailable_output "$i" "PROJECTOR" 
    else
      print_available_output "$i"
    fi
  done  
}

select_output () {
  local outputName
  eval "outputName=$1"

  local output=""
  while [ "$output" == "" ]
  do
    user "Choose your $outputName output:"
    display_outputs
    read -n 1 output
    cls

    case $output in
      ''|*[!0-9]*) 
         error "Please enter a valid number from 0 to $(($numberOfOutputs-1))"
         output="" 
         ;;
      *) 
        if [ ! $output -lt $numberOfOutputs ]
        then 
          error "Please enter a valid number from 0 to $(($numberOfOutputs-1))" 
          output="" 
        else
          if [ "$output" == "$primary" ] || [ "$output" == "$secondary" ] ; then
            error "${outputs[$output]} is already selected!"
            output=""
          fi
        fi 
        ;;
    esac
  done

  cls
  eval "$1='$output'"
}
