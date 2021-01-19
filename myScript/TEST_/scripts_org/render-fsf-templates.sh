#!/bin/bash
#
# render-fsf-templates.sh fills in templated fsf files so FEAT can use them
# original author: mason simon (mgsimon@princeton.edu)
# this script was provided by NeuroPipe. modify it to suit your needs
#
# refer to the secondlevel neuropipe tutorial to see an example of how
# to use this script

set -e

source globals.sh

 
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

render_firstlevel $FSF_DIR/phase2_initRep.fsf.template \
                  $FIRSTLEVEL_DIR/phase2_repSupp_run1.feat \
                  $FSL_DIR/data/standard/MNI152_T1_2mm_brain \
                  $NIFTI_DIR/${SUBJ}_repSup_01 \
                  $NIFTI_DIR/${SUBJ}_t1_flash01.nii.gz \
                  $NIFTI_DIR/${SUBJ}_t1_mprage_brain.nii.gz \
                  . \
                  . \
                  $EV_DIR/phase2_run1 \
                  > $FSF_DIR/phase2_initRep_01.fsf

render_firstlevel $FSF_DIR/phase2_initRep.fsf.template \
                  $FIRSTLEVEL_DIR/phase2_repSupp_run2.feat \
                  $FSL_DIR/data/standard/MNI152_T1_2mm_brain \
                  $NIFTI_DIR/${SUBJ}_repSup_02 \
                  $NIFTI_DIR/${SUBJ}_t1_flash01.nii.gz \
                  $NIFTI_DIR/${SUBJ}_t1_mprage_brain.nii.gz \
                  . \
                  . \
                  $EV_DIR/phase2_run2 \
                  > $FSF_DIR/phase2_initRep_02.fsf


render_firstlevel $FSF_DIR/phase2_initRep_nosmooth.fsf.template \
                  $FIRSTLEVEL_DIR/phase2_repSupp_nosmooth_run1.feat \
                  $FSL_DIR/data/standard/MNI152_T1_2mm_brain \
                  $NIFTI_DIR/${SUBJ}_repSup_01 \
                  $NIFTI_DIR/${SUBJ}_t1_flash01.nii.gz \
                  $NIFTI_DIR/${SUBJ}_t1_mprage_brain.nii.gz \
                  . \
                  . \
                  $EV_DIR/phase2_run1 \
                  > $FSF_DIR/phase2_initRep_nosmooth_01.fsf

render_firstlevel $FSF_DIR/phase2_initRep_nosmooth.fsf.template \
                  $FIRSTLEVEL_DIR/phase2_repSupp_nosmooth_run2.feat \
                  $FSL_DIR/data/standard/MNI152_T1_2mm_brain \
                  $NIFTI_DIR/${SUBJ}_repSup_02 \
                  $NIFTI_DIR/${SUBJ}_t1_flash01.nii.gz \
                  $NIFTI_DIR/${SUBJ}_t1_mprage_brain.nii.gz \
                  . \
                  . \
                  $EV_DIR/phase2_run2 \
                  > $FSF_DIR/phase2_initRep_nosmooth_02.fsf

render_firstlevel $FSF_DIR/phase1_stimBase.fsf.template \
                  $FIRSTLEVEL_DIR/phase1_stimBase_run1.feat \
                  $FSL_DIR/data/standard/MNI152_T1_2mm_brain \
                  $NIFTI_DIR/${SUBJ}_train_01 \
                  $NIFTI_DIR/${SUBJ}_t1_flash01.nii.gz \
                  $NIFTI_DIR/${SUBJ}_t1_mprage_brain.nii.gz \
                  . \
                  . \
                  $EV_DIR/phase1_run1 \
                  > $FSF_DIR/phase1_stimBase_01.fsf

render_firstlevel $FSF_DIR/phase1_stimBase.fsf.template \
                  $FIRSTLEVEL_DIR/phase1_stimBase_run2.feat \
                  $FSL_DIR/data/standard/MNI152_T1_2mm_brain \
                  $NIFTI_DIR/${SUBJ}_train_02 \
                  $NIFTI_DIR/${SUBJ}_t1_flash01.nii.gz \
                  $NIFTI_DIR/${SUBJ}_t1_mprage_brain.nii.gz \
                  . \
                  . \
                  $EV_DIR/phase1_run2 \
                  > $FSF_DIR/phase1_stimBase_02.fsf

render_firstlevel $FSF_DIR/phase1_stimBase.fsf.template \
                  $FIRSTLEVEL_DIR/phase1_stimBase_run3.feat \
                  $FSL_DIR/data/standard/MNI152_T1_2mm_brain \
                  $NIFTI_DIR/${SUBJ}_train_03 \
                  $NIFTI_DIR/${SUBJ}_t1_flash01.nii.gz \
                  $NIFTI_DIR/${SUBJ}_t1_mprage_brain.nii.gz \
                  . \
                  . \
                  $EV_DIR/phase1_run3 \
                  > $FSF_DIR/phase1_stimBase_03.fsf

