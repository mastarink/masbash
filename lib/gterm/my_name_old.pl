#!/usr/bin/perl
use POSIX qw(strftime);

$mas_logdir_other="$ENV{MAS_BASH_LOG}/otherapps";
$mas_log_file="$mas_logdir_other/my_name_log";


#-- /bin/sh
#echo $0 $* >> /var/log/mastar/otherapps/my_profile_log
#echo 'mastar'
local *F;
open F, ">> $mas_log_file";
print F strftime("%a %b %e %H:%M:%S %Y", localtime()), "\n";
print F "\n", ('@' x 50), "\n";
print F join(' ', $0, @ARGV), "\n";
print F "\n", ('@' x 50), "\n";
print F join("\n", $0, map {"$_='$ENV{$_}'"} keys(%ENV)), "\n", ('@' x 50)."\n";
my (@args)=@ARGV;
while(grep /^\-x$/, @args)
{ 
  shift @args;
}

if ($args[0] ne 'gnome-terminal')
{
  print 'mastar';
}
elsif ($args[1] eq 'ping')
{
  print 'masworkterminal';
}
elsif ($args[1] eq 'ytree')
{
  print 'ytree';
}
elsif ( $args[1]=~/^\s*$/ )
{

}
else
{
  print 'masworkterminal.'.$args[1];
}

