# if [[ "$HOME" ]] && [[ -f ${MAS_ETC_BASH:=/etc/mastar/shell/bash}/.topparamfuncs ]] ; then
#   . ${MAS_ETC_BASH:=/etc/mastar/shell/bash}/.topparamfuncs
  
  mas_sourcing_start libscreen.bash
# mas_loadlib_if_not mywmws wm
# mas_get_lib_ifnot wm mywmws
# mas_loadlib_if_not terminal_emulator_euristic_show terminal_emulator
  mas_get_lib_ifnot terminal_emulator terminal_emulator_euristic_show
# mas_loadlib_if_not datemt time
  mas_get_lib_ifnot time datemt

  havefun datemt && export MAS_TIME_LIBSCREEN=$(datemt)

  declare -xg MAS_SCREEN_MODE MAS_SCREEN_MODE_PREV
  # -- export SCREENRC="${MAS_CONF_DIR_TERM:=${MAS_CONF_DIR:=${MAS_DIR:=$HOME/.mas}/config}/term_new}/screen/rc0" 
  #export SCREENRC="${MAS_CONF_DIR_SCREENS:=${MAS_CONF_DIR_TERM:=${MAS_CONF_DIR:=${MAS_DIR:=$HOME/.mas}/config}/term_new}/masscreen}/rc0" 
  #export SCREENDIR=${SCREENDIR:=${MAS_SCREEN_VAR_DIR:=${MAS_VAR_DIR:=${MAS_DIR:=$HOME/.mas}/var}/screen}}

  export MAS_SCREEN_SESSION_REGEX='s@^[[:space:]]\+[[:digit:]]\+\.\([[:alnum:]_.-]\+\)[[:space:]]\+(\(Detached\|Attached\))@\1@p'
  function screen_make_suffix ()
  {
    local suffix=$1
    shift
    if [[ "$suffix" ]] ; then
      case "$suffix" in
	pwd)
	  suffix=".at-$( basename `pwd` )"
	  ;;
	*)
	  suffix=".$suffix"
	  ;;
      esac
    fi
    echo -n "$suffix"
  }
  # 1. rex 2. ws 3. term 4. limit 5. suffix ....
  function screen_list_as ()
  {
    export MAS_SCREEN_WS MAS_SCREEN_TERMINAL_EMULATOR
    local rex=${1:-'Detached\|Attached'}
    shift
    local ws=${1:-${MAS_SCREEN_WS:=${MAS_DESKTOP_NAME}}}
    shift
    local term=${1:-${MAS_SCREEN_TERMINAL_EMULATOR:=$( terminal_emulator_euristic_show )}}
    shift
    local limit=${1:-99999}
    shift
    local suffix=$1
    shift
  # echo ">>>>>>>>[`terminal_emulator_euristic_show`]  ${term}\.${ws}\.[[:digit:]]\+.*(\<\($rex\)\>) --- $term.$ws - $limit" >&2
    echo "SCREENDIR: $SCREENDIR" >&2
    echo "SCREENDIR: $SCREENDIR" >&2
    {
      ${MAS_SCREEN_CMD:=/usr/bin/screen} -list "${term}.${ws}$( screen_make_suffix $suffix)" \
        | grep "${term}\.${ws}\.[[:digit:]]\+_.*(\<\($rex\)\>)" \
        | head -${limit} 
    } || sleep 20
  }
  function screen_list_as_test ()
  {
    local qpid term ws id state IFS='.'
    screen_list_as "$@" \
     | while read  qpid term ws id ; do
	 if [[ $id =~ ^[[:space:]]*([[:digit:]]+)[[:space:]]+\(([[:alpha:]]+)\) ]] ; then
	   id=${BASH_REMATCH[1]}
	   state=${BASH_REMATCH[2]}
	   echo "qpid:$qpid term:$term ws:$ws id:'$id' state:'$state'" >&2
	 fi
       done
  }

  # 1. limit 2. suffix ....
  function screen_list_ws ()
  {
    local limit=${1:-99999}
    shift
    local suffix=$1
    shift
    screen_list_as '' '' '' "$limit" $suffix
  }
  # 1. limit 2. suffix ....
  function screen_list_attached ()
  {
    local limit=${1:-99999}
    shift
    local suffix=$1
    shift
    screen_list_as 'Attached' '' '' "$limit" $suffix
  }

  # 1. limit 2. suffix ....
  function screen_list_detached ()
  {
    local limit=${1:-99999}
    shift
    local suffix=$1
    shift
    screen_list_as 'Detached' '' '' "$limit" $suffix
  }

  # 1. limit 2. suffix ....
  function screen_find_detached ()
  {
    local limit=${1:-1}
    shift
    local suffix=$1
    shift
    screen_list_detached "$limit" $suffix | ${MAS_SED_CMD:=/bin/sed} -n -e $MAS_SCREEN_SESSION_REGEX
  }
  # 1. limit 2. suffix ....
  function screen_find_attached ()
  {
    local limit=${1:-1}
    shift
    local suffix=$1
    shift
    screen_list_attached "$limit" $suffix | ${MAS_SED_CMD:=/bin/sed} -n -e $MAS_SCREEN_SESSION_REGEX
  }
  # 1. limit 2. suffix ....
  function screen_find ()
  {
    local limit=${1:-1}
    shift
    local suffix=$1
    shift
    screen_list_ws "$limit" $suffix | ${MAS_SED_CMD:=/bin/sed} -n -e $MAS_SCREEN_SESSION_REGEX
  }

  # 1. ws 2. term 3. suffix ....
  function screen_try_new ()
  {
    local ws term id rest
    local defws=${1:-${MAS_SCREEN_WS:=${MAS_DESKTOP_NAME}}}
    shift
    local defterm=${1:-${MAS_SCREEN_TERMINAL_EMULATOR:=$( terminal_emulator_euristic_show )}}
    shift
    local suffix=$1
    shift


    local pos=0 IFS='.' freeidmin=0 freeid=0
    if [[ "${suffix}" ]] ; then
  #   echo "Test: ${defterm}.${defws}$( screen_make_suffix $suffix)" >&2
      echo "${defterm}.${defws}$( screen_make_suffix $suffix)"
    else
      while read term ws id rest ; do
        if [[ "$id" =~ ^([[:digit:]]+)_$ ]] ; then
	  id=${BASH_REMATCH[1]}
	fi
    #   echo "Test:$pos -term:$term ($defterm) -ws:$ws ($defws) -id:$id -rest:$rest" >&2
	if [[ "$id" -eq "$freeidmin" ]] && [[ "$ws" == "$defws" ]] && [[ "$term" == "$defterm" ]] ; then
	  freeidmin=$(( $freeidmin + 1 ))
    #   else
    #     echo "Why:$pos -term:$term ($defterm) -ws:$ws ($defws) -id:$id ($freeidmin) -rest:$rest" >&2
	fi
	pos=$(( $pos + 1 ))
      done
    # echo "Test:$pos -freeidmin:$freeidmin" >&2
      while freeid=$RANDOM && [[ "$freeid" -lt $freeidmin ]] ; do
        :
      done
      echo "${defterm}.${defws}.${freeid}_"
    fi
  }
  # 1. suffix ....
  function screen_propose_new ()
  {
    screen_find 99999 $@ | sort | screen_try_new '' '' $@
  }

  # 1. suffix ....
  function screen_find_or_propose ()
  {
    local sess sess1 sess2 sess3 w1 w2 w
    while true ; do
      sess1=$( screen_find_detached '' $@ )
      if ! [[ "$sess1" ]] ; then
        break
      fi
      w="0.$RANDOM"
      w1=10
      if [[ "$RANDOM" =~ ^(.)(.*)$ ]] ; then w1=${BASH_REMATCH[1]} w2=${BASH_REMATCH[2]} w="${w1}.${w2}" ; fi
      if [[ "$RANDOM" -lt 20000 ]] ; then w1=0 ; else w1=1 ; fi
      w="${w1}.${w2}"     
      echo "Wait $w" >&2
      sleep "$w"
      sess2=$( screen_find_detached '' $@ )
      if [[ "$sess1" == "$sess2" ]] ; then
        sess=$sess1
	break
      fi
    done
    if [[ "$sess" ]] ; then
      echo -n "$sess"
    else
      screen_propose_new $@
    fi
  }
  # 1. suffix ....
  function screen_find_or_propose_here ()
  {
    local sess=$( screen_find_or_propose $@ )
    echo -n "$sess"
  }
  function launch_screen_shell_try1 ()
  {
    MAS_SCREEN_WORKDIR=`realpath $PWD`
    local dt dtx dt5 session="S`echo -n $MAS_SCREEN_WORKDIR | md5sum | awk '{print $1}'`"
    dbgmasp 3 "$LINENO:$FUNCNAME MAS_SCREEN_WORKDIR: $MAS_SCREEN_WORKDIR"
    dbgmasp 3 "$LINENO:$FUNCNAME lmode: $lmode"
    if ${MAS_SCREEN_CMD:=/usr/bin/screen} -ls "$session"  | grep '(Attached)'  2>/dev/null 
    then
      if ${MAS_SCREEN_CMD:=/usr/bin/screen} -ls | grep '(Detached)'  2>/dev/null ; then
	launch_screen_shell_try2
	return $?
      else
        for dt in $MAS_GTERMO_TABSS ; do
	  dbgmasp 3 "$LINENO:$FUNCNAME dt: $dt"
	  if [[ "$MAS_GTERMO_PROJECTS_DIR" ]] && [[ -d "$MAS_GTERMO_PROJECTS_DIR/$dt" ]] ; then
            dtx="$MAS_GTERMO_PROJECTS_DIR/$dt"
	    dbgmasp 3 "$LINENO:$FUNCNAME dtx: $dtx"
	    MAS_SCREEN_WORKDIR=`realpath $dtx`
	    dt5="S`echo -n $MAS_SCREEN_WORKDIR | md5sum | awk '{print $1}'`"
	    dbgmasp 3 "$LINENO:-$FUNCNAME -- QQ SESSION [$dt:$dt5]"
#	    if ! ${MAS_SCREEN_CMD:=/usr/bin/screen} -ls | grep "$dt5" ; then
	    if ! ${MAS_SCREEN_CMD:=/usr/bin/screen} -ls "$dt5" ; then
	      dbgmasp 3 "$LINENO:-$FUNCNAME -- SESSION [$dt:$dt5]"
	      launch_screen_shell_try2 "$dt5" direct
	      return $?
	    else
	      dbgmasp 3 "$LINENO:-$FUNCNAME -- NO SESSION [$dt:$dt5]"
	    fi
          fi
        done
        return 0
      fi
    fi
    declare -gx MAS_XSHELL_CMD="${MAS_SCREEN_CMD:=/usr/bin/screen}"
    MAS_XSHELL_CMD="$MAS_XSHELL_CMD -D -RR -S $session"
    declare -gx MAS_SGSHELL_CMD="${MAS_SG_CMD:=/usr/bin/sg} mastar-screen '$MAS_XSHELL_CMD'"
    if [[ "$MAS_DEBUG" -gt 0 ]] ; then
      dbgmasp 3 "$LINENO:-$FUNCNAME MAS_SCREEN_VAR_WS_DIR: $MAS_SCREEN_VAR_WS_DIR"
      dbgmasp 3 "$LINENO:-$FUNCNAME MAS_SCREEN_VAR_WST_DIR: $MAS_SCREEN_VAR_WST_DIR"
      dbgmasp 3 "$LINENO:-$FUNCNAME MAS_SCREENDIR: $MAS_SCREENDIR"
      dbgmasp 3 "$LINENO:-$FUNCNAME SCREENDIR: $SCREENDIR"
      dbgmasp 3 "$LINENO:-$FUNCNAME MAS_SGSHELL_CMD: $MAS_SGSHELL_CMD"
      dbgmasp 3 "$LINENO:-$FUNCNAME lmode: $lmode"
    fi
    infomas "libscreen Go ($lmode) screen $MAS_SGSHELL_CMD"
    infomas "sgs: $MAS_SGSHELL_CMD"
    
    mas_dynsleep "${MAS_SCREEN_DELAY_START}" "${MAS_SCREEN_DELAY_START} seconds to screen (try1) [$lmode] : $MAS_SGSHELL_CMD"
    case "$lmode" in
      bash)
	${MAS_BASH_CMD:=/bin/bash} --norc --noprofile -c $MAS_SGSHELL_CMD && return 0
      ;;
      call)
	eval $MAS_SGSHELL_CMD && return 0
      ;;
      simple)
	eval $MAS_SGSHELL_CMD && return 0
      ;;
      exec)
	eval exec "$MAS_SGSHELL_CMD" && return 0
      ;;
      *)
	eval exec "$MAS_SGSHELL_CMD" && return 0
      ;;
    esac  
    return 1
  }
  function launch_screen_shell_try2 ()
  {
    local session session2 direct
    dbgmasp 3 "$LINENO:$FUNCNAME"
    dbgmasp 3 "$LINENO:$FUNCNAME lmode: $lmode"
    session=${1:-`${MAS_SCREEN_CMD:=/usr/bin/screen} -ls | grep '(Detached)' | head -1 | awk '{print $1}'`}
    shift
    direct=$1
    shift
    if ! [[ "$direct" ]] && [[ "$session" ]] ; then
      w="0.$RANDOM"
      w1=10
      if [[ "$RANDOM" =~ ^(.)(.*)$ ]] ; then w1=${BASH_REMATCH[1]} w2=${BASH_REMATCH[2]} w="${w1}.${w2}" ; fi
      if [[ "$RANDOM" -lt 20000 ]] ; then w1=0 ; else w1=1 ; fi
      w="${w1}.${w2}"     
      echo "Wait $w" >&2
      sleep "$w"
    
      session2=`${MAS_SCREEN_CMD:=/usr/bin/screen} -ls | grep '(Detached)' | head -1 | awk '{print $1}'`
      if ! [[ "$session" == "$session2" ]] ; then
	return 1
      fi
    fi
    declare -gx MAS_XSHELL_CMD="${MAS_SCREEN_CMD:=/usr/bin/screen}"
    if [[ "$direct" ]] ; then
      MAS_XSHELL_CMD="$MAS_XSHELL_CMD -D -RR $session"
    elif [[ "$session" ]] ; then
      MAS_XSHELL_CMD="$MAS_XSHELL_CMD -r $session"
    else
      MAS_XSHELL_CMD="$MAS_XSHELL_CMD -R"
    fi
    declare -gx MAS_SGSHELL_CMD="${MAS_SG_CMD:=/usr/bin/sg} mastar-screen '$MAS_XSHELL_CMD'"
    
    dbgmasp 0 "$LINENO:-$FUNCNAME MAS_SCREEN_VAR_WS_DIR: $MAS_SCREEN_VAR_WS_DIR"
    dbgmasp 0 "$LINENO:-$FUNCNAME MAS_SCREEN_VAR_WST_DIR: $MAS_SCREEN_VAR_WST_DIR"
    dbgmasp 0 "$LINENO:-$FUNCNAME MAS_SCREENDIR: $MAS_SCREENDIR"
    dbgmasp 0 "$LINENO:-$FUNCNAME SCREENDIR: $SCREENDIR"
    dbgmasp 0 "$LINENO:-$FUNCNAME MAS_SGSHELL_CMD: $MAS_SGSHELL_CMD"
    dbgmasp 0 "$LINENO:-$FUNCNAME lmode: $lmode"

    infomas "libscreen Go ($lmode) screen $MAS_SGSHELL_CMD"
    infomas "sgs: $MAS_SGSHELL_CMD"
    
#   MAS_SCREEN_DELAY_START=2

    mas_dynsleep "${MAS_SCREEN_DELAY_START2}" "${MAS_SCREEN_DELAY_START2} seconds to screen (try2) [$lmode]"
    case "$lmode" in
      bash)
	${MAS_BASH_CMD:=/bin/bash} --norc --noprofile -c $MAS_SGSHELL_CMD && return 0
      ;;
      call)
	eval $MAS_SGSHELL_CMD && return 0
      ;;
      simple)
	eval $MAS_SGSHELL_CMD && return 0
      ;;
      exec)
	eval exec "$MAS_SGSHELL_CMD" && return 0
      ;;
      *)
