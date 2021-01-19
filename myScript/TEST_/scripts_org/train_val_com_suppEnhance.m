%generating design for GLM
function train_val_com_suppEnhance(path, mask, inputType, suppEnhance, bin, regType)
%%
addpath('~/fMRI_analysis/packages/NIfTI_20140122/')
inputType_list = {'tstat', 'filtered'};
suppEnhance_list = {'sup', 'enhance'};
bin_list = {'bin', 'norm'};
regType_list = {'linear', 'ridge'};
%% mask index original (w/o dividing supp and enhance)
maskFile = ['inter_output/gen_masks/mask' num2str(mask) '.nii'];
maskVol = load_nii(maskFile); maskVol = maskVol.img;
maskIndx_orig = find(maskVol == 1);
%% mask index by supp and enhance
maskFile = ['inter_output/gen_masks/' suppEnhance_list{suppEnhance} '_maskCut' num2str(mask) '.nii.gz'];
maskVol = load_nii(maskFile); maskVol = maskVol.img;
maskIndx = find(maskVol > 0);
maskAct = maskVol(maskIndx);
%normalization (0~1 range)
maskIndx(:,2) = (maskAct-min(maskAct))/(max(maskAct)-min(maskAct));

for ii = 1:length(maskIndx)
    xIndx = maskIndx(ii,1);
    maskIndx_orig(maskIndx_orig == xIndx, 2) = maskIndx(ii,2);
    maskIndx_orig(maskIndx_orig == xIndx, 3) = 1;
end%for ii

xVoxIndx{1} = find(maskIndx_orig(:,3) == 1);%selected
xVoxIndx{2} = find(maskIndx_orig(:,3) == 0);%non-selected
%% load activation pat (training)
fileName = ['inter_output/gen_actPat/' inputType_list{inputType} '_masked_pat_concat_train_mask' num2str(mask) '.mat'];
load(fileName, 'tstat_masked_pat_concat_train');
%% loading latent space
latent_fileName = ['inter_output/regression/' ...
    'train_lat.mat'];
load(latent_fileName);%﻿train_lat
%% reconstruction
xPat_orig = tstat_masked_pat_concat_train'; %vox x item --> item x vox
xPat = xPat_orig;
xPat(:, xVoxIndx{2}) = 0;%set zero for non-selected voxels
if bin == 2%normalization
    for item = 1:size(xPat,1)
        xPat(item, xVoxIndx{1}) = xPat(item, xVoxIndx{1}).*maskIndx_orig(xVoxIndx{1},2)';%mul nomalized values
    end%for item
end%if bin
%%
nItemTotal = 1000;
testSetSize = 100;
nIter = nItemTotal/testSetSize;
%%
for iter = 1:nIter
    %% %%%%%%%%%%%%%%%%%%%%%%%%%% with voxel selection
    %% load weights
    fileName = ['inter_output/regression/train_reg_weights_mask' num2str(mask) '_' inputType_list{inputType} ... 
        '_' regType_list{regType} '_iter' num2str(iter) '.mat'];
    %     fileName = [path.analysis.firstlevel '/phase1_trialWiseGLM_train_run1.feat/train_reg_ridge_weights.mat'];
    load(fileName, 'train_w');%latent(100) x vox(17690)
    xWeights = train_w';%latent(100) x vox(17690) --> vox(17690) x latent(100)
    %% selecting test set
    xTestSet = xPat((iter-1)*testSetSize+1:iter*testSetSize, :);%item x vox, with voxel selection
    xLatMat = train_lat((iter-1)*testSetSize+1:iter*testSetSize, :);%item x lat
    %% mul weights
    reconVec = xTestSet*xWeights;
    
    xRecon = reconVec;
    
    for recon = 1:size(xRecon,1)
        others = setdiff(1:size(xRecon,1), recon);
        pat_latCorr{iter}(recon,1) = corr(xRecon(recon,:)', xLatMat(recon,:)');%self
        clear tempCorr
        for oth = 1:length(others)
            pat_latCorr{iter}(recon,1+oth) = corr(xRecon(recon,:)', xLatMat(others(oth),:)');%self
        end%for oth
    end%for recon
    %% summarizing
    for item = 1:size(xRecon,1)
        val_ori_other_item((iter-1)*testSetSize+item, 1) = pat_latCorr{iter}(item,1);
        val_ori_other_item((iter-1)*testSetSize+item, 2) = mean(pat_latCorr{iter}(item,2:end));
    end%for item
    
    val_ori_other_iter(iter,:) = mean(val_ori_other_item((iter-1)*testSetSize+1:iter*testSetSize,:), 1);
    
    %% %%%%%%%%%%%%%%%%%%%%%%%%%% without voxel selection (no normalization)
    if bin == 1 && suppEnhance == 1%no normalization
        xTestSet_nosel = xPat_orig((iter-1)*testSetSize+1:iter*testSetSize, :);%item x vox, with voxel selection
        
        %% mul weights
        reconVec_nosel = xTestSet_nosel*xWeights;
        
        xRecon_nosel = reconVec_nosel;
        
        for recon = 1:size(xRecon_nosel,1)
            others = setdiff(1:size(xRecon_nosel,1), recon);
            pat_latCorr_nosel{iter}(recon,1) = corr(xRecon_nosel(recon,:)', xLatMat(recon,:)');%self
            clear tempCorr
            for oth = 1:length(others)
                pat_latCorr_nosel{iter}(recon,1+oth) = corr(xRecon_nosel(recon,:)', xLatMat(others(oth),:)');%self
            end%for oth
        end%for recon
        %% summarizing
        for item = 1:size(xRecon_nosel,1)
            val_ori_other_item_nosel((iter-1)*testSetSize+item, 1) = pat_latCorr_nosel{iter}(item,1);
            val_ori_other_item_nosel((iter-1)*testSetSize+item, 2) = mean(pat_latCorr_nosel{iter}(item,2:end));
        end%for item
        
        val_ori_other_iter_nosel(iter,:) = mean(val_ori_other_item_nosel((iter-1)*testSetSize+1:iter*testSetSize,:), 1);
    end%if bin
end%for iter
%%
val_ori_other_iterCol = mean(val_ori_other_item, 1);

outputDir = 'inter_output/train_val_com_suppEnhance';
mkdir(outputDir);
prefix = [inputType_list{inputType} '_' regType_list{regType} '_mask' num2str(mask) '_' suppEnhance_list{suppEnhance} '_' bin_list{bin}];

if bin == 1 && suppEnhance == 1%no normalization
    val_ori_other_iterCol_nosel = mean(val_ori_other_item_nosel, 1);
    save([outputDir '/val_ori_other_item_nosel_' prefix '.mat'], 'val_ori_other_item_nosel');
    save([outputDir '/val_ori_other_iter_nosel_' prefix '.mat'], 'val_ori_other_iter_nosel');
    save([outputDir '/val_ori_other_iterCol_nosel_' prefix '.mat'], 'val_ori_other_iterCol_nosel');
end%if bin
%%

save([outputDir '/val_ori_other_item_' prefix '.mat'], 'val_ori_other_item');
save([outputDir '/val_ori_other_iter_' prefix '.mat'], 'val_ori_other_iter');
save([outputDir '/val_ori_other_iterCol_' prefix '.mat'], 'val_ori_other_iterCol');


% save([outputDir '/val_ori_other_' prefix '.mat'], 'val_ori_other');


