mas_sourcing_start ${BASH_SOURCE[0]}

export MAS_LOGOUT_USLEEP=4000000

# mas_loadlib_if_not datemt time
mas_get_lib_ifnot time datemt
export MAS_TIME_BASH_LOGOUT="`datemt`"
echo "$MAS_TIME_BASH_LOGOUT :$TERM: ${BASH_SOURCE[0]} " >>$MAS_BASH_LOG/login/log.$( datem )

if [[ "$MAS_LOGOUT_USLEEP" ]] && [[ $MAS_LOGOUT_USLEEP -gt 0 ]] ; then
  echo -en "............. logout at $MAS_TIME_BASH_LOGOUT ...................\e[K\r" >&2
  [[ $MAS_USLEEP ]] && $MAS_USLEEP $MAS_LOGOUT_USLEEP
  clear
fi

mas_sourcing_end ${BASH_SOURCE[0]}

# ${MAS_SHLIB:=${MAS_CONFIG_DIR_TERM:=${MAS_CONFIG_DIR:=${MAS_DIR:=${HOME}/.mas}/config}/term_new}/lib}
# vi: ft=sh
