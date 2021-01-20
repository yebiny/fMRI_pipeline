#!/bin/bash

SUBJ=${1}
INFIX=${2}

TEMPLATE=templates/2ndlv_template.fsf

input1=results/$SUBJ/1stLV
input2=$INFIX
output=results/$SUBJ/2ndLV

bash render-2ndLV-templates.sh $input1 $input2 $output $TEMPLATE
