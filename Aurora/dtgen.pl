#!/usr/bin/env perl

$fid=0;
while(<>) {
    if (/^transfer/) {
        close OF;
        $fname = "data-".$fid.".csv";
        open (OF, "> $fname") || die "Cannot open $fname for write";
        printf(OF "# %s", $_);
        printf(OF "Size,GBps\n");
        $fid++;
    } elsif (/average\s+([\d\.]+)\s+(GByte)/) {
        $bw=$1;
    } elsif (/^result:\s*(\d+)\.\d+/) {
        $sz=$1;
        printf(OF "%s,%s\n", $sz, $bw);        
    }
}
