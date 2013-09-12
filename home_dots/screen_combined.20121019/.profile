[[ "$MAS_TOPVARS" ]] || . $HOME/.topvars
echo -en "Sourcing   ${BASH_SOURCE[0]}\e[K\r" >&2
######################################################################
declare -gx MAS_TEST_AT_PROFILE=MAS_TEST_AT_PROFILE

# declare -agx MAS_TESTAR_AT_PROFILE
# declare -Agx MAS_TESTAS_AT_PROFILE
# MAS_TESTAR_AT_PROFILE[0]=MAS_TESTAR_AT_PROFILE
# MAS_TESTAS_AT_PROFILE[MAS_TESTAS_AT_PROFILE]=MAS_TESTAS_AT_PROFILE

# {
#   mas_loadlib_if_not mas_source_register_script_a regzero
#   mas_loadlib_if_not mas_term_new_status bash_init
#   type -t mas_term_new_status && mas_term_new_status >>$HOME/.mas/log/mstat/profile.1.$$.txt
# }


if [[ "$HOME" ]] && ! [[ "$MAS_BASH_LOG" ]] ; then declare -xg MAS_BASH_LOG=$HOME/.mas/log ; echo "`/bin/date '+%Y%m%d.%H%M%S.%N'`:p: $LINENO" >> $MAS_BASH_LOG/lili.txt ; fi

# mas_loadlib_if_not umoment service
# mas_loadlib_if_not mas_source_register_script_a regzero
# mas_source_register_script_a S ".profile"


mas_loadlib_if_not datemt time
export MAS_TIME_PROFILE="`datemt`"
echo "$( datemt ) :$TERM: ${BASH_SOURCE[0]} " >>$MAS_BASH_LOG/login/log.$( datem )


export MAS_PROFILE_TERM=$TERM


mas_source_register_script S "-1" "${BASH_SOURCE[0]}"

  mas_loadlib_if_not mas_profile_common profile
  mas_profile_common
  [[ "$MAS_CONF_DIR_PROFILE" ]] && \
       mas_source_scriptsn _profcomm_profile -  MAS_CONF_DIR_PROFILE   profile settings
# {
#   mas_loadlib_if_not mas_source_register_script_a regzero
#   mas_loadlib_if_not mas_term_new_status bash_init
#   type -t mas_term_new_status && mas_term_new_status >>$HOME/.mas/log/mstat/profile.2.$$.txt
# }
mas_source_register_script E "-1" "${BASH_SOURCE[0]}"

# vi: ft=sh
