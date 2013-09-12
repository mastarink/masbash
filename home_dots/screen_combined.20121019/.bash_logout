[[ "$MAS_TOPVARS" ]] || . $HOME/.topvars

mas_loadlib_if_not datemt time
export MAS_TIME_BASH_LOGOUT="`datemt`"
echo "$( datemt ) :$TERM: ${BASH_SOURCE[0]} " >>$MAS_BASH_LOG/login/log.$( datem )

echo "................. logout at `date`........................" >&2
# vi: ft=sh
