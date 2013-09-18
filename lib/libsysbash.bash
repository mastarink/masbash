mas_get_lib_ifnot time datemt
export MAS_TIME_LIBSYSBASH=$(datemt)


function files_at_bash_dirs ()
{
  local findopts="! -name '.*.swp'"
# if [ -z "$MAS_DIRS_SEARCH_BASH" ] ; then
#   MAS_DIRS_SEARCH_BASH="$MAS_CONF_DIR_BASH $MAS_CONF_DIR_PATH $MAS_CONF_DIR_PROFILE $MAS_CONF_DIR_UTIL $MAS_CONF_DIR_WS"
# fi
  (
#   find $HOME/.bash* $HOME/.profile* $HOME/.xprofile* $MAS_SHLIB/* -maxdepth 0 \( -type l -or -type f \) \! -name '.*.swp'
    if [[ "$HOME" ]] ; then 
      find -L $HOME/{.bash,.profile,.xprofile}*                    -maxdepth 0 \( -type l -or -type f \) $findopts 2>/dev/null 
      find -L $MAS_SHLIB   -maxdepth 1 \( -type l -or -type f \) $findopts 2>/dev/null 
    fi
    if [[ "$MAS_DIRS_SEARCH_BASH" ]] ; then find -L $MAS_DIRS_SEARCH_BASH -type f $findopts 2>/dev/null ; fi
  ) | sort | uniq
}
function files_at_bash_dirs_cached ()
{
  if ! [[ "$MAS_FILES_AT_BASH_DIRS_CACHE" ]] ; then
    export MAS_FILES_AT_BASH_DIRS_CACHE=$( files_at_bash_dirs )
  fi
  echo "$MAS_FILES_AT_BASH_DIRS_CACHE"
}
function command_at_bash_dirs ()
{
  files_at_bash_dirs_cached | xargs "$@"
}
function grep_nocolor_at_bash_dirs ()
{
# echo "Search at `files_at_bash_dirs`" >&2
  command_at_bash_dirs grep --color=never "$@" 2>/dev/null
}
function grep_at_bash_dirs ()
{
# echo "Search at `files_at_bash_dirs`" >&2
  if [[ "$@" ]] ; then
    command_at_bash_dirs grep --color=auto "$@" 2>/dev/null
  fi
}
