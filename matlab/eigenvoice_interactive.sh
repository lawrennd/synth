#!/bin/bash

PERL="perl"


TYPE=$1
WORKDIR=$2
MEANPARAM="${WORKDIR}$3"
VARPARAM="${WORKDIR}$4"

MEAN_CMP_HMM="${WORKDIR}data/meancmp.mmf"
MEAN_DUR_HMM="${WORKDIR}data/meandur.mmf"

if [ $TYPE = "dur" ]; then

$PERL ${WORKDIR}insert_HMM_param.pl $MEAN_DUR_HMM $MEANPARAM $VARPARAM ${WORKDIR}tmp/hmm.dur.interactive

${WORKDIR}Synth.simple.pl ${WORKDIR}Config.synth.pm $MEAN_CMP_HMM ${WORKDIR}tmp/hmm.dur.interactive ${WORKDIR}data/demo.lab ${WORKDIR}data/demo $WORKDIR

else if [ $TYPE = "cmp" ]; then

$PERL ${WORKDIR}insert_HMM_param.pl $MEAN_CMP_HMM $MEANPARAM $VARPARAM ${WORKDIR}tmp/hmm.cmp.interactive

${WORKDIR}Synth.simple.pl ${WORKDIR}Config.synth.pm ${WORKDIR}tmp/hmm.cmp.interactive $MEAN_DUR_HMM ${WORKDIR}data/demo.lab ${WORKDIR}data/demo $WORKDIR

else if [ $TYPE = "mean" ]; then

${WORKDIR}Synth.simple.pl ${WORKDIR}Config.synth.pm $MEAN_CMP_HMM $MEAN_DUR_HMM ${WORKDIR}data/demo.lab ${WORKDIR}data/demo $WORKDIR

fi

fi

fi