#       eval "$MAS_SGSHELL_CMD || $MAS_SGSHELL_CMD2"
	eval "$MAS_SGSHELL_CMD" && return 0
      ;;
    esac  
    return 1
  }
  function launch_screen_shell ()
  {
    local wd ns  session
    local lmode
    lmode=${1:-$MAS_SCREEN_LMODE}
    shift
    dbgmasp 3 "$LINENO:$FUNCNAME"

    declare -gx MAS_SCREEN_WORKDIR
    MAS_SCREEN_WORKDIR=$MAS_BASHRC_PWD0

    wd=`realpath $PWD`
    if [[ "$wd" ]] && [[ -d "$wd" ]] ; then
      mas_cd "$wd"
    fi
    declare -gx MAS_SCREEN_PWD0="$PWD"
    
    if [[ "$MAS_SCREEN_PWD0" ]] && [[ -d "$MAS_SCREEN_PWD0" ]] ; then
      mas_cd $MAS_SCREEN_PWD0
    fi

    declare -gx MAS_PRE_PWD=`pwd`
    declare -gx \
    	SCREENRC="${SCREENRC:=${MAS_CONF_DIR_SCREENS:=${MAS_CONF_DIR_TERM:=${MAS_CONF_DIR:=${MAS_DIR:=$HOME/.mas}/config}/term_new}/masscreen}/rc0}" 
    declare -gx SCREENDIR=$MAS_SCREENDIR
#     declare -gx MAS_XSHELL_CMD="${MAS_SCREEN_CMD:=/usr/bin/screen} -t $sesname -D -RR $sesname"
    
    if [[ "$MAS_SCREEN_SESMODE" -eq "1" ]] ; then
      for (( ii=0 ; $ii < 100 ; ii++ )) ; do
	launch_screen_shell_try1 && break
	mas_dynsleep "1" "wait"
      done
    else
      for (( ii=0 ; $ii < 100 ; ii++ )) ; do
	launch_screen_shell_try2 && break
	mas_dynsleep "1" "wait"
      done
    fi

    ${MAS_SCREEN_CMD:=/usr/bin/screen} -list
    dbgmasp 3 "$LINENO:$FUNCNAME after screen"

    case "$lmode" in
      bash)
	mas_dynsleep 1 "($lmode) seconds to bash"
	/bin/bash
      ;;
      call)
	mas_dynsleep 1 "($lmode) seconds to bash"
	/bin/bash
      ;;
      simple)
      ;;
      exec)
      ;;
      *)
      ;;
    esac
    mas_dynsleep "${MAS_SCREEN_DELAY_EXIT}" "${MAS_SCREEN_DELAY_EXIT} seconds to Exit; ^C to use nonscreen term"

