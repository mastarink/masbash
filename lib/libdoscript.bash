if [[ "$HOME" ]] && [[ -f ${MAS_ETC_BASH:=/etc/mastar/shell/bash}/.topparamfuncs ]] ; then
  . ${MAS_ETC_BASH:=/etc/mastar/shell/bash}/.topparamfuncs

  function mas_src_not_found ()
  {
    local errlineno=$1
    shift
    local errmpath=$1
    shift
    dbgmasp 3 "$LINENO:$FUNCNAME"
    
    case $MAS_SCRIPTSN_ERRTYPE in
      notify)
	  mas_get_lib_ifnot notify mas_notify
	  mas_notify mas_src_scripts "Error DS ($errlineno) - file/dir not found: [$errmpath] $@ pwd:`pwd`"
      ;;
      *)
	  builtin echo "Error DS ($errlineno) - file absent: $@" >&2
      ;;
    esac
  }

  # source file subscripts
  # args
  #  - full path
  #  - cnt
  # action : read all scripts from directory "$path.d"
  function mas_src_literal_sub ()
  {
    local shs=$1
    shift
    local cnt=$1
    shift
    local shscr=$1
    shift
    dbgmasp 3 "$LINENO:$FUNCNAME"

    mas_src_literal_script - "./$shs"  "$cnt" $@
    dbgmasp 3 "$LINENO:/$FUNCNAME"
  }
  # scripts in <directory>.d/
  function mas_src_literal_subscripts ()
  {
    local shscr ddir cnt shs
    shscr=$1
    shift
    cnt=$1
    shift
    dbgmasp 3 "$LINENO:$FUNCNAME"

    ddir="${shscr}.d"
    if [[ -d "$ddir" ]] ; then
      mas_sourcing_start_r '@/' $ddir
      dbgmasp 3 "$LINENO:-$FUNCNAME source dir @RP$ddir@"
      #${MAS_ECHO_CMD:=/bin/echo} $ddir/* >&2
  ##### mas_echo_trace "-- Call from $ddir"
  #   echo "-- Call from $ddir" >&2
      pushd $ddir &>/dev/null
##    if [[ "$MAS_CONF_DIR_TERM_STAT" ]] ; then
##      echo ">>>msls (pushd) `pwd`" >> $MAS_CONF_DIR_TERM_STAT/sourcing.$UID.$$.stat
##      echo ">>>msls (pushd) pushd $ddir" >> $MAS_CONF_DIR_TERM_STAT/sourcing.$UID.$$.stat
##      cat $prog >> $MAS_CONF_DIR_TERM_STAT/sourcing.$UID.$$.stat
##    fi
      dbgmasp 3 "$LINENO:-$FUNCNAME"
      for shs in * ; do
        dbgmasp 3 "$LINENO:-$FUNCNAME"
	if [[ -f "$shs" ]] ; then
          dbgmasp 3 "$LINENO:-$FUNCNAME"
	  mas_src_literal_sub "$shs" $cnt "${shscr}" $@
	  dbgmasp 3 "$LINENO:-$FUNCNAME"
	fi
  #   find "$ddir" -maxdepth 1 -type f >&2
  #   find "$ddir" -maxdepth 1 -type f -exec mas_src_literal_sub \{} $cnt >&2 \;
      done
##    if [[ "$MAS_CONF_DIR_TERM_STAT" ]] ; then
##      echo ">>>msls (popd) `pwd`" >> $MAS_CONF_DIR_TERM_STAT/sourcing.$UID.$$.stat
##    fi
      popd &>/dev/null
##    if [[ "$MAS_CONF_DIR_TERM_STAT" ]] ; then
##      echo ">>>msls (popd) `pwd`" >> $MAS_CONF_DIR_TERM_STAT/sourcing.$UID.$$.stat
##    fi
      mas_sourcing_end_r '@/' $ddir
  # else
    else
      dbgmasp 3 "$LINENO:-$FUNCNAME :: no subdir @RP$ddir@"
    fi
    dbgmasp 3 "$LINENO:/$FUNCNAME"
    return 0
  }
  # source file
  # and subscripts
  # args:
  #  - default script (if ONE OF scripts is absent) or -
  #  - full path
  #  - cnt
  function mas_src_literal_script ()
  {
    local cnt name result
    defscript=$1
    shift
    name=$1
    shift
    cnt=$1
    shift
    dbgmasp 3 "$LINENO:$FUNCNAME"

    result=0
    

    mas_sourcing_start_r '@' $name
  ####  mas_echo_trace "   Call      $name"
    MAS_CALL_SCRIPT_SERIAL=$(( ${MAS_CALL_SCRIPT_SERIAL:=0} + 1 ))
  # echo "${MAS_CALL_SCRIPT_SERIAL:=0}   Call      $name" >&2
    if [[ "$name" ]] ; then
      if [[ -r "$name" ]] ; then
	dbgmasp 1 "$LINENO:$FUNCNAME () source @RP$name@"
	
	dbgmas 0 "source (present) @RP$name@"
        if ! source $name ; then
	  mas_src_not_found $LINENO $name
	  result=1
	elif ! [[ "$mas_src_scripts_no_subscript" ]] ; then
	  dbgmas 0 "sourced @RP$name@; do subscripts for it"
	  result=0
	  if ! mas_src_literal_subscripts "$name" "$cnt" $@ ; then
	    mas_src_not_found $LINENO "sub: ($name)"
	    result=1
	  fi
	  dbgmasp 3 "$LINENO:-$FUNCNAME"
	else
	  dbgmas 0 "sourced @RP$name@"
	fi
      elif [[ -r "$defscript" ]] ; then
	dbgmasp 0 "source (present) default @RP$defscript@"
        if ! source $defscript ; then
	  mas_src_not_found $LINENO "$name / $defscript"
	  result=1
	else
	  dbgmasp 0 "sourced default @RP$defscript@"
	fi
      elif [[ "${mas_src_scripts_optional}" ]] ; then
	dbgmas 0 "not source (optional) @RP$shs@"
        result=7
      else
	mas_src_not_found $LINENO "name: $name default: $defscript"
	result=1
      fi
    fi
  # source file subscripts ; args: full path, cnt
    mas_sourcing_end_r '@' $name
    dbgmasp 3 "$LINENO:/$FUNCNAME"
    return $result
  }
  function mas_src_get_mpath ()
  {
    local mpath_name=$1 mpath_x mpath
    dbgmasp 3 "$LINENO:$FUNCNAME"

    if [[ "$mpath_name" =~ ^(.*)\+(.*)$ ]] ; then
      mpath_name=${BASH_REMATCH[1]}
      mpath_x=${BASH_REMATCH[2]}
    fi
    if [[ "$mpath_name" ]] ; then
      mpath=${!mpath_name}
    fi
    if [[ "$mpath" ]] && [[ "$mpath_x" ]] ; then
      mpath="$mpath/$mpath_x"
    fi
    if [[ "$mpath" ]] ; then
      echo "$mpath"
    fi
    dbgmasp 3 "$LINENO:/$FUNCNAME"
  }
  # do scripts, report absent files (if mas_src_scripts_optional not set)
  # args:
  #  - mpath var name 
  #  - default script (if ONE OF scripts is absent) or -
  #  - ...... (scripts)
  # env:
  #  - $mas_src_scripts_tail==<extension>
  #  - $mas_src_scripts_name=<name>
  #  - $mas_src_scripts_optional - if set, don't report error if file absent
  function mas_src_scripts ()
  {
    local s s1 shscrx mpath_name mpath mpath_more result=127 res defscript
    mpath_name="$1"
    shift
    defscript="$1"
    shift
    if ! [[ "$MAS_SCRIPTS_WORKDIR" ]] ; then local MAS_SCRIPTS_WORKDIR=$PWD ; fi
    dbgmasp 3 "$LINENO:$FUNCNAME"

    if [[ "$defscript" ]] && ! [[ "$defscript" == '-' ]] ; then
      defscript="./$defscript"
    fi
    
  # mas_call_from define_std_directories stddirs
    mas_get_lib_call stddirs define_std_directories

#   mpath="${!mpath_name}"
    mpath=$( mas_src_get_mpath ${mpath_name} )

  # ${MAS_ECHO_CMD:=/bin/echo} "directory ($mas_src_scripts_optional): '$mpath' <== '$mpath_name'" >&2
    local cnt=0 mid

    declare -gx MAS_DOSCRIPT_MPATH=$mpath
##  if [[ "$MAS_CONF_DIR_TERM_STAT" ]] ; then
##    echo ">>>mss (pushd) `pwd`" >> $MAS_CONF_DIR_TERM_STAT/sourcing.$UID.$$.stat
##    echo ">>>mss (pushd) pushd $mpath" >> $MAS_CONF_DIR_TERM_STAT/sourcing.$UID.$$.stat
##  fi
    dbgmasp 3 "$LINENO:$FUNCNAME"
    if [[ "$mpath" ]] && pushd "$mpath" &>/dev/null ; then
      dbgmasp 3 "$LINENO:$FUNCNAME"
      for s in $@ ; do
  #     if [[ "$s" ]] ; then
  #       echo "eval ... $s" >&2
  #       s=`eval "builtin echo $s"`
  #     fi 
        dbgmasp 3 "$LINENO:$FUNCNAME"
	if [[ "$s" ]] ; then
	  cnt=$(( $cnt + 1 ))
	  shscrx="${s}${mas_src_scripts_tail}"
	  declare -gx MAS_DOSCRIPT_NAME=$s
	  mas_src_literal_script "${defscript:--}" "./$shscrx" "$cnt"
	  dbgmasp 3 "$LINENO:-$FUNCNAME"
	  result=$?
	  if [[ $result -ne 7 ]] ; then
	    dbgmasp 3 "$LINENO:$FUNCNAME"
	    break
	  fi
#         if [[ "$shscrx" ]] && [[ -f $shscrx ]] ; then
#             # do script + subscripts
#           if ! mas_src_literal_script "${defscript:--}" "./$shscrx" "$cnt" "${shscr}" ; then
#             mas_src_not_found $LINENO $mpath $shscrx
#             result=2
#           else
#             result=0
#           fi
#           break
#         elif [[ "${mas_src_scripts_optional}" ]] ; then
#           :
#         else
#           mas_src_not_found $LINENO $mpath $shscrx
#           result=2
#           break
#         fi
	fi
      done
##    echo ">>>mss (popd) `pwd`" >> $MAS_CONF_DIR_TERM_STAT/sourcing.$UID.$$.stat
      dbgmasp 3 "$LINENO:$FUNCNAME"
      popd  &>/dev/null
      dbgmasp 3 "$LINENO:$FUNCNAME"
##    echo ">>>mss (popd) `pwd`" >> $MAS_CONF_DIR_TERM_STAT/sourcing.$UID.$$.stat
    else
  #   ${MAS_ECHO_CMD:=/bin/echo} "directory error: '$mpath' <== '$mpath_name'" >&2
      [[ "${mas_src_scripts_optional}" ]] || mas_src_not_found $LINENO ${mpath:-EMPTY} "$mpath_name"
      dbgmasp 5 " --- $FUNCNAME () -- bad mpath:$mpath"
      result=2
    fi
    dbgmasp 3 "$LINENO:/$FUNCNAME"
    return $result
  }
  # do scripts, report absent files (if mas_src_scripts_optional not set)
  # args:
  #  - scriptset name 
  #  - extension ('.sh', for instance) or '-' for none
  #  - mpath var name
  #  - default script (if ONE OF scripts is absent) or -
  #  - ....... (scripts)
  function mas_src_scriptsn ()
  {
    local mas_src_scripts_tail
    local mas_src_scripts_name=$1
    shift
    local exten=$1
    shift
    dbgmasp 3 "$LINENO:$FUNCNAME"

    if [[ "$exten" ]] && ! [[ "$exten" == '-' ]] ; then
      mas_src_scripts_tail="$exten"
    fi
  # args:  mpath var name , ...... (scripts)
  # env : $mas_src_scripts_tail==<extension> ; $mas_src_scripts_name=<name>
  ####  mas_echo_trace ">To call   $mas_src_scripts_name [$exten] $@"
    mas_src_scripts $@
    dbgmasp 3 "$LINENO:/$FUNCNAME"
  }
  # do scripts, don't report absent files
  # args:
  #  - scriptset name 
  #  - extension ('.sh', for instance) or '-' for none
  #  - mpath var name
  #  - default script (if ONE OF scripts is absent) or -
  #  - ....... (scripts)
  function mas_src_scriptsn_optional ()
  {
    local mas_src_scripts_optional=yes
    dbgmasp 3 "$LINENO:$FUNCNAME"

    mas_src_scriptsn $@
    dbgmasp 3 "$LINENO:/$FUNCNAME"
  }
  # do std scripts (opt.?) default and opt. rc with opt.subscripts
  # args:
  #  - scriptset name 
  #  - mpath var names...
  function mas_src_scriptsn_opt_std ()
  {
    local mas_src_scripts_name=$1
    dbgmasp 3 "$LINENO:$FUNCNAME"

    shift
    local mpath_name
    local mas_src_scripts_no_subscript
    for mpath_name in $@ ; do
  #   ${MAS_ECHO_CMD:=/bin/echo} "[Do std] ${MAS_SCREEN_MODE_NEW}:${MAS_SCREEN_MODE} - ${mpath_name} : ${!mpath_name}" >&2
      mas_src_scripts_no_subscript=yes
      mas_src_scriptsn_optional "${mas_src_scripts_name:-unknown_mssn}" - ${mpath_name:-unknown_mpn} - default
      unset mas_src_scripts_no_subscript
      mas_src_scriptsn_optional "${mas_src_scripts_name:-unknown_mssn}" - ${mpath_name:-unknown_mpn} - rc
    done
    dbgmasp 3 "$LINENO:/$FUNCNAME"
  }
  # do scripts, report absent files (if mas_src_scripts_optional not set)
  # SAME as mas_src_scriptsn, but with timing
  # args:
  #  - scriptset name 
  #  - extension ('.sh', for instance) or '-' for none
  #  - mpath var name
  #  - default script (if ONE OF scripts is absent) or -
  #  - ....... (scripts)
  function mas_src_scriptsnt ()
  {
    local start_time end_time interval intervalp
    dbgmasp 3 "$LINENO:$FUNCNAME"

    if [[ "$MAS_RC_TIMING" ]] ; then
      start_time=$(umoment)
    fi
    mas_src_scriptsn $@
    if [[ "$MAS_RC_TIMING" ]] ; then
      end_time=$(umoment)
      if [[ "$end_time" && "$start_time" ]] ; then
	interval=$( /usr/bin/dc --expression="$end_time $start_time -p" )
	if [[ "${interval}" ]] ; then
  #	${MAS_ECHO_CMD:=/bin/echo} "$PPID:$$ :r:[${interval} sec]" >>$MAS_BASH_LOG/screen/timing.$$.txt
	  :
	fi
      fi
      if [[ "$end_time" && "$MAS_T00SP" ]] ; then
	intervalp=$( /usr/bin/dc --expression="$end_time $MAS_T00SP -p" )
	if [[ "${intervalp}" ]] ; then
  #	${MAS_ECHO_CMD:=/bin/echo} "$PPID:$$ :p:[${intervalp} sec]" >>$MAS_BASH_LOG/screen/timing.$$.txt
	  :
	fi
      fi
    fi
    dbgmasp 3 "$LINENO:/$FUNCNAME"
  }
  # do scripts, don't report absent files
  # SAME as mas_src_scriptsn_optional, but with timing
  # args:
  #  - scriptset name 
  #  - extension ('.sh', for instance) or '-' for none
  #  - mpath var name
  #  - default script (if ONE OF scripts is absent) or -
  #  - ....... (scripts)
  function mas_src_scriptsnt_optional ()
  {
    local mas_src_scripts_optional=yes
    dbgmasp 3 "$LINENO:$FUNCNAME"

    mas_src_scriptsnt $@
  }

  function mas_interactive ()
  {
    dbgmasp 3 "$LINENO:$FUNCNAME"

    [[ $- =~ 'i' ]] && return 0
    return 2
  }

fi

# vi: ft=sh
