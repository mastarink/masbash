
function mas_source_not_found ()
{
  local errlineno=$1
  shift
  local errmpath=$1
  shift
  local errshscrx=$1
  shift
  
  case $MAS_SCRIPTSN_ERRTYPE in
    notify)
	mas_get_lib_ifnot notify mas_notify
	mas_notify mas_source_scripts "Error DS ($errlineno) - file absent: [$errmpath] $errshscrx"
    ;;
    *)
	builtin echo "Error DS ($errlineno) - file absent: $errshscrx" >&2
    ;;
  esac
}

# source file subscripts
# args
#  - full path
#  - cnt
# action : read all scripts from directory "$path.d"
function mas_source_literal_sub ()
{
  local shs=$1
  shift
  local cnt=$1
  shift
  if [[ -r "$shs" ]] ; then 
    mas_sourcing_start "@> $shs"
    if ! mas_source_literal_script  "./$shs"  "$cnt" ; then
      builtin echo "Error DS ($LINENO) $? ($shs @ $shs)" >&2
     #mas_source_not_found $LINENO $mpath $shscrx
      return 2
    fi
    mas_sourcing_end "@> $shs"
  else
  # builtin echo "Error DS ($LINENO) - no script at $shs" >&2
    mas_source_not_found $LINENO '...' $shs
  fi
}
# scripts in <directory>.d/
function mas_source_literal_subscripts ()
{
  local shscr ddir cnt shs
  shscr=$1
  shift
  cnt=$1
  shift
  

  ddir="${shscr}.d"
  if [[ -d "$ddir" ]] ; then
    mas_sourcing_start '@/' $ddir
    #${MAS_ECHO_CMD:=/bin/echo} $ddir/* >&2
##### mas_echo_trace "-- Call from $ddir"
#   echo "-- Call from $ddir" >&2
    pushd $ddir &>/dev/null
    for shs in * ; do
      if [[ -f "$shs" ]] ; then
	mas_source_literal_sub "$shs" $cnt
      fi
#   find "$ddir" -maxdepth 1 -type f >&2
#   find "$ddir" -maxdepth 1 -type f -exec mas_source_literal_sub \{} $cnt >&2 \;
    done
    popd &>/dev/null
    mas_sourcing_end '@/' $ddir
# else
  fi
  return 0
}
# source file
# and subscripts
# args:
# - full path
# - cnt
# - suscripts dir name (without .d)
function mas_source_literal_script ()
{
  local cnt name subname
  name=$1
  shift
  cnt=$1
  shift
  subname=${1:-$name}
  shift

  
  mas_sourcing_start '@ ' $name
####  mas_echo_trace "   Call      $name"
  MAS_CALL_SCRIPT_SERIAL=$(( ${MAS_CALL_SCRIPT_SERIAL:=0} + 1 ))
# echo "${MAS_CALL_SCRIPT_SERIAL:=0}   Call      $name" >&2
  if ! [[ "$name" ]] || ! . $name ; then
    builtin echo "Error DS ($LINENO) ($name returned $?)" >&2
    return 1
  fi
# source file subscripts ; args: full path, cnt
  if ! [[ "$mas_source_scripts_no_subscript" ]] ; then
    if ! mas_source_literal_subscripts "$subname" "$cnt" ; then
      builtin echo "Error DS ($LINENO) $? ($subname)" >&2
      return 1
    fi
  fi
  if [[ -r "${name}_" ]] ; then
    . ${name}_
  fi
  mas_sourcing_end '@ ' $name
  return 0
}
# do scripts, report absent files (if mas_source_scripts_optional not set)
# args:
#  - mpath var name 
#  - ...... (scripts)
# env:
#  - $mas_source_scripts_tail==<extension>
#  - $mas_source_scripts_name=<name>
#  - $mas_source_scripts_optional - if set, don't report error if file absent
function mas_source_scripts ()
{
  local s s1 shscr shscrx mpath_name mpath result=127 res
  mpath_name="$1"
  shift
  
# mas_call_from define_std_directories stddirs
  mas_get_lib_call stddirs define_std_directories

  mpath="${!mpath_name}"
# ${MAS_ECHO_CMD:=/bin/echo} "directory ($mas_source_scripts_optional): '$mpath' <== '$mpath_name'" >&2
  local cnt=0 mid


  if [[ "$mpath" ]] && pushd "$mpath" &>/dev/null ; then
    for s in $@ ; do
#     if [[ "$s" ]] ; then
#       echo "eval ... $s" >&2
#       s=`eval "builtin echo $s"`
#     fi 
      if [[ "$s" ]] ; then
	cnt=$(( $cnt + 1 ))
	shscrx="${s}${mas_source_scripts_tail}"
	if [[ "$shscrx" ]] && [[ -f $shscrx ]] ; then
	    # do script + subscripts
	  if ! mas_source_literal_script "./$shscrx" "$cnt" "${shscr}" ; then
	    mas_source_not_found $LINENO $mpath $shscrx
	    result=2
	  else
	    result=0
	  fi
	  break
	elif [[ "${mas_source_scripts_optional}" ]] ; then
	  :
	else
	  mas_source_not_found $LINENO $mpath $shscrx
	  result=2
	  break
	fi
      fi
    done
    popd  &>/dev/null
  else
#   ${MAS_ECHO_CMD:=/bin/echo} "directory error: '$mpath' <== '$mpath_name'" >&2
    [[ "${mas_source_scripts_optional}" ]] || errormas "directory error: '$mpath' <== '$mpath_name'"
    result=2
  fi
  return $result
}
# do scripts, report absent files (if mas_source_scripts_optional not set)
# args:
#  - scriptset name 
#  - extension ('.sh', for instance) or '-' for none
#  - mpath var name
#  - ....... (scripts)
function mas_source_scriptsn ()
{
  local mas_source_scripts_tail
  local mas_source_scripts_name=$1
  shift
  local exten=$1
  shift
  if [[ "$exten" ]] && ! [[ "$exten" == '-' ]] ; then
    mas_source_scripts_tail="$exten"
  fi
# args:  mpath var name , ...... (scripts)
# env : $mas_source_scripts_tail==<extension> ; $mas_source_scripts_name=<name>
####  mas_echo_trace ">To call   $mas_source_scripts_name [$exten] $@"
  mas_source_scripts $@
}
# do scripts, don't report absent files
# args:
#  - scriptset name 
#  - extension ('.sh', for instance) or '-' for none
#  - mpath var name
#  - ....... (scripts)
function mas_source_scriptsn_optional ()
{
  local mas_source_scripts_optional=yes
  mas_source_scriptsn $@
}
# do std scripts (opt.?) default and opt. rc with opt.subscripts
# args:
#  - scriptset name 
#  - mpath var names...
function mas_source_scriptsn_opt_std ()
{
  local mas_source_scripts_name=$1
  shift
  local mpath_name
  local mas_source_scripts_no_subscript
  for mpath_name in $@ ; do
#   ${MAS_ECHO_CMD:=/bin/echo} "[Do std] ${MAS_SCREEN_MODE_NEW}:${MAS_SCREEN_MODE} - ${mpath_name} : ${!mpath_name}" >&2
    mas_source_scripts_no_subscript=yes
    mas_source_scriptsn_optional "${mas_source_scripts_name:-unknown_mssn}" - ${mpath_name:-unknown_mpn} default
    unset mas_source_scripts_no_subscript
    mas_source_scriptsn_optional "${mas_source_scripts_name:-unknown_mssn}" - ${mpath_name:-unknown_mpn} rc
  done
}
# do scripts, report absent files (if mas_source_scripts_optional not set)
# SAME as mas_source_scriptsn, but with timing
# args:
#  - scriptset name 
#  - extension ('.sh', for instance) or '-' for none
#  - mpath var name
#  - ....... (scripts)
function mas_source_scriptsnt ()
{
  local start_time end_time interval intervalp
  if [[ "$MAS_RC_TIMING" ]] ; then
    start_time=$(umoment)
  fi
  mas_source_scriptsn $@
  if [[ "$MAS_RC_TIMING" ]] ; then
    end_time=$(umoment)
    if [[ "$end_time" && "$start_time" ]] ; then
      interval=$( /usr/bin/dc --expression="$end_time $start_time -p" )
      if [[ "${interval}" ]] ; then
#	${MAS_ECHO_CMD:=/bin/echo} "$PPID:$$ :r:[${interval} sec]" >>$MAS_BASH_LOG/screen/timing.$$.txt
        :
      fi
    fi
    if [[ "$end_time" && "$MAS_T00SP" ]] ; then
      intervalp=$( /usr/bin/dc --expression="$end_time $MAS_T00SP -p" )
      if [[ "${intervalp}" ]] ; then
#	${MAS_ECHO_CMD:=/bin/echo} "$PPID:$$ :p:[${intervalp} sec]" >>$MAS_BASH_LOG/screen/timing.$$.txt
        :
      fi
    fi
  fi
}
# do scripts, don't report absent files
# SAME as mas_source_scriptsn_optional, but with timing
# args:
#  - scriptset name 
#  - extension ('.sh', for instance) or '-' for none
#  - mpath var name
#  - ....... (scripts)
function mas_source_scriptsnt_optional ()
{
  local mas_source_scripts_optional=yes
  mas_source_scriptsnt $@
}

function mas_interactive ()
{
  [[ $- =~ 'i' ]] && return 0
  return 2
}


# vi: ft=sh
