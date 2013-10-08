# mas_loadlib_if_not mywmws wm
# mas_loadlib_if_not gvimer ed

#typemas datemt  && export MAS_TIME_LIBSTDBINS=$(datemt) 
function define_std_binnames ()
{ 
# echo "define_std_binnames ------------- ${BASH_SOURCE[@]} ---------( $BASH_SUBSHELL )------- ${FUNCNAME[@]} --" >&2
  declare -xg MAS_UTIME=${MAS_BIN:=${MAS_DIR:=$HOME/.mas}/bin}/utime 
  declare -xg MAS_PS_CMD=${MAS_PS_CMD:=/bin/ps}
  declare -xg MAS_USLEEP=${MAS_BIN:=${MAS_DIR:=$HOME/.mas}/bin}/usleep
# declare -xg
# MAS_WS_CMD=${MAS_BIN:=${MAS_DIR:=$HOME/.mas}/bin}/mywmworkspace

  declare -xg MAS_BASENAME=${MAS_BASENAME:=/usr/bin/basename}
  declare -xg MAS_WHICH_CMD=${MAS_WHICH:=/usr/bin/which}
  declare -xg MAS_WHICH=${MAS_WHICH_CMD}
  declare -xg MAS_GREP_CMD=${MAS_GREP_CMD:=/bin/grep}
  
  declare -xg MAS_SED_CMD=${MAS_SED_CMD:=/bin/sed}
  declare -xg MAS_AWK_CMD=${MAS_AWK_CMD:=/bin/awk}
  declare -xg MAS_TTY_CMD=${MAS_TTY_CMD:=/bin/tty}
  declare -xg MAS_DATE_CMD=${MAS_DATE_CMD:=/bin/date}
  declare -xg MAS_MKDIR_CMD=${MAS_MKDIR_CMD:=/bin/mkdir}
  declare -xg MAS_CUT_CMD=${MAS_CUT_CMD:=/bin/cut}
  declare -xg MAS_CAT_CMD=${MAS_CAT_CMD:=/bin/cat}
  declare -xg MAS_ECHO_CMD=${MAS_ECHO_CMD:=/bin/echo}

  declare -xg MAS_VI_CMD=/usr/bin/vi
  if [[ -x /usr/bin/vim ]] ; then
    MAS_VI_CMD=/usr/bin/vim
  elif [[ -x /usr/bin/vi ]] ; then
    MAS_VI_CMD=/usr/bin/vi
  fi
  declare -xg MAS_VIM_CMD=$MAS_VI_CMD
  if [[ -x /usr/bin/gvim ]] ; then
    declare -xg MAS_GVIM_CMD=/usr/bin/gvim
  fi
# declare -xg MAS_WS_CMD_TMP_=mywmws
  declare -xg MAS_SCREEN_CMD=${MAS_SCREEN_CMD:=/usr/bin/screen}
  declare -xg MAS_EDITOR_TYPE='vi'
  declare -xg MAS_PERSONAL_EDITOR=''
# infomas "MAS_UNDER=$MAS_UNDER; MAS_EDITOR_TYPE=$MAS_EDITOR_TYPE"
  if [[ "$MAS_EDITOR_TYPE" == 'vi' ]] ; then
    declare -xg MAS_EDITOR_OPTS='-o'
    declare -xg MAS_EDITOR_CMD=${MAS_VI_CMD:-$MAS_EDITOR_CMD}
    declare -xg MAS_EDITOR_OPTS_NOFORK="$MAS_EDITOR_OPTS"
#   mas_loadlib_if_not mas_set_under under
    mas_get_lib_ifnot under mas_set_under
    mas_set_under
    if [[ "$MAS_UNDER" == tty* ]] ; then
      declare -xg MAS_EDITOR_CMD=${MAS_VI_CMD:-$MAS_EDITOR_CMD}
      declare -xg MAS_EDITOR_OPTS_NOFORK="$MAS_EDITOR_OPTS"
#     infomas "MAS_UNDER=$MAS_UNDER; MAS_EDITOR_TYPE=$MAS_EDITOR_TYPE; MAS_EDITOR_CMD=$MAS_EDITOR_CMD"
    elif [[ "$MAS_UNDER" == X* ]] ; then
      declare -xg MAS_EDITOR_CMD=${MAS_GVIM_CMD:-$MAS_EDITOR_CMD}
      declare -xg MAS_EDITOR_OPTS_NOFORK="--nofork ${MAS_EDITOR_OPTS}"

      if havefun gvim_caller  ; then
	MAS_PERSONAL_EDITOR=gvim_caller
      else
        MAS_PERSONAL_EDITOR="$MAS_BIN/gvim-e.sh -o"
      fi
#     infomas "MAS_UNDER=$MAS_UNDER; MAS_EDITOR_TYPE=$MAS_EDITOR_TYPE; MAS_EDITOR_CMD=$MAS_EDITOR_CMD; MAS_PERSONAL_EDITOR=$MAS_PERSONAL_EDITOR"

    fi
    MAS_PERSONAL_EDITOR=${MAS_PERSONAL_EDITOR:-"$MAS_EDITOR_CMD $MAS_EDITOR_OPTS"}
  fi
  declare -xg MAS_SAWFISH_CLIENT_CMD=${MAS_SAWFISH_CLIENT_CMD:=/usr/bin/sawfish-client}
}
export -f define_std_binnames
mas_sourcing_end libstdbins.bash

return 0
