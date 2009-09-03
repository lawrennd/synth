#! /usr/local/bin/perl
#
# Extract mean and variance parameters from an HMM file
#

$hmmfile = "$ARGV[0]"; # input HMM filename
$meanfile = "$ARGV[1]"; # input mean filename
$varfile = "$ARGV[2]"; # input variance filename
$outhmmfile = "$ARGV[3]"; # output HMM filename

open (HMMFILE, $hmmfile) || die "Couldn't open $filename";
open (MEANFILE, "$meanfile") || die "Couldn't open $varfile";
open (VARFILE, "$varfile") || die "Couldn't open $varfile";
open (OUTHMMFILE, ">$outhmmfile") || die "Couldn't open $outhmmfile";

$mean=0;
$variance=0;

$line=<MEANFILE>;
@means= split(' ',$line);

$line=<VARFILE>;
@vars = split(' ',$line);

$mindex=0;
$vindex=0;

while ($line=<HMMFILE>) {
  chop($line);
  @items = split(' ',$line);
  $item0 =uc $items[0]; # convert to upper case

  $write_line=1;

  if ($mean!=0) {
    while ($mean>0) {
      print OUTHMMFILE " ".$means[$mindex];
      $mindex++;
      $mean--;
    }
    print OUTHMMFILE "\n";
    $write_line=0;
    $mean=0;
  } elsif ($variance!=0) {
    while ($variance>0) {
      print OUTHMMFILE " ".$vars[$vindex];
      $vindex++;
      $variance--;
    }
    print OUTHMMFILE "\n";
    $variance=0;
    $write_line=0;
  } elsif ($item0 eq "<BEGINHMM>") {
    $inHMM=1;
  } elsif ($item0 eq "<ENDHMM>") {
    $inHMM=0;
  } elsif ($item0 eq "<MEAN>" && $inHMM) {
    $mean=$items[1];
  } elsif ($item0 eq "<VARIANCE>" && $inHMM) {
    $variance=$items[1];
  }

  if ($write_line) {
    print OUTHMMFILE $line."\n";
  }

}
