
#       ESC 7		     (V)  Save Cursor and Attributes
#       ESC 8		     (V)  Restore Cursor and Attributes
#       ESC [s		     (A)  Save Cursor and Attributes
#       ESC [u		     (A)  Restore Cursor and Attributes
#       ESC [ Pn ; Pn H		  Direct Cursor Addressing
# echo -en "\e[s\e[0;$(( $COLUMNS -10 ))HTopright\e[u" ; sleep 3
#   or
# echo -en "\e[s\e[0;$(( $COLUMNS -10 ))fTopright\e[u" ; sleep 3
#      ESC [ Pn J		  Erase in Display
#            Pn = None or 0	  From Cursor to End of Screen
#       	  1		  From Beginning of Screen to Cursor
#       	  2		  Entire Screen
#      ESC [ Pn K		  Erase in Line
#            Pn = None or 0	  From Cursor to End of Line
#       	  1		  From Beginning of Line to Cursor
#       	  2		  Entire Line
#      ESC [ Pn X		  Erase character
#      ESC [ Pn A		  Cursor Up
#      ESC [ Pn B		  Cursor Down
#      ESC [ Pn C		  Cursor Right
#      ESC [ Pn D		  Cursor Left
#      ESC [ Pn E		  Cursor next line
#      ESC [ Pn F		  Cursor previous line
#      ESC [ Pn G		  Cursor horizontal position
#      ESC [ Pn `		  same as above
#      ESC [ Pn d		  Cursor vertical position
# ESC [ Pn ; Pn ... m
#       	  1		  Bold
#       	  2	     (A)  Faint
#       	  3	     (A)  Standout Mode (ANSI: Italicized)
#       	  4		  Underlined
#       	  5		  Blinking
#       	  7		  Negative Image
#       	  22	     (A)  Normal Intensity
#       	  23	     (A)  Standout Mode off (ANSI: Italicized off)
#       	  24	     (A)  Not Underlined
#       	  25	     (A)  Not Blinking
#       	  27	     (A)  Positive Image
#       	  30	     (A)  Foreground Black
#       	  31	     (A)  Foreground Red
#       	  32	     (A)  Foreground Green
#       	  33	     (A)  Foreground Yellow
#       	  34	     (A)  Foreground Blue
#       	  35	     (A)  Foreground Magenta
#       	  36	     (A)  Foreground Cyan
#       	  37	     (A)  Foreground White
#       	  39	     (A)  Foreground Default
#		  90
#		  91
#		  92
#		  93
#		  94
#		  95
#		  96
#		  97
#       	  40	     (A)  Background Black
#       	  ...
#       	  49	     (A)  Background Default
#100 101 102 103 104 105 106 107



# Back: 
# 40  gray      #3D3D3D = fg 30
# 41 dark red - #AA0000 = fg 31
# 42 green #00AA00 = fg 32
# 43 brown #AA5500 = fg 33
# 44 blue #0000AA = fg 34
# 45 magenta #AA00AA = fg 35
# 46 cyan #00AAAA = fg 36
# 47 gray #AAAAAA
# 49 current / default ?!
# 100 dark gray #555555
# 101      #FF5555 Light brilliant red = fg 91
# 102      #55FF55 Light brilliant green = fg 92
# 103      #FFFF55 yellow = fg 93
# 104      #5555FF Light brilliant blue = fg 94
# 105      #FF55FF (Light brilliant) magenta = fg 95
# 106      #55FFFF (Light brilliant) cyan  = fg 96
# 107      #FFFFFF white = fg 97 

# Fore:
# 30 gray = bg 40
# 31 dark red = bg 41
# 32 green = bg 42
# 33 brown = bg 43
# 34 blue = bg 44
# 35 magenta = bg 45
# 36 #00AAAA = bg 46
# 37 #AAAAAA = bg 47 white
# 39 current / default ?!
# 90 light gray : #555555 = bg 100
# 91 Light brilliant red = bg 101
# 92 Light brilliant green = bg 102
# 93 Light brilliant yellow = bg 103
# 94 Light brilliant blue = fg 94
# 95 (Light brilliant) magenta = bg 105
# 96 (Light brilliant) cyan = bg 106
# 97 white = bg 107

