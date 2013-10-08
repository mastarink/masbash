
#typemas datemt  && export MAS_TIME_LIBSTDDIRS=$(datemt)
declare -gx MAS_GVAR_PREFIX=MAS_
function mas_define_dir_at_log_log ()
{
  local prefix name basen fullbasen value opt fullname nsub

  prefix="$1" ; shift
  name="$1"   ; shift
  basen="$1"  ; shift
  value="$1"  ; shift
  opt="$1"   ; shift
# if [[ "$prefix" == '-' ]] ; then prefix='' ; fi
 #echo "mas_define_dir_at_log : $basen : $name : $value" >&2
 #echo "mas_define_dir_at_log : $basen : $name : $value" >&$MAS_STDDIRS_LOG_FD
  if [[ "${basen}" == '^' ]] ; then
    fullbasen="HOME"
  else
    fullbasen="${prefix}${basen}"
#   infomas "fullbasen=$fullbasen prefix=$prefix basen=$basen :: ${name} = $value"
  fi
  fullname="${prefix}${name}"
  if [[ "$basen"  && "$name" && "$value" && "$prefix" ]] ; then
    if [[ "$value" == =* && "$value" =~ ^=(.+)$ ]] ; then
      value="${prefix}${BASH_REMATCH[1]}"
      value=${!value}
      if ! [[ "$value" ]] ; then
        printf "%03d %03d. %-4s %-30s=  %s [%s]\n" "$MAS_DEFINE_STD_DIRECTORIES_CNT" "$MAS_DEFINE_STD_DIRECTORY_POS" " ER1" "$fullname" "${!fullname}" "${opt}" >&$MAS_STDDIRS_LOG_FD
        echo "Error 1 $FUNCNAME : $LINENO ($fullbasen : ${!fullbasen}) (prefix:$prefix : name:$name : basen:$basen : value:$value) [${opt}]" >&2
      fi
      declare -gx "$fullname"="$value"
      MAS_DEFINE_STD_DIRECTORY_POS=$(( $MAS_DEFINE_STD_DIRECTORY_POS + 1 ))
    else
      declare -gx "$fullname"="${!fullbasen}/$value"
###   echo "2b== '$prefix' == '$name' '$basen' = '$value' ===" >&2
      MAS_DEFINE_STD_DIRECTORY_POS=$(( $MAS_DEFINE_STD_DIRECTORY_POS + 1 ))
    fi
#  export "${fullname}_T"="${!fullbasen}/$value"
    if [[ "$MAS_DEFINE_STD_DIRECTORIES_CNT" -eq 1 ]] ; then
      if [[ -d "${!fullname}" ]] ; then
	printf "%03d %03d. %-4s %-30s=  %s [%s]\n" "$MAS_DEFINE_STD_DIRECTORIES_CNT" "$MAS_DEFINE_STD_DIRECTORY_POS" " OK " "$fullname" "${!fullname}" "${opt}" >&$MAS_STDDIRS_LOG_FD
	nsub=`${MAS_STAT_CMD:=/usr/bin/stat} --printf='%h' "${!fullname}"`
	case $opt in
	  rmdir)
	    if [[ "`${MAS_STAT_CMD:=/usr/bin/stat} --printf='%h' ${!fullname}`" -eq 2 ]] && \
	    			[[ "`${MAS_LS_CMD:=/bin/ls} -1 ${!fullname} | ${MAS_WC_CMD:=/bin/wc} -l`" -eq 0 ]] ; then
	      echo "$MAS_DEFINE_STD_DIRECTORIES_CNT removing ${!fullname}" >&2
	      MAS_RMDIR_CMD=${MAS_RMDIR_CMD:=/bin/rmdir} "${!fullname}"
	    fi
	  ;;
	  must)
	    :
	  ;;
	  *)
#	    echo "$MAS_DEFINE_STD_DIRECTORIES_CNT Present optional ${!fullname}" >&2
	    :
	  ;;
	esac
      else
	printf "%03d %03d. %-4s %-30s=  %s %s [%s]\n" "$MAS_DEFINE_STD_DIRECTORIES_CNT" "$MAS_DEFINE_STD_DIRECTORY_POS" "-no-" "$fullname" "${!fullname}" "($fullbasen : ${!fullbasen} : $value)" "${opt}" >&$MAS_STDDIRS_LOG_FD
	case $opt in
	  mkdir)
	    echo "$MAS_DEFINE_STD_DIRECTORIES_CNT Create ${!fullname}" >&2
	  ;;
	  must)
	    echo "$MAS_DEFINE_STD_DIRECTORIES_CNT Absent ${!fullname}" >&2
	    sleep 20
	  ;;
