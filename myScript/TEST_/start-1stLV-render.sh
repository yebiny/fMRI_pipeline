#!/bin/bash

SUBJ=${1}
INFIX=${2}


output=results/$SUBJ/1stLV
input1=results/$SUBJ/process/2-reorient
input2=results/$SUBJ/process/3-bet/t1_mprage_brain.nii.gz

template=templates/1stlv_$INFIX.fsf
design=exp_info/$SUBJ/design

bash render-1stLV-templates.sh $input1 $input2 $output $template $design $INFIX
