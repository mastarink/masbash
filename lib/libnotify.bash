function mas_notify ()
{
  local mtime sum text
  mtime=$1
  if [[ "$mtime" ]] ; then
    if [[ "$mtime" == '-' ]] ; then
      mtime=2000 ; shift
    elif [[ "$mtime" == '+' ]] ; then
      mtime=20000 ; shift
    elif [[ "$mtime" -gt 0 ]] ; then
      shift
    else
      mtime=50000
    fi
  else
    mtime=2000
  fi
  sum=${1:-beep}
  shift
  text="[$*]"
  if [[ "${#text}" -gt 300 ]] ; then
    text="${text:0:300} ..."
  fi
#  sw-notify-send  '***1 ping ***' "$( ${MAS_CAT_CMD:=/bin/cat} )"
#  /usr/bin/tinynotify-send  '***2 ping ***' "$( ${MAS_CAT_CMD:=/bin/cat} )"
# echo "$mtime:[$@]" >>/tmp/libnotify.tmp
#?  /usr/bin/notify --expire-time="$mtime" "$text"
# ? 5 times ??  sw-notify-send --expire-time="$mtime" "$text"

  if [[ "$MAS_DEBUG" -gt 0 ]] ; then
    echo "NOTIFY $mtime :: $sum / $text" >&2
  else
  ( coproc ( /usr/bin/notify-send --expire-time="$mtime" "[$sum]" "[$text]" &>/dev/null ) )
  fi
# /usr/bin/tinynotify-send -t "$mtime" $sum "${text}" 2>/dev/null
  return 0
}
export -f mas_notify

return 0

# vi: ft=sh

