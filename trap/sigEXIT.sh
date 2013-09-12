#!/bin/sh

########	  ! type -t mas_source_clean_pid2 >/dev/null 2>&1 && [[ "$MAS_SHLIB" ]] && . $MAS_SHLIB/libregbash.bash

########	  (
########	    sleep 0.5 ; type -t mas_source_clean_pid2 >/dev/null 2>&1 && mas_source_clean_pid2
########	  ) &
########	  mas_logger "it's a trap 1 sigEXIT"


########	  if [[ "$MAS_BASH_LOG" ]] ; then
########	    set > $MAS_BASH_LOG/trap_EXIT.$UID.set.txt
########	  fi
########	  #       	  if [[ "$MAS_CONF_DIR_TERM" ]] ; then
########	  #       	    if [[ -x $MAS_CONF_DIR_TERM/trap/mastar_end.sh ]] ; then
########	  #       	      trap $MAS_CONF_DIR_TERM/trap/mastar_end.sh EXIT
########	  #       	    #   echo "Set trap  $MAS_CONF_DIR_TERM/.bashrc_mastar_end"
########	  #       	    #   sleep 5
########	  #       	    fi
########	  #       	  fi



# vim: filetype=sh
