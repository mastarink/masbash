# mas_loadlib_if_not set_prompt_string promptbase
mas_get_lib_ifnot promptbase set_prompt_string

function mas_prompt_conditional ()
{ 
  local cnd  
  local el cmd
  cnd=$1
  shift

  if mas_prompt_test_condition $cnd ; then
    mas_prompt_do "$@"
    return 0
  else
    return 1
  fi
}
function set_prompt_eofsign ()
{
  set_prompt_color_by_id eofsign
  case "$TERM" in
    xterm)  set_prompt_string "⊂╋⊃" ;;
    screen) set_prompt_string "╋"   ;;
    linux)  set_prompt_string "◀○▶"   ;;
#   linux)  set_prompt_string "Φ"   ;;
    *)      set_prompt_string ":"   ;;
  esac
  # Erase in Line From Cursor to End of Line
  set_prompt_string "\e[0m\e[K"
}
function set_prompt_geometry ()
{
  set_prompt_color_by_id geometry
  set_prompt_string "${MAS_PROMPT_GEOMETRY}"
}
function set_prompt_bash_version ()
{
  if [[ "$MAS_PROMPT_NUMLINE" -ge "$MAS_PS10LIMIT" ]] ; then
    set_prompt_color_by_id bash_version
    set_prompt_string "V\v"
  fi
}
function set_prompt_prompt_options ()
{
  set_prompt_color_by_id prompt_options
  set_prompt_string "$MAS_PROMPT_OPTIONS"
}
function set_prompt_tty_old ()
{
  set_prompt_color_by_id tty

  if [ -z "$MAS_GTTY" ] ; then
    export MAS_GTTY
    MAS_GTTY=$( ${MAS_TTY_CMD:=/bin/tty} )
  fi
  if [[ "$MAS_PROMPT_NUMLINE" -ge "$MAS_PS10LIMIT" ]] ; then
    set_prompt_string "$MAS_GTTY \l"
  fi
# \l     the basename of the shell's terminal device name
}

function set_prompt_term ()
{
  set_prompt_color_by_id term
  if [[ "$TERM" ]] ; then 
    set_prompt_string "${TERM}"
  fi
}
function set_prompt_tty ()
{
  local mtty
  set_prompt_color_by_id tty

  mtty=$( ${MAS_TTY_CMD:=/bin/tty} )
  set_prompt_string "${mtty}"
  if [[ "$MAS_PROMPT_NUMLINE" -ge "$MAS_PS10LIMIT" ]] ; then
    set_prompt_string ":\l"
# \l     the basename of the shell's terminal device name
  fi
}
function set_prompt_stty ()
{
  set_prompt_color_by_id stty
  if [[ "${STY:-$MAS_PROMPT_STY}" ]] ; then
    set_prompt_string ":<${STY:-$MAS_PROMPT_STY}>"
    #${MAS_CAT_CMD:=/bin/cat} /proc/$PPID/environ  | tr '\0' '\n'|grep STY
  fi
}
function set_prompt_stty_pp ()
{
  set_prompt_color_by_id sttypp
  if [[ -n "$PPID" && "$MAS_STY_UP" ]] ; then
    set_prompt_string ":<<$MAS_STY_UP>>"
  fi
}
\
function set_prompt_ttys ()
{
  set_prompt_tty
  set_prompt_stty
  set_prompt_stty_pp
}
function set_prompt_windowid ()
{
  set_prompt_color_by_id windowid
  if [[ "$MAS_PROMPT_NUMLINE" -ge "$MAS_PS10LIMIT" ]] ; then
    set_prompt_string '$MAS_WINDOWID'
  else
    set_prompt_string "$MAS_WINDOWID"
  fi
}
function set_prompt_tabidws ()
{
  set_prompt_color_by_id tabidws
  if [[ "$MAS_PROMPT_NUMLINE" -ge "$MAS_PS10LIMIT" ]] ; then
    set_prompt_string '$MAS_WIN_TABNUMWS'
  else
    set_prompt_string "$MAS_WIN_TABNUMWS"
  fi
}
function set_prompt_tabidp ()
{
  set_prompt_color_by_id tabidp
  if [[ "$MAS_PROMPT_NUMLINE" -ge "$MAS_PS10LIMIT" ]] ; then
    set_prompt_string '$MAS_WIN_TABNUMP'
  else
    set_prompt_string "$MAS_WIN_TABNUMP"
  fi
}
function set_prompt_tabidt ()
{
  set_prompt_color_by_id tabidt
  if [[ "$MAS_PROMPT_NUMLINE" -ge "$MAS_PS10LIMIT" ]] ; then
    set_prompt_string '$MAS_WIN_TABNUMT'
  else
    set_prompt_string "$MAS_WIN_TABNUMT"
  fi
}
function set_prompt_screen_windid ()
{
  set_prompt_color_by_id screen_windid
  if [[ "$MAS_PROMPT_NUMLINE" -ge "$MAS_PS10LIMIT" ]] ; then
    set_prompt_string '$WINDOW'
  else
    set_prompt_string "$WINDOW"
  fi
}