#   echo "${losleep} seconds to Exit" >&2
#   echo "^C to use nonscreen term" >&2
#   for (( ii=0; ii<30 ; ii++)) ; do
#     echo -n '.' >&2
#     [[ "$MAS_USLEEP" ]] && [[ -x "$MAS_USLEEP" ]] && $MAS_USLEEP $losleep
#   done
    dbgmasp 3 "$LINENO:-$FUNCNAME exit?:$MAS_SCREEN_NOEXIT"
    unset MAS_NO_DYNSLEEP
    if ! [[ "$MAS_SCREEN_NOEXIT" ]] ; then
      dbgmasp 3 "$LINENO:-$FUNCNAME exit!"
      mas_exit_wait 0 10
    fi
    dbgmasp 3 "$LINENO:/$FUNCNAME"
  }
  function launch_screen_shell_old ()
  {
    local sesname ns
    local lmode
    lmode=$1
    shift
#   sesname=$( screen_find_or_propose_here pwd )
    sesname=$( screen_find_or_propose_here )
    infomas "launch_screen_shell 1"
    if [[ "$sesname" ]] ; then
      export SCREENRC="${SCREENRC:=${MAS_CONF_DIR_SCREENS:=${MAS_CONF_DIR_TERM:=${MAS_CONF_DIR:=${MAS_DIR:=$HOME/.mas}/config}/term_new}/masscreen}/rc0}" 
      export SCREENDIR=$MAS_SCREEN_WST_DIR
      
      dbgmasp 0 "$LINENO:-$FUNCNAME MAS_SCREEN_VAR_WS_DIR: $MAS_SCREEN_VAR_WS_DIR"
      dbgmasp 0 "$LINENO:-$FUNCNAME MAS_SCREEN_VAR_WST_DIR: $MAS_SCREEN_VAR_WST_DIR"
      dbgmasp 0 "$LINENO:-$FUNCNAME MAS_SCREENDIR: $MAS_SCREENDIR"
      dbgmasp 0 "$LINENO:-$FUNCNAME SCREENDIR: $SCREENDIR"

      export MAS_XSHELL_CMD="${MAS_SCREEN_CMD:=/usr/bin/screen} -t $sesname -D -RR $sesname"
      export MAS_SGSHELL_CMD="${MAS_SG_CMD:=/usr/bin/sg} mastar-screen '$MAS_XSHELL_CMD'"
      infomas "libscreen Go ($lmode) screen $MAS_SGSHELL_CMD"
      infomas "sgs: $MAS_SGSHELL_CMD"
      case "$lmode" in
	bash)
	  ${MAS_BASH_CMD:=/bin/bash} --norc --noprofile -c $MAS_SGSHELL_CMD
	;;
	call)
	  eval $MAS_SGSHELL_CMD
	;;
	exec)
	  eval exec $MAS_SGSHELL_CMD
	;;
	*)
	  eval exec $MAS_SGSHELL_CMD
	;;
      esac
      
      ${MAS_SCREEN_CMD:=/usr/bin/screen} -list
      echo "--------------to start bash--------" >&2
      /bin/bash
#     echo "--------------to sleep 3--------" >&2
      mas_dynsleep "3" "--------- to sleep 3"
#     ${MAS_SLEEP_CMD:=/bin/sleep} 3
    fi  
  }
  export -f screen_find_detached screen_list_as screen_list_ws screen_list_attached screen_list_detached screen_propose_new
  export -f screen_find_or_propose screen_find_or_propose_here launch_screen_shell

  mas_sourcing_end libscreen.bash
# fi

# vi: ft=sh
