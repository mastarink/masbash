function mas_get_paths ()
{
  local tpath ptype xpath data_file rpath
  ptype=$1
  shift
# echo "P ${BASH_LINENO[@]} : $LINENO" >&2
  if [ -n "$ptype" ] ; then
    #echo >&2 ; echo "<PATH>" >&2
    for data_file in $MAS_CONF_DIR_PATHS/$ptype/* $* ; do
#      mas_logger  "$data_file"
      #echo "LIB 1 : $rpath" >&2
#     echo "> LIB ($data_file) : $rpath" >&2
      while read tpath ; do
	if [[ "$tpath" == \#* ]] || ! [[ "$tpath" ]]; then continue ; fi
#       if ! [[ "$tpath" ]] ; then
#         echo "Lib : $rpath" >&2
#         echo "$rpath"
#         return
#       fi
	#echo "<PATH value=\"$tpath\">" >&2
	xpath=`eval "echo $tpath"`
#	echo "X: $xpath" >&2
	if [[ "$rpath" ]] ; then
	  rpath="$rpath $xpath"
	else
	  rpath="$xpath"
	fi
      done < "$data_file"
#     echo "< LIB ($data_file) : $rpath" >&2
    done
    #echo "</PATH>" >&2
  fi
  #echo "LIB 2 : $rpath" >&2
  echo "$rpath"
#     echo "ptype=$ptype : xpath=$xpath" >&2
}

