#!/bin/bash

SUBJ=sub01

inputfile=results/$SUBJ/2ndLV/train.gfeat/cope3.feat/stats/zstat1.nii.gz

outputDir=results/$SUBJ/mask
outputfile=$outputDir/stim_act_thr31.nii.gz

#thresholding z>3.1 (stim > baseline)
fslmaths $inputfile -thr 3.1 $outputfile

# #################### mask 1 (stim vs. base threshold 3.1 + whole visual cortex mask) + selecting supp & enhance voxels
anatMask=visualCortexMasks/mask1_bin.nii.gz
#cutting using anatomical mask
inputfile=$outputDir/stim_act_thr31.nii.gz
outputfile=$outputDir/stim_act_thr31_anatCut.nii.gz
fslmaths $inputfile -mas $anatMask $outputfile

#binalization
inputfile=$outputDir/stim_act_thr31_anatCut.nii.gz
outputfile=$outputDir/stim_act_thr31_anatCut_bin.nii.gz
fslmaths $inputfile -bin $outputfile


# selecting suppression & enhancement voxels (cutting by visual cortex mask)
visCortexMask=$outputDir/stim_act_thr31_anatCut_bin.nii.gz
cp $visCortexMask $outputDir/mask1.nii.gz
gunzip $outputDir/mask1.nii.gz

inputfile=results/$SUBJ/2ndLV/repSup.gfeat/cope3.feat/stats/zstat1.nii.gz
outputfile=$outputDir/temp.nii.gz
fslmaths $inputfile -mas $visCortexMask $outputfile
inputfile=$outputDir/temp.nii.gz
outputfile=$outputDir/sup_maskCut1.nii.gz
fslmaths $inputfile -thr 0 $outputfile
inputfile=$outputDir/sup_maskCut1.nii.gz
outputfile=$outputDir/sup_maskCut1_bin.nii.gz
fslmaths $inputfile -bin $outputfile



inputfile=results/$SUBJ/2ndLV/repSup.gfeat/cope4.feat/stats/zstat1.nii.gz
outputfile=$outputDir/temp.nii.gz
fslmaths $inputfile -mas $visCortexMask $outputfile
inputfile=$outputDir/temp.nii.gz
outputfile=$outputDir/enhance_maskCut1.nii.gz
fslmaths $inputfile -thr 0 $outputfile
inputfile=$outputDir/enhance_maskCut1.nii.gz
outputfile=$outputDir/enhance_maskCut1_bin.nii.gz
fslmaths $inputfile -bin $outputfile


# #################### mask 2 (temporal occipital cortex) + selecting supp & enhance voxels
anatMask=visualCortexMasks/mask2_bin.nii.gz


# selecting suppression & enhancement voxels (cutting by visual cortex mask)
visCortexMask=$anatMask
cp $visCortexMask $outputDir/mask2.nii.gz
gunzip $outputDir/mask2.nii.gz

inputfile=results/$SUBJ/2ndLV/repSup.gfeat/cope3.feat/stats/zstat1.nii.gz
outputfile=$outputDir/temp.nii.gz
fslmaths $inputfile -mas $visCortexMask $outputfile
inputfile=$outputDir/temp.nii.gz
outputfile=$outputDir/sup_maskCut2.nii.gz
fslmaths $inputfile -thr 0 $outputfile
inputfile=$outputDir/sup_maskCut2.nii.gz
outputfile=$outputDir/sup_maskCut2_bin.nii.gz
fslmaths $inputfile -bin $outputfile



inputfile=results/$SUBJ/2ndLV/repSup.gfeat/cope4.feat/stats/zstat1.nii.gz
outputfile=$outputDir/temp.nii.gz
fslmaths $inputfile -mas $visCortexMask $outputfile
inputfile=$outputDir/temp.nii.gz
outputfile=$outputDir/enhance_maskCut2.nii.gz
fslmaths $inputfile -thr 0 $outputfile
inputfile=$outputDir/enhance_maskCut2.nii.gz
outputfile=$outputDir/enhance_maskCut2_bin.nii.gz
fslmaths $inputfile -bin $outputfile


