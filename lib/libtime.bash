function datemtu ()
{
  /bin/date '+%Y%m%d.%H%M%S.%N'
}
function datemt ()
{
  /bin/date '+%Y%m%d.%H%M%S'
}
function datem ()
{
  /bin/date '+%Y%m%d'
}
function datet ()
{
  /bin/date '+.%H%M%S'
}
function umoment ()
{
  /bin/date +'%s.%N'
}

export -f datemtu datemt datem datet umoment
