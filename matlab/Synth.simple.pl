#!/usr/bin/perl
# ----------------------------------------------------------------- #
#           The HMM-Based Speech Synthesis System (HTS)             #
#           developed by HTS Working Group                          #
#           http://hts.sp.nitech.ac.jp/                             #
# ----------------------------------------------------------------- #
#                                                                   #
#  Copyright (c) 2001-2008  Nagoya Institute of Technology          #
#                           Department of Computer Science          #
#                                                                   #
#                2001-2008  Tokyo Institute of Technology           #
#                           Interdisciplinary Graduate School of    #
#                           Science and Engineering                 #
#                                                                   #
# All rights reserved.                                              #
#                                                                   #
# Redistribution and use in source and binary forms, with or        #
# without modification, are permitted provided that the following   #
# conditions are met:                                               #
#                                                                   #
# - Redistributions of source code must retain the above copyright  #
#   notice, this list of conditions and the following disclaimer.   #
# - Redistributions in binary form must reproduce the above         #
#   copyright notice, this list of conditions and the following     #
#   disclaimer in the documentation and/or other materials provided #
#   with the distribution.                                          #
# - Neither the name of the HTS working group nor the names of its  #
#   contributors may be used to endorse or promote products derived #
#   from this software without specific prior written permission.   #
#                                                                   #
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND            #
# CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,       #
# INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF          #
# MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE          #
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS #
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,          #
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED   #
# TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,     #
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON #
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,   #
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY    #
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE           #
# POSSIBILITY OF SUCH DAMAGE.                                       #
# ----------------------------------------------------------------- #

# Based on Training.pl from the HTS working group. Modified 2009 by Jon Barker.

$|=1;

if (@ARGV<4) {
   print "usage: Synth.simple.pl Config.synth.pm cmpHMM durHMM labfile outdir workingdir\n";
   exit(0);
}
$cmphmm=$ARGV[1];
print "$cmphmm";
$durhmm = $ARGV[2];
$labfile = $ARGV[3];
$outdir = $ARGV[4];
$prjdir= $ARGV[5]; 

# load configuration variables
require($ARGV[0]);


# File locations =========================

# list of label files describing utterances to be synthesised
shell("echo $labfile > utterance.lab");
$scp{'gen'} = "utterance.lab";


# file containing list of hmm model names
$lst{'monoc'} = "$prjdir/etc/monocsp.list";

# configuration variable files for HMGenS
$cfg{'syn'} = "$prjdir/configs/syn.cnf";

# model files
foreach $set (@SET){
   $gvmmf{$set}   = "$prjdir/etc/gv.mmf";
   $gvlst{$set}   = "$prjdir/etc/gv.list";
}

# window files for parameter generation
$windir = "$prjdir/etc/win";
foreach $type (@cmp) {
   for ($d=1;$d<=$nwin{$type};$d++) {
      $win{$type}[$d-1] = "${type}.win${d}";
  }
}

# model structure
$vSize{'total'} = 0;
$nstream{'total'} = 0;
$nPdfStreams = 0;
foreach $type (@cmp) {
   $vSize{$type}      = $nwin{$type}*$ordr{$type};
   $vSize{'total'}   += $vSize{$type};
   $nstream{$type}    = $stre{$type}-$strb{$type}+1;
   $nstream{'total'} += $nstream{$type};
   $nPdfStreams++;
}

# HTS Commands & Options ========================
$HMGenS         = "$HMGENS -A -B -C $cfg{'syn'} -D -T 1 -S $scp{'gen'} -t $beam ";


# =============================================================
# ===================== Main Program ==========================
# =============================================================

# preparing environments

# HMGenS (generating speech parameter sequences (1mix))


make_config();

print_time("generating speech parameter sequences (1mix)");


$pgtype=0;

# generate parameter
$dir = "$outdir";
mkdir $dir, 0755;

shell("$HMGenS  -c 0 -v 0.5 -H $cmphmm -N $durhmm -M $dir $lst{'monoc'} $lst{'monoc'}");
shell("rm -f $scp{'gen'}");

# SPTK (synthesizing waveforms (1mix))
print_time("synthesizing waveforms (1mix)");

gen_wave("${dir}");





# sub routines ============================

# =============================================================
# =============================================================
# =============================================================

