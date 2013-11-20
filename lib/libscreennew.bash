  mas_sourcing_start libscreen.bash
  mas_get_lib_ifnot terminal_emulator terminal_emulator_euristic_show
  mas_get_lib_ifnot time datemt

  havefun datemt && export MAS_TIME_LIBSCREEN=$(datemt)
# screen -A -r  --- attaches if single  detached
# screen -A -R  --- attaches if single detached
# screen -A -RR --- attaches first detached or creates if no detached
# screen -A -d  --- detaches if single attached
# screen -A -D  --- detaches if single attached

# screen -A -r <session>  --- attaches if single matched detached
# screen -A -R <session>  --- attaches if single matched detached or creates if no detached even if attached match exists
# screen -A -RR <session> --- attaches first matched detached creates if no detached even if attached exists
# screen -A -d <session>  --- detaches if single matched attached
# screen -A -D <session>  --- detaches if single matched attached
# screen -A -D -R <session>  --- detaches if single matched attached and anyway attaches or creates if no matched
# screen -A -D -RR <session>  --- detaches first matched attached and anyway attaches or creates even if attached match exists

# ???? screen -A -r <session> || screen -D -R <session>
# 
# xxx="S`screen -r <session> | wc -l`"
# xxx=0 -- ok attached single session
# xxx=1 -- no matching screen to attach
#     There is no screen to be resumed matching xxxxxxxxxx.
# xxx=3 -- single (attached) session, can't attach
#     There is a screen on:
#             nnnnn.xxxxxxxxxx	(Attached)
#     There is no screen to be resumed matching xxxxxxxxxx.
# xxx>3 -- more than 1 matched sessions, none or more than 1 detached
#     There are screens on:
#             nnnnn.xxxxxxxxxx	(Attached)
#             mmmm.xxxxxxxxxx	(Attached)
#     There is no screen to be resumed matching xxxxxxxxxx.

function launch_screen_shell_scan ()
{
  local dt dtx session try4 try5
  if [[ "${MAS_GTERMO_TABSS}" ]] ; then
    for dt in $MAS_GTERMO_TABSS ; do
      echo "$LINENO: dt: $dt" >&2
      dbgmasp 3 "$LINENO:$FUNCNAME dt: $dt"
      if [[ "$MAS_GTERMO_PROJECTS_DIR" ]] && [[ -d "$MAS_GTERMO_PROJECTS_DIR/$dt" ]] ; then
	dtx="$MAS_GTERMO_PROJECTS_DIR/$dt"
	echo "$LINENO: dtx: $dtx" >&2
	dbgmasp 3 "$LINENO:$FUNCNAME dtx: $dtx"
	MAS_SCREEN_WORKDIR=`realpath $dtx`
	if [[ "$MAS_SCREEN_WORKDIR" ]] ; then
	  session="S`echo -n $MAS_SCREEN_WORKDIR | md5sum | awk '{print $1}'`"
	  try4=`${MAS_SCREEN_CMD:=/usr/bin/screen} -A -r $session | wc -l`
	  echo "$LINENO: session: $session" >&2
	  echo "$LINENO: try4: '$try4'" >&2
	  if [[ $try4 -eq 1 ]] ; then
	    try5=`${MAS_SCREEN_CMD:=/usr/bin/screen} -A -R $session | wc -l`
	    if [[ $try5 -eq 0 ]] ; then
	      return 0
	    fi
	    ${MAS_SCREEN_CMD:=/usr/bin/screen} -ls >&2
	    echo "$LINENO: try5: '$try5' session: $session" >&2
	  elif [[ $try4 -eq 0 ]] ; then
	    return 0
	  else
	    echo "$LINENO: try4: '$try4' != 1" >&2
	  fi
	fi
      fi
    done
    return 0
  else
    echo "$LINENO: ..." >&2
    return 1
  fi
  return 1
}
function launch_screen_shell_q ()
{
  declare -gx MAS_SCREEN_WORKDIR
  local lmode session try1=1
  lmode=${1:-$MAS_SCREEN_LMODE}
  shift
  dbgmasp 3 "$LINENO:$FUNCNAME"
  declare -gx \
      SCREENRC="${SCREENRC:=${MAS_CONF_DIR_SCREENS:=${MAS_CONF_DIR_TERM:=${MAS_CONF_DIR:=${MAS_DIR:=$HOME/.mas}/config}/term_new}/masscreen}/rc0}" 
  declare -gx SCREENDIR=$MAS_SCREENDIR
  declare -gx MAS_XSHELL_CMD MAS_SGSHELL_CMD
  
  MAS_SCREEN_WORKDIR=`realpath $PWD`
  if [[ "$MAS_SCREEN_WORKDIR" ]] ; then
    session="S`echo -n $MAS_SCREEN_WORKDIR | md5sum | awk '{print $1}'`"
    echo "$LINENO: session: $session" >&2
    try1=`${MAS_SCREEN_CMD:=/usr/bin/screen} -A -r $session | wc -l`
    if [[ $try1 -eq 0 ]] ; then
      return 0
    fi
  fi
  echo "$LINENO: try1: $try1" >&2
  if [[ $try1 -eq 1 ]] ; then
    # no such Detached session
    if ${MAS_SCREEN_CMD:=/usr/bin/screen} -A -r >/dev/null ; then
      echo $LINENO >&2
      return 0
    else
      echo "$LINENO: MAS_GTERMO_TABSS: ${MAS_GTERMO_TABSS}" >&2
      # no any Detached session
      launch_screen_shell_scan && return 0
    fi
  elif [[ $try1 -eq 3 ]] && [[ "$session" ]] ; then
    launch_screen_shell_scan && return 0
  fi
  return 1
}
function launch_screen_shell_new ()
{
  local ii
  for (( ii=0 ; ii < 100 ; ii++ )) ; do
    if launch_screen_shell_q $@ ; then
      echo "$LINENO: ..." >&2
#     sleep 10
      return 0
    else
      echo "$LINENO: ..." >&2
#     sleep 10
      return 1
    fi
  done
}
export -f launch_screen_shell_new

# vi: ft=sh
