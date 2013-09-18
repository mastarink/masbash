#mas_loadlib_if_not mywmws wm
#mas_loadlib_if_not datemt time

#typemas datemt  && export MAS_TIME_LIBLOGGER=$(datemt)
function mas_true_logger ()
{
  if [ -z "$MAS_TIME_LOG" ] ; then MAS_TIME_LOG=0 ; fi
  local prev_log_time=$MAS_TIME_LOG
  local loffset0=2
  local log_nano log_delta
  local flabel="$(/bin/date '+%H%M%S').$$"
  local fenv='' fps='' fset=''
  export MAS_TIME_LOG=$( /bin/date +%s.%N )
  local logger_ini_ws
  export MAS_I_WS=${MAS_I_WS:-${MAS_DESKTOP_NAME}}
  logger_ini_ws=$MAS_I_WS
  [[ "$logger_ini_ws" ]] || logger_ini_ws='NONE'
# if true ; then
  #         for f in {1..4} ; do
  #           c="`caller $f`"
  #           if [ -n "$c" ] ; then
  #             echo -n "{$c}"
  #           else
  #             echo -n "-"
  #             break
  #           fi
  #         done

  # logger -i -t term-new "[$$ UID:$UID] @ ${BASH_SOURCE[1]}:${BASH_LINENO[0]} @ ${BASH_SOURCE[2]}:${BASH_LINENO[1]} $@"
    local loffset lloffset floffset
    if [[ -v logger_offset && -n "$logger_offset" ]] ; then
       loffset=$logger_offset
    else
       loffset=$loffset0
    fi
    lloffset=$(( $loffset - 1 ))
   # floffset=$(( $loffset - 5 ))
    floffset=$loffset
#   while ! [[ "${FUNCNAME[ $floffset ]}" == 'mas_logger' ]] ; do
#     floffset=$(( $floffset + 1 ))
#     if [[ $floffset > 10 ]] ; then break ; fi
#   done
#   if [[ "${FUNCNAME[ $floffset ]}" == 'mas_logger' ]] ; then floffset=$(( $floffset + 1 )) ; fi
#   if [[ "${FUNCNAME[ $floffset ]}" == 'mas_script' ]] ; then floffset=$(( $floffset + 1 )) ; fi

    export MAS_LOGGER_SERIAL
    local src="${BASH_SOURCE[$loffset]}"
    local string="[$$:$UID] ${BASH_LINENO[$lloffset]}:$src $@"
    local interactive='I?'
    
    if [ -z "$MAS_LOGGER_SERIAL" ] ; then
      MAS_LOGGER_SERIAL=0
      local ldir="/tmp/logger"
      ldir=''
      if [[ "$ldir" ]] ; then
        if [ -n "$UID" ] ; then
	  if ! [ -d "$ldir" ] ; then /bin/mkdir -p "$ldir" ; fi
	  chmod a+rwX "$ldir"
	  local tdir="$ldir/$UID/`/bin/date '+%Y%m%d'`"
	  if [ -n "$tdir" ] ; then
	    if ! [ -d "$tdir" ] ; then /bin/mkdir -p "$tdir" ; fi
	   #echo "tdir=$tdir" >&2
	   #ls -l "$tdir" >&2
	    fenv="$tdir/${flabel}.${MAS_LOGGER_SERIAL}.env.tmp"
	    fps="$tdir/${flabel}.${MAS_LOGGER_SERIAL}.ps.tmp"
	    fset="$tdir/${flabel}.${MAS_LOGGER_SERIAL}.set.tmp"
	    ${MAS_ENV_CMD:=/bin/env} > "$fenv"
	    set > "$fset"
	    if [[ -n "$USER" && -n "$HOME" && -d "$HOME" && -d $HOME/bin && -x $HOME/bin/ps.sh ]] ; then
	      $HOME/bin/ps.sh >> "$fps"
	    else
	      PS_FORMAT='lstart,tty,ni,user,pid,%cpu,%mem,rss,vsz,sz,thcount,cmd' ps wwwaux >> "$fps"
	    fi
	  fi
	fi
      fi
    else
      MAS_LOGGER_SERIAL=$(( $MAS_LOGGER_SERIAL + 1 ))
    fi
    
    if false ; then
      local THOME
      THOME=$HOME
      if [ -n "$MAS_CONF_DIR" ] ; then
	local rex1="^(.*)${MAS_CONF_DIR}(.*)$"
	
	while [[ "$string" =~ $rex1 ]] ; do
	  string="${BASH_REMATCH[1]}<C>${BASH_REMATCH[2]}"
	done
      fi
      if [ -n "$THOME" ] ; then
	local rex2="^(.*)${THOME}(.*)$"
	
	while [[ "$string" =~ $rex2 ]] ; do
	  string="${BASH_REMATCH[1]}<H>${BASH_REMATCH[2]}"
	done
      fi
    fi
    if [[ $- = *i* ]] ; then
      interactive='I-'
    else
      interactive='I+'
    fi
    if typemas mas_interactive ; then
      if mas_interactive ; then interactive='I+' ; else interactive='I-' ; fi
    fi
    if [ -n "$fenv" ] ; then
      string="[$fenv] $string"
    fi
    #logger -i -t term-new "$interactive `tty` ${logger_ini_ws}:$( $MAS_WS_CMD 2>/dev/null): $string"
    log_nano=$( /bin/date +.%N )
    log_delta=999999
    if [[ "$prev_log_time" > 0 ]] ; then
#     log_delta=$( wcalc -P4 "$MAS_TIME_LOG - $prev_log_time" )
#     log_delta=$( /usr/bin/wcalc -P4 "$MAS_TIME_LOG - $prev_log_time" )
#     log_delta=$( echo "$MAS_TIME_LOG - $prev_log_time" | bc -q )
      log_delta=$( /usr/bin/dc --expression="${MAS_TIME_LOG} ${prev_log_time} -p" )
    fi
#   logger -i -t term-new "+${log_delta}:${MAS_TIME_LOG} $interactive `tty` :${logger_ini_ws}:$($MAS_WS_CMD 2>/dev/null): $0:${FUNCNAME[ $(( $floffset )) ]}  $string"
    /usr/bin/logger -i -t term-new "WS_${logger_ini_ws}: #${MAS_LOGGER_SERIAL}+${log_delta}:${log_nano} $interactive:$0:${FUNCNAME[ $floffset ]}:u${floffset} : $string"
#   echo "#${MAS_LOGGER_SERIAL}+${log_delta}:${log_nano} $interactive:${logger_ini_ws}:$0:${FUNCNAME[ $floffset ]}:u${floffset} : $string" >&2
   return 0
}

function mas_logger ()
{
  if ! [[ -v MAS_NO_LOGGER && "$MAS_NO_LOGGER" ]] ; then
    mas_true_logger $@
  fi
  return 0
}

function mas_script ()
{
  local logger_offset
  local here_offset=1
  if [[ "$1" -gt 0 ]] ; then
    here_offset=$1
    shift
  fi
  logger_offset=$(( $here_offset + 2 ))
# echo "                                        ${BASH_SOURCE[$here_offset]}" >&2
  mas_logger SCRIPT
  return 0
}

export -f mas_true_logger mas_logger mas_script

return 0

# vi: ft=sh
