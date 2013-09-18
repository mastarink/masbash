function mecho_cat ()
{
  local marker=$1
  shift

  echo "mecho_cat $marker" >&2

  ${MAS_CAT_CMD:=/bin/cat} $@
}
function mecho_segment ()
{
  local skip=$1 ; shift
  local num=$1 ; shift
  if [[ -z "$skip" ]] ; then skip=0 ; fi
  if [[ "$skip" -gt 0 && -n "$num" && "$num" -gt 0 ]] ; then 
    head -"$(( $skip + $num ))" $@ | tail --lines=-"$num"    
  elif [[ -n "$num" && "$num" -gt 0 ]] ; then
    head -"$num" $@
  else
    ${MAS_CAT_CMD:=/bin/cat} $@
  fi
}
function mecho_echo ()
{
  echo -e "$@"
}
function mecho_stdout ()
{
  mecho_echo "$@"
}
function mecho_stderr ()
{
  mecho_echo "$@" >&2
}
function mecho_log ()
{
  mecho_stdout "$(datemt): $@" >> "${logfile}"
}


function mecho_set_title
{
  local title
  if [ "$TERM" == "xterm" ] ; then
    #if tty -s ; then
      #if [[ "$mecho_term" ]] ; then
	title="\e]2;"
	title="${title} : $@"
	title="${title}\e\\"
	echo -ne $title >&2
      #fi
    #fi
  elif [ "$TERM" == "screen" ] ; then
    #if tty -s ; then
      #if [[ "$mecho_term" ]] ; then
	title="\e]2;"
	title="${title} :sc: $@"
	title="${title}\e\\"
	echo -ne $title >&2
      #fi
    #fi
  fi
}
# logging
# logfile
# logging_message
function mecho_stdin_log ()
{
  local notlogged='[notlogged] '
  local f_log
  local f_stderr
  if [[ "$logging" ]] ; then
    if [[ "${logfile}" ]] ; then
      if ! [[ "$logging_message" ]] ; then
        mecho_stderr "Logging to ${logfile}"
	logging_message='made'
      fi
#     tee "${logfile}" 1>&2
      f_log=yes
      notlogged=''
    else
# Can't use 'mecho_error'  here - recursion
      mecho_stderr "logfile not defined ${BASH_SOURCE[1]} : ${BASH_LINENO[0]} : ${FUNCNAME[1]}" ; exit 1
    fi
  fi
  if [ -n "$notlogged" -o -n "$showlog" ] ; then
#   mecho_stderr "${notlogged}$@"
    f_stderr=yes
  fi
  if [[ "$f_stderr" && "$f_log" ]] ; then
    ${MAS_TEE_CMD:=/usr/bin/tee} -a "${logfile}" 1>&2
  elif [[ "$f_stderr" ]] ; then
    ${MAS_CAT_CMD:=/bin/cat} >&2
  elif [[ "$f_log" ]] ; then
    ${MAS_CAT_CMD:=/bin/cat} >> "${logfile}"
  fi
}
function mecho_message ()
{
  local showlogonce
  local notlogged='[notlogged] '
  if [[ "$1" = '-f' ]] ; then
    showlogonce=yes
    shift
  fi
  if ! [[ "$nomessage" ]] ; then
    if [[ "$logging" ]] ; then
      if [[ "${logfile}" ]] ; then
	if ! [[ "$logging_message" ]] ; then
	  mecho_stderr "Logging to ${logfile}"
	  logging_message='made'
	fi
	mecho_log $@
	notlogged=''
      else
  # Can't use 'mecho_error'  here - recursion
	mecho_stderr "logfile not defined ${BASH_SOURCE[1]} : ${BASH_LINENO[0]} : ${FUNCNAME[1]}" ; exit 1
      fi
    fi
    if [ -n "$notlogged" -o -n "$showlog" -o -n "$showlogonce" ] ; then
      mecho_stderr "${notlogged}$@"
    fi
  fi
}
function mecho_warn ()
{
  local nomessage
  local showlog
  showlog='yes'
  mecho_message "$@"
}
# args:
# 1:who
# 2:how
# 3:where
# 4:comment
# 5... : details
function mecho_error ()
{
  local nomessage
  local mwho mhow mwh mcomm
#  mas_logger "Error : $@"
  mwho="$1" ; shift
  mhow="$1" ; shift
  mwh="$1" ; shift
  mcomm="$1" ; shift
# mecho_warn "Error: $@ ($$ : $BASHPID)"
 #mecho_warn "  %% \e[0m\e[1;7;91m* Error *\e[0m: $mwho\e[1;33m $mhow:\e[0m \e$@\e[0m \e[1;34mat $mwh\e[0m \e[1;31m$mcomm\e0m"
  c_z="\e[0m"
  
  declare -p MAS_COLORS >/dev/null 2>&1 || declare -Axg MAS_COLORS
  declare -p MAS_BGCOLORS >/dev/null 2>&1 || declare -Axg MAS_BGCOLORS
  declare -p MAS_DECORS >/dev/null 2>&1 || declare -Axg MAS_DECORS

  c_tit="\e[${MAS_DECORS[error_title]};${MAS_BGCOLORS[error_title]};${MAS_COLORS[error_title]}m"
  c_who="\e[${MAS_DECORS[error_who]};${MAS_BGCOLORS[error_who]};${MAS_COLORS[error_who]}m"
  c_how="\e[${MAS_DECORS[error_how]};${MAS_BGCOLORS[error_how]};${MAS_COLORS[error_how]}m"
  c_det="\e[${MAS_DECORS[error_details]};${MAS_BGCOLORS[error_details]};${MAS_COLORS[error_details]}m"
  c_wh="\e[${MAS_DECORS[error_where]};${MAS_BGCOLORS[error_where]};${MAS_COLORS[error_where]}m"
  c_comm="\e[${MAS_DECORS[error_comment]};${MAS_BGCOLORS[error_comment]};${MAS_COLORS[error_comment]}m"

  mecho_warn "${c_tit}* Error *${c_z}:${c_who} ${mwho}${c_z}: ${c_how}${mhow}:${c_z} [${c_det}${@}${c_z}] ${c_wh}at ${mwh}${c_z} ${c_comm}${mcomm}${c_z}"
#  sleep 3
  # exit 1
  return 0
}
function mecho_error_exit ()
{
  mecho_error $@
  exit 1
}
export -f mecho_cat mecho_segment mecho_echo mecho_stdout mecho_stderr mecho_log mecho_set_title mecho_stdin_log mecho_message mecho_warn mecho_error mecho_error_exit

return 0

# vi: ft=sh
