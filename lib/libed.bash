mas_get_lib_ifnot time datemt
mas_get_lib_ifnot notify mas_notify

MAS_GVIMER_LOADED=`datemt`
function gvimer_loaded ()
{
  echo $MAS_GVIMER_LOADED
}
function _gvimer_mased_global ()
{
  local filnam=$1
  shift
  local mased_tfile rootdir
  if [[ -x "sh/projectsdir.sh" ]] && rootdir=$( "sh/projectsdir.sh" ) && [[ "$rootdir" ]] && [[ -d "$rootdir" ]] ; then
#   mased_tfile=$( grep -rl "$filnam" "$rootdir" | head -1 )
#   echo "search rootdir : '$rootdir'" >&2
    mased_tfile=$( grep --inc='*.mased.vim' -rl "^\s*\(tab\s\+sp\|sp\|tab\s\+sfind\|sfind\|find\|e\)\>\s\+$filnam\s*$" "$rootdir" )
    mased_indir=$( dirname `dirname "$mased_tfile"` )
    return 0
  else
    echo "can't find mased file at {$rootdir}" >&2
  fi
  return 1
}
function _gvimer_mased ()
{
  local filnam=$1
  shift
  filset=${1:-src}
  shift
  if [[ -d mased ]] ; then
    if [[ "$filnam" ]] ; then
#     wfile=$( grep "\(tab sp\|sp\|e\)\>\s\+$infile" mased/*.mased.vim )
      wfile=$( ${MAS_SED_CMD:=/bin/sed} -sne "s/^\s*\(tab\s+sp\|sp\|tab\s\+sfind\|sfind\|find\|e\)\>\s\+\($filnam\)\s*$/\2/p" mased/*.mased.vim )
      mased_file=$( grep -l $wfile mased/*.mased.vim | head -1 )
      if [[ $mased_file =~ ^mased\/(.+)\.mased\.vim$ ]] ; then
	fileset=${BASH_REMATCH[1]}
#       echo "@1" >&2
	return 0
      fi
    else
      mased_file="mased/${fileset:=$filset}.mased.vim"
      wfile=$( ${MAS_SED_CMD:=/bin/sed} -sne "s/^\s*\(tab\s+sp\|sp\|tab\s\+sfind\|sfind\|find\|e\)\>\s\+\(.\+\)\s*$/\2/p" "$mased_file" | head -1 )
      infile=$wfile
#     echo "@2" >&2
      return 0
    fi
  fi
  return 1
}
function _gvimer_findpath ()
{
  local filset=$1
  shift
  case "$filset" in
    ac)
      findpath=.
    ;;
    src)
      if [[ "$infile" =~ \.c$ ]] ; then
        findpath="src/"
      elif [[ "$infile" =~ \.h$ ]] ; then
        findpath="inc/ src/inc/"
      else
        findpath='src/'
      fi
    ;;
    sh)
      findpath='sh/'
    ;;
    *)
      findpath=.
    ;;
  esac
}
function _gvimer_debug ()
{
  echo "DEBUG $@" >&2
  echo "===================" >&2
  echo "mased_file:$mased_file" >&2
  echo "===================" >&2
  echo "filename:$filename" >&2
  echo "infile:$infile" >&2
  echo "wfile:$wfile" >&2
  echo "ffile:'$ffile'" >&2
  echo "===================" >&2
  echo "findpath:$findpath" >&2
  echo "fileset:$fileset" >&2
  echo "sname:$sname" >&2
# echo "PRJ:$prj" >&2
# echo "PRJd:$prjd" >&2
  echo "===================" >&2
}
function mased_realpath ()
{
  local fileset masedf bn
  fileset=$1
  shift
  masedf=$1
  shift
  if [[ "$masedf" ]] ; then
    if [[ "$fileset" == sh ]] ; then
      realpath "$masedf"
    else
      realpath -s "$masedf"
    fi
  fi
}
function mased_id ()
{
  local f
  local filset=$1
  shift
  for f in $@ ; do
    mased_realpath "$filset" $f
  done | md5sum | awk '{print $1}'
}
function gvimer_have_mased ()
{
  local keyfile infil filset findpath
  local ffile sname sname_m
  keyfile=$1
  shift
  infil=$1
  shift
  filset=$1
  shift
  mased_name=$1
  shift
  if [[ "$filset" == '.' ]] ; then unset filset ; fi
# set findpath variable
  if [[ -f "$infil" ]] ; then
    ffile="$infil"
  elif [[ "$wfile" ]] ; then
    _gvimer_findpath "$filset"
    ffile=$( find $findpath -type f -name "$wfile" | head -1 )
  fi

  sname='servermd5-'$( mased_id "$filset" $keyfile )
  
  sname_m=$( ${MAS_GVIM_CMD} --serverlist | ${MAS_GREP_CMD} "^${sname^^*}[[:digit:]]*$" 2>&1 )
# echo "[$sname] $keyfile @@ $filset @@ $mased_name" >&2

  if [[ "$sname_m" ]] ; then sname=$sname_m ; fi
  if ! ${MAS_GVIM_CMD:-/usr/bin/gvim} --serverlist | ${MAS_GREP_CMD:-/bin/grep} "^${sname^^*}[[:digit:]]*$" >/dev/null 2>&1 ; then
    if [[ "$@" ]] ; then 
      ${MAS_GVIM_CMD} --servername "$sname" -o "$mased_name" $@
    else
      ${MAS_GVIM_CMD} --servername "$sname" "$mased_name"
    fi
    for  (( wcnt=0 ; $wcnt<10 ; wcnt++ )) ; do
      if sname_m=$( ${MAS_GVIM_CMD} --serverlist | ${MAS_GREP_CMD} "^${sname^^*}[[:digit:]]*$" 2>&1 ) ; then
	break
      fi
      sleep 0.05
    done
    if [[ "$sname_m" ]] ; then sname=$sname_m ; fi
  fi
  if [[ "$ffile" ]] && [[ -f "$ffile" ]] ; then
    ${MAS_GVIM_CMD} --servername "$sname" --remote "$ffile"
    if [[ "$fline" ]] ; then
      ${MAS_GVIM_CMD} --servername "$sname" --remote-expr "MasGo($fline, $fcol)"
    fi
  fi
}
function gvimer ()
{
  local infile filename wfile mased_file fileset fline mased_indir
  infile=$1
  shift
  if [[ "$infile" ]] ; then
    if infile_t=`find $infile \( -type l -printf '%h/%l' \) -o \( -type f -printf '%h/%f' \) 2>/dev/null` && find $infile_t -type f &>/dev/null ; then
      infile=$infile_t
      filename=$infile
    fi
    if [[ "$infile" =~ ^:(.*)$ ]] ; then
      fileset=${BASH_REMATCH[1]}
      unset infile
    fi
    if [[ $infile =~ \/([^\/]+)$ ]] ; then
      filename=${BASH_REMATCH[1]}
    else
      filename=$infile
    fi
  fi
  echo "[$filename]" >&2

  # set mased_file, wfile, fileset  in _gvimer_mased && _gvimer_mased_global
  # mased_indir may be set in _gvimer_mased_global
  if ! _gvimer_mased "$filename" "${fileset:=src}" && _gvimer_mased_global "$filename" "$fileset" ; then
    if [[ "$mased_indir" ]] ; then
      pushd $mased_indir >/dev/null && _gvimer_mased "$filename" "$fileset"
    fi
  fi
  if [[ "$mased_file" ]] && [[ -f "$mased_file" ]] ; then
#   echo "A $mased_file : ${fileset}" >&2
    gvimer_have_mased "$mased_file" "$infile" "$fileset" "${fileset}.mased"
  elif [[ "$infile" ]] ; then
#   echo B >&2
    gvimer_have_mased "$infile" "$infile" . "$infile" $@
  else
#   echo C >&2
    ${MAS_GVIM_CMD:-/usr/bin/gvim} -o "$infile" $@
  fi
  if [[ "$mased_indir" ]] ; then
      popd >/dev/null
  fi
}

function gvim_caller ()
{
  gvimer $@
}