sub shell($) {
   my($command) = @_;
   my($exit);

   $exit = system($command);

   if($exit/256 != 0){
      die "Error in $command\n"
   }
}

sub print_time ($) {
   my($message) = @_;
   my($ruler);
   
   $message .= `date`;
   
   $ruler = '';
   for ($i=0; $i<=length($message)+10; $i++) {
      $ruler .= '=';
   }
   
   print "\n$ruler\n";
   print "Start @_ at ".`date`;
   print "$ruler\n\n";
}



sub make_config {
   my($s,$type,@boolstring);
   $boolstring[0] = 'FALSE';
   $boolstring[1] = 'TRUE';

   # config file for parameter generation
   open(CONF,">$cfg{'syn'}") || die "Cannot open $!";
   print CONF "NATURALREADORDER = T\n";
   print CONF "NATURALWRITEORDER = T\n";
   print CONF "USEALIGN = T\n";
   
   print CONF "PDFSTRSIZE = \"IntVec $nPdfStreams";  # PdfStream structure
   foreach $type (@cmp) {
      print CONF " $nstream{$type}";
   }
   print CONF "\"\n";
   
   print CONF "PDFSTRORDER = \"IntVec $nPdfStreams";  # order of each PdfStream
   foreach $type (@cmp) {
      print CONF " $ordr{$type}";
   }
   print CONF "\"\n";
   
   print CONF "PDFSTREXT = \"StrVec $nPdfStreams";  # filename extension for each PdfStream
   foreach $type (@cmp) {
      print CONF " $type";
   }
   print CONF "\"\n";
   
   print CONF "WINFN = \"";
   foreach $type (@cmp) {
      print CONF "StrVec $nwin{$type} @{$win{$type}} ";  # window coefficients files for each PdfStream
   }
   print CONF "\"\n";
   print CONF "WINDIR = $windir\n";  # directory which stores window coefficients files
   
   print CONF "MAXEMITER = $maxEMiter\n";
   print CONF "EMEPSILON = $EMepsilon\n";
   print CONF "USEGV      = $boolstring[$useGV]\n";
   print CONF "GVMODELMMF = $gvmmf{'cmp'}\n";
   print CONF "GVHMMLIST  = $gvlst{'cmp'}\n";
   print CONF "MAXGVITER  = $maxGViter\n";
   print CONF "GVEPSILON  = $GVepsilon\n";
   print CONF "MINEUCNORM = $minEucNorm\n";
   print CONF "STEPINIT   = $stepInit\n";
   print CONF "STEPINC    = $stepInc\n";
   print CONF "STEPDEC    = $stepDec\n";
   print CONF "HMMWEIGHT  = $hmmWeight\n";
   print CONF "GVWEIGHT   = $gvWeight\n";
   print CONF "OPTKIND    = $optKind\n";
   
   close(CONF);      
}

# sub routine for log f0 -> f0 conversion
sub lf02pitch($$) {
   my($base,$gendir) = @_;
   my($t,$T,$data);

   # read log f0 file
   open(IN,"$gendir/${base}.lf0");
   @STAT=stat(IN);
   read(IN,$data,$STAT[7]);
   close(IN);

   # log f0 -> pitch conversion
   $T = $STAT[7]/4;
   @frq = unpack("f$T",$data);
   for ($t=0; $t<$T; $t++) {
      if ($frq[$t] == -1.0e+10) {
         $out[$t] = 0.0;
      } else {
         $out[$t] = $sr/exp($frq[$t]);
      }
   }
   $data = pack("f$T",@out);

   # output data
   open(OUT,">$gendir/${base}.pit");
   print OUT $data;
   close(OUT);
}

