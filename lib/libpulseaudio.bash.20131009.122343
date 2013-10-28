function pulseaudio_pacmd ()
{
  /usr/bin/pacmd $@ 2>/dev/null
}
function pulseaudio_pacmdz ()
{
  /usr/bin/pacmd $@ &>/dev/null
}
function pulseaudio_client_id ()
{
  local name="$@"
  local is_index is_client
  pulseaudio_pacmd list-sink-inputs | while read ; do
    if [[ "$REPLY" =~ [[:space:]]+index: ]] ; then
      is_index=$(( 0 + $( echo "$REPLY" | awk '{print $2}' ) ))
    elif [[ "$REPLY" =~ [[:space:]]+client: ]] ; then
      is_client=$( echo "$REPLY" | sed 's=^.*<\(.*\)>.*$=\1=' )
      if [[ $is_client == $name ]] ; then
        echo $is_index
      fi
    fi
  done
}
function pulseaudio_client_idc ()
{
  local name="$@"
  local is_index is_client
  pulseaudio_pacmd list-clients | while read ; do
    if [[ "$REPLY" =~ [[:space:]]+index: ]] ; then
      is_index=$(( 0 + $( echo "$REPLY" | awk '{print $2}' ) ))
    elif [[ "$REPLY" =~ [[:space:]]+application.name[[:space:]]+= ]] ; then
      is_client=$( echo "$REPLY" | sed 's@^.*application\.name\s*=\s*"\(.*\)".*$@\1@' )
      if [[ $is_client == $name ]] ; then
        echo $is_index
      fi
    fi
  done
}

function pulseaudio_sink_name ()
{
  local id=$1
  local is_index sink_name
  pulseaudio_pacmd list-sinks | while read ; do
    if [[ "$REPLY" =~ [[:space:]]+index: ]] ; then
      is_index=$( echo "$REPLY" | awk '{print $3}' )
      is_index=$(( 0 + $is_index ))
    elif [[ "$REPLY" =~ [[:space:]]+name: ]] ; then
      sink_name=$( echo "$REPLY" | awk '{print $2}' | sed 's=<\(.*\)>=\1=' )
      if [[ $is_index == $id ]] ; then
        echo $sink_name
      fi
    fi
  done
}

function pulseaudio_set_app_volume ()
{
  local app ai appid vol voln
  vol=$1 ; shift
  app="$@" ; shift
  voln=`wcalc "round( 0x10000 / 100 * $vol )"`
  appid=`pulseaudio_client_id "$app"`
  if [[ "$appid" ]] ; then
    for ai in $appid ; do
      echo "setting $vol% ($voln) for app $app ($ai)" >&2
      pulseaudio_pacmdz set-sink-input-volume "$ai" "$voln" 
    done
  elif [[ "$-" == *i* ]] ; then
    errormas "pulseaudio_set_app_volume: $app not found"
  fi
}
function pulseaudio_sink_mute ()
{
  local i=$1
  shift
  local s=$1
  shift
  local fname="$HOME/.pulse_mas_mute.$i"
  if [ "@$s" == '@on' ] ; then
    s=on
  elif [ "@$s" == '@off' ] ; then
    s=off
  elif [ -f "$fname" ] ; then
    s=off
    rm -f "$fname"
  else
    s=on
    touch "$fname"
 # else
 #   echo "$0 <id> <on/off> [$s]" >&2
  fi
#  pulseaudio_pacmdz set-sink-mute `pulseaudio_sink_name $i` "$s"

#  echo pacmd set-sink-mute "$i" "$s" >&2
  pulseaudio_pacmdz set-sink-mute "$i" "$s"
#   >/dev/null 2>&1
}
function pulseaudio_set_sink_volume_old ()
{
  local sink vol voln
  sink=$1 ; shift
  vol=$1 ; shift
  voln=`wcalc "round( 0x10000 / 100 * $vol )"`
#  echo "setting $vol% ($voln) for sink $sink (`pulseaudio_sink_name 0`)" >&2
  pulseaudio_pacmdz set-sink-volume "$sink" "$voln"
}
function pulseaudio_set_sink_volume ()
{
  local sink vol voln
  sink=$1 ; shift
  vol=$1 ; shift
  pactl set-sink-volume "$sink" -- "${vol}%"
#  >/dev/null 2>&1
}


function pulseaudio_sink_get_volume ()
{
  local sink_id=$1
# echo "sink_id:$sink_id" >&2
  local sink_name=`pulseaudio_sink_name $sink_id`
#  echo "sink_name:$sink_name" >&2
  local xvol=`pulseaudio_pacmd dump | grep "set-sink-volume $sink_name" | cut -d " " -f 3`
#  echo "xvol:$xvol" >&2
  local voln=`wcalc $xvol`
#  echo "voln:$voln" >&2
  local vol=`wcalc "round( $voln / ( 0x10000 / 100 ) )"`
#  echo "vol:$vol" >&2
#  echo "$sink_name $xvol $voln $vol">&2
  echo $vol
}

# vi: ft=sh
