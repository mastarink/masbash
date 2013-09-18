  declare -gx MAS_TERMINAL_EMULATOR
  declare -gx MAS_POSSIBLE_TERMINAL_EMULATORS
  declare -gx MAS_PROBABLE_TERMINAL_EMULATOR


# 1. x11-terms/terminal
#      COLORTERM=Terminal
# 2. x11-terms/xterm
#      XTERM_VERSION=XTerm(279)
#      XTERM_LOCALE=en_US.UTF-8
#      XTERM_SHELL=/bin/bash
#      XTERM_VERSION=XTerm(279)
# 3. x11-terms/terminator
#      COLORTERM=gnome-terminal ------- BUT SAME FOR: x11-terms/gnome-terminal
#      MAS_WINDOWID
#      TERMINATOR_UUID=urn:uuid:22b06b62-0c89-4b62-951f-ca29dd8cb583
# 4. x11-terms/gnome-terminal
#      COLORTERM=gnome-terminal ------- BUT SAME FOR: x11-terms/terminator
#      ORBIT_SOCKETDIR=/tmp/orbit-mastar
#      MAS_WINDOWID=96652384
#                                               MAS_GTERM_CLASS=C-video
#                                               MAS_GTERM_NAME=gt-ws-video
#                                               MAS_GTERM_PROFILE=wsp-video
#                                               MAS_GTERM_ROLE=gtermws
#                                               MAS_GT_GEOMETRY=156x60+0+0
# 5. x11-terms/valaterm
#      no COLORTERM
#      no MAS_WINDOWID
#      nothing special
#      cat /proc/$PPID/cmdline -> valaterm; if not in screen etc
#       				?	MAS_PARENT_CMD_LAST=/usr/bin/SCREEN -D -R -S more.0 
#       				?	MAS_PARENT_CMD=valaterm 
# 6. lxde-base/lxterminal
#      no COLORTERM
#      no MAS_WINDOWID
#      nothing special
#      cat /proc/$PPID/cmdline -> lxterminal; if not in screen etc
#       				?	MAS_PARENT_CMD_LAST=/usr/bin/SCREEN -D -R -S more.0 
#       				?	MAS_PARENT_CMD=lxterminal 
# 7. x11-terms/qterminal                - same for kde-base/konsole
#      COLORFGBG=15;0
#      LANGUAGE=
# 8. x11-terms/sakura
#       				?	MAS_PARENT_CMD_LAST=/usr/bin/SCREEN -D -R -S more.0 
#       				?	MAS_PARENT_CMD=sakura 
# 9. x11-libs/vte -> /usr/bin/vte
#       				?	MAS_PARENT_CMD_LAST=/usr/bin/SCREEN -D -R -S more.0 
#       				?	MAS_PARENT_CMD=... 
# 10. x11-terms/evilvte
#       				?	MAS_PARENT_CMD_LAST=/usr/bin/SCREEN -D -R -S more.0 
#       				?	MAS_PARENT_CMD=... 
# 11. kde-base/konsole
#      COLORFGBG=15;0                - same for x11-terms/qterminal 
#      KONSOLE_DBUS_SERVICE=:1.459
#      KONSOLE_DBUS_SESSION=/Sessions/1
#      SHELL_SESSION_ID=a4788e19024240009f05c72a6531ac88
#      PROFILEHOME=
#      MAS_WINDOWID=98566166
# 12. x11-terms/mlterm
#      COLORFGBG=default;default
#      MLTERM=3.0.11
#      MAS_WINDOWID=98566146
# 13. x11-terms/multi-aterm
#      TERM=rxvt
#      COLORFGBG=0;15
#      COLORTERM=rxvt-xpm
# 14. x11-terms/aterm
#      TERM=rxvt
#      COLORFGBG=0;15
#      COLORTERM=rxvt-xpm
#      TERMINFO=/usr/share/terminfo
# 15. x11-terms/rxvt-unicode -> /usr/lib/urxvt
#      COLORFGBG=0;15
#      COLORTERM=rxvt
#      TERM=rxvt-unicode
# 16. x11-terms/mrxvt
#      COLORTERM=rxvt-xpm
#      TERM=rxvt
# 17. x11-terms/rxvt
#      COLORTERM=rxvt-xpm
#      COLORFGBG=default;default;0
#      TERM=rxvt
# 18. x11-terms/eterm
#      COLORTERM=Eterm
#      COLORFGBG=7;default;0
#      TERM=Eterm
#
# xterm;terminal;gnome-terminal;terminator;valaterm;lxterminal;qterminal;sakura;vte;evilvte;konsole;mlterm;aterm;multi-aterm;rxvt-unicode;mrxvt
declare -Axg MAS_APOSSIBLE_TERMINAL_EMULATORS
  MAS_APOSSIBLE_TERMINAL_EMULATORS[aterm]=1
  MAS_APOSSIBLE_TERMINAL_EMULATORS[Eterm]=1
  MAS_APOSSIBLE_TERMINAL_EMULATORS[evilvte]=1
  MAS_APOSSIBLE_TERMINAL_EMULATORS[gnome-terminal]=1
  MAS_APOSSIBLE_TERMINAL_EMULATORS[konsole]=1
  MAS_APOSSIBLE_TERMINAL_EMULATORS[lxterminal]=1
  MAS_APOSSIBLE_TERMINAL_EMULATORS[mlterm]=1
  MAS_APOSSIBLE_TERMINAL_EMULATORS[mrxvt]=1
  MAS_APOSSIBLE_TERMINAL_EMULATORS[multi-aterm]=1
  MAS_APOSSIBLE_TERMINAL_EMULATORS[qterminal]=1
  MAS_APOSSIBLE_TERMINAL_EMULATORS[rxvt]=1
  MAS_APOSSIBLE_TERMINAL_EMULATORS[rxvt-unicode]=1
  MAS_APOSSIBLE_TERMINAL_EMULATORS[sakura]=1
  MAS_APOSSIBLE_TERMINAL_EMULATORS[Terminal]=1
  MAS_APOSSIBLE_TERMINAL_EMULATORS[terminator]=1
  MAS_APOSSIBLE_TERMINAL_EMULATORS[valaterm]=1
  MAS_APOSSIBLE_TERMINAL_EMULATORS[vte]=1
  MAS_APOSSIBLE_TERMINAL_EMULATORS[xterm]=1
  MAS_APOSSIBLE_TERMINAL_EMULATORS[console]=1
  MAS_APOSSIBLE_TERMINAL_EMULATORS[roxterm]=1
  MAS_APOSSIBLE_TERMINAL_EMULATORS[lilyterm]=1
  MAS_APOSSIBLE_TERMINAL_EMULATORS[st]=1
  MAS_APOSSIBLE_TERMINAL_EMULATORS[guake]=1
  MAS_APOSSIBLE_TERMINAL_EMULATORS[terminology]=1
