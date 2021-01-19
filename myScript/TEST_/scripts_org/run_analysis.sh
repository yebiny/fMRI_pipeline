#!/bin/bash
source globals.sh

bash scripts/convert-and-wrap-raw-data.sh
bash scripts/reorient-to-las.sh
bash scripts/render-fsf-templates.sh
bet data/nifti/${SUBJ}_t1_mprage.nii.gz data/nifti/${SUBJ}_t1_mprage_brain.nii.gz -R
bash scripts/glm.sh

#generate visual cortex masks
bash scripts/gen_ROIs.sh
#selecting suppression & enhancement voxels
bash scripts/gen_masks.sh

#align trial-wise tstat and masking tstat(mask1:whole visual, mask2: fusiform)
bash scripts/aling_trialWiseTstat2standard.sh

#align filtered 2 standard and masking (mask1:whole visual, mask2: fusiform)
bash scripts/aling_filtered2standard.sh
#getting activaion pattern for each trial based on filterd data
matlab -nodisplay -nosplash -nodesktop -r "addpath('scripts/'); [subj path] = path_setting; get_filtered_trialPat(path); exit"

#concatenation activation patterns (tstat, filtered patterns)
matlab -nodisplay -nosplash -nodesktop -r "addpath('scripts/'); [subj path] = path_setting; for inputType = 1:2; gen_actPat(path, inputType); end; exit"

#running regression
bash scripts/run_regression.sh

#validation based on training items (cross-validation) for suppression and enhancement voxels groups
matlab -nodisplay -nosplash -nodesktop -r "addpath('scripts/'); [subj path] = path_setting; for mask = 1:2; for inputType = 1:2; for suppEnhance = 1:2; for bin = 1:2; for regType = 1:2; train_val_com_suppEnhance(path, mask, inputType, suppEnhance, bin, regType); end; end; end; end; end; exit"
