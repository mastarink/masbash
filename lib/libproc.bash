function mas_pid_cmd ()
{
  local pid=${1:-$$}
  local proc
  if [[ "$pid" ]] ; then
    proc="/proc/$pid"
    if [[ -d "$proc" ]] ; then
      ${MAS_CAT_CMD:=/bin/cat} $proc/cmdline | tr '\0' ' ' && return 0
    fi
  fi
  return 2
}
function mas_pid_env ()
{
  local pid=${1:-$$}
  local proc
  if [[ "$pid" ]] ; then
    proc="/proc/$pid"
    if [[ -d "$proc" ]] ; then
      ${MAS_CAT_CMD:=/bin/cat} $proc/environ 2>/dev/null | tr '\0' '\n' && return 0
    fi
  fi
  return 2
}
function mas_pid_env2 ()
{
  local pid=${1:-$$}
  shift
  if [[ $# -gt 0 ]] ; then
    echo "Too many args" >&2
  elif [[ "$pid" ]] && [[ "$pid" -gt 0 ]] ; then
    ${MAS_CAT_CMD:=/bin/cat} /proc/$pid/environ | ${MAS_SED_CMD:=/bin/sed} -e 's@\([a-zA-Z0-9[:blank:]]\+\)@\1@' | tr '\0' '\n' && return 0
  fi
  return 2
}
function mas_pid_env_var ()
{
  local pid=${1:-$$}
  shift
  local v rex=''
  for v in $@ ; do
#   echo "$pid : $v ? "
    if [[ "$rex" ]] ; then
      rex+="\|$v"
    else
      rex=$v
    fi
  done
  mas_pid_env $pid | grep '^\('$rex'\)=\(.*\)$'
}
function mas_pid_env_val1 ()
{  
  mas_pid_env_var $@ | head -1 | ${MAS_SED_CMD:=/bin/sed} -ne 's@^\([^=]*\)=\(.*\)$@\2@p'
}
function mas_pid_env_val ()
{
  local pid=${1:-$$}
  shift
  local v rex=''
  for v in $@ ; do
#   echo "$pid : $v ? "
    if [[ "$rex" ]] ; then
      rex+="\|$v"
    else
      rex=$v
    fi
  done
  mas_pid_env $pid | ${MAS_SED_CMD:=/bin/sed} -ne 's@^\('$rex'\)=\(.*\)$@'"$pid: "'\2@p'
}
function mas_ppid ()
{
  local mstat
  if [[ "$pid" ]] ; then
    proc="/proc/$pid"
    if [[ -d "$proc" ]] ; then
      mstat="/proc/$u_pid/stat"
      read u_pid u_tcomm u_state u_ppid u_other < "$mstat"
      echo $u_ppid
      return 0
    fi
  fi
  return 2
}

function mas_parent_cmd ()
{
  mas_pid_cmd $PPID
}

function mas_proc_me_and_parents ()
{
  local IFS=' ' pid=99999 tcomm state ppid=99999 other
  local mstat='/proc/self/stat'

  while [[ $ppid -gt 1 ]] ; do
    read pid tcomm state ppid other < $mstat
    if ! cmd=$( mas_pid_cmd ) ; then
      echo "for "
      return 2
    fi
    echo "$pid : $cmd" >&2
    mstat="/proc/$ppid/stat"
  done
  return 0
}
function mas_proc_wm_env ()
{
  local wm_proc
  if ! [[ "$MAS_WM_PID" ]] ; then
    return 2
  fi
  mas_pid_env "$MAS_WM_PID"
}
function mas_list_up_pids ()
{
  local u_pid=${1:-$$} u_tcomm u_state u_ppid u_other
  local mstat cmd match
  while [[ $u_pid -gt 1 ]] ; do
    mstat="/proc/$u_pid/stat"
    read u_pid u_tcomm u_state u_ppid u_other < "$mstat"
    cmd=$( mas_pid_cmd ) || return 2
    echo "$u_pid"
    u_pid=$u_ppid
  done
  return 0
}
function mas_up_pid_path ()
{
  local u_path=''
  local u_pid=${1:-$$} u_tcomm u_state u_ppid u_other
  local mstat cmd match tlist
  while [[ $u_pid -gt 1 ]] ; do
#   echo $u_pid
    mstat="/proc/$u_pid/stat"
    read u_pid u_tcomm u_state u_ppid u_other < "$mstat" || return 2

    cmd=$( mas_pid_cmd )
#    echo "$u_pid : $cmd" >&2
    tlistt='gnome-terminal|valaterm|sakura|Terminal|xterm|qterminal|lxterminal|urxvt|rxvt|mlterm|vte|evilvte'
    #tlist="(gdm|/bin/sh[[:space:]]+/etc/X11/gdm/Xsession[[:space:]]+sawfish|login|SCREEN|screen|$tlistt)"
    tlist="(gdm|login|SCREEN|screen|$tlistt)"
    if [[ "$cmd" =~ ^(/usr/bin/|/bin/|)$tlist([[:space:]]+) ]] ; then
      match=${BASH_REMATCH[2]}
      if [[ "$WINDOWID" ]] ; then
        if [[ "$match" =~ $tlistt ]] ; then
########  if [[ "$MAS_WS_CMD" ]] ; then 
	    match+="/ws/${MAS_DESKTOP_NAME}/window/${WINDOWID}"
########  else
########    match+="/window/${WINDOWID}"
########  fi
	fi
      fi
      if [[ "$match" == 'Terminal' ]] ; then
	match="xfce-$match"
      elif [[ "${match}" == 'SCREEN' ]] ; then 
        if [[ "$MAS_SCREEN_SESSION" ]] ; then
          match+="/sty/$MAS_SCREEN_SESSION"
	elif [[ "$STY" ]] ; then
          match+="/sty/$STY"
	fi
      fi
      u_path="/${match}${u_path}"
    else
      u_path="/pid/${u_pid}${u_path}"
    fi
    u_pid=$u_ppid
  done
# u_path="$u_pid/$u_path"
  echo "$u_path"
}

function mas_up_pid_env ()
{
  local u_pid=$$
  local ur_pid ur_tcomm ur_state ur_ppid ur_other
  while [[ $u_pid -gt 1 ]] ; do
    mstat="/proc/$u_pid/stat"
    read ur_pid ur_tcomm ur_state ur_ppid ur_other < "$mstat" || return 2
    mas_pid_env $u_pid $@ || return 2
    u_pid=$ur_ppid
  done
  return 0
}
function mas_up_pid_env_var ()
{
  local u_pid=$$
  local ur_pid ur_tcomm ur_state ur_ppid ur_other
  while [[ $u_pid -gt 1 ]] ; do
    mstat="/proc/$u_pid/stat"
    read ur_pid ur_tcomm ur_state ur_ppid ur_other < "$mstat" || return 2
    mas_pid_env_var $u_pid $@ || return 2
    u_pid=$ur_ppid
  done
  return 0
}
function mas_up_pid_env_val ()
{
  local u_pid=$$
  local ur_pid ur_tcomm ur_state ur_ppid ur_other
  while [[ $u_pid -gt 1 ]] ; do
    mstat="/proc/$u_pid/stat"
    read ur_pid ur_tcomm ur_state ur_ppid ur_other < "$mstat" || return 2
    mas_pid_env_val $u_pid $@ || return 2
    u_pid=$ur_ppid
  done
  return 0
}
function mas_up_pid_env_val1 ()
{
  local u_pid=$$
  local ur_pid ur_tcomm ur_state ur_ppid ur_other
  while [[ $u_pid -gt 1 ]] ; do
    mstat="/proc/$u_pid/stat"
    read ur_pid ur_tcomm ur_state ur_ppid ur_other < "$mstat" || return 2
    mas_pid_env_val1 $u_pid $@ && break
    u_pid=$ur_ppid
  done
  return 0
}



export -f mas_list_up_pids mas_parent_cmd mas_pid_env mas_pid_env_var mas_pid_env_val mas_proc_me_and_parents mas_proc_wm_env mas_up_pid_env_var mas_up_pid_env_val mas_up_pid_path


return 0

# vi: ft=sh
