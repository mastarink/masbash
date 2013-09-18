#  mas_loadlib_if_not set_prompt_reset_colors prompt
mas_get_lib_ifnot prompt set_prompt_reset_colors

# mas_loadlib_if_not datemt time
mas_get_lib_ifnot time datemt
export MAS_TIME_LIBPROMPT_MAIN=$(datemt)

function mas_build_ps10 ()
{
  # a - alternative >
  # A - audio
  # B - 'ruby'
  # c - working dir \w ; workdir
  # d - a working dir \W ; workdir
  # D - date
  # E - 'eof'
  # e - 'error : last not found command'
  # f - tab # p
  # F - tab # t
  # G - dimensions / geometry
  # g - tab # ws
  # H - host
  # i - shell pid
  # L - smiley
  # M - multiline
  # N - command number
  # O - oneline
  # o - prompt_options
  # P - pname
  # p - prompt symbol $/#
  # r - screen start at (screen)
  # R - window id (screen)
  # $ - ... SHLVL
  # S - seconds
  # t - $TERM
  # T - time
  # u - terminal emulator guess
  # U - user
  # v - bash version
  # V - SHLVL
  # W - working dir ; workdir
  # w - workspace
  # X - windowid
  # Y - $STY / tty

  # OFF all: (quoted due to dollar)
  #export MAS_PROMPT_OPTIONS='EBGYUHDTPSRrWdcNLOV$wivpaAoM'
  # ON all:
  

  #########################################################################################################
  if false \
     || [[ "$MAS_PS10PWD" != "$PWD"                        ]] \
     || [[ "$MAS_PROMPT_GEOMETRY" != "${COLUMNS}x${LINES}" ]] \
     || [[ "$mas_new_result" -ne "$MAS_OLD_RESULT"         ]] \
     || [[ "$MAS_I_WS" != "$MAS_OLD_WS"                    ]] \
     || [[ "$SECONDS" -gt "$MAS_SECONDS_OLD"               ]] \
     ; then
#  echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>> [$MAS_PS10PWD : $PWD] [$MAS_PROMPT_GEOMETRY : ${COLUMNS}x${LINES}] [$mas_new_result : $MAS_OLD_RESULT] [$MAS_I_WS : $MAS_OLD_WS] [$MAS_DSECONDS0 : $MAS_DSECONDS0_OLD] RESET" >&2
   #echo "'$MAS_PS10PWD'" >&2
   #echo "'$PWD'" >&2
    MAS_PS10PWD=$PWD
    MAS_PROMPT_GEOMETRY="${COLUMNS}x${LINES}"
    MAS_OLD_RESULT=$mas_new_result
    MAS_OLD_WS=$MAS_I_WS
    MAS_SECONDS_OLD=$(( $SECONDS + 1 ))
    unset MAS_PS10
    unset MAS_APS10
  #else
    #echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>> NO reset $MAS_DSECONDS0_OLD ? $MAS_DSECONDS0 " >&2
  fi
  # MAS_MAXLENGTH >= 14
  MAS_PWD_OFFSET=4
  MAS_MAXLENGTH="24"
  MAS_MINHOMELENGTH="15"

  if [ $MAS_MAXLENGTH -lt $((10 + $MAS_PWD_OFFSET)) ] ; then
    MAS_MAXLENGTH=$((10 + $MAS_PWD_OFFSET))
  fi
  if [ $(( $MAS_MAXLENGTH * 3 )) -lt ${#MAS_PS10PWD} ] ; then
    MAS_MAXLENGTH=$(( ${#MAS_PS10PWD} / 3 ))
  fi
    #MAS_MAXLENGTH=$((40 + $MAS_PWD_OFFSET))
  half="$(($MAS_MAXLENGTH/2))"
#   if [ ${#MAS_PS10PWD} -ge $(($minlength)) ] ; then
#     MAS_PS10PWD=$(echo "$MAS_PS10PWD" | /bin/sed s/\\/home\\/$USER/~/)
#   fi
  if [ ${#MAS_PS10PWD} -gt $(($MAS_MAXLENGTH)) ] ; then    
    MAS_PS10PWDS=$( echo "${MAS_PS10PWD:0:$(($half-$MAS_PWD_OFFSET))}...${MAS_PS10PWD:$((${#MAS_PS10PWD}-$half-3-$MAS_PWD_OFFSET)):$half+3+$MAS_PWD_OFFSET}" )
  else
    MAS_PS10PWDS=$MAS_PS10PWD
  fi
  #if [ -z "MAS_UNAME" ] ; then
  # export MAS_UNAME
  # MAS_UNAME=`uname -a`
  #fi

# if [ -z "MAS_MDATE" ] ; then
#  export MAS_MDATE
#  MAS_MDATE=`/bin/date +%a` `/bin/date +%T`
# fi

  mdate="`/bin/date '+%a %T'`"
  #mdate=$MAS_MDATE


  export MAS_PROMPT_FLAGS=0
  if [[ -v MAS_NODEBUG && -n "$MAS_NODEBUG" ]] ; then
    MAS_PROMPT_FLAGS=$(( $MAS_PROMPT_FLAGS | 1 ))
  fi
  if [[ -v MAS_NOWARNINGS && -n "$MAS_NOWARNINGS" ]] ; then
    MAS_PROMPT_FLAGS=$(( $MAS_PROMPT_FLAGS | 2 ))
  fi
  if [[ -v MAS_NOLOG && -n "$MAS_NOLOG" ]] ; then
    MAS_PROMPT_FLAGS=$(( $MAS_PROMPT_FLAGS | 4 ))
  fi
  if [[ -v MAS_DEBUG && -n "$MAS_DEBUG" ]] ; then
    if [ "$MAS_DEBUG" -gt 0 ] ; then
      MAS_PROMPT_FLAGS=$(( $MAS_PROMPT_FLAGS | 8 ))
    fi
  fi

  if [ -z "$MAS_HOSTNAME" ] ; then
    export MAS_HOSTNAME
    MAS_HOSTNAME=$(/bin/hostname)
  fi
  if ! [[ "$MAS_PS10" ]] ; then
    #MAS_PS10="X$WHOOO"
    MAS_PS10=""
  # character set on some terminals
#   MAS_PS10="${MAS_PS10}"'\e[10m' # ???
#   set_prompt_string '\e[10m'
    mas_build_ps10_details 
  fi
# echo "$PS10" >/tmp/ps10.tmp
}
function mas_prompt ()
{
  export MAS_TERM=$TERM
  local mas_new_result='' MAS_DATE2 i
  local prompt_window prompt_mas_pname before after
  
  declare -p MAS_COLORS >/dev/null 2>&1 || declare -Axg MAS_COLORS
  declare -p MAS_BGCOLORS >/dev/null 2>&1 || declare -Axg MAS_BGCOLORS
  declare -p MAS_DECORS >/dev/null 2>&1 || declare -Axg MAS_DECORS


# mas_loadlib_if_not mas_init_colors colors
  mas_get_lib_ifnot colors mas_init_colors
# mas_loadlib_if_not  mas_source_clean_pid2 regbash
# mas_loadlib_if_not  mas_source_register_pid2 regbash
# mas_source_register_pid2 PROMPT

  if ! [[ "${MAS_COLORS[@]}" && "${MAS_BGCOLORS[@]}" && "${MAS_DECORS[@]}" ]] ; then
    mas_init_colors
  fi
  PROMPT_DIRTRIM=4
  MAS_PSECONDS=${MAS_PSECONDS:-$SECONDS}
  
  mas_new_result="$1"
  shift

  export MAS_I_WS=${MAS_I_WS:-${MAS_DESKTOP_NAME}}
 #if [[ -z "$MAS_PSECONDS" ]] ; then export MAS_PSECONDS=$SECONDS ; fi
 #export MAS_DSECONDS0=$(( $SECONDS - $MAS_PSECONDS ))
  #export MAS_pDSECONDS=`printf '%03d' $MAS_DSECONDS0`

  if [[ -v WINDOW ]] ; then  prompt_window="$WINDOW" ; else prompt_window='' ; fi
  if [[ -v MAS_PNAME ]] ; then prompt_mas_pname="$MAS_PNAME" ; else prompt_mas_pname='' ; fi

  if [ -z "$mas_new_result" ] ; then mas_new_result=$? ; fi

  local WHOOO='+' 
  local half mdate sl tt
# cg_ws

# if [ -n "$WM" -a "$WM" == awesome -a -s $awe_status_dir/shlvl ] ; then
#  export MAS_PREV_SHLVL=`cat $awe_status_dir/shlvl`
# fi

  if [ "x$WHOOO" == "x" ] ; then
    PS1='> '
  elif [[ "$MAS_PS1" ]] ; then
    PS1=$MAS_PS1
  else
    if [[ -z "$MAS_PROMPT_OPTIONS" ]] ; then export MAS_PROMPT_OPTIONS='' ; fi

    mas_build_ps10

    #########################################################################################################
    # ???   cd .
    #alias ee1='echo "[`pwd`]"'
    MAS_PS10LIMIT=2
    before=''
    after=''
    for (( i=0 ; $i < $MAS_PS10LIMIT ; i++ )) ; do
      before="${before}${MAS_APS10[$i]}"
    done
    for (( i=$MAS_PS10LIMIT ; $i < ${#MAS_APS10[@]} ; i++ )) ; do
      after="${after}${MAS_APS10[$i]}"
    done
    echo -ne "${before}"
    if [[ "$MAS_USE_PS1" ]] ; then
#     if   [[ "$TERM" == 'xterm' ]]                     ; then  PS1="${after}"
#     elif [[ "$TERM" == 'xterm-color' ]]               ; then  PS1="${after}"
#     elif [[ "$TERM" =~ ^(rxvt-unicode|rxvt|Eterm)$ ]] ; then  PS1="${after}"
#     elif [[ "$TERM" == 'linux' ]]                     ; then  PS1="${after}"
#     elif [[ "$TERM" =~ ^(screen|screen.rxvt|screen.Eterm)$ ]]      ; then  PS1="${after}"
#     elif [[ "$TERM" == 'dumb' ]]                      ; then  PS1="\h > "
#     elif [[ -z "$TERM" ]]                             ; then  PS1="\h ?> "
#     else                                                      PS1="\h $TERM >"
#     fi
      case "$TERM" in
        xterm|xterm-color)
	 PS1="${after}"
	;;
        screen.rxvt|rxvt|screen.rxvt-unicode|rxvt-unicode|screen.Eterm|Eterm|screen)
	 PS1="${after}"
	;;
        screen.linux|linux)
	 PS1="${after}"
	;;
        dumb)
	 PS1="\h > "
	;;
        *)
	 if [[ "$TERM" ]] ; then
	   PS1="\h $TERM > "
         else  
	   PS1="\h ?> "
         fi
	;;
      esac
    fi

    if false ; then
      if [ -v STY && -n "$STY" ] ; then 
	screen -S $STY -X title "$STY @ $prompt_mas_pname @ $mdate @ $MAS_PS10PWD"
	if [ -n "$MAS_PNUM" ] ; then
	  screen -S $STY -X number "$MAS_PNUM"
	else
	  export MAS_PNUM=`echo $prompt_mas_pname|/bin/sed -r 's/^[^0-9]*([0-9]+)$/\1/'`
	fi
	echo -ne "\e]2;"'\e\\'
      else
      # Window title (slows down!) :
      #if [ $MAS_pDSECONDS -gt 0 ] ; then 
	col=$(($COLUMNS-12))
	echo -ne "\e]2;[ $MAS_WINDOWID $prompt_mas_pname @ $mdate @ $MAS_PS10PWD ]"'\e\\'
      #  echo -ne "\e[s\e[2;${col}f${mdate}\e[u"
      #fi
      fi
    fi

    if false ; then
      if [ "$TERM" == "xterm" ] ; then
  #      if [ "$SECONDS" -gt 30 ] ; then
	if [ "$SECONDS" -gt 3 ] ; then
	  # "window" title
	  if [[ -v STY ]] ; then
	    tt='\e]2;'"${STY} gT ${$}"
	  else
	    tt='\e]2;'" gT ${$}"	    
	  fi
	  if [ "$MAS_DSECONDS0" -gt 10 ] ; then
	     tt="$tt+"
	  else
	     tt="$tt-"
	  fi
	  export MAS_I_WS=${MAS_I_WS:-${MAS_DESKTOP_NAME}}
	  export MAS_GTERM_WORKSPACE=$MAS_I_WS
	  if [ -n "${MAS_GTERM_WORKSPACE}" ] ; then tt="$tt(${MAS_GTERM_WORKSPACE})" ; fi
	  if [[ -v MAS_PSET_NAME && -n "${MAS_PSET_NAME}" ]] ; then tt="$tt.${MAS_PSET_NAME}" ; fi
	  if [ -n "${prompt_mas_pname}" ] ; then tt="$tt:${prompt_mas_pname}" ; fi
	  tt="$tt id$MAS_WINDOWID $mdate"'\e\\'
	  echo -ne $tt
	fi
      fi
    fi
#   if [ -z "$MAS_PROMPT_COUNT" ] ; then
#     mas_logger Set prompt first time
#     mas_logger "TERM:$TERM"
#   fi
    export MAS_PROMPT_STY="${MAS_SCREEN_SESSION}"
    MAS_PROMPT_STY="${STY:-${MAS_PROMPT_STY}}"



    #PS1="\[\033[0m\]\[\033[1;31m\](\[\033[0m\]\[\033[0;35m\]\u\[\033[0m\]\[\033[1;31m\]@\[\033[0m\]\[\033[0;35m\]\h\[\033[0m\]\[\033[1;31m\])\[\033[0m\]\[\033[1;37m\]--\[\033[0m\]\[\033[1;31m\](\[\033[0m\]\[\033[0;35m\]\${PWD}\[\033[0m\]\[\033[1;31m\]:\[\033[0m\]\[\033[0;35m\]\$(ls -l | grep \"^-\" | /usr/bin/wc -l | tr -d \" \")\[\033[0m\]\[\033[1;31m\]/\[\033[0m\]\[\033[0;35m\]\$(ls --si -s | /usr/bin/head -1 | /usr/bin/awk '{print \$2}')\[\033[0m\]\[\033[1;31m\])\[\033[0m\]\[\033[1;37m\]-\n(\[\033[0m\]\[\033[0;35m\]\!\[\033[0m\]\[\033[1;37m\])\[\033[0m\]\[\033[1;31m\]\$ \[\033[0m\]"
    #unset PS1
    # /bin/date +%Y%m%d.%H%M%S >> $MAS_BASH_LOG/prompt_log
    export MAS_PROMPT_COUNT=$(($MAS_PROMPT_COUNT + 1))
#   if ! [[ "$MAS_USE_PS1" ]] ; then
#     echo -ne "$MAS_PS10\e[-1;100H"
#   fi
  fi
  if [[ "$MAS_USE_PS1" ]] ; then
    if ! [[ "$PS1" ]] ; then
      PS1='?>'
    fi
  fi
  MAS_PSECONDS=${SECONDS:-0}
  PS1=$( echo $PS1|sed -n -e 's@\\\]\\\[@@pg' )

# mas_loadlib_if_not mas_set_keyboard service
  mas_get_lib_ifnot service mas_set_keyboard
  if ! mas_set_keyboard ; then
    echo "ERROR mas_set_keyboard ($XAUTHORITY)" >&2
    if [[ "$XAUTHORITY" ]] && [[ -f "/home/mastar/.Xauthority" ]] ; then
      /bin/cp "/home/mastar/.Xauthority" "$XAUTHORITY" && mas_set_keyboard
    else
      ${MAS_LS_CMD:=/bin/ls} -l "$XAUTHORITY"
      ${MAS_LS_CMD:=/bin/ls} -l "/home/mastar/.Xauthority"
    fi
  fi
}
return 0
