mas_get_lib_ifnot time datemt
function mas_sawfish_habak ()
{
  mas_get_lib_ifnot time datemt
  echo " -------- `datemt`:$FUNCNAME -----------" >> /tmp/sawfishwschanged.tmp
  echo "Habak $@"                                >> /tmp/sawfishwschanged.tmp
  habak $@
}
function mas_sawfish_bg_notset ()
{
  local id sub msg
  id=$1
  shift
  sub=$1
  shift
  msg=$1
  shift
  mas_get_lib_ifnot time datemt
  echo " -------- `datemt`:$FUNCNAME -----------" >> /tmp/sawfishwschanged.tmp
  echo "BG NOT set id=$id; sub=$sub; msg='$msg' other='$@'" >> /tmp/sawfishwschanged.tmp
# mas_bg_notify "no B/g; $msg"
}
function mas_sawfish_setbg ()
{
  local id bgi sub
  id=$1
  shift
  sub=$1
  shift
  mas_get_lib_ifnot time datemt
  echo " -------- `datemt`:$FUNCNAME -----------" >> /tmp/sawfishwschanged.tmp
  echo "bg $id $sub $bgi" >> /tmp/sawfishwschanged.tmp
  if ! [[ "$sub" ]] ; then sub='0' ; fi
  bgi="$MAS_CONF_DIR_WM/bg/$id"
  echo "bg $id $sub $bgi" >> /tmp/sawfishwschanged.tmp

#     mas_notify 3000 "[$toooldpid $oldpid $$]"
  if [[ -d "$bgi" ]] ; then
    if [[ -f "$bgi/habak.${sub}.opts" ]] ; then
      habak_opts=`cat "$bgi/habak.${sub}.opts"`
    elif [[ -f "$bgi/${sub}/habak.opts" ]] ; then
      habak_opts=`cat "$bgi/${sub}/habak.opts"`
    else
      habak_opts='-ms'
    fi
    if [[ -d "$bgi/Habak.${sub}" ]] ; then
      mas_sawfish_habak  $habak_opts -hi "$bgi/Habak.${sub}"
      # -mf $HOME/.fonts/LiberationMono-Regular.ttf -ht "$id $sub"
      return
    else
#     image="$( find $bgi/${sub} -maxdepth 1 -name '*.jpg' -o -name '*.png' | tail -1 )"
      if [[ -d "$bgi/${sub}" ]] ; then
	mas_sawfish_habak  $habak_opts -hi "$bgi/${sub}"
	# -mf $HOME/.fonts/LiberationMono-Regular.ttf -ht "$id $sub"
#	mas_bg_notify "Use from dir $bgi/${sub}"
	return 0
      else
	mas_sawfish_bg_notset "$id" "$sub" "No dir @ $bgi/${sub}"
	return 2
      fi
    fi
  elif [[ -f "$bgi" ]] ; then
    image=$bgi
    mas_sawfish_bg_notset "$id" "$sub" "File, not dir $bgi"
    return 2
  else
    mas_sawfish_bg_notset "$id" "$sub" "No dir $bgi"
    return 2
  fi
  wmmsg_notify ws
  return 0
}
function mas_sawfish_set_bg_file ()
{
mas_get_lib_ifnot time datemt
  echo " -------- `datemt`:$FUNCNAME -----------" >> /tmp/sawfishwschanged.tmp
  if [[ "$MAS_CONF_DIR_WM" ]] && [[ "$MAS_DESKTOP_NAME" ]] && [[ -d "$MAS_CONF_DIR_WM/bg" ]] ; then
    mas_get_lib_ifnot sawfish mas_sawfish_setbg
    if ! [[ -d "$MAS_CONF_DIR_WM/bg/$MAS_DESKTOP_NAME/0" ]] ; then
      if ! [[ -d "$MAS_CONF_DIR_WM/bg/$MAS_DESKTOP_NAME" ]] ; then
	mkdir "$MAS_CONF_DIR_WM/bg/$MAS_DESKTOP_NAME"
      fi
      mkdir "$MAS_CONF_DIR_WM/bg/$MAS_DESKTOP_NAME/0"
    fi
    if [[ -d "$MAS_CONF_DIR_WM/bg/$MAS_DESKTOP_NAME/0" ]] ; then
      cp -a "$1"  $MAS_CONF_DIR_WM/bg/$MAS_DESKTOP_NAME/0
    fi
    mas_sawfish_setbg $MAS_DESKTOP_NAME 0
  fi
}

