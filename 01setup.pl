#!/usr/bin/perl

#open (HELP, ">help.txt");

#################
## SUBROUTINES ##
#################

sub define_variable {
      open (TMP, ">tmp");
      print TMP "$CC", $tmp_list;
      close TMP;

      read_file("tmp");
      system ("rm -rf tmp");
      @{$_[1]} = @array;
      $_[2] = $row;
      @{$_[3]} = @cntr;
}

sub read_file {
      @array = (); @cntr = (); #clear temporary array and column counter
      open (IN,$_[0]) or die ("Error: file ($_[0]) not found!\n");
      $nrow = 1; #initialize row variable to zero
      while(<IN>) {
            chomp; @line = split (/\s+/,$_);
            $col = (); $col = @line; #clear column variable then  count entries on a line (starts from 0)
            push @{$array[$nrow]}, $nrow;
            foreach $column (@line) {
                  push @{$array[$nrow]}, $column; #row starts at [1] and column starts at [1] if there are no indents
                  $cntr[$nrow] =  $col;
            }
            $nrow++;
      }
      $row = $nrow-1;

      close (IN);
}

sub get_wrkdir {
      $wrkdir = ();
      system ("pwd > wrkdir_tmp");
      open (IN, "wrkdir_tmp"); 
      $row = 0;
      @array = (); 
      while(<IN>) {
            chomp; @line = split (/\s+/,$_);
            foreach $column (@line) {
                  push @{$array[$row]}, $column;
            }
            $row++;
      }
      close (IN);

      $wrkdir = $array[0][0];
      system ("rm wrkdir_tmp");
      print "$wrkdir\n";
}

#######################
## DEFAULT VARIABLES ##
#######################

@lt = localtime(time);
$timestamp = sprintf "%04d-%02d-%02d, %02d:%02d:%02d", $lt[5]+1900, $lt[4]+1, @lt[3,2,1,0];

############
## INPUTS ##
############

$CC=<<"CC";
Enter a message for commiting files:
CC
print $CC;
$msg1 = <STDIN>;
chomp $msg1;

$CC=<<"CC";
Add an optional exteded description...
CC
print $CC;
$msg2 = <STDIN>;
chomp $msg2;

################
## MAIN BLOCK ##
################

get_wrkdir;

$CC=<<"CC";
git status command shows me all of the
files that were updated or created or
deleted but haven't been saved in a
commit yet 

you need to use the git add command to
track untracked files

use a period at the end of git add which means
you're telling it to track all of the
files that are listed

origin is the location of our git repository 
master is the branch that we want to push to
CC

$SYS=<<"SYS";
git add .
git commit -m "$msg1" -m "$msg2"
git push origin
SYS
printf "\n$SYS\n";
system "$SYS";

$prompt=<<"CC";
Do you want to push the changes to github.com? (y/n)
CC
print "$prompt";

$CC=<<"CC";
origin is the location of our git repository 
master is the branch that we want to push to
CC

if ($prompt eq 'y') {
$SYS=<<"SYS";
git push origin master
SYS
printf "\n$SYS\n";
system "$SYS";      
}

##############
## END MAIN ##
##############

$CC=<<"CC";
CC
printf HELP "$CC";

close HELP;
