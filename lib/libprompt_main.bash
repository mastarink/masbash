#  mas_loadlib_if_not set_prompt_reset_colors prompt
mas_get_lib_ifnot prompt set_prompt_reset_colors

mas_get_lib_ifnot time datemt
export MASPROMPT_TIME_LIBPROMPT_MAIN=$(datemt)

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
  #export MASPROMPT_OPTIONS='EBGYUHDTPSRrWdcNLOV$wivpaAoM'
  # ON all:
  

  #########################################################################################################
  if false \
     || [[ "$MASPROMPT_PS10PWD" != "$PWD"                        ]] \
     || [[ "$MASPROMPT_GEOMETRY" != "${COLUMNS}x${LINES}" ]] \
     || [[ "$mas_new_result" -ne "$MASPROMPT_OLD_RESULT"         ]] \
     || [[ "$MASPROMPT_I_WS" != "$MASPROMPT_OLD_WS"                    ]] \
     || [[ "$SECONDS" -gt "$MASPROMPT_SECONDS_OLD"               ]] \
     ; then
#  echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>> [$MASPROMPT_PS10PWD : $PWD] [$MASPROMPT_GEOMETRY : ${COLUMNS}x${LINES}] [$mas_new_result : $MASPROMPT_OLD_RESULT] [$MASPROMPT_I_WS : $MASPROMPT_OLD_WS] [$MASPROMPT_DSECONDS0 : $MASPROMPT_DSECONDS0_OLD] RESET" >&2
   #echo "'$MASPROMPT_PS10PWD'" >&2
   #echo "'$PWD'" >&2
    MASPROMPT_PS10PWD=$PWD
    MASPROMPT_GEOMETRY="${COLUMNS}x${LINES}"
    MASPROMPT_OLD_RESULT=$mas_new_result
    MASPROMPT_OLD_WS=$MASPROMPT_I_WS
    MASPROMPT_SECONDS_OLD=$(( $SECONDS + 1 ))
    unset MASPROMPT_PS10
    unset MASPROMPT_APS10
  #else
    #echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>> NO reset $MASPROMPT_DSECONDS0_OLD ? $MASPROMPT_DSECONDS0 " >&2
  fi
  # MASPROMPT_MAXLENGTH >= 14
  MASPROMPT_PWD_OFFSET=4
  MASPROMPT_MAXLENGTH="24"
  MASPROMPT_MINHOMELENGTH="15"

  if [ $MASPROMPT_MAXLENGTH -lt $((10 + $MASPROMPT_PWD_OFFSET)) ] ; then
    MASPROMPT_MAXLENGTH=$((10 + $MASPROMPT_PWD_OFFSET))
  fi
  if [ $(( $MASPROMPT_MAXLENGTH * 3 )) -lt ${#MASPROMPT_PS10PWD} ] ; then
    MASPROMPT_MAXLENGTH=$(( ${#MASPROMPT_PS10PWD} / 3 ))
  fi
    #MASPROMPT_MAXLENGTH=$((40 + $MASPROMPT_PWD_OFFSET))
  half="$(($MASPROMPT_MAXLENGTH/2))"
#   if [ ${#MASPROMPT_PS10PWD} -ge $(($minlength)) ] ; then
#     MASPROMPT_PS10PWD=$(echo "$MASPROMPT_PS10PWD" | /bin/sed s/\\/home\\/$USER/~/)
#   fi
  if [[ "$MASPROMPT_SHN_PROJECTS_DIR" ]] && [[ "$MASPROMPT_PS10PWD" =~ ^${MASPROMPT_SHN_PROJECTS_DIR}(.*)$ ]] ; then
    MASPROMPT_PS10PWDS="{$(basename $(realpath ${MASPROMPT_SHN_PROJECTS_DIR}/..))}${BASH_REMATCH[1]}"
  elif [ ${#MASPROMPT_PS10PWD} -gt $(($MASPROMPT_MAXLENGTH)) ] ; then    
    MASPROMPT_PS10PWDS=$( echo "${MASPROMPT_PS10PWD:0:$(($half-$MASPROMPT_PWD_OFFSET))}...${MASPROMPT_PS10PWD:$((${#MASPROMPT_PS10PWD}-$half-3-$MASPROMPT_PWD_OFFSET)):$half+3+$MASPROMPT_PWD_OFFSET}" )
  else
    MASPROMPT_PS10PWDS=$MASPROMPT_PS10PWD
  fi
  #if [ -z "MASPROMPT_UNAME" ] ; then
  # export MASPROMPT_UNAME
  # MASPROMPT_UNAME=`uname -a`
  #fi

# if [ -z "MASPROMPT_MDATE" ] ; then
#  export MASPROMPT_MDATE
#  MASPROMPT_MDATE=`/bin/date +%a` `/bin/date +%T`
# fi

  mdate="`/bin/date '+%a %T'`"
  #mdate=$MASPROMPT_MDATE


  export MASPROMPT_FLAGS=0
  if [[ -v MASPROMPT_NODEBUG && -n "$MASPROMPT_NODEBUG" ]] ; then
    MASPROMPT_FLAGS=$(( $MASPROMPT_FLAGS | 1 ))
  fi
  if [[ -v MASPROMPT_NOWARNINGS && -n "$MASPROMPT_NOWARNINGS" ]] ; then
    MASPROMPT_FLAGS=$(( $MASPROMPT_FLAGS | 2 ))
  fi
  if [[ -v MASPROMPT_NOLOG && -n "$MASPROMPT_NOLOG" ]] ; then
    MASPROMPT_FLAGS=$(( $MASPROMPT_FLAGS | 4 ))
  fi
  if [[ -v MASPROMPT_DEBUG && -n "$MASPROMPT_DEBUG" ]] ; then
    if [ "$MASPROMPT_DEBUG" -gt 0 ] ; then
      MASPROMPT_FLAGS=$(( $MASPROMPT_FLAGS | 8 ))
    fi
  fi

  MASPROMPT_HOSTNAME=${MASPROMPT_HOSTNAME:-$(/bin/hostname)}
  if ! [[ "$MASPROMPT_PS10" ]] ; then
    #MASPROMPT_PS10="X$whooo"
    MASPROMPT_PS10=""
  # character set on some terminals
#   MASPROMPT_PS10="${MASPROMPT_PS10}"'\e[10m' # ???
#   set_prompt_string '\e[10m'
    mas_build_ps10_details 
  fi
# echo "$PS10" >/tmp/ps10.tmp
}

function mas_prompt1 ()
{
  export MASPROMPT_TERM=${MAS_TERM:-$TERM}
  local mas_new_result='' MASPROMPT_DATE2 i
  local prompt_window prompt_mas_pname before after
  
  declare -p MAS_COLORS >/dev/null 2>&1 || declare -Axg MAS_COLORS
  declare -p MAS_BGCOLORS >/dev/null 2>&1 || declare -Axg MAS_BGCOLORS
  declare -p MAS_DECORS >/dev/null 2>&1 || declare -Axg MAS_DECORS


  mas_get_lib_ifnot colors mas_init_colors

  if ! [[ "${MAS_COLORS[@]}" && "${MAS_BGCOLORS[@]}" && "${MAS_DECORS[@]}" ]] ; then
    mas_init_colors
  fi
  PROMPT_DIRTRIM=4
  MASPROMPT_PSECONDS=${MASPROMPT_PSECONDS:-$SECONDS}
  
  mas_new_result="$1"
  shift

  export MASPROMPT_I_WS=${MAS_I_WS:-${MAS_DESKTOP_NAME}}
 #if [[ -z "$MASPROMPT_PSECONDS" ]] ; then export MASPROMPT_PSECONDS=$SECONDS ; fi
 #export MASPROMPT_DSECONDS0=$(( $SECONDS - $MASPROMPT_PSECONDS ))
  #export MASPROMPT_pDSECONDS=`printf '%03d' $MASPROMPT_DSECONDS0`

  if [[ -v WINDOW ]] ; then  prompt_window="$WINDOW" ; else prompt_window='' ; fi
  if [[ -v MASPROMPT_PNAME ]] ; then prompt_mas_pname="$MASPROMPT_PNAME" ; else prompt_mas_pname='' ; fi

  if ! [[ "$mas_new_result" ]] ; then mas_new_result=$? ; fi
  local whooo='+' 
  local half mdate sl tt
# cg_ws

# if [ -n "$WM" -a "$WM" == awesome -a -s $awe_status_dir/shlvl ] ; then
#  export MASPROMPT_PREV_SHLVL=`cat $awe_status_dir/shlvl`
# fi

  if [ "x$whooo" == "x" ] ; then
    PS1='> '
  elif [[ "$MASPROMPT_PS1" ]] ; then
    PS1=$MASPROMPT_PS1
  else
    if [[ -z "$MASPROMPT_OPTIONS" ]] ; then export MASPROMPT_OPTIONS='' ; fi

    mas_build_ps10

    #########################################################################################################
    # ???   cd .
    #alias ee1='echo "[`pwd`]"'
    MASPROMPT_PS10LIMIT=2
    before=''
    after=''
    for (( i=0 ; $i < $MASPROMPT_PS10LIMIT ; i++ )) ; do
      before="${before}${MASPROMPT_APS10[$i]}"
    done
    for (( i=$MASPROMPT_PS10LIMIT ; $i < ${#MASPROMPT_APS10[@]} ; i++ )) ; do
      after="${after}${MASPROMPT_APS10[$i]}"
    done
    echo -ne "${before}"
#   echo -ne "<(<${after}>)> :: $TERM :: [$MASPROMPT_USE_PS1]"
    if [[ "$MASPROMPT_USE_PS1" ]] ; then
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
	screen -S $STY -X title "$STY @ $prompt_mas_pname @ $mdate @ $MASPROMPT_PS10PWD"
	if [ -n "$MASPROMPT_PNUM" ] ; then
	  screen -S $STY -X number "$MASPROMPT_PNUM"
	else
	  export MASPROMPT_PNUM=`echo $prompt_mas_pname|/bin/sed -r 's/^[^0-9]*([0-9]+)$/\1/'`
	fi
	echo -ne "\e]2;"'\e\\'
      else
      # Window title (slows down!) :
      #if [ $MASPROMPT_pDSECONDS -gt 0 ] ; then 
	col=$(($COLUMNS-12))
	echo -ne "\e]2;[ $MASPROMPT_WINDOWID $prompt_mas_pname @ $mdate @ $MASPROMPT_PS10PWD ]"'\e\\'
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
	  if [ "$MASPROMPT_DSECONDS0" -gt 10 ] ; then
	     tt="$tt+"
	  else
	     tt="$tt-"
	  fi
	  export MASPROMPT_I_WS=${MAS_I_WS:-${MAS_DESKTOP_NAME}}
	  export MASPROMPT_GTERM_WORKSPACE=$MASPROMPT_I_WS
	  if [ -n "${MASPROMPT_GTERM_WORKSPACE}" ] ; then tt="$tt(${MASPROMPT_GTERM_WORKSPACE})" ; fi
	  if [[ -v MASPROMPT_PSET_NAME && -n "${MASPROMPT_PSET_NAME}" ]] ; then tt="$tt.${MASPROMPT_PSET_NAME}" ; fi
	  if [ -n "${prompt_mas_pname}" ] ; then tt="$tt:${prompt_mas_pname}" ; fi
	  tt="$tt id$MASPROMPT_WINDOWID $mdate"'\e\\'
	  echo -ne $tt
	fi
      fi
    fi
#   if [ -z "$MASPROMPT_COUNT" ] ; then
#     mas_logger Set prompt first time
#     mas_logger "TERM:$TERM"
#   fi
    export MASPROMPT_STY="${MASPROMPT_SCREEN_SESSION}"
    MASPROMPT_STY="${STY:-${MASPROMPT_STY}}"



    #PS1="\[\033[0m\]\[\033[1;31m\](\[\033[0m\]\[\033[0;35m\]\u\[\033[0m\]\[\033[1;31m\]@\[\033[0m\]\[\033[0;35m\]\h\[\033[0m\]\[\033[1;31m\])\[\033[0m\]\[\033[1;37m\]--\[\033[0m\]\[\033[1;31m\](\[\033[0m\]\[\033[0;35m\]\${PWD}\[\033[0m\]\[\033[1;31m\]:\[\033[0m\]\[\033[0;35m\]\$(ls -l | grep \"^-\" | /usr/bin/wc -l | tr -d \" \")\[\033[0m\]\[\033[1;31m\]/\[\033[0m\]\[\033[0;35m\]\$(ls --si -s | /usr/bin/head -1 | /usr/bin/awk '{print \$2}')\[\033[0m\]\[\033[1;31m\])\[\033[0m\]\[\033[1;37m\]-\n(\[\033[0m\]\[\033[0;35m\]\!\[\033[0m\]\[\033[1;37m\])\[\033[0m\]\[\033[1;31m\]\$ \[\033[0m\]"
    #unset PS1
    # /bin/date +%Y%m%d.%H%M%S >> $MASPROMPT_BASH_LOG/prompt_log
    export MASPROMPT_COUNT=$(($MASPROMPT_COUNT + 1))
#   if ! [[ "$MASPROMPT_USE_PS1" ]] ; then
#     echo -ne "$MASPROMPT_PS10\e[-1;100H"
#   fi
  fi
  if [[ "$MASPROMPT_USE_PS1" ]] ; then
    if ! [[ "$PS1" ]] ; then
      PS1='?>'
    fi
  fi
  MASPROMPT_PSECONDS=${SECONDS:-0}
  PS1=$( echo $PS1|sed -n -e 's@\\\]\\\[@@pg' )

# mas_loadlib_if_not mas_set_keyboard service
  mas_get_lib_ifnot service mas_set_keyboard
  if ! mas_set_keyboard ; then
    echo "ERROR mas_set_keyboard ($XAUTHORITY)" >&2
    if [[ "$XAUTHORITY" ]] && [[ -f "/home/mastar/.Xauthority" ]] ; then
      /bin/cp "/home/mastar/.Xauthority" "$XAUTHORITY" && mas_set_keyboard
    else
      ${MAS_LS_CMD:-/bin/ls} -l "$XAUTHORITY"
      ${MAS_LS_CMD:-/bin/ls} -l "/home/mastar/.Xauthority"
    fi
  fi
}
function mas_prompt ()
{
# SSH_CLIENT='192.168.71.2 38786 22'
# SSH_CONNECTION='192.168.71.2 38786 192.168.71.70 22'
# SSH_TTY=/dev/pts/21

  if [[ "$SSH_CONNECTION" ]] ; then
    PS1='\w \$ '
  else
    mas_prompt1 $*
  fi
}
return 0