#         opt|rmdir|*)
#           echo "Absent optional ${!fullname}" >&2
#  	  ;;
	esac
      fi
    fi

    return 0
  fi
  printf "%03d %03d. %-4s %-30s=  %s [%s]\n" "$MAS_DEFINE_STD_DIRECTORIES_CNT" "$MAS_DEFINE_STD_DIRECTORY_POS" " ER3" "$fullname" "${!fullname}" "${opt}" >&$MAS_STDDIRS_LOG_FD
# echo "Error 2 $FUNCNAME : $LINENO ($fullbasen : ${!fullbasen}) (prefix:$prefix : name:$name : basen:$basen : value:$value) [${opt}]" >&2
# echo ${FUNCNAME}-r2 >&2
  return 2
}
function mas_define_dir_at ()
{
  export MAS_STDDIRS_LOG_FD
  if [[ "${MAS_STDDIRS_LOG_FD}" ]] && [[ -w /dev/fd/${MAS_STDDIRS_LOG_FD} ]] ; then
    mas_define_dir_at_log_log $@
  else
    local logdir=${MAS_BASH_LOG:=${MAS_DIR:=$HOME/.mas}/log}
    local logfile=$logdir/stddirs.log
    mas_define_dir_at_log_log $@ {MAS_STDDIRS_LOG_FD}>>$logfile
  fi
}
function mas_define_dir ()
{
  mas_define_dir_at "${MAS_GVAR_PREFIX:=MAS_}" $@
}

# declare -xg MAS_DEFINE_STD_DIRECTORIES_CNT=0
declare -gx MAS_DEFINE_STD_DIRECTORY_POS=0

