#!/bin/bash
source globals.sh

#bet $NIFTI_DIR/${SUBJ}_t1_mprage.nii.gz $NIFTI_DIR/${SUBJ}_t1_mprage_brain.nii.gz

feat $FSF_DIR/phase2_initRep_01.fsf
feat $FSF_DIR/phase2_initRep_02.fsf

# Wait for two first-level analyses to finish
scripts/wait-for-feat.sh $FIRSTLEVEL_DIR/phase2_repSupp_run1.feat
scripts/wait-for-feat.sh $FIRSTLEVEL_DIR/phase2_repSupp_run2.feat

STANDARD_BRAIN=/usr/local/fsl/data/standard/MNI152_T1_2mm_brain.nii.gz

pushd $SUBJECT_DIR > /dev/null
subj_dir=$(pwd)

# This function defines variables needed to render
# higher-level fsf templates.
function define_vars {
 output_dir=$1

 echo "
 <?php
 \$OUTPUT_DIR = '$output_dir';
 \$STANDARD_BRAIN = '$STANDARD_BRAIN';
 \$SUBJECTS_DIR = '$subj_dir';
 "

 echo '$runs = array();'
 #for runs in `ls $FIRSTLEVEL_DIR/`; do
 cd $FIRSTLEVEL_DIR
 for runs in `ls -d phase2_repSupp_run*`; do
   echo "array_push(\$runs, '$runs');";
 done
 cd ../..

 echo "
 ?>
 "
}

# Form a complete template by prepending variable
# definitions to the template,
# then render it with PHP and run FEAT on the rendered fsf file.
fsf_template=$subj_dir/$FSF_DIR/phase2_repSupp_secondlevel.fsf.template
fsf_file=$subj_dir/$FSF_DIR/phase2_repSup_secondlevel.fsf
output_dir=$subj_dir/analysis/secondlevel/phase2_repSupp.gfeat
define_vars $output_dir | cat - "$fsf_template" | php > "$fsf_file"
feat "$fsf_file"

cp -R $FIRSTLEVEL_DIR/phase2_repSupp_run1.feat/reg analysis/secondlevel/phase2_repSupp.gfeat
cp $FIRSTLEVEL_DIR/phase2_repSupp_run1.feat/example_func.nii.gz analysis/secondlevel/phase2_repSupp.gfeat

popd > /dev/null  # return to whatever directory this script was run from

feat $FSF_DIR/phase1_stimBase_01.fsf
feat $FSF_DIR/phase1_stimBase_02.fsf
feat $FSF_DIR/phase1_stimBase_03.fsf
feat $FSF_DIR/phase1_stimBase_04.fsf
feat $FSF_DIR/phase1_stimBase_05.fsf
feat $FSF_DIR/phase1_stimBase_06.fsf
feat $FSF_DIR/phase1_stimBase_07.fsf
feat $FSF_DIR/phase1_stimBase_08.fsf
feat $FSF_DIR/phase1_stimBase_09.fsf
feat $FSF_DIR/phase1_stimBase_10.fsf

# Wait for two first-level analyses to finish
scripts/wait-for-feat.sh $FIRSTLEVEL_DIR/phase1_stimBase_run1.feat
scripts/wait-for-feat.sh $FIRSTLEVEL_DIR/phase1_stimBase_run2.feat
scripts/wait-for-feat.sh $FIRSTLEVEL_DIR/phase1_stimBase_run3.feat
scripts/wait-for-feat.sh $FIRSTLEVEL_DIR/phase1_stimBase_run4.feat
scripts/wait-for-feat.sh $FIRSTLEVEL_DIR/phase1_stimBase_run5.feat
scripts/wait-for-feat.sh $FIRSTLEVEL_DIR/phase1_stimBase_run6.feat
scripts/wait-for-feat.sh $FIRSTLEVEL_DIR/phase1_stimBase_run7.feat
scripts/wait-for-feat.sh $FIRSTLEVEL_DIR/phase1_stimBase_run8.feat
scripts/wait-for-feat.sh $FIRSTLEVEL_DIR/phase1_stimBase_run9.feat
scripts/wait-for-feat.sh $FIRSTLEVEL_DIR/phase1_stimBase_run10.feat


STANDARD_BRAIN=/usr/local/fsl/data/standard/MNI152_T1_2mm_brain.nii.gz

pushd $SUBJECT_DIR > /dev/null
subj_dir=$(pwd)

# This function defines variables needed to render
# higher-level fsf templates.
function define_vars {
 output_dir=$1

 echo "
 <?php
 \$OUTPUT_DIR = '$output_dir';
 \$STANDARD_BRAIN = '$STANDARD_BRAIN';
 \$SUBJECTS_DIR = '$subj_dir';
 "

 echo '$runs = array();'
 #for runs in `ls $FIRSTLEVEL_DIR/`; do
 cd $FIRSTLEVEL_DIR
 for runs in `ls -d phase1_stimBase*`; do
   echo "array_push(\$runs, '$runs');";
 done
 cd ../..

 echo "
 ?>
 "
}

# Form a complete template by prepending variable
# definitions to the template,
# then render it with PHP and run FEAT on the rendered fsf file.
fsf_template=$subj_dir/$FSF_DIR/phase1_stimBase_secondlevel.fsf.template
fsf_file=$subj_dir/$FSF_DIR/phase1_stimBase_secondlevel.fsf
output_dir=$subj_dir/analysis/secondlevel/phase1_stimBase.gfeat
define_vars $output_dir | cat - "$fsf_template" | php > "$fsf_file"
feat "$fsf_file"

cp -R $FIRSTLEVEL_DIR/phase1_stimBase_run1.feat/reg analysis/secondlevel/phase1_stimBase.gfeat
cp $FIRSTLEVEL_DIR/phase1_stimBase_run1.feat/example_func.nii.gz analysis/secondlevel/phase1_stimBase.gfeat

popd > /dev/null  # return to whatever directory this script was run from

# trial-wise glm for phase1
feat $FSF_DIR/phase1_trialWiseGLM_train_run1.fsf
feat $FSF_DIR/phase1_trialWiseGLM_train_run2.fsf
feat $FSF_DIR/phase1_trialWiseGLM_train_run3.fsf
feat $FSF_DIR/phase1_trialWiseGLM_train_run4.fsf
feat $FSF_DIR/phase1_trialWiseGLM_train_run5.fsf
feat $FSF_DIR/phase1_trialWiseGLM_train_run6.fsf
feat $FSF_DIR/phase1_trialWiseGLM_train_run7.fsf
feat $FSF_DIR/phase1_trialWiseGLM_train_run8.fsf
feat $FSF_DIR/phase1_trialWiseGLM_train_run9.fsf
feat $FSF_DIR/phase1_trialWiseGLM_train_run10.fsf





