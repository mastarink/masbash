# X or tty
function mas_set_under ()
{
  declare -gx MAS_UNDER='tty'
  if [[ "$TERM" == 'linux' ]] ; then
    MAS_UNDER='tty-linux'
  elif [[ "$GDM_LANG" ]] || [[ "$GDMSESSION" ]] || [[ "$DISPLAY" ]] || [[ "$WM" ]] ; then
    MAS_UNDER='X'
  elif xwininfo -root >/dev/null 2>&1 ; then
    MAS_UNDER='X'
  elif [[ "$MAS_WINDOWID" ]] && xwininfo -id $MAS_WINDOWID >/dev/null 2>&1 ; then
    MAS_UNDER='X'
# elif xprop -root >/dev/null 2>&1 ; then
#   MAS_UNDER='X'
  fi
  return 0
}