function set_prompt_screen_start_at ()
{
  set_prompt_color_by_id screen_started
  set_prompt_string " ${MAS_TIME_SCREEN_START} "
}
function set_prompt_user ()
{
  set_prompt_color_by_id user
  if [[ "$MAS_PROMPT_NUMLINE" -ge "$MAS_PS10LIMIT" ]] ; then
    set_prompt_string "\u"
  else
    set_prompt_string "$USER"
  fi
}
function set_prompt_host ()
{
  set_prompt_color_by_id host
  if [[ "$MAS_PROMPT_NUMLINE" -ge "$MAS_PS10LIMIT" ]] ; then
    set_prompt_string "\h"
  else
    set_prompt_string "$MAS_HOSTNAME"
  fi
}
function set_prompt_weekday ()
{
  if [[ "$MAS_PROMPT_NUMLINE" -ge "$MAS_PS10LIMIT" ]] ; then
    set_prompt_color_by_id day
    set_prompt_string "\D{%a}"
  fi
}
function set_prompt_monthday ()
{
  if [[ "$MAS_PROMPT_NUMLINE" -ge "$MAS_PS10LIMIT" ]] ; then
    set_prompt_color_by_id date
    set_prompt_string "\D{%d}"
  fi
}
function set_prompt_date ()
{
  mas_prompt_do _weekday ' '
  mas_prompt_do _monthday
}
function set_prompt_time ()
{
  # Time

  #if [ -z "$MAS_DATE2" ] ; then
  #export MAS_DATE2=`/bin/date +%H:%M:%S`
  #fi
  unset MAS_DATE2
  set_prompt_color_by_id time

  if [[ -v MAS_DATE2 && -n "$MAS_DATE2" ]] ; then
    set_prompt_string "$MAS_DATE2"
  elif [[ "$MAS_PROMPT_NUMLINE" -ge "$MAS_PS10LIMIT" ]] ; then
    set_prompt_string "\t"
  fi
}
function set_prompt_terminal_emulator ()
{
  set_prompt_color_by_id terminal_emulator
  set_prompt_string "$MAS_PROBABLE_TERMINAL_EMULATOR"
}
function set_prompt_workspace ()
{
  set_prompt_color_by_id workspace
  set_prompt_string "$MAS_OLD_WS"
}

