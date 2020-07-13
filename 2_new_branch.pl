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

################
## MAIN BLOCK ##
################

@lt = localtime(time);
$timestamp = sprintf "%04d-%02d-%02d, %02d:%02d:%02d", $lt[5]+1900, $lt[4]+1, @lt[3,2,1,0];
get_wrkdir;

################
## GIT BRANCH ##
################

$SYS=<<"SYS";
git branch
SYS
printf "\n$SYS\n";
system "$SYS";

$CC=<<"CC";
Insert a name for the new branch (Otherwise Ctrl+C):
CC
print $CC;
$input = <STDIN>;
chomp $input;

if ($input eq '') {
      die ("Error: No input provided!\n");
}

$SYS=<<"SYS";
git checkout -b $input
SYS
printf "\n$SYS\n";
system "$SYS";

##############
## END MAIN ##
##############

$CC=<<"CC";
CC
printf HELP "$CC";

close HELP;
