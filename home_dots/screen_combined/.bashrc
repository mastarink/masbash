if [[ "$-" == *i* ]] ; then
#   infomas "TERM=$TERM"
#   infomas "MAS_TERM=$MAS_TERM"
#   infomas "MAS_BASHRC_TYPE=$MAS_BASHRC_TYPE"
#   infomas "MAS_DOTS_NAME=$MAS_DOTS_NAME"
#   infomas "MAS_UNDER=$MAS_UNDER"
#   infomas "MAS_DESKTOP_NUM=$MAS_DESKTOP_NUM"
#   infomas "MAS_DESKTOP_NAME=$MAS_DESKTOP_NAME"
#   infomas "MAS_TERMINAL_EMULATOR=$MAS_TERMINAL_EMULATOR"
   echo ".bashrc <@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@>" >&2
fi
shopt -u sourcepath
if shopt login_shell >/dev/null ; then
  :
fi

if [[ "$HOME" ]] && [[ -f ${MAS_ETC_BASH:=/etc/mastar/shell/bash}/.topparamfuncs ]] ; then
  . ${MAS_ETC_BASH:=/etc/mastar/shell/bash}/.topparamfuncs
  mas_sourcing_start .bashrc
  
  export MAS_BHOME MAS_BASHRC_SUB
  if [[ ${MAS_TERM:=${TERM:-none}} ]] && [[ ${MAS_BASHRC_NAME} ]] \
	&& [[ ${MAS_BHOME:=${MAS_SHOME:-$HOME}} ]] \
	&& [[ -f "${MAS_BASHRC_SUB:=${MAS_BHOME}/${MAS_BASHRC_NAME}_${MAS_TERM}}" ]] ; then
#    infomas "sub: $MAS_BASHRC_SUB"
    . $MAS_BASHRC_SUB
  fi
# echo "[$LINENO]-- $MAS_DIRNAME_CMD -- $MAS_BASENAME_CMD -- $MAS_BASHRC :: ${BASH_SOURCE[0]}}" >&2
# echo "[$LINENO]-- MAS_SHOME=$MAS_SHOME -- MAS_BHOME=$MAS_BHOME -- MAS_BASHRC_NAME=$MAS_BASHRC_NAME -- MAS_BASHRC_SUB=$MAS_BASHRC_SUB" >&2
# env > /tmp/env.bashrc.$LINENO
# set > /tmp/set.bashrc.$LINENO
  if [[ "$MAS_INITIAL_DIRECTORY" ]] && pushd ${MAS_INITIAL_DIRECTORY} &>/dev/null ; then
    if [[ -f .localrc ]] ; then
      . ./.localrc
    fi
    popd &>/dev/null
  fi
  mas_sourcing_end .bashrc
fi

# vi: ft=sh
