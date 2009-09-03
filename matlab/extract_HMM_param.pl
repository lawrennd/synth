#! /usr/local/bin/perl
#
# Extract mean and variance parameters from an HMM file
#

$hmmfile = "$ARGV[0]"; # input HMM filename
$meanfile = "$ARGV[1]"; # output mean filename
$varfile = "$ARGV[2]"; # output variance filename

open (HMMFILE, $hmmfile) || die "Couldn't open $filename";
open (MEANFILE, ">$meanfile") || die "Couldn't open $varfile";
open (VARFILE, ">$varfile") || die "Couldn't open $varfile";

$variance=0;
$mean=0;

while ($line=<HMMFILE>) {
  chop($line);
  @items = split(' ',$line);
  $item0 =uc $items[0]; # convert to upper case


  if ($variance!=0) {
    print VARFILE $line;
    $variance=0;
  } elsif ($mean!=0) {
    print MEANFILE $line;
    $mean=0;
  } elsif ($item0 eq "<BEGINHMM>") {
    $inHMM=1;
  } elsif ($item0 eq "<ENDHMM>") {
    $inHMM=0;
  } elsif ($item0 eq "<MEAN>" && $inHMM) {
    $mean=$items[1];
  } elsif ($item0 eq "<VARIANCE>" && $inHMM) {
    $variance=$items[1];
  }

}

print MEANFILE "\n";
print VARFILE "\n";
