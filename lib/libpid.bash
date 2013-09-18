# fpidof_ext1
# fpidof_ext
# fpidof_ext_old
# fpidof_old
# fpidof
function m_kill ()
{
  local pids
  local pid sig
  
  sig=$1  
  shift

  pids=$@
  echo $pids | while read pid ; do
    m_echo_d "m_kill pid:'$pid'" >&2
    kill -"$sig" "$pid" 
  done
}
function m_killall ()
{
  local pids
  local pid rex sig
  
  sig=$1
  shift
  m_echo_d "[m_killall]" >&2
  pids=$@
  rex='^[[:digit:]]\+$'
  echo $pids | while read pid ; do
    if ! [[ "$pid" =~ $rex ]] ; then
      m_echo_d "1. m_kill $sig `fpidof $pid`" >&2
      m_kill $sig `fpidof $pid`
    else
      m_echo_d "2. m_kill $sig $pid" >&2
      m_kill $sig $pid
    fi
  done
}
function fpidof_ext1 ()
{
  local name fname lname result
  export MAS_WHICH=${MAS_WHICH:=/usr/bin/which}
  name="$@"
  result=112
  #echo "name: '$name'" >&2
  #fname=`$MAS_WHICH "$name"`
  #if [ -n "$fname" -a -L "$fname" ] ; then lname=`readlink -f $fname` ; fi
  #echo -e "\n\nname:'$name'\nfname:'$fname'\nlname:'$lname'\n" >&2
  [ -n "$name" ] && pgrep -f -umastar "^${name}\b" || \
  	fname=`$MAS_WHICH "$name"` 2>/dev/null && [ -n "$fname" ] && pgrep -f -umastar "^${fname}\b" || \
 	[ -n "$fname" -a -L "$fname" ] && \
  	   lname=`readlink -f $fname` && [ -n "$lname" ] && pgrep -f -umastar "^${lname}\b" && result=$?
  echo -e "\n\nname:'$name'\nfname:'$fname'\nlname:'$lname' : $result\n" >&2
  return $result
}
function xtmp ()
{
echo "X $FUNCNAME" >&2
}
function xfpidof ()
{
[[ "$MAS_TMP_LOG" ]] && echo "B1 $FUNCNAME" >&2
  local name fname lname result slf
  export MAS_WHICH=${MAS_WHICH:=/usr/bin/which}
[[ "$MAS_TMP_LOG" ]] && echo "B2 $FUNCNAME" >&2
  if [[ $# -lt 1 ]] ; then
    echo "Error xfpidof - no args" >&2
  else
    name="$@"
    result=112
    #echo "name: '$name'" >&2
    #fname=`$MAS_WHICH "$name"`
    #if [ -n "$fname" -a -L "$fname" ] ; then lname=`readlink -f $fname` ; fi
    #echo -e "\n\nname:'$name'\nfname:'$fname'\nlname:'$lname'\n" >&2
    if [[ "$name" ]] ; then
      slf="${BASHPID}"
[[ "$MAS_TMP_LOG" ]] &&      echo "Q$LINENO: $name / $slf :: $MAS_WHICH" >&2
      pgrep -f -umastar "^${name}\b(\s|$)" | grep -v "\b${slf}\b" && return 0
[[ "$MAS_TMP_LOG" ]] &&       echo "Q$LINENO: $fname / $slf" >&2
      [[ "$MAS_WHICH" ]] || return 2
[[ "$MAS_TMP_LOG" ]] &&       echo "Q$LINENO: $fname / $slf" >&2
      fname=`$MAS_WHICH "$name" 2>/dev/null` || return 2
[[ "$MAS_TMP_LOG" ]] &&       echo "Q$LINENO: $fname / $slf" >&2
      [[ "$fname" ]] || return 2
[[ "$MAS_TMP_LOG" ]] &&       echo "Q$LINENO: $fname / $slf" >&2
      if pgrep -f -umastar "^${fname}\b(\s|$)" | grep -v "\b${slf}\b" ; then  return 0 ; fi
[[ "$MAS_TMP_LOG" ]] &&       echo "Q$LINENO: $fname / $slf" >&2
      [[ -L "$fname" ]] || return 2
[[ "$MAS_TMP_LOG" ]] &&       echo "Q$LINENO: $fname / $slf" >&2
      lname=`readlink -f $fname` || return 2
[[ "$MAS_TMP_LOG" ]] &&       echo "Q$LINENO: $fname / $slf" >&2
      [[ "$lname" ]] || return 2
[[ "$MAS_TMP_LOG" ]] &&       echo "Q$LINENO: $lname / $slf" >&2
      pgrep -f -umastar "^${lname}\b(\s|$)" | grep -v "\b${slf}\b" && return 0
[[ "$MAS_TMP_LOG" ]] &&       echo "Q$LINENO: $lname / $slf" >&2
      return 2
####  if pgrep -f -umastar "^${name}\b" | grep -v "\b${slf}\b" ; then
####    result=0
####  else
####    fname=`$MAS_WHICH "$name" 2>/dev/null`
####    if [ -n "$fname" ] ; then
####      if pgrep -f -umastar "^${fname}\b" | grep -v "\b${slf}\b" ; then
####        result=0
####      elif [ -n "$fname" -a -L "$fname" ] ; then
####        lname=`readlink -f $fname`
####        if [ -n "$lname" ] ; then
####          pgrep -f -umastar "^${lname}\b" | grep -v "\b${slf}\b"
####          result=$?
####        fi
####      fi
####    fi
####  fi
    fi
  fi
  #echo -e "\n\nname:'$name'\nfname:'$fname'\nlname:'$lname' : $result\n" >&2
  return $result
}


function fpidof_ext_old ()
{
  local name fname lname result
  export MAS_WHICH=${MAS_WHICH:=/usr/bin/which}
  name="$@"
  result=0
  #echo "name: '$name'" >&2
  fname=`$MAS_WHICH $name 2>/dev/null`
  if [ -n "$fname" -a -L "$fname" ] ; then lname=`readlink -f $fname` ; fi
  echo "name:$name fname:$fname lname:$lname" >&2
  pgrep -f -umastar "^${name}\b" || pgrep -f -umastar "^${fname:-$name}\b" || pgrep -f -umastar "^${lname:-$name}\b"
  result=$?
  return $result
}
function fpidof_old ()
{
  export MAS_WHICH=${MAS_WHICH:=/usr/bin/which}
  local name
  local fname
  local lname
  local first
  local last
  for name in $@ ; do
    if [ "@${name}" == '@+' ] ; then
      first=$name
    elif [ "@${first}" == '@+' ] ; then
      if [ -n "$last" ] ; then  last="$last " ; fi
      last="${last}${name}"
    else
      #echo "name: '$name'" >&2
      fname=`$MAS_WHICH $name 2>/dev/null`
      if [ -n "$fname" ] ; then lname=`readlink -f $fname` ; fi
      #echo "name:$name fname:$fname lname:$lname" >&2
      pgrep -f -umastar "^${name}\b" || pgrep -f -umastar "^${fname:-$name}\b" || pgrep -f -umastar "^${lname:-$name}\b"
      result=$?
    fi
  done
  if [ -n "$last" ] ; then
    #echo "last: '$last'" >&2
    pgrep -f -umastar "^$last\b"
    result=$?
  fi
  return $result
}
# find -L /proc/*/exe -maxdepth 1 -samefile /usr/bin/stardict
# pgrep -f -umastar stardict
function fpidof ()
{
  local last
  [[ $MAS_TMP_LOG ]] && m_echo_d "fpidof A $LINENO" >&2
  [[ $MAS_TMP_LOG ]] && m_echo_d "fpidof A1 '$@' $LINENO" >&2
  [[ $MAS_TMP_LOG ]] && m_echo_d "fpidof A2 '$@' $LINENO" >&2
  

  xfpidof "$@" || return 2
  [[ $MAS_TMP_LOG ]] &&   m_echo_d "fpidof $LINENO" >&2
  if [ -n "$last" ] ; then
    [[ $MAS_TMP_LOG ]] &&   m_echo_d "fpidof $LINENO" >&2
    #echo "last: '$last'" >&2
    pgrep -f -umastar "^$last\b(\s|$)" || return 2
  fi
  [[ $MAS_TMP_LOG ]] &&   m_echo_d "fpidof $LINENO" >&2
  return 0
}
declare -xf  m_kill  m_killall fpidof xfpidof
# fpidof_ext1
# fpidof_ext 
# fpidof_ext_old 
# fpidof_old 
