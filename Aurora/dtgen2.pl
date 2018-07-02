#!/usr/bin/env perl
# (C) Copyright NEC Enterprise Communication Technologi Inc. 2018

$fname = "commbench.csv";
open (OF, "> $fname") || die "Cannot open $fname for write";

$fid=0;
%size=();
%bws=();
%cmt=();

printf("Creating '%s' ...\n", $fname);
while(<>) {
    if (/^logname=(\S+)$/) {
        $log=$1;
        $fid++;
        printf("fid=%d: %s\n", $fid, $log);
        $cmt{$fid} = $log;
    } elsif (/average\s+([\d\.]+)\s+(GByte)/) {
        $bw=$1;
    } elsif (/^result:\s*(\d+)\.\d+/) {
        $sz=$1;
        if (!exists($size{$sz})) {
            $size{$sz} = $sz; # any value is fine.
        }
        $bws{$fid}{$sz} = $bw;
    }
}

# writing header
printf(OF "Size");
for ($f = 1; $f <= $fid; $f++) {
   printf(OF ",%s", $cmt{$f});
}
printf(OF "\n");

# writig data

foreach $sz (sort { $a <=> $b } (keys(%size))) {
  printf(OF "%s", $sz);
  for ($f = 1; $f <= $fid; $f++) {
       if (exists($bws{$f}{$sz})) {
           printf(OF ",%s", $bws{$f}{$sz});
       } else {
           printf(OF ",");
      }
  }
  print(OF "\n");
}
close OF;