#export MAS_KNOWN_EMULATORS='aterm|Eterm|evilvte|gnome-terminal|konsole|lxterminal|mlterm|mrxvt|multi-aterm|qterminal|rxvt|rxvt-unicode|sakura|Terminal|terminator|valaterm|vte|xterm'
export MAS_KNOWN_EMULATORS=$( echo "${!MAS_APOSSIBLE_TERMINAL_EMULATORS[@]}" | tr ' ' '|' )

function terminal_emulator_do_unset_negative ()
{
  local k emulator_test=$1 ; shift
  for k in ${!MAS_APOSSIBLE_TERMINAL_EMULATORS[@]} ; do
    if ! [[ "$k" =~ ^($emulator_test)$ ]] ; then
#     echo "UNSET $k"
      unset MAS_APOSSIBLE_TERMINAL_EMULATORS[$k]
    fi
  done  
}
function terminal_emulator_do_unset ()
{
  local k emulator_test=$1 ; shift
  for k in ${!MAS_APOSSIBLE_TERMINAL_EMULATORS[@]} ; do
    if [[ "$k" =~ ^($emulator_test)$ ]] ; then
#     echo "UNSET $k"
      unset MAS_APOSSIBLE_TERMINAL_EMULATORS[$k]
    fi
  done  
}