function define_std_directories ()
{
  unset MAS_CONF_DIR
  unset MAS_CONF_DIR_TERM

# for MAS_WS_CMD
# mas_loadlib_if_not define_std_binnames stdbins
# mas_get_lib_ifnot stdbins define_std_binnames

  unset MAS_I_WS
#   mas_define_dir	    MAS_DIR                      '^'				 .mas					must
    mas_define_dir	    DIR                          '^'				 .mas					must
# BIN, UBIN, BASH_LOG to be defined ALSO at .topvars
    mas_define_dir	    UBIN                         '^'				  ubin
    mas_define_dir          DIR_BASH_LOG                 '^'				  log
    mas_define_dir          DIR_XBASH_LOG                '^'				  xbin
    mas_define_dir          BIN                          DIR                              bin
    mas_define_dir          BASHBIN                      DIR                              bash
    mas_define_dir          BASHSOURCE                   BASHBIN                          src
    mas_define_dir          PULSESOURCE                  BASHSOURCE                       pulse
    mas_define_dir          DEVELOP_DIR                  DIR                              develop
    mas_define_dir          VAR_DIR                      DIR                              var
    mas_define_dir          TRY1_DIR                     DIR                              try1
    mas_define_dir          TRY2_DIR                     TRY1_DIR                         try2
    mas_define_dir          SCREEN_VAR_DIR               VAR_DIR                          screen
    mas_define_dir          TERM_VAR_DIR                 VAR_DIR                          term
    mas_define_dir          TERM_WIN_VAR_DIR             TERM_VAR_DIR                     win
    mas_define_dir          GTERM_VAR_DIR                TERM_VAR_DIR                     gterm
    mas_define_dir          SAWFISH_BIN                  UBIN                             sawfish
    mas_define_dir          RUNONCE_LIB                  UBIN                             runonce
    mas_define_dir          CONF_DIR                     DIR                              config
    mas_define_dir          CONF_DIR_RUNONCE             CONF_DIR                         runonce
    mas_define_dir          CONF_DIR_VIM                 CONF_DIR                         vim
    mas_define_dir          CONF_DIR_WM                  CONF_DIR                         maswm					rmdir
    mas_define_dir          CONF_DIR_TERM                CONF_DIR                         term_new				must
    mas_define_dir          SHLIB                        CONF_DIR_TERM                    lib
    mas_define_dir          CONF_DIR_TERM_STAT           CONF_DIR_TERM                    stat
    mas_define_dir          CONF_DIR_BASH                CONF_DIR_TERM                    bash
    mas_define_dir          CONF_DIR_DOTS                CONF_DIR_TERM                    home_dots
    mas_define_dir          CONF_DIR_BINDING             CONF_DIR_TERM                    binding
#   mas_define_dir          CONF_DIR_BINDWS_BASE         CONF_DIR_BINDING                 _ws
#   mas_define_dir          CONF_DIR_BINDWS              CONF_DIR_BINDWS_BASE             "${MAS_I_WS:-${MAS_DESKTOP_NAME}}"
    mas_define_dir          CONF_DIR_BINDWS              CONF_DIR_BINDING                 _ws
    mas_define_dir          CONF_DIR_BINDWS_TEST         CONF_DIR_BINDWS                  "${MAS_BINDING_NAME}"
    mas_define_dir          CONF_DIR_BINDGTERM           CONF_DIR_BINDING                 gterm
    mas_define_dir          CONF_DIR_PRERC               CONF_DIR_TERM                    prerc
    mas_define_dir          CONF_DIR_POSTRC              CONF_DIR_TERM                    postrc
#           mas_define_dir          CONF_DIR_UTIL                CONF_DIR_TERM                    util
    mas_define_dir          CONF_DIR_PROFILE             CONF_DIR_TERM                    profile
    mas_define_dir          CONF_DIR_TMP                 CONF_DIR_TERM                    tmp					rmdir
    mas_define_dir          CONF_DIR_INPUT               CONF_DIR_TERM                    input
    mas_define_dir          CONF_DIR_PROFILE_GROUPS      CONF_DIR_TERM                    profile-sets
    mas_define_dir          CONF_DIR_PATH_UTIL           CONF_DIR_TERM                    path_util
    mas_define_dir          CONF_DIR_PATHS               CONF_DIR_TERM                    paths
    mas_define_dir          CONF_DIR_WS_BASE             CONF_DIR_TERM                    _ws					rmdir
    mas_define_dir          CONF_DIR_I_WS                CONF_DIR_WS_BASE                "${MAS_I_WS:-${MAS_DESKTOP_NAME}}"	rmdir

    mas_define_dir          CONF_DIR_I_WS_USERS          CONF_DIR_I_WS                    _user					rmdir
    mas_define_dir          CONF_DIR_I_WS_USER           CONF_DIR_I_WS_USERS             "$USER"				rmdir

    mas_define_dir          CONF_DIR_I_WS_USER_SCMS      CONF_DIR_I_WS_USER               _screen_mode				rmdir
    mas_define_dir          CONF_DIR_I_WS_USER_SCM       CONF_DIR_I_WS_USER_SCMS         "${MAS_SCREEN_MODE:-unknown_msm}"	rmdir

    mas_define_dir          CONF_DIR_SCREENS             CONF_DIR_TERM                    masscreen
#           mas_define_dir          CONF_DIR_SCREENS             CONF_DIR_I_WS                    masscreen
    mas_define_dir          CONF_DIR_SCREEN_MODE_BASE    CONF_DIR_SCREENS                 scrmode				rmdir
    mas_define_dir          CONF_DIR_SCREEN_MODE_P       CONF_DIR_SCREEN_MODE_BASE       "${MAS_SCREEN_MODE_PREV:-unknown_msm}"	rmdir
    mas_define_dir          CONF_DIR_SCREEN_MODE         CONF_DIR_SCREEN_MODE_BASE       "${MAS_SCREEN_MODE:-unknown_msm}"	rmdir
    mas_define_dir          CONF_DIR_SCRNUM              CONF_DIR_SCREENS                 num					rmdir
    mas_define_dir          CONF_DIR_SCREEN              CONF_DIR_SCRNUM                 "${MAS_SCREEN_SESSION_NUM:-99999}"	rmdir


    mas_define_dir          CONF_DIR_I_SWS_BASE          CONF_DIR_SCREEN_MODE             _ws					rmdir
    mas_define_dir          CONF_DIR_I_SWS               CONF_DIR_I_SWS_BASE             "${MAS_I_WS:-${MAS_DESKTOP_NAME}}"	rmdir
    mas_define_dir          CONF_DIR_I_SWS_USER_BASE     CONF_DIR_I_SWS                   _user					rmdir
    mas_define_dir          CONF_DIR_I_SWS_USER          CONF_DIR_I_SWS_USER_BASE        "$USER"				rmdir


    mas_define_dir          CONF_DIR_I_SWS_BASE_P        CONF_DIR_SCREEN_MODE_P           _ws					rmdir
    mas_define_dir          CONF_DIR_I_SWS_P             CONF_DIR_I_SWS_BASE_P           "${MAS_I_WS:-${MAS_DESKTOP_NAME}}"	rmdir
    mas_define_dir          CONF_DIR_I_SWS_USER_BASE_P   CONF_DIR_I_SWS_P                 _user					rmdir
    mas_define_dir          CONF_DIR_I_SWS_USER_P        CONF_DIR_I_SWS_USER_BASE_P      "$USER"				rmdir


    mas_define_dir          HISTORY_T_DIR_BASE            CONF_DIR                         term_history
    mas_define_dir          HISTORY_DIR_BASE		 HISTORY_T_DIR_BASE                history
    mas_define_dir          HISTORY_DIR_USER_BASE        HISTORY_DIR_BASE		  user					rmdir
    mas_define_dir          HISTORY_DIR_USER             HISTORY_DIR_USER_BASE		 "$USER"				rmdir
    mas_define_dir          HISTORY_DIR                  HISTORY_DIR_BASE                "$UID"					mkdir
    mas_define_dir          WM_DOCKAPPLETS               CONF_DIR                         wmaker				rmdir

    mas_define_dir          CONF_DIR_CUSTOM_BASE         CONF_DIR_BASH                    custom				rmdir
    mas_define_dir          CONF_DIR_CUSTOM              CONF_DIR_CUSTOM_BASE            "$USER"				rmdir

    mas_define_dir          CONF_DIR_TERM_TERM_BASE      CONF_DIR_BASH                   _term					rmdir
    mas_define_dir          CONF_DIR_TERM_TERM           CONF_DIR_TERM_TERM_BASE         "$TERM"				rmdir
    mas_define_dir          CONF_DIR_TERM_EMUL_BASE      CONF_DIR_TERM_TERM              _emul					rmdir
    mas_define_dir          CONF_DIR_TERM_EMUL           CONF_DIR_TERM_EMUL_BASE         "${MAS_PROBABLE_TERMINAL_EMULATOR:-unknown_pte}" rmdir

  export MAS_DIRS_CONF_AT=${!MAS_CONF_*}
# export MAS_MASVARS=${!MAS_*}
  export MAS_DIRS="$MAS_BIN $MAS_UBIN $MAS_CONF_DIR $MAS_CONF_DIR_TERM $MAS_CONF_DIR_WS $MAS_CONF_DIR_CUSTOM $MAS_CONF_DIR_TERM_TERM $MAS_CONF_DIR_BASH $MAS_CONF_DIR_PROFILE $MAS_CONF_DIR_TMP $MAS_CONF_DIR_PROFILE_GROUPS $MAS_WM_DOCKAPPLETS $MAS_HISTORY_DIR $MAS_BASH_LOG $MAS_CONF_DIR_PATH_UTIL $MAS_CONF_DIR_PATHS $MAS_CONF_DIR_I_WS"
  export MAS_DIRS_SEARCH_BASH_AT="MAS_BIN MAS_UBIN MAS_CONF_DIR_TERM MAS_CONF_DIR_BASH MAS_CONF_DIR_PATH_UTIL MAS_CONF_DIR_PROFILE MAS_CONF_DIR_I_WS"
  export MAS_DIRS_SEARCH_BASH="$MAS_BIN $MAS_UBIN $MAS_CONF_DIR_RUNONCE $MAS_CONF_DIR_TERM $MAS_CONF_DIR_BASH $MAS_CONF_DIR_PATH_UTIL $MAS_CONF_DIR_PROFILE $MAS_CONF_DIR_I_WS"
# export MAS_TIME_DIRS=`datemt`
  unset MAS_FILES_AT_BASH_DIRS_CACHE
  MAS_DEFINE_STD_DIRECTORIES_CNT=$(( ${MAS_DEFINE_STD_DIRECTORIES_CNT:=0} + 1 ))
}
function define_std_directories_init ()
{
  define_std_directories
}
# if ! [[ "$MAS_BASH_LOG" ]] ; then echo "::: $LINENO ${BASH_SOURCE[0]}: $LINENO ${BASH_SOURCE[1]}" >&2 ; sleep 10 ; fi


return 0


# vi: ft=sh
