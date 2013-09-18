#!/usr/bin/perl
use POSIX qw(strftime);
use strict;


sub suggest
{
  my ($prog_name,$workspace,$exec)=@_;

  my ($mas_logdir_other, $mas_log_file);
  $mas_logdir_other="$ENV{MAS_BASH_LOG}/otherapps";
  $mas_log_file="$mas_logdir_other/my_class_log";


  local *F;
  open F, ">> $mas_log_file";
  print F strftime("%a %b %e %H:%M:%S %Y", localtime()), "\n";
  print F "\n", ('@' x 50), "\n";
  print F join(' ', $0, @_), "\n";
  print F "\n", ('@' x 50), "\n";
  print F join("\n", $0, map {"$_='$ENV{$_}'"} keys(%ENV)), "\n", ('@' x 50)."\n";
  close F;

  if ($exec eq 'ytree')
  {
    return 'ytree';
  }
  elsif ($workspace)
  {
    return "$prog_name-$workspace";
  }
  else
  {
    return 'mastar';
  }
}
print suggest(@ARGV);
