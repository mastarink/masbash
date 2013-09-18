mas_sourcing_start libprofile.bash
function mas_set_home_special ()
{
  # Special case 1
  if ! [[ "$HOME" ]] ; then
   export MAS_X_HOME="$( echo ~ )"
   export MAS_C_USER="$( echo $USER )"
   if [[ "$USER" ]] ; then
    if [[ "$UID" -eq 0 ]] ; then
      MAS_C_HOME="$( su - $USER -c pwd )"
      export MAS_C_HOME
    fi
    if [[ "$MAS_C_HOME" ]] ; then
      export HOME=$MAS_C_HOME
    fi
   fi
  fi
}
function mas_profile_common ()
{
# mas_loadlib_if_not mas_init_colors colors
# mas_init_colors
  mas_get_lib_call colors mas_init_colors

# mas_loadlib_if_not umoment time
  export MAS_T00SP=$( mas_get_lib_call time umoment )
  unset BROWSER CVSEDITOR CVS_RSH EDITOR FCEDIT GNUSTEP_USER_ROOT GNUSTEP_USER_ROOT_B HISTFILE HISTFILESIZE HISTSIZE HISTTIMEFORMAT INPUTRC
  unset MAS_I_WS
#?? unset MAS_BASH_LOG MAS_BASH_PROFILE_TIME MAS_BASHRC MAS_BASHRC_DIR MAS_BASH_RCFILE MAS_BASH_SET_VAR_TIME MAS_DSECONDS MAS_GTTY MAS_HOSTNAME MAS_INCLUDE_PATH MAS_I_WS MAS_TIME_I_WS MAS_INPUTRC MAS_INTERACTIVE MAS_LD_LIBRARY_PATH MAS_PATH MAS_pDSECONDS MAS_PROMPT_COUNT MAS_PROMPT_STY MAS_PS MAS_PSECONDS MAS_STATUS MAS_USLEEP MAS_UTIME MAS_WMCTRL MAS_GTERM_WORKSPACE
  unset PROMPT_COMMAND PS10 SVN_EDITOR TERM_GEOMETRY WMAKER_BIN_NAME MAS_WM_DOCKAPPLETS

  mas_set_home_special

  return 0
}
mas_sourcing_end libprofile.bash
