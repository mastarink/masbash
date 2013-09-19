declare -p MAS_BASH_MESSAGS >/dev/null 2>&1 && declare -axg MAS_BASH_MESSAGES && export MAS_BASH_MESSAGES
declare -xg MAS_SCREEN_MODE

function mas_bash_init_after_shell ()
{
  mas_src_scriptsnt _bashrc_rc - MAS_CONF_DIR_BASH - rc
  trap - SIGTERM SIGINT SIGHUP SIGTERM EXIT
  unset MAS_DO_EXIT
}
function mas_bash_init ()
{
  local logdir=${MAS_BASH_LOG:=${MAS_DIR:=$HOME/.mas}/log}
  export MAS_DO_EXIT=yes
 
  mas_get_lib_call stdbins define_std_binnames
  mas_get_lib_call stddirs define_std_directories
  mas_get_lib_call terminal_emulator terminal_emulator_euristic
  mas_get_lib_call under mas_set_under
  mas_get_lib_ifnot ed gvim_caller gvimer

  
  if ! [[ "$MAS_BASH_RC_CALLED" ]] ; then
#   dir from variable $MAS_CONF_DIR_PRERC : PRERC
#  1. $MAS_CONF_DIR_PRERC/default
#  2. $MAS_CONF_DIR_PRERC/rc
#  3. $MAS_CONF_DIR_PRERC/rc.d/*

    mas_get_lib_call doscript mas_src_scriptsn_opt_std    _rc_mastar_pre       MAS_CONF_DIR_PRERC

    mas_get_lib_call doscript mas_src_scriptsn            _bashrc_rc       -   MAS_CONF_DIR_BASH - rc

    mas_get_lib_call doscript mas_src_scriptsn_opt_std    _rc_mastar_post      MAS_CONF_DIR_POSTRC

    MAS_BASH_RC_CALLED=yes
  fi
}


# vi: ft=sh
