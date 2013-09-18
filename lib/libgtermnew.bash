mas_get_lib_ifnot notify mas_notify
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
function mas_set_gterminal_cmd ()
{
# geometry should depend on ${MAS_DESKTOP_NAME}
  if [[ "${MAS_DESKTOP_NAME}" == test ]] ; then
    MAS_GTERM_CMD="/usr/bin/roxterm --tab"
  else
    mas_get_lib_ifnot time datemt
    MAS_GTERM_CMD="/usr/bin/gnome-terminal --class=masGtermws-`datemt`-${MAS_DESKTOP_NAME} --role=gtermws --window-with-profile='wsp-${MAS_DESKTOP_NAME}' --geometry='156x60+0+0' --title='gtermws @ ${MAS_DESKTOP_NAME}' --name=gtermws-${MAS_DESKTOP_NAME}"
  fi
}


function mas_gterminal_cmd ()
{
  mas_set_gterminal_cmd $@
  echo $MAS_GTERM_CMD
}
function mas_gterminal ()
{
  local cmd log_to
 #cmd=$( mas_gterminal_cmd $@ )
# ----------  mas_set_gterminal_cmd $@
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
    mas_notify gterm $MAS_GTERM_CMD
    eval $cmd  >>/tmp/gtermcmd.txt 2>&1
  else
    echo $cmd
  fi
}
function mas_genterminal ()
{
  local ko
  declare -gx MAS_GTERMO_WD
  MAS_GTERMO_WD=$MAS_GTERMO_BIN
  for ko in ${!MAS_GTERMOPTS[@]} ; do
    MAS_GTERMO_WD="$MAS_GTERMO_WD --${ko}='${MAS_GTERMOPTS[$ko]}'"
  done
  echo ">>> [${#MAS_GTERMOPTS[@]}]  $MAS_GTERMO_WD"
  eval $MAS_GTERMO_WD
}

fi