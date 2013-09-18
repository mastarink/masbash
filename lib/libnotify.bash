function mas_notify ()
{
  local mtime
  mtime=$1
  shift
  local text="$@"
#  sw-notify-send  '***1 ping ***' "$( ${MAS_CAT_CMD:=/bin/cat} )"
#  /usr/bin/tinynotify-send  '***2 ping ***' "$( ${MAS_CAT_CMD:=/bin/cat} )"
  if [ -z "$mtime" ] ; then
    mtime=1
  fi
  if [ -z "$text" ] ; then
    text='beeeep'
  fi
#?  /usr/bin/notify --expire-time="$mtime" "$text"
# ? 5 times ??  sw-notify-send --expire-time="$mtime" "$text"
  /usr/bin/tinynotify-send --timeout "$mtime" "$text"
}
export -f mas_notify

return 0

# vi: ft=sh

