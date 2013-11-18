#  To get a list of all buffers in all tabs use this: >
#  let buflist = []
#    for i in range(tabpagenr('$'))
#       call extend(buflist, tabpagebuflist(i + 1))
#    endfor
function gvimer2_bin ()
{
# echo "${MAS_GVIM_CMD:=/usr/bin/gvim} $@" >&2
  ${MAS_GVIM_CMD:=/usr/bin/gvim} $@
}
function gvimer2_resident ()
{
  local file=$1 
  shift
  local fuuid=$1
  shift
  gvimer2_bin --servername "$fuuid" --remote "$file"
}
function gvimer2_fuuid ()
{
  local file=$1 
  shift
  local fuuid=$1
  shift
# gvimer2_bin --servername "$fuuid" "$file"
  gvimer2_bin --servername "$fuuid" --remote-silent "$file"
}
function gvimer2_uuid ()
{
  local fuuid
  local file
  local string
  local rp
  for file in $@ ; do
    if [[ "$typf" ]] && [[ "$typf" == shn ]] ; then
      rp=`realpath $file`
    else
      rp=`realpath -s $file`
    fi
    if [[ "$string" ]] ; then
      string="$string;$r"
    else
      string="$rp"
    fi
  done
  echo realpath $string | md5sum | cut -b-32
}
function gvimer2_regfile_in ()
{
  local file=$1
  shift
  local fuuid=${1:-"gvimer2-$( gvimer2_uuid $file )"}
  shift
  local masedf=$1
  shift
  local typf=$1
  shift
  local filen=`basename $file`
  local resident
# echo "gvimer2_regfile_in: file:$file; $fuuid; $masedf; typf:$typf; filen:$filen" >&2
  if [[ -f "$file" ]] ; then
#   echo "found file $file for $fuuid" >&2
    for resident in $( gvimer2_bin --serverlist ) ; do
#     echo "resident: $resident" >&2
      if [[ "$resident" == $fuuid ]] ; then
#       echo "Found! : $file" >&2
        gvimer2_resident $file $fuuid
	return $?
#     else
#       echo "Not match $fuuid ? $resident" >&2
      fi
    done
    if [[ "$typf" ]] && [[ -f "$masedf" ]] ; then
      if grep $filen $masedf &>/dev/null ; then
#       echo "via mased:${typf}.mased"
        gvimer2_bin --servername "$fuuid" "${typf}.mased"
#     gvimer2_fuuid "${typf}.mased" $fuuid
	sleep 0.5
	gvimer2_resident $rfile $fuuid
      else
        echo "$FUNCNAME not found ${filen} at $masedf" >&2
        gvimer2_fuuid $file $fuuid
      fi
    else
#     echo "file:${file}"
      gvimer2_fuuid $file $fuuid
    fi
    return $?
  else
    echo "$FUNCNAME not found $file"
    return 1
  fi
  return 0
}
function gvimer2_regfile ()
{
  local nocase retcode
  if shopt  nocasematch &>/dev/null ; then nocase=1 ; else nocase=0 ; fi
  shopt -s nocasematch &>/dev/null
  gvimer2_regfile_in $@
  retcode=$?
  if [[ "$nocase" -eq 0 ]] ; then shopt -u nocasematch &>/dev/null ; fi
  return $retcode
}
function gvimer2_reg ()
{
  local file
# echo "$FUNCNAME $file" >&2
  for file in $@ ; do
    gvimer2_regfile $file || return $?
  done
  return 0
}
function gvimer2_mased ()
{
  local file=$1 filef
# echo "gvimer2_mased: $file" >&2
  if [[ "$file" == */* ]] ; then
    filef=$1
  else
    filef=`find -L -type f -name "${file:-*.c}" | head -1`
    if ! [[ "$filef" ]] ; then 
      echo "$FUNCNAME not found $file" >&2
      return 1
    fi
  fi
# echo "$1 => filef:$filef"
  local typf
  local rfile=`realpath $filef`
  filef=`basename $rfile`
  local dir=`dirname $rfile`
  local dirn=`basename $dir`
  local masedf
  if [[ "$filef" == *.c ]] || [[ "$filef" == *.h ]]  ; then
    typf="src"
  elif  [[ "$dirn" == shn ]] && ( [[ "$filef" == *.sh ]] || [[ "$filef" == *.bash ]] ) ; then
    typf="shn"
  elif [[ "$filef" == *.ac ]] || [[ "$filef" == *.am ]] ; then
    typf="ac"
  fi
  masedf=mased/${typf}.mased.vim
  local fuuid="gvimer2-$( gvimer2_uuid $masedf )"
  if ! [[ -f "$masedf" ]] ; then
    if [[ "$typf" == shn ]] && [[ -d "$typf" ]] ; then
      ls -1 shn/ | sed -e 's/^/:sfind /' > $masedf
    fi
  fi
  if [[ -f "$masedf" ]] ; then
#   echo "mased rfile: $rfile" >&2
#   echo "mased filef: $filef" >&2
#   echo "mased typf: $typf" >&2
    echo "mased fuuid: $fuuid" >&2
    echo "mased masedf: $masedf" >&2
    gvimer2_regfile $rfile $fuuid $masedf $typf
    return $?
  else
    echo "$FUNCNAME not found $masedf" >&2
    return 1
  fi
  return 1
}
function gvimer2 ()
{
  local file
# echo "gvimer2 : $@" >&2
  if [[ -d mased ]] ; then
    deffile=$( find src -type f -name '*.c' | head -1 )
#   echo "deffile : $deffile" >&2
    if [[ "$@" ]] ; then
#     echo "try gvimer2_mased" >&2
      gvimer2_mased $@ && return $?
#     echo "try gvimer2_reg" >&2
      gvimer2_reg $@ && return $?
      echo "error editing $@" >&2
      return 1
    elif [[ "$deffile" ]] ; then
      gvimer2_mased $deffile || return $?
    else
      return 1
    fi
  elif ! [[ "$@" ]] ; then
    gvimer2_bin
  else
    gvimer2_reg $@ || return $?
  fi
}
function gvim_caller2 ()
{
# echo "gvim2_caller2 : $@" >&2
  gvimer2 $@ || return $?
}
