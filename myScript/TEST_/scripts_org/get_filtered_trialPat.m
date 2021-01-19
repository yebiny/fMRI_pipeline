%generating design for GLM
function get_filtered_trialPat(path)
addpath('~/fMRI_analysis/packages/NIfTI_20140122/')

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% phase 1: trial-wise onset for training and test set separately (note taht there was a glm problem for using training + test)
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TR = 1.5;
for run = 1:10
    load([path.behavioralData '/data_phase1_run' num2str(run) '.mat']);
    xOnsetList = designMat(6,designMat(2,:) < 3) - 6;
    %%
    for mask = 1:2
        inputName = [path.analysis.firstlevel '/phase1_trialWiseGLM_train_run' num2str(run) '.feat/' ...
            'filtered2standard_mask' num2str(mask) '.nii.gz'];
        wholeVol = load_nii(inputName);
        wholeVol_img = wholeVol.img;
        
        for ii = 1:length(xOnsetList)
            xOnset = xOnsetList(ii);
            xOnset_vol_hrf = xOnset/TR+1+3;%+4.5
            xVol = wholeVol_img(:,:,:,xOnset_vol_hrf);
            
            outputName = [path.analysis.firstlevel '/phase1_trialWiseGLM_train_run' num2str(run) '.feat/stats/' ...
                'filtered' num2str(ii) '_mask' num2str(mask) '.nii.gz'];
            
            xNii = make_nii(xVol);
            save_nii(xNii, outputName);
        end%for ii
    end%for mask
end%for run

