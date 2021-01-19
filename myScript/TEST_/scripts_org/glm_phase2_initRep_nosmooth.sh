#!/bin/bash
source globals.sh

feat $FSF_DIR/phase2_initRep_nosmooth_01.fsf
feat $FSF_DIR/phase2_initRep_nosmooth_02.fsf

# Wait for two first-level analyses to finish
scripts/wait-for-feat.sh $FIRSTLEVEL_DIR/phase2_repSupp_nosmooth_run1.feat
scripts/wait-for-feat.sh $FIRSTLEVEL_DIR/phase2_repSupp_nosmooth_run2.feat

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
 for runs in `ls -d phase2_repSupp_nosmooth_run*`; do
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
fsf_template=$subj_dir/$FSF_DIR/phase2_repSupp_nosmooth_secondlevel.fsf.template
fsf_file=$subj_dir/$FSF_DIR/phase2_repSup_nosmooth_secondlevel.fsf
output_dir=$subj_dir/analysis/secondlevel/phase2_repSupp_nosmooth.gfeat
define_vars $output_dir | cat - "$fsf_template" | php > "$fsf_file"
feat "$fsf_file"

cp -R $FIRSTLEVEL_DIR/phase2_repSupp_nosmooth_run1.feat/reg analysis/secondlevel/phase2_nosmooth_repSupp.gfeat
cp $FIRSTLEVEL_DIR/phase2_repSupp_nosmooth_run1.feat/example_func.nii.gz analysis/secondlevel/phase2_nosmooth_repSupp.gfeat

popd > /dev/null  # return to whatever directory this script was run from