# Decorations
# 1 bold
# 2 low intensity
# 4 underline
# 5 blinking
# 7 negative
# 8 invisible
# 9 striked-out
# 10    The ASCII character set is the current 7-bit display character set (default)—SCO Console only.
# 11    Map Hex 00-7F of the PC character set codes to the current 7-bit display character set—SCO Console only.
# 12    Map Hex 80-FF of the current character set to the current 7-bit display character set—SCO Console only.
# 22    bold off
# 24    underline off
# 25    blinking off
# 27    negative off
# 28    invisible off

function mas_init_colors ()
{
  declare -p MAS_COLORS >/dev/null 2>&1 || declare -Axg MAS_COLORS
  declare -p MAS_BGCOLORS >/dev/null 2>&1 || declare -Axg MAS_BGCOLORS
  declare -p MAS_DECORS >/dev/null 2>&1 || declare -Axg MAS_DECORS


  MAS_BGCOLORS[cmdnum]=49
  MAS_DECORS[cmdnum]='27;1'
  MAS_COLORS[cmdnum]='33'


  MAS_DECORS[date]=1
  MAS_BGCOLORS[date]=44
  MAS_COLORS[date]=93

  MAS_DECORS[day]=1
  MAS_BGCOLORS[day]=44
  MAS_COLORS[day]=93

  MAS_BGCOLORS[eofsign]=104
  MAS_DECORS[eofsign]=1
  MAS_COLORS[eofsign]=37

  MAS_COLORS[geometry]=32
  MAS_DECORS[geometry]=''
  MAS_BGCOLORS[geometry]=''

  MAS_COLORS[bash_version]=35
  MAS_DECORS[bash_version]=''
  MAS_BGCOLORS[bash_version]=''

  MAS_DECORS[highlight]=1


  MAS_DECORS[negative]=7

  MAS_DECORS[nohighlight]=22

  MAS_DECORS[workdir]='7'
  MAS_BGCOLORS[workdir]='48' 
  MAS_COLORS[workdir]=37

  MAS_BGCOLORS[pid]=''
  MAS_DECORS[pid]=''
  MAS_COLORS[pid]=36

  MAS_DECORS[symbol]='27;1'
  MAS_BGCOLORS[symbol]=42
  MAS_COLORS[symbol]=93

  MAS_DECORS[sadsymbol]='27;1'
  MAS_BGCOLORS[sadsymbol]=41
  MAS_COLORS[sadsymbol]=93

  MAS_DECORS[result]=1
  MAS_BGCOLORS[result]=41
  MAS_COLORS[result]=93

  MAS_COLORS[ruby]=32
  MAS_BGCOLORS[ruby]=41
  MAS_DECORS[ruby]='22;7'

  MAS_DECORS[sad]='1;7'
  MAS_COLORS[sad]=31 
  MAS_BGCOLORS[sad]=40 

  MAS_BGCOLORS[smiley]=103
  MAS_COLORS[smiley]=32
  MAS_DECORS[smiley]=7

  MAS_DECORS[time]=1
  MAS_COLORS[time]=32
  MAS_BGCOLORS[time]=44

  MAS_DECORS[current_time]='1'
  MAS_COLORS[current_time]=37
  MAS_BGCOLORS[current_time]=49

  MAS_DECORS[timing2]=''
  MAS_COLORS[timing2]=34
  MAS_BGCOLORS[timing2]=49

  MAS_BGCOLORS[timingx]=''
  MAS_DECORS[timingx]=''
  MAS_COLORS[timingx]=31

  MAS_COLORS[tty]=31
  MAS_DECORS[tty]=''
  MAS_BGCOLORS[tty]=49

  MAS_COLORS[stty]=33
  MAS_DECORS[stty]=''
  MAS_BGCOLORS[stty]=49

  MAS_COLORS[sttypp]=35
  MAS_DECORS[sttypp]=''
  MAS_BGCOLORS[sttypp]=49

  MAS_DECORS[workspace]=1
  MAS_COLORS[workspace]=39
  MAS_BGCOLORS[workspace]=42

  MAS_DECORS[terminal_emulator]=1
  MAS_COLORS[terminal_emulator]=39
  MAS_BGCOLORS[terminal_emulator]=42

  MAS_DECORS[underline]=4

  MAS_BGCOLORS[host]=46 ; MAS_COLORS[host]=30 ; MAS_DECORS[host]=''
  MAS_BGCOLORS[user]=49 ; MAS_COLORS[user]=33 ; MAS_DECORS[user]='1'


  MAS_DECORS[screen_windid]=1
  MAS_COLORS[screen_windid]=35
  MAS_BGCOLORS[screen_windid]=41

  MAS_DECORS[windowid]=1
  MAS_COLORS[windowid]=35
  MAS_BGCOLORS[windowid]=49

  MAS_DECORS[screen_started]=1
  MAS_COLORS[screen_started]=33
  MAS_BGCOLORS[screen_started]=43

  MAS_BGCOLORS[term]=49
  MAS_COLORS[term]='33'
  MAS_DECORS[term]='27;1'

  MAS_BGCOLORS[error_title]=49
  MAS_COLORS[error_title]=91
  MAS_DECORS[error_title]='1;7'

  MAS_BGCOLORS[error_who]=49
  MAS_COLORS[error_who]='33'
  MAS_DECORS[error_who]=''

  MAS_BGCOLORS[error_where]=49
  MAS_COLORS[error_where]='34'
  MAS_DECORS[error_where]='1'

  MAS_BGCOLORS[error_how]=49
  MAS_COLORS[error_how]='34'
  MAS_DECORS[error_how]='1'

  MAS_BGCOLORS[error_comment]=49
  MAS_COLORS[error_comment]='31'
  MAS_DECORS[error_comment]=''

  MAS_BGCOLORS[error_details]=49
  MAS_COLORS[error_details]='92'
  MAS_DECORS[error_details]='1'







  case "$TERM" in
  screen)
    MAS_DECORS[timingx]=''
    MAS_COLORS[timingx]=31
    MAS_BGCOLORS[timingx]=49

    MAS_DECORS[current_time]='1'
    MAS_COLORS[current_time]=37
    MAS_BGCOLORS[current_time]=49

    MAS_DECORS[delta_time]='1'
    MAS_COLORS[delta_time]=32
    MAS_BGCOLORS[delta_time]=49

    MAS_DECORS[period_time]='1'
    MAS_COLORS[period_time]=37
    MAS_BGCOLORS[period_time]=49

    MAS_DECORS[timing2]=''
    MAS_COLORS[timing2]=34
    MAS_BGCOLORS[timing2]=49

    MAS_DECORS[pid]=''
    MAS_COLORS[pid]=36
    MAS_BGCOLORS[pid]=49

  MAS_BGCOLORS[cmdnum]=49
MAS_DECORS[cmdnum]='27;1'
MAS_COLORS[cmdnum]='33'

    MAS_DECORS[geometry]=''
    MAS_DECORS[bash_version]=''
    MAS_BGCOLORS[bash_version]=''
  ;;
  *)
  ;;
  esac
}
function mas_set_color_by_id ()
{
  local id=$1
  declare -p MAS_COLORS >/dev/null 2>&1 || declare -Axg MAS_COLORS
  declare -p MAS_BGCOLORS >/dev/null 2>&1 || declare -Axg MAS_BGCOLORS
  declare -p MAS_DECORS >/dev/null 2>&1 || declare -Axg MAS_DECORS

  echo -e "\e[${MAS_DECORS[$id]};${MAS_BGCOLORS[$id]};${MAS_COLORS[$id]}m"
}
function set_reset_colors ()
{
  echo -e "\e[0m"
}
export -f mas_init_colors mas_set_color_by_id set_reset_colors 


return 0
