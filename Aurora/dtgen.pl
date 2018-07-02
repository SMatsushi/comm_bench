#!/usr/bin/env perl
## (C) Copyright NEC Enterprise Communication Technologi Inc. 2018

$fid=0;
while(<>) {
    if (/^logname=(\S+)$/) {
        $commt=$1;
        close OF;
        $fname = "data-".$commt.".csv";
        open (OF, "> $fname") || die "Cannot open $fname for write";
        printf(OF "%s\n", $commt);
        printf(OF "Size,GBps\n");
        $fid++;
    } elsif (/average\s+([\d\.]+)\s+(GByte)/) {
        $bw=$1;
    } elsif (/^result:\s*(\d+)\.\d+/) {
        $sz=$1;
        printf(OF "%s,%s\n", $sz, $bw);        
    }
}
