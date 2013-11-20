export MASPROMPT_PS10='' MASPROMPT_NUMLINE=0 MASPROMPT_USE_PS1=yes MASPROMPT_PS10PWD="$PWD" MASPROMPT_PS10PWDS MASPROMPT_GEOMETRY MASPROMPT_OLD_RESULT MASPROMPT_OLD_WS MASPROMPT_DSECONDS0_OLD 
export MASPROMPT_ESCAPE_NP MASPROMPT_PS10LIMIT=2
declare -a MASPROMPT_APS10
function set_prompt_dollar ()
{
  if [[ "$MASPROMPT_USE_PS1" ]] ; then
    MASPROMPT_PS10="${MASPROMPT_PS10}"'\$'
    if [[ "$MASPROMPT_NUMLINE" ]] ; then
      MASPROMPT_APS10[$MASPROMPT_NUMLINE]="${MASPROMPT_APS10[$MASPROMPT_NUMLINE]}"'\$'
    fi
  elif [[ "$EUID" -gt 0 ]] ; then
    MASPROMPT_PS10="${MASPROMPT_PS10}"'$'
  else
    MASPROMPT_PS10="${MASPROMPT_PS10}"'#'
  fi
}
function set_prompt_string ()
{
  local s
  MASPROMPT_PS10="${MASPROMPT_PS10}${@}"
  if [[ "$MASPROMPT_NUMLINE" ]] ; then
    s=${MASPROMPT_APS10[$MASPROMPT_NUMLINE]}
    MASPROMPT_APS10[$MASPROMPT_NUMLINE]="${s}${@}"
  fi
# echo -e "[$MASPROMPT_NUMLINE : ${MASPROMPT_APS10[$MASPROMPT_NUMLINE]}]" >&2
}
function set_prompt_reset_colors ()
{
  if [[ "$MASPROMPT_ESCAPE_NP" ]] ; then
  # for PS1
    set_prompt_string '\[\e[0m\]'
    set_prompt_string "$@"
  else
  # for echo
    set_prompt_string '\e[0m'"$@"
  fi
}
function set_prompt_color_by_id ()
{
  local id=$1
  if [[ "$MASPROMPT_ESCAPE_NP" ]] ; then
  # for PS1
    set_prompt_string '\[\e['
  else
    set_prompt_string '\e['
  fi
  set_prompt_string "${MAS_DECORS[$id]}"
  
  declare -p MAS_COLORS >/dev/null 2>&1 || declare -Axg MAS_COLORS
  declare -p MAS_BGCOLORS >/dev/null 2>&1 || declare -Axg MAS_BGCOLORS
  declare -p MAS_DECORS >/dev/null 2>&1 || declare -Axg MAS_DECORS


  if [[ "${MAS_BGCOLORS[$id]}" ]] ; then
    if [[ "${MAS_DECORS[$id]}" ]] ; then
      set_prompt_string ';'
    fi
    set_prompt_string "${MAS_BGCOLORS[$id]}"
  fi
  if [[ "${MAS_COLORS[$id]}" ]] ; then
    if [[ "${MAS_BGCOLORS[$id]}" ]] || [[ "${MAS_DECORS[$id]}" ]] ; then
      set_prompt_string ';'
    fi
    set_prompt_string "${MAS_COLORS[$id]}"
  fi
  
  if [[ "$MASPROMPT_ESCAPE_NP" ]] ; then
  # for PS1
    set_prompt_string "m\]"
  else
  # for echo
    set_prompt_string "m"
  fi
}
function mas_prompt_test_condition ()
{
# ret. 1 (no) if one of letters present
  local l cond result=1
  cond=$@
  for l in $( echo $cond|sed -e 's@\(.\)@\1 @g' ) ; do
    if ! [[ $MASPROMPT_OPTIONS =~ $l ]] ; then
#     echo "$l : YES" >&2
      result=0
    fi
  done
  return $result
}
function mas_prompt_do ()
{
  for el in "$@" ; do
    if [[ "$el" == _* ]] ; then
      cmd="set_prompt$el"
      $cmd
    else
      ! [[ "$el" == '&' ]] && set_prompt_reset_colors "$el"
    fi
  done
  [[ "$el" == '&' ]] && set_prompt_reset_colors
}
