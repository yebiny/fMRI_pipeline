#!/bin/bash

SUBJ=${1}

TEMPLATE=templates
DESIGN=exp_info/$SUBJ/design
STANDARD_BRAIN=/usr/local/fsl/data/standard/MNI152_T1_2mm_brain

output=results/$SUBJ
input1=$output/process/2-reorient
input2=$output/process/3-bet/t1_mprage_brain.nii.gz

bash render-fsf-templates.sh $input1 $input2 $output $TEMPLATE $DESIGN $STANDARD_BRAIN
