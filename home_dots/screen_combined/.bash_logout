mas_sourcing_start ${BASH_SOURCE[0]}
function mas_logout ()
{
  local ii losleep
  losleep=$1
  shift
  # mas_loadlib_if_not datemt time
  mas_get_lib_ifnot time datemt
  export MAS_TIME_BASH_LOGOUT="`datemt`"
  echo "$MAS_TIME_BASH_LOGOUT :$TERM: ${BASH_SOURCE[0]} " >>$MAS_BASH_LOG/login/log.$( datem )

  if ! [[ "$STY" ]] ; then
    mas_dynsleep "${losleep}" "..... logout at $MAS_TIME_BASH_LOGOUT, sleeping $losleep"
  fi

# if [[ "$losleep" ]] && [[ $losleep -gt 0 ]] ; then
#   echo -en "....... logout at $MAS_TIME_BASH_LOGOUT, sleeping $losleep  ...\e[K" >&2
#   for (( ii=0; ii<30 ; ii++)) ; do
#     echo -n '.' >&2
#     [[ "$MAS_USLEEP" ]] && [[ -x "$MAS_USLEEP" ]] && $MAS_USLEEP $losleep
#   done
#   echo >&2
# fi

#?  /usr/bin/reset
#?  clear

  mas_sourcing_end ${BASH_SOURCE[0]}

  # ${MAS_SHLIB:=${MAS_CONFIG_DIR_TERM:=${MAS_CONFIG_DIR:=${MAS_DIR:=${HOME}/.mas}/config}/term_new}/lib}
}
export MAS_LOGOUT_DELAY=150000

mas_logout $MAS_LOGOUT_DELAY

# vi: ft=sh