function set_prompt_user_host_date_time ()
{
  if mas_prompt_test_condition U ; then set_prompt_user ; fi
  if mas_prompt_test_condition H ; then set_prompt_reset_colors '@' ; set_prompt_host ; fi
  if mas_prompt_test_condition D ; then set_prompt_reset_colors ' ' ; set_prompt_date ; fi
  if mas_prompt_test_condition T ; then set_prompt_reset_colors ' ' ; set_prompt_time ; set_prompt_reset_colors ; fi
}
function set_prompt_shlvl ()
{
#      '¹²³⁴⁵⁶⁷⁸'
  if [[ "$TERM" == 'linux' ]] ; then MAS_PS10="${MAS_PS10}${SHLVL}."
  elif [[ "$TERM" == 'xterm' ]] ; then MAS_PS10="${MAS_PS10}${SHLVL}."
  elif [ "$SHLVL" == 1 ] ; then MAS_PS10="${MAS_PS10}¹."
  elif [ "$SHLVL" == 2 ] ; then MAS_PS10="${MAS_PS10}²."
  elif [ "$SHLVL" == 3 ] ; then MAS_PS10="${MAS_PS10}³."
  elif [ "$SHLVL" == 4 ] ; then MAS_PS10="${MAS_PS10}⁴."
  elif [ "$SHLVL" == 5 ] ; then MAS_PS10="${MAS_PS10}⁵."
  elif [ "$SHLVL" == 6 ] ; then MAS_PS10="${MAS_PS10}⁶."
  elif [ "$SHLVL" == 7 ] ; then MAS_PS10="${MAS_PS10}⁷."
  elif [ "$SHLVL" == 8 ] ; then MAS_PS10="${MAS_PS10}⁸."
  else                          MAS_PS10="${MAS_PS10}${SHLVL}."
  fi
}
function set_prompt_cmdnum ()
{
  set_prompt_color_by_id cmdnum
  set_prompt_string "#\#"
}
function  set_prompt_format_time ()
{
  local seconds secs0 mins0 hours0 days0 secs mins hours
  seconds=$1
  shift

  mins0=$(( $seconds / 60 ))
  hours0=$(( $mins0 / 60 ))
  days0=$(( $hours0 / 24 ))

  hours=$(( $hours0 - ($days0 * 24) ))
  mins=$(( $mins0 - ($hours0 * 60) ))
  secs=$(( $seconds - ($mins0 * 60) ))


  if   [[ "$seconds" -gt 86400 ]] ; then
    set_prompt_string `printf "%dd %2d:%02d:%02d"   "$days0" "$hours" "$mins" "$secs"`
  elif   [[ "$seconds" -gt 3600 ]] ; then
    set_prompt_string `printf "%dh %02d:%02d"                    "$hours" "$mins" "$secs"`
  elif [[ "$seconds" -gt 60   ]] ; then
   #set_prompt_string "$mins:$secs"
    set_prompt_string `printf "%dm %02ds"                              "$mins" "$secs"`
  elif [[ "$seconds" -gt 0    ]] ; then
   #set_prompt_string "$seconds"
    set_prompt_string `printf "%ds"                                              "$secs"`
  fi
}
function  set_prompt_pause ()
{
  set_prompt_color_by_id delta_time
  set_prompt_format_time "$delta_seconds"

  if [ "$delta_seconds" -gt 86400 ] ; then
    set_prompt_string " : $MAS_LAST_ENTER"
  fi

  set_prompt_color_by_id timing2
  mas_get_lib_ifnot time datemt
  export MAS_LAST_ENTER=`datemt`

  if [[ -v TMOUT && -n "$TMOUT" ]] ; then
    if [ "$delta_seconds" -gt $(( $TMOUT / 2 )) ] ; then
      set_prompt_string " <$TMOUT>"
    fi
  fi
  # Brace

  set_prompt_color_by_id timingx
}
function  set_prompt_period ()
{
  set_prompt_color_by_id period_time
  set_prompt_format_time "$SECONDS"
  set_prompt_color_by_id timingx
}
function  set_prompt_seconds ()
{
  if [[ "$SECONDS" && "$MAS_PSECONDS" ]] ; then
    local delta_seconds=$(( $SECONDS - $MAS_PSECONDS ))
    # No-touch seconds

    if [ "$delta_seconds" -gt 0 ] ; then
      set_prompt_color_by_id timingx
      if [[ $- =~ 'i' ]] ; then
	if [[ -v MAS_PROFILE_DATA_DIR && -n "$MAS_PROFILE_DATA_DIR" && -d "$MAS_PROFILE_DATA_DIR" ]] ; then
	  echo "$OLDPWD" > $MAS_PROFILE_DATA_DIR/oldpwd.$SHLVL.$WINDOW.txt
	  echo "$MAS_PS10PWD" > $MAS_PROFILE_DATA_DIR/pwd.$SHLVL.$WINDOW.txt
	  mas_get_lib_ifnot time datemt
	  echo "$MAS_PROMPT_COUNT. `datemt` [$prompt_window $MAS_WINDOWID] old: $OLDPWD" >> $MAS_PROFILE_DATA_DIR/pwds.txt
	  echo "$MAS_PROMPT_COUNT. `datemt` [$prompt_window $MAS_WINDOWID] pwd: $MAS_PS10PWD" >> $MAS_PROFILE_DATA_DIR/pwds.txt
	  #${MAS_ENV_CMD:=/bin/env} > $MAS_PROFILE_DATA_DIR/env.`datemt`.txt
	fi
      fi

      #set_prompt_string "{"
      mas_prompt_do '{' _pause '} {' _period '} '
      #set_prompt_string "}"
      #set_prompt_reset_colors ' '
    fi
  else
    echo "Error timing $SECONDS : $MAS_PSECONDS" >&2
  fi
  set_prompt_color_by_id current_time
}
function  set_prompt_pid ()
{
  set_prompt_color_by_id pid
  set_prompt_string "$$"
}
function  set_prompt_workdir ()
{
  set_prompt_color_by_id workdir
# Work dir
  set_prompt_string " ${MAS_PS10PWDS} "
}
function  set_prompt_workdir_ps ()
{
  set_prompt_color_by_id workdir
# Work dir
  if [[ "$MAS_PROMPT_NUMLINE" -ge "$MAS_PS10LIMIT" ]] ; then
    set_prompt_string " \W "
  else 
    set_prompt_string " ${MAS_PS10PWDS} "
  fi
}
function  set_prompt_workdir_psl ()
{
  set_prompt_color_by_id workdir
# Work dir
  if [[ "$MAS_PROMPT_NUMLINE" -ge "$MAS_PS10LIMIT" ]] ; then
    set_prompt_string " \w "
  else
    set_prompt_string " ${MAS_PS10PWDS} "
  fi
}
function  set_prompt_seconds_seconds_pid ()
{
  mas_prompt_conditional S _seconds
  mas_prompt_conditional i '~' _pid '&'
# if mas_prompt_test_condition Wdc ; then
#   mas_prompt_conditional '-1' M    ']' "\n" '['
# fi
}
function  set_prompt_last_not_found_cmd ()
{
  if [[ "$MAS_OLD_RESULT" -eq 1 ]]; then
    local lfile="$MAS_BASH_LOG/last_command_not_found.log"
    if [[ "$MAS_BASH_LOG" && -s "$lfile" ]] ; then
      set_prompt_color_by_id error_details
      set_prompt_string "$( head -1 "$lfile" | ${MAS_SED_CMD:=/bin/sed} -e 's@^.*:[[:space:]]\+@@' | cut -b-20 )"
    fi
  fi
}
function set_prompt_audio ()
{
  if [[ "$MAS_PROMPT_NUMLINE" -ge "$MAS_PS10LIMIT" ]] ; then
  # for PS1
    set_prompt_string "\[\a\]"
  else
    true
  fi
}
function set_prompt_smiley_result ()
{
  if shopt -q restricted_shell ; then
    set_prompt_color_by_id smiley
    set_prompt_string "R!"
  fi
  # Exit status - smiley
  if [[ "$MAS_OLD_RESULT" -eq 0 ]]; then
    set_prompt_color_by_id smiley
    set_prompt_string ":)"
  else 
    set_prompt_color_by_id result
    set_prompt_string "${MAS_OLD_RESULT}"
    set_prompt_color_by_id sad
    set_prompt_string ":("
  fi
}
function set_prompt_ruby ()
{
  set_prompt_color_by_id ruby
  if [[ "$TERM" =~ ^(screen\.|)(linux)$ ]] ; then
    set_prompt_string "(~)"
  elif [[ "$TERM" =~ ^(screen\.|)(rxvt.*)$ ]] ; then
    set_prompt_string "(x)"
  elif [[ "$TERM" =~ ^(screen\.|)(Eterm)$ ]] ; then
    set_prompt_string "(+)"
  else
    #set_prompt_string "x\[\e[D"
    case "$MAS_PROMPT_FLAGS" in
     0)
	set_prompt_string "◇"
	;;
     1)
	set_prompt_string "◑"
	;;
     2)
	set_prompt_string "◐"
	;;
     3)
	set_prompt_string "☻"
	;;
     4)
	set_prompt_string "▽"
	;;
     5)
	set_prompt_string "∷"
	;;
     6)
	set_prompt_string "△"
	;;
     7)
	set_prompt_string "◁"
	;;
     8)
	set_prompt_string "◊"
	;;
     9)
	set_prompt_string "◑"
	;;
    10)
	set_prompt_string "◐"
	;;
    11)
	set_prompt_string "⊃"
	;;
    12)
	set_prompt_string "⊂"
	;;
    13)
	set_prompt_string "⊂"
	;;
    14)
	set_prompt_string "⊂"
	;;
    15)
	set_prompt_string "⊂"
	;;      
    esac
    #set_prompt_string "\]"
  fi
}
function set_prompt_symbol ()
{
  if [[ "$MAS_OLD_RESULT" -eq 0 ]]; then
    set_prompt_color_by_id symbol
  else
    set_prompt_color_by_id sadsymbol
  fi
#     sh_count=$SHLVL
#     if [ -n "$MAS_SH_CORR" ] ; then
#       sh_count=$(( $sh_count - $MAS_SH_CORR ))
#     fi
#     if [ -n "$MAS_WM_RESTART_COUNT" ] ; then
#       sh_count=$(( $sh_count - $MAS_WM_RESTART_COUNT ))
#     fi
#     if [ -n "$MAS_WM_SHLVL" ] ; then
#       sh_count=$(( $sh_count - $MAS_WM_SHLVL + 1 ))
#     fi
  #sh_count=$(( ${SHLVL:-0} - ${MAS_SH_CORR:-0} - ${MAS_WM_SHLVL:-0} +1  ))
  if [[ "$MAS_PROMPT_OPTIONS" != *\$* ]] ; then
    set_prompt_string "$IGNOREEOF"
    set_prompt_dollar
  else
    sh_count=$(( ${SHLVL:-0} - ${MAS_SH_CORR:-0}  ))
    for (( sl=0 ; $sl - $sh_count ; sl++ )) ; do 
      set_prompt_dollar
    done	
  fi
}
function set_prompt_alternative ()
{
  set_prompt_color_by_id symbol
  set_prompt_string ">"
}
function mas_build_ps10_details ()
{
  local i
MAS_PROMPT_NUMLINE=0
MAS_ESCAPE_NP=''
#No:  MAS_PS10="${MAS_PS10}\n"
		      mas_prompt_conditional E          _eofsign             '&'
		      
		      mas_prompt_conditional M    "\n\n"
MAS_PROMPT_NUMLINE=$(( $MAS_PROMPT_NUMLINE + 1 ))

		      mas_prompt_conditional G          _geometry
		      mas_prompt_conditional v    ' '   _bash_version        ' '
		      mas_prompt_conditional o    '='   _prompt_options      '='
		      mas_prompt_conditional t    '('   _term                ')='
		      mas_prompt_conditional Y    '('   _ttys                ')'
[[ "$MAS_WINDOWID" ]] &&  mas_prompt_conditional X    ' '  _windowid
[[ "$MAS_WIN_TABNUMP" ]] &&  mas_prompt_conditional f    ' '  _tabidp
[[ "$MAS_WIN_TABNUMT" ]] &&  mas_prompt_conditional F    ' '  _tabidt
[[ "$MAS_WIN_TABNUMWS" ]] &&  mas_prompt_conditional g    ' '  _tabidws
  [[ "$WINDOW" ]] &&  mas_prompt_conditional R    '+'  _screen_windid
  [[ "$WINDOW" ]] &&  mas_prompt_conditional r    ' @ (' _screen_start_at ')'
		      mas_prompt_conditional M    "\n"
MAS_ESCAPE_NP='yes'
MAS_PROMPT_NUMLINE=$(( $MAS_PROMPT_NUMLINE + 1 ))
		      mas_prompt_conditional UHTD '['   _user_host_date_time ']'
		      mas_prompt_conditional u    ' ['  _terminal_emulator           ']'
		      mas_prompt_conditional w    ' ['  _workspace           ']'
[[ "$MAS_OLD_RESULT" -eq 1 && -s "$MAS_BASH_LOG/last_command_not_found.log" ]] \
		&& mas_prompt_conditional e  '                      ? ['  _last_not_found_cmd ' ...]'
		      mas_prompt_conditional M    "\n"
MAS_PROMPT_NUMLINE=$(( $MAS_PROMPT_NUMLINE + 1 ))
		      
		      mas_prompt_conditional V          _shlvl
		      mas_prompt_conditional N          _cmdnum              '&'
		      mas_prompt_conditional SWi  '[ '  _seconds_seconds_pid '] '
		      mas_prompt_conditional B          _ruby
		      mas_prompt_conditional M    "\n"
MAS_PROMPT_NUMLINE=$(( $MAS_PROMPT_NUMLINE + 1 ))
                                   mas_prompt_conditional c '[' _workdir_psl '] ' \
		      		|| \
				   mas_prompt_conditional W '[' _workdir '] ' \
				|| \
				   mas_prompt_conditional d '[' _workdir_ps '] '

		      mas_prompt_conditional L          _smiley_result
		      mas_prompt_conditional p    ' '   _symbol ' ' || mas_prompt_conditional a _alternative ' '
		      mas_prompt_conditional A          _audio

}
return 0