function terminal_emulator_test_variable ()
{
  local emulator_test=$1 ; shift
  local test_variable_name=$1 ; shift
  local test_value=$1 ; shift
# echo "${BASH_LINENO[0]}: A $emulator_test $test_variable_name=${!test_variable_name} ? $test_value: (@ ${#MAS_APOSSIBLE_TERMINAL_EMULATORS[@]} @)"
# declare -p  MAS_APOSSIBLE_TERMINAL_EMULATORS
  if [[ "$emulator_test" ]] && [[ "$test_variable_name" ]] && [[ ${#MAS_APOSSIBLE_TERMINAL_EMULATORS[@]} -gt 1 ]] ; then
    if ! [[ "${!test_variable_name}" ]] ; then
#     infomas A
      terminal_emulator_do_unset $emulator_test
    elif ! [[ "${test_value}" ]] || [[  "${!test_variable_name}" =~ ^${test_value}$ ]] ; then
#     infomas B
#     echo "good ${test_variable_name}==${test_value} [$emulator_test]"
      terminal_emulator_do_unset_negative $emulator_test
    elif [[ "${test_value}" ]] && ! [[ "${!test_variable_name}" ]] ; then    
#     infomas C
      terminal_emulator_do_unset $emulator_test
    elif [[ "${test_value}" ]] && ! [[ "${!test_variable_name}" =~ ^${test_value}$ ]] ; then    
#     infomas D
      terminal_emulator_do_unset $emulator_test
    else
#     infomas "E $emulator_test ${test_variable_name}=${!test_variable_name} ? $test_value"
      :
    fi
  fi
#  echo "${BASH_LINENO[0]}: B (@ ${#MAS_APOSSIBLE_TERMINAL_EMULATORS[@]} @)"
#  declare -p  MAS_APOSSIBLE_TERMINAL_EMULATORS
# infomas "[$emulator_test :: $test_variable_name :: $test_value] => ${!MAS_APOSSIBLE_TERMINAL_EMULATORS[@]}"
  if [[ ${#MAS_APOSSIBLE_TERMINAL_EMULATORS[@]} -eq 1 ]] ; then
    return 0
  fi
  return 12
}
# ROXTERM_ID=0x17c3490
# ROXTERM_NUM=3
# ROXTERM_PID=32010
# lilyterm : VTE_CJK_WIDTH=narrow
function terminal_emulator_euristic_base ()
{
# terminal_emulator_test_variable 'aterm|qterminal|konsole|Eterm|mlterm|Terminal|gnome-terminal|terminator|multi-aterm|rxvt|mrxvt|rxvt-unicode|xterm|roxterm' MAS_WINDOWID
     
  terminal_emulator_test_variable "$MAS_KNOWN_EMULATORS"                TERM
  terminal_emulator_test_variable 'rxvt|mrxvt|aterm|aterm|multi-aterm'  TERM 'rxvt'
  terminal_emulator_test_variable 'rxvt-unicode'                        TERM 'rxvt-unicode'
  terminal_emulator_test_variable 'Eterm'                               TERM 'Eterm'
  terminal_emulator_test_variable 'st'                                  TERM 'st-256color'
  terminal_emulator_test_variable 'console'                             TERM '(screen\.|)linux'

  terminal_emulator_test_variable 'xterm' XTERM_VERSION
  terminal_emulator_test_variable 'Eterm' ETERM_VERSION
  terminal_emulator_test_variable 'terminator' TERMINATOR_UUID
  terminal_emulator_test_variable 'mlterm' MLTERM
  terminal_emulator_test_variable 'terminology' TERMINOLOGY
  terminal_emulator_test_variable 'roxterm' ROXTERM_ID
  terminal_emulator_test_variable 'roxterm' ROXTERM_NUM
  terminal_emulator_test_variable 'roxterm' ROXTERM_PID
  terminal_emulator_test_variable 'lilyterm' VTE_CJK_WIDTH narrow
  terminal_emulator_test_variable 'konsole' KONSOLE_DBUS_SERVICE
  terminal_emulator_test_variable 'qterminal|konsole|rxvt|rxvt-unicode|mlterm|Eterm|multi-aterm|aterm' COLORFGBG

  terminal_emulator_test_variable 'Eterm' COLORTERM_BCE

# terminal_emulator_test_variable 'terminator|gnome-terminal|qterminal|Terminal|rxvt|mrxvt|aterm|multi-aterm|Eterm' COLORTERM
  terminal_emulator_test_variable 'Eterm'                             COLORTERM 'Eterm'
  terminal_emulator_test_variable 'rxvt|mrxvt|multi-aterm'            COLORTERM 'rxvt-xpm'
  terminal_emulator_test_variable 'rxvt-unicode|aterm'                COLORTERM 'rxvt'
  terminal_emulator_test_variable 'Terminal'                          COLORTERM 'Terminal'
  terminal_emulator_test_variable 'terminator|gnome-terminal'         COLORTERM 'gnome-terminal' 

# infomas "${#MAS_APOSSIBLE_TERMINAL_EMULATORS[@]} ${!MAS_APOSSIBLE_TERMINAL_EMULATORS[@]}"
  return 2
}
function terminal_emulator_euristic ()
{
# if ! [[ "$MAS_PROBABLE_TERMINAL_EMULATOR" ]] ; then
    terminal_emulator_euristic_base
    if [[ "${#MAS_APOSSIBLE_TERMINAL_EMULATORS[@]}" ]] ; then
      unset MAS_TERMINAL_EMULATOR MAS_POSSIBLE_TERMINAL_EMULATORS
      if [[ ${#MAS_APOSSIBLE_TERMINAL_EMULATORS[@]} -eq 1 ]] ; then 
	MAS_TERMINAL_EMULATOR="${!MAS_APOSSIBLE_TERMINAL_EMULATORS[@]}"
#	infomas "${!MAS_APOSSIBLE_TERMINAL_EMULATORS[@]}"
      else
	MAS_POSSIBLE_TERMINAL_EMULATORS=$( echo "${!MAS_APOSSIBLE_TERMINAL_EMULATORS[@]}" | tr ' ' '|' )
	MAS_TERMINAL_EMULATOR=Undefined
	MAS_TERMINAL_EMULATOR=$( echo "${!MAS_APOSSIBLE_TERMINAL_EMULATORS[@]}" | sed -e 's@ @_or_@g' )
      fi
      MAS_PROBABLE_TERMINAL_EMULATOR=$MAS_TERMINAL_EMULATOR
      if [[ "$MAS_PARENT_CMD" =~ ^($MAS_POSSIBLE_TERMINAL_EMULATORS)[[:space:]]*$ ]] ; then
	MAS_PROBABLE_TERMINAL_EMULATOR=${BASH_REMATCH[1]}
      fi
    else
      errormas "No possible emulators"
    fi
# fi
# infomas ">> $MAS_TERMINAL_EMULATOR >> $MAS_PROBABLE_TERMINAL_EMULATOR"
  return 0
}
function terminal_emulator_euristic_show0 ()
{
  if ! [[ "$MAS_TERMINAL_EMULATOR" ]] ; then terminal_emulator_euristic ; fi
  echo $MAS_TERMINAL_EMULATOR
}
function terminal_emulator_euristic_show ()
{
  declare -gx MAS_TERMINAL_EMULATOR_SET
  echo ${MAS_TERMINAL_EMULATOR_SET:=`terminal_emulator_euristic_show0`}
}

export -f terminal_emulator_euristic_show  terminal_emulator_euristic_show0 terminal_emulator_euristic terminal_emulator_euristic_base terminal_emulator_test_variable terminal_emulator_do_unset terminal_emulator_do_unset_negative