render_firstlevel $FSF_DIR/phase1_stimBase.fsf.template \
                  $FIRSTLEVEL_DIR/phase1_stimBase_run4.feat \
                  $FSL_DIR/data/standard/MNI152_T1_2mm_brain \
                  $NIFTI_DIR/${SUBJ}_train_04 \
                  $NIFTI_DIR/${SUBJ}_t1_flash01.nii.gz \
                  $NIFTI_DIR/${SUBJ}_t1_mprage_brain.nii.gz \
                  . \
                  . \
                  $EV_DIR/phase1_run4 \
                  > $FSF_DIR/phase1_stimBase_04.fsf

render_firstlevel $FSF_DIR/phase1_stimBase.fsf.template \
                  $FIRSTLEVEL_DIR/phase1_stimBase_run5.feat \
                  $FSL_DIR/data/standard/MNI152_T1_2mm_brain \
                  $NIFTI_DIR/${SUBJ}_train_05 \
                  $NIFTI_DIR/${SUBJ}_t1_flash01.nii.gz \
                  $NIFTI_DIR/${SUBJ}_t1_mprage_brain.nii.gz \
                  . \
                  . \
                  $EV_DIR/phase1_run5 \
                  > $FSF_DIR/phase1_stimBase_05.fsf

render_firstlevel $FSF_DIR/phase1_stimBase.fsf.template \
                  $FIRSTLEVEL_DIR/phase1_stimBase_run6.feat \
                  $FSL_DIR/data/standard/MNI152_T1_2mm_brain \
                  $NIFTI_DIR/${SUBJ}_train_06 \
                  $NIFTI_DIR/${SUBJ}_t1_flash01.nii.gz \
                  $NIFTI_DIR/${SUBJ}_t1_mprage_brain.nii.gz \
                  . \
                  . \
                  $EV_DIR/phase1_run6 \
                  > $FSF_DIR/phase1_stimBase_06.fsf

render_firstlevel $FSF_DIR/phase1_stimBase.fsf.template \
                  $FIRSTLEVEL_DIR/phase1_stimBase_run7.feat \
                  $FSL_DIR/data/standard/MNI152_T1_2mm_brain \
                  $NIFTI_DIR/${SUBJ}_train_07 \
                  $NIFTI_DIR/${SUBJ}_t1_flash01.nii.gz \
                  $NIFTI_DIR/${SUBJ}_t1_mprage_brain.nii.gz \
                  . \
                  . \
                  $EV_DIR/phase1_run7 \
                  > $FSF_DIR/phase1_stimBase_07.fsf

render_firstlevel $FSF_DIR/phase1_stimBase.fsf.template \
                  $FIRSTLEVEL_DIR/phase1_stimBase_run8.feat \
                  $FSL_DIR/data/standard/MNI152_T1_2mm_brain \
                  $NIFTI_DIR/${SUBJ}_train_08 \
                  $NIFTI_DIR/${SUBJ}_t1_flash01.nii.gz \
                  $NIFTI_DIR/${SUBJ}_t1_mprage_brain.nii.gz \
                  . \
                  . \
                  $EV_DIR/phase1_run8 \
                  > $FSF_DIR/phase1_stimBase_08.fsf

render_firstlevel $FSF_DIR/phase1_stimBase.fsf.template \
                  $FIRSTLEVEL_DIR/phase1_stimBase_run9.feat \
                  $FSL_DIR/data/standard/MNI152_T1_2mm_brain \
                  $NIFTI_DIR/${SUBJ}_train_09 \
                  $NIFTI_DIR/${SUBJ}_t1_flash01.nii.gz \
                  $NIFTI_DIR/${SUBJ}_t1_mprage_brain.nii.gz \
                  . \
                  . \
                  $EV_DIR/phase1_run9 \
                  > $FSF_DIR/phase1_stimBase_09.fsf

render_firstlevel $FSF_DIR/phase1_stimBase.fsf.template \
                  $FIRSTLEVEL_DIR/phase1_stimBase_run10.feat \
                  $FSL_DIR/data/standard/MNI152_T1_2mm_brain \
                  $NIFTI_DIR/${SUBJ}_train_10 \
                  $NIFTI_DIR/${SUBJ}_t1_flash01.nii.gz \
                  $NIFTI_DIR/${SUBJ}_t1_mprage_brain.nii.gz \
                  . \
                  . \
                  $EV_DIR/phase1_run10 \
                  > $FSF_DIR/phase1_stimBase_10.fsf


#fsf files for phase 1 trial-wise design.fsf
#matlab -nodisplay -nosplash -nodesktop -r "addpath('scripts/'); [subj path] = path_setting; gen_design(path); gen_trialWiseGLM_designFSF(subj, path); exit"

