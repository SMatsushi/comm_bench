#!/usr/bin/env perl

$fname = "commbench.csv";
open (OF, "> $fname") || die "Cannot open $fname for write";

$fid=0;
%size=();
%bws=();
%cmt=();

while(<>) {
    if (/^transfer/) {
        $fid++;
        chomp;
        s/^transfer\s+rate\s+//;
        s/^between\s+//;
        printf("fid=%d: %s\n", $fid, $_);
        $cmt{$fid} = $_;
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

