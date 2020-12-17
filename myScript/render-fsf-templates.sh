#!/bin/bash
set -e

function render_firstlevel {
  fsf_template=$1
  output_dir=$2
  standard_brain=$3
  data_file_prefix=$4
  initial_highres_file=$5
  highres_file=$6
  ev_dir1=$7
  ev_dir2=$8
  ev_dir=$9

  subject_dir=$(pwd)

  # note: the following replacements put absolute paths into the fsf file. this
  #       is necessary because FEAT changes directories internally
  cat $fsf_template \
    | sed "s:<?= \$OUTPUT_DIR ?>:$subject_dir/$output_dir:g" \
    | sed "s:<?= \$STANDARD_BRAIN ?>:$standard_brain:g" \
    | sed "s:<?= \$DATA_FILE_PREFIX ?>:$subject_dir/$data_file_prefix:g" \
    | sed "s:<?= \$INITIAL_HIGHRES_FILE ?>:$subject_dir/$initial_highres_file:g" \
    | sed "s:<?= \$HIGHRES_FILE ?>:$subject_dir/$highres_file:g" \
    | sed "s:<?= \$EV1 ?>:$subject_dir/$ev_dir1:g" \
    | sed "s:<?= \$EV2 ?>:$subject_dir/$ev_dir2:g" \
    | sed "s:<?= \$EV_DIR ?>:$subject_dir/$ev_dir:g" 

}

#FIX
USELESS_BRAIN=t1_flash01.nii.gz
MPRAGE_BRAIN=results/3-bet/sub01/sub01_t1_mprage_brain.nii.gz
STANDARD_BRAIN=/usr/local/fsl/data/standard/MNI152_T1_2mm_brain

#VARIABLES
TARGET_DIR=results/2-reorient/sub01
OUTPUT_DIR=results/4-glm/sub01
TEMPLATE_DIR=data/templates
DESIGN_DIR=data/design/

if [ -d "$OUTPUT_DIR" ]; then
  read -t 5 -p "data has already been converted. overwrite? (y/N) " overwrite || true
  if [ "$overwrite" != "y" ]; then exit; fi
  rm -rf $OUTPUT_DIR
fi
mkdir -p $OUTPUT_DIR

template=$TEMPLATE_DIR/phase2_initRep.fsf.template
for target in `ls $TARGET_DIR/*repSup*nii*`;
do
    outfix=$(echo ${target%%.*}| cut -d'_' -f 2,3)
    printf '==========================================\n'
    printf '* target: '$target'\n'
    printf '* template: '$template'\n'
    printf '* output: '$OUTPUT_DIR/$outfix'\n' 
    render_firstlevel $template \
                      $OUTPUT_DIR/$outfix.feat\
                      $STANDARD_BRAIN \
                      $target \
                      $USELESS_BRAIN \
                      $MPRAGE_BRAIN \
                      . \
                      . \
                      $DESIGN_DIR/$outfix \
                      > $OUTPUT_DIR/$outfix.fsf
done

template=$TEMPLATE_DIR/phase1_stimBase.fsf.template
for target in `ls $TARGET_DIR/*train*nii*`;
do
    outfix=$(echo ${target%%.*}| cut -d'_' -f 2,3)
    printf '==========================================\n'
    printf '* target: '$target'\n'
    printf '* template: '$template'\n'
    printf '* output: '$OUTPUT_DIR/$outfix'\n' 
    render_firstlevel $template \
                      $OUTPUT_DIR/$outfix.feat\
                      $STANDARD_BRAIN \
                      $target \
                      $USELESS_BRAIN \
                      $MPRAGE_BRAIN \
                      . \
                      . \
                      $DESIGN_DIR/$outfix  \
                      > $OUTPUT_DIR/$outfix.fsf
done
