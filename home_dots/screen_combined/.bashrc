#if [[ "$-" == *i* ]] ; then
#   infomas "TERM=$TERM"
#   infomas "MAS_TERM=$MAS_TERM"
#   infomas "MAS_BASHRC_TYPE=$MAS_BASHRC_TYPE"
#   infomas "MAS_DOTS_NAME=$MAS_DOTS_NAME"
#   infomas "MAS_UNDER=$MAS_UNDER"
#   infomas "MAS_DESKTOP_NUM=$MAS_DESKTOP_NUM"
#   infomas "MAS_DESKTOP_NAME=$MAS_DESKTOP_NAME"
#   infomas "MAS_TERMINAL_EMULATOR=$MAS_TERMINAL_EMULATOR"
#   echo ".bashrc <@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@>" >&2
#fi

function bashrc_main ()
{
  dbgmasp 3 "$LINENO:$FUNCNAME"
  shopt -u sourcepath
  if shopt login_shell >/dev/null ; then
    :
  fi

  mas_dynsleep 1 '.bashrc - ^C to run w/o' || echo NO
  mas_sourcing_start .bashrc

# declare -gx MAS_BASHRC_PWD=${MAS_BASHRC_PWD:-$(pwd)}
  declare -gx MAS_BASHRC_PWD0="$PWD"
  dbgmasp 3 "$LINENO:-$FUNCNAME"
  
  declare -gx MAS_INITIAL_DIRECTORY=$MAS_BASHRC_PWD0

  export MAS_BHOME MAS_BASHRC_SUB
  if [[ ${MAS_TERM:=${TERM:-none}} ]] && [[ ${MAS_BASHRC_NAME} ]] \
	&& [[ ${MAS_BHOME:=${MAS_SHOME:-$HOME}} ]] \
	&& [[ -f "${MAS_BASHRC_SUB:=${MAS_BHOME}/${MAS_BASHRC_NAME}_${MAS_TERM}}" ]] ; then
#    infomas "sub: $MAS_BASHRC_SUB"
    dbgmasp 3 "$LINENO:-$FUNCNAME source @RP$MAS_BASHRC_SUB@"
    . $MAS_BASHRC_SUB
    dbgmasp 3 "$LINENO:-$FUNCNAME sourced @RP$MAS_BASHRC_SUB@"
  fi
  dbgmasp 3 "$LINENO:-$FUNCNAME"
# echo "[$LINENO]-- $MAS_DIRNAME_CMD -- $MAS_BASENAME_CMD -- $MAS_BASHRC :: ${BASH_SOURCE[0]}}" >&2
# echo "[$LINENO]-- MAS_SHOME=$MAS_SHOME -- MAS_BHOME=$MAS_BHOME -- MAS_BASHRC_NAME=$MAS_BASHRC_NAME -- MAS_BASHRC_SUB=$MAS_BASHRC_SUB" >&2
# env > /tmp/env.bashrc.$LINENO
# set > /tmp/set.bashrc.$LINENO
  if [[ "$MAS_INITIAL_DIRECTORY" ]] && pushd ${MAS_INITIAL_DIRECTORY} &>/dev/null ; then
    dbgmasp 3 "I.D.: ${MAS_INITIAL_DIRECTORY}"
    if [[ -f .localrc ]] ; then
      . .localrc
    fi
    popd &>/dev/null
  fi
  dbgmasp 3 "$LINENO:/$FUNCNAME"
  mas_sourcing_end .bashrc
  return 0
}

if [[ "$HOME" ]] && [[ -f ${MAS_ETC_BASH:=/etc/mastar/shell/bash}/.topparamfuncs ]] ; then
  . ${MAS_ETC_BASH:=/etc/mastar/shell/bash}/.topparamfuncs
  if ! [[ "$MAS_DESKTOP_NAME" =~ ^devel-A$ ]] ; then
    bashrc_main $@
  fi
fi


# vi: ft=sh
