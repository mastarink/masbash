[[ "$MAS_TOPVARS" ]] || . $HOME/.topvars
echo -en "Sourcing   ${BASH_SOURCE[0]}\e[K\r" >&2

declare -gx MAS_TEST_AT_BASHRC=MAS_TEST_AT_BASHRC
# declare -agx MAS_TESTAR_AT_BASHRC
# declare -Agx MAS_TESTAS_AT_BASHRC
# MAS_TESTAR_AT_BASHRC[0]=MAS_TESTAR_AT_BASHRC
# MAS_TESTAS_AT_BASHRC[MAS_TESTAS_AT_BASHRC]=MAS_TESTAS_AT_BASHRC

# {
#   mas_loadlib_if_not mas_source_register_script_a regzero
#   mas_loadlib_if_not mas_term_new_status bash_init
#   type -t mas_term_new_status && mas_term_new_status >>$HOME/.mas/log/mstat/bashrc.1.$$.txt
# }


if [[ -f "${MAS_FLAGS_DIR:=${MAS_VAR_DIR:=${MAS_DIR:=$HOME/.mas}/var}/flags}/mas_libs_reload" ]] ; then
  mas_libs_reload
# echo "RELOAD" >&2 
# sleep 3
fi
# mas_source_register_script_a S ".bashrc-point.`datemt`"
mas_loadlib_if_not mas_source_register_script_a regzero
# mas_source_register_script_a S ".bashrc"


mas_loadlib_if_not datemt time
echo "$( datemt ) :$TERM: ${BASH_SOURCE[0]} " >>$MAS_BASH_LOG/login/log.$( datem )
export MAS_TIME_BASHRC="`datemt`"


export MAS_BASHRC_TERM=$TERM
export MAS_RC_TIMING=yes

mas_loadlib_if_not mas_bash_init bash_init
mas_loadlib_if_not mas_source_register_script regbash

     mas_source_register_pid2 BASHRC

mas_source_register_script S "-1" "${BASH_SOURCE[0]}"
mas_bash_init
mas_source_register_script E "-1" "${BASH_SOURCE[0]}"

mas_source_register_called >>$MAS_BASH_LOG/login/log.$( datem )
# {
#   mas_loadlib_if_not mas_source_register_script_a regzero
#   mas_loadlib_if_not mas_term_new_status bash_init
#   type -t mas_term_new_status && mas_term_new_status >>$HOME/.mas/log/mstat/bashrc.2.$$.txt
# }
return 0

# vi: ft=sh
