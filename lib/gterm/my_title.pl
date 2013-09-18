#!/usr/bin/perl

$mas_logdir_other="$ENV{MAS_BASH_LOG}/otherapps";
$mas_log_file="$mas_logdir_other/my_title_log";

#-- /bin/sh
#echo $0 $* >> /var/log/mastar/otherapps/my_profile_log
#echo 'mastar'
local *F;
open F, ">> $mas_log_file";
print F join(' ', $0, @ARGV), "\n";
my (@args)=@ARGV;
while(grep /^\-x$/, @args)
{ 
  shift @args;
}
print F "args[0]=".$args[0]." \n";
if ($args[0] eq 'ping')
{
  print "Ping";
}
else
{
  print "'mastar $args[2]'";
}