# sub routine for formant emphasis in Mel-cepstral domain
sub postfiltering($$) {
   my($base,$gendir) = @_;
   my($i,$line);

   # output postfiltering weight coefficient 
   $line = "echo 1 1 ";
   for ($i=2; $i<$ordr{'mgc'}; $i++) {
      $line .= "$pf ";
   }
   $line .= "| $X2X +af > $gendir/weight";
   shell($line);

   # calculate auto-correlation of original mcep
   $line = "$FREQT -m ".($ordr{'mgc'}-1)." -a $fw -M $co -A 0 < $gendir/${base}.mgc |"
         . "$C2ACR -m $co -M 0 -l $fl > $gendir/${base}.r0";
   shell($line);
         
   # calculate auto-correlation of postfiltered mcep   
   $line = "$VOPR  -m -n ".($ordr{'mgc'}-1)." < $gendir/${base}.mgc $gendir/weight | "
         . "$FREQT    -m ".($ordr{'mgc'}-1)." -a $fw -M $co -A 0 | "
         . "$C2ACR -m $co -M 0 -l $fl > $gendir/${base}.p_r0";
   shell($line);

   # calculate MLSA coefficients from postfiltered mcep 
   $line = "$VOPR -m -n ".($ordr{'mgc'}-1)." < $gendir/${base}.mgc $gendir/weight | "
         . "$MC2B    -m ".($ordr{'mgc'}-1)." -a $fw | "
         . "$BCP     -n ".($ordr{'mgc'}-1)." -s 0 -e 0 > $gendir/${base}.b0";
   shell($line);
   
   # calculate 0.5 * log(acr_orig/acr_post)) and add it to 0th MLSA coefficient     
   $line = "$VOPR -d < $gendir/${base}.r0 $gendir/${base}.p_r0 | "
         . "$SOPR -LN -d 2 | "
         . "$VOPR -a $gendir/${base}.b0 > $gendir/${base}.p_b0";
   shell($line);
   
   # generate postfiltered mcep
   $line = "$VOPR  -m -n ".($ordr{'mgc'}-1)." < $gendir/${base}.mgc $gendir/weight | "
         . "$MC2B     -m ".($ordr{'mgc'}-1)." -a $fw | "
         . "$BCP      -n ".($ordr{'mgc'}-1)." -s 1 -e ".($ordr{'mgc'}-1)." | "
         . "$MERGE    -n ".($ordr{'mgc'}-2)." -s 0 -N 0 $gendir/${base}.p_b0 | "
         . "$B2MC     -m ".($ordr{'mgc'}-1)." -a $fw > $gendir/${base}.p_mgc";
   shell($line);
}

# sub routine for speech synthesis from log f0 and Mel-cepstral coefficients 
sub gen_wave($) {
   my($gendir) = @_;
   my($line,@FILE,$num,$period,$file,$base);

   $line   = `ls $gendir/*.mgc`;
   @FILE   = split('\n',$line);
   $num    = @FILE;
   $lgopt = "-l" if ($lg);

   print "Processing directory $gendir:\n";  
   foreach $file (@FILE) {
      $base = `basename $file .mgc`;
      chomp($base);
      if ( -s $file && -s "$gendir/$base.lf0" ) {
         print " Synthesizing a speech waveform from $base.mgc and $base.lf0...";
         
         # convert log F0 to pitch
         lf02pitch($base,$gendir);
         
         if ($ul) {
            # MGC-LSPs -> MGC coefficients
            $line = "$LSPCHECK -m ".($ordr{'mgc'}-1)." -s ".($sr/1000)." -r $file | "
                  . "$LSP2LPC  -m ".($ordr{'mgc'}-1)." -s ".($sr/1000)." $lgopt | "
                  . "$MGC2MGC  -m ".($ordr{'mgc'}-1)." -a $fw -g $gm -n -u -M ".($ordr{'mgc'}-1)." -A $fw -G $gm "
                  . " > $gendir/$base.c_mgc";
            shell($line);

            $mgc = "$gendir/$base.c_mgc";
         }
         else { 
            # apply postfiltering
             if ($gm==0 && $pf!=1.0 && $useGV==0) {
               postfiltering($base,$gendir);
               $mgc = "$gendir/$base.p_mgc";
             }
             else {
                $mgc = $file;
             }
         }

         # synthesize waveform
         $line = "$EXCITE -p $fs $gendir/$base.pit | "
               . "$MGLSADF -m ".($ordr{'mgc'}-1)." -p $fs -a $fw -c $gm $mgc  > xxx; "
               . "$F2S xxx yyy; "
               . "cat yyy | $SOX -c 1 -s -w -t raw -r $sr - -c 1 -s -w -t wav -r $sr - > $gendir/$base.wav; rm xxx yyy;";
	 shell("rm -f xxx; rm -f yyy");
	 print("\n$line\n");
         shell($line);

         print "done\n";
      }
   }
   print "done\n";
}



##################################################################################################

