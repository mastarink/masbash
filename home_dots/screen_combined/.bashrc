if [[ "$HOME" ]] && [[ -f ${MAS_ETC_BASH:=/etc/mastar/shell/bash}/.topparamfuncs ]] ; then
  . ${MAS_ETC_BASH:=/etc/mastar/shell/bash}/.topparamfuncs
  mas_sourcing_start .bashrc
  
  export MAS_BHOME MAS_BASHRC_SUB
  if [[ ${MAS_TERM:=${TERM:-none}} ]] && [[ ${MAS_BASHRC_NAME} ]] \
	&& [[ ${MAS_BHOME:=${MAS_SHOME:-$HOME}} ]] \
	&& [[ -f "${MAS_BASHRC_SUB:=${MAS_BHOME}/${MAS_BASHRC_NAME}_${MAS_TERM}}" ]] ; then
    . $MAS_BASHRC_SUB
  fi


# echo "[$LINENO]-- $MAS_DIRNAME_CMD -- $MAS_BASENAME_CMD -- $MAS_BASHRC :: ${BASH_SOURCE[0]}}" >&2
# echo "[$LINENO]-- MAS_SHOME=$MAS_SHOME -- MAS_BHOME=$MAS_BHOME -- MAS_BASHRC_NAME=$MAS_BASHRC_NAME -- MAS_BASHRC_SUB=$MAS_BASHRC_SUB" >&2
  mas_sourcing_end .bashrc
fi

# vi: ft=sh
