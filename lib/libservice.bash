mas_get_lib_ifnot time datemt
export MAS_TIME_LIBSERVICE=$(datemt)

function mas_mkdir ()
{
  local dir=$1
  shift
  if [[ "$dir" ]] ; then
    /bin/mkdir "$dir" 2>>$MAS_BASH_LOG/mkdir.err
  fi
}
function mas_command_echo_error ()
{
  local nomessage
  local mwho mhow mwh mcomm
#  mas_logger "Error : $@"
  mwho="$1" ; shift
  mhow="$1" ; shift
  mwh="$1" ; shift
  mcomm="$1" ; shift
  /usr/bin/logger -i -t term-new "Command error: $mwho:$mhow:$mwh:$mcomm - $@ - ($$ : $BASHPID : $PPID)"
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

  echo -e "${c_tit}* Error *${c_z}:${c_who} ${mwho}${c_z}: ${c_how}${mhow}:${c_z} [${c_det}${@}${c_z}] ${c_wh}at ${mwh}${c_z} ${c_comm}${mcomm}${c_z}" >&2
#  sleep 3
  # exit 1
  return 0
}

function off_command_not_found_handle () 
{ 
  local lin fun src='' at_line
# mas_loadlib_if_not mecho_error echo

  at_line=0
  at_linep=$(( $at_line + 1 ))
  lin=${BASH_LINENO[$at_line]}
  if [[ "${BASH_SOURCE[$at_linep]}" ]] ; then
    src="(${BASH_SOURCE[$at_linep]})" 
  fi
  fun=${FUNCNAME[$at_linep]:-cmdline}
  if false ; then
    echo "$(datemt): $@" > $MAS_BASH_LOG/last_command_not_found.log
    ${MAS_CAT_CMD:=/bin/cat} $MAS_BASH_LOG/last_command_not_found.log >> $MAS_BASH_LOG/command_not_found.log
  fi
# mas_service_error _Not found "'$@' at $fun:$lin ($src)" || echo "Error: " "Not found " $@ "at $fun:$lin ($src)" 1>&2
  if typemas mas_command_echo_error ; then
    echo -e "Error (libservice) command_not_found_handle: '$@'\e[K" >&2
    echo "S: ${BASH_SOURCE[@]}" >&2
    echo "L: ${BASH_LINENO[@]}" >&2
    echo "0: $0" >&2
#   mas_command_echo_error "$0" "command not found" "$fun:$lin src:$src" "(command_not_found_handle)" "$@" || echo "$0: $@: command not found at $fun:$lin $src (command_not_found_handle)"
#   mas_command_echo_error "BASH_SOURCE: ${BASH_SOURCE[@]}" 
#   mas_command_echo_error "PATH: $PATH" 
#   mas_command_echo_error "caller: `caller`" 
  else
    echo "FATAL ERROR" >&2
    sleep 1000
    exit
  fi
  #read
  return 1
}
function mas_get_variable ()
{
  local name cname
  name=$1
  shift
  cname="MAS_${name}"
  echo ${!cname}
}
function mas_set_variable ()
{
  local name cname val
  name=$1
  shift
  val=$1
  shift
  cname="MAS_${name}"
  eval "export $cname='$val'"
}
function mas_set_keyboard ()
{
# mas_loadlib_if_not mas_set_under under 
  mas_get_lib_ifnot under mas_set_under
  if mas_set_under ; then
    if [[ "$MAS_UNDER" == 'X' ]] ; then
      xmodmap $HOME/.Xmodmap || return 1
      xset m 20/10 10 r rate 300  30 || return 1
    fi
  else
    unset mas_set_under
    return 1
  fi
  return 0
}
function mas_show_var ()
{
  local name=$1 
  shift
  local pref=${1:-MAS}
  shift

  if [[ "$name" ]] ; then
    name="${pref}_${name}"
    echo ${!name}
  fi
}
function mas_show_conf_var ()
{
  mas_show_var $1 MAS_CONF
}
function mas_show_conf_dir ()
{
  mas_show_var $1 MAS_CONF_DIR
}


export -f mas_mkdir mas_get_variable mas_set_variable mas_set_keyboard mas_command_echo_error
# export -f  command_not_found_handle

return 0


# vi: ft=sh
