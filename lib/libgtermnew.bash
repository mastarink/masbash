mas_get_lib notify mas_notify
if [[ "$HOME" ]] && [[ -f ${MAS_ETC_BASH:=/etc/mastar/shell/bash}/.topparamfuncs ]] ; then
  . ${MAS_ETC_BASH:=/etc/mastar/shell/bash}/.topparamfuncs

# use $MAS_DESKTOP_NAME $UID $USER $USERNAME  
# set terminal_bin, class, role, profile, execute
# terminal_bin=gnome-terminal
#	--profile
#	--show-menubar /--hide-menubar
#	--full-screen
#	--geometry
#	--tab --tab / --active / --command / --working-directory / --zoom
#	--role
#	--class
#	--name
#	--command
#	--disable-factory ???
# terminal_bin=Terminal
#	--show-menubar /--hide-menubar
#	--show-borders /--hide-borders
#	--show-toolbars /--hide-toolbars
#	--fullscreen
#	--tab --tab / --working-directory / --command
#	--command
#	--working-directory
# -------------------
# profile= "wsp-<desktop name>"
# class=masGtermws
# role=gtermws
# -------------------

function mas_gterminal ()
{
  local cmd log_to
  
  cmd='sg mastar-gterm ''"'"${MAS_GTERM_CMD:-gnome-terminal} &"'"'
# cmd="${MAS_GTERM_CMD:-gnome-terminal} &"
  unset STY
  #echo "3-=-= $cmd" >> $MAS_BASH_LOG/otherapps/geom-prof$UID.txt
  MAS_LOGDIR_OTHER=${MAS_BASH_LOG:=${MAS_DIR:=$HOME/.mas}/log}/otherapps
  log_to=$MAS_LOGDIR_OTHER/my_gterm
  #echo "CMD: [$cmd]"
  #exit
  echo "Start: `date`" >> $log_to
  echo $cmd >> $log_to
  #	--tab-with-profile=mastar \
  #gnome-terminal --name 'masworkterminal' --disable-factory --window-with-profile=mastar --tab-with-profile=mastar --geometry=
  if gconftool-2 --ping ; then  true > /dev/null ; else  /usr/bin/gconftool-2 --spawn ; fi
  if true ; then
    date >/tmp/gtermcmd.txt
    #echo "wsg:`mywmws  2>&1` = $?" >>/tmp/gtermcmd.txt
#   mas_loadlib_if_not mywmwsWow wm
#   echo "WS:'`mas_this_win_ws_sawfish_q 2>&1`' = $?" >>/tmp/gtermcmd.txt
#   echo "WS1:'`mas_this_win_ws_sawfish 2>&1`' = $?" >>/tmp/gtermcmd.txt
#   echo "ws0:'`mywmws_sawfish_wid 2>&1`' = $?" >>/tmp/gtermcmd.txt
#   echo "ws1:'`mywmws_sawfish_curr 2>&1`' = $?" >>/tmp/gtermcmd.txt
#   echo "ws2:'`mywmws_wmctrl 2>&1`' = $?" >>/tmp/gtermcmd.txt
#   echo "ws3:'`mywmws_tty 2>&1`' = $?" >>/tmp/gtermcmd.txt
#   echo "wsg:'`mywmws  2>&1`' = $?" >>/tmp/gtermcmd.txt
    #echo $? >>/tmp/gtermcmd.txt
    #echo "ws:`mas_this_win_ws_sawfish_q 2>&1`" >>/tmp/gtermcmd.txt
    #echo $? >>/tmp/gtermcmd.txt
    #mas_this_win_ws_sawfish_q >>/tmp/gtermcmd.txt  2>&1
    #echo $? >>/tmp/gtermcmd.txt
##  type mywmws >&2
##  echo "TERM: '$TERM'" >&2
##  echo "MAS_GTERM_WORKSPACE: ${MAS_GTERM_WORKSPACE:=$( mywmws )}" >&2
##  echo ":1: '$( mywmws )'" >&2
##  echo ":2: '$( xdotool get_desktop )'" >&2
##  echo ":3: '$( mywmws_wmctrl )'" >&2
##  echo ":4: '$( mywmws_sawfish_curr )'" >&2
##  echo ":5: '$( mywmws_sawfish_wid )'" >&2
##  echo ":6: '$( mywmws )'" >&2
#   echo "$cmd" >>/tmp/gtermcmd.txt
#   echo "$cmd" >&2
    mas_notify gterm "$MAS_GTERM_CMD"
    eval $cmd  >>/tmp/gtermcmd.txt 2>&1
  else
    echo $cmd
  fi
}
function mas_genterminal ()
{
  local ko val
  declare -gx MAS_GTERMO_EVC
  if [[ "$MAS_GTERMO_BINNAME" ]] ; then MAS_GTERMO_BIN=`which $MAS_GTERMO_BINNAME` ; fi
  if [[ "$MAS_GTERMO_BIN" ]] ; then
    MAS_GTERMO_EVC=$MAS_GTERMO_BIN
    for ko in ${!MAS_GTERMOPTS[@]} ; do
      val="${MAS_GTERMOPTS[$ko]}"
      if [[ "$val" ]] ; then MAS_GTERMO_EVC="$MAS_GTERMO_EVC ${MAS_GTERMO_OPTPREF:---}${ko}${MAS_GTERMO_OPTEQ:-=}'${val}'" ; fi
    done
    for ko in ${!MAS_GTERMOPTSPLUS[@]} ; do
      val="${MAS_GTERMOPTSPLUS[$ko]}"
      if [[ "$val" ]] ; then MAS_GTERMO_EVC="$MAS_GTERMO_EVC ${MAS_GTERMO_OPTPREF:--}${ko}${MAS_GTERMO_OPTEQ:-=}'${val}'" ; fi
    done
    if [[ "$MAS_GTERMO_CAN_TABS" ]] ; then
      for ko in ${MAS_GTERMO_TABS[@]} ; do
	MAS_GTERMO_EVC="$MAS_GTERMO_EVC ${MAS_GTERMO_CAN_TABS}${MAS_GTERMO_OPTEQ:-=}${MAS_GTERMO_PROJECT}/${ko}"
      done
    fi
    MAS_GTERMO_EVC="sg ${MAS_GTERMO_GROUP:=mastar-gterm} "'"'"${MAS_GTERMO_EVC:-gnome-terminal} &"'"'" # $(datemt) $(tty) - $- - ${MAS_DESKTOP_NAME}"
  # echo ">>> [${#MAS_GTERMOPTS[@]}]  $MAS_GTERMO_EVC"
  # echo "[${#MAS_GTERMOPTS[@]}]  $MAS_GTERMO_EVC" >&2
    if [[ "$MAS_GTERMO_EVC" ]] ; then
      mas_notify gterm "command: [${MAS_GTERMO_EVC}]"
      mas_notify + "GT" "... ... [${MAS_GTERMO_EVC}]"
      echo "[MAS_GTERMO_PROJECT: $MAS_GTERMO_PROJECT]" >> /tmp/gtermnew.tmp
      echo "[MAS_DEVELOP_DIR: $MAS_DEVELOP_DIR]" >> /tmp/gtermnew.tmp
      echo "[MAS_GTERMO_EVC: $MAS_GTERMO_EVC]" >> /tmp/gtermnew.tmp
      echo "[MAS_GTERMO_TABS: ${MAS_GTERMO_TABS[@]}]" >> /tmp/gtermnew.tmp
      if [[ "$MAS_DRY_RUN" ]] ; then
	echo "DRY RUN : $MAS_GTERMO_EVC" >&2
      else
        declare -gx MAS_GTERMO_TABSS="${MAS_GTERMO_TABS[*]}"
        declare -gx -a MAS_GTERMO_TABSA=( ${MAS_GTERMO_TABS[*]} )
	eval $MAS_GTERMO_EVC
      fi
    else
      mas_notify gterm "EMPTY command"
    fi
  fi
}

fi
