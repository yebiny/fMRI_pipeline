%generating design for GLM
function test_val_com_suppEnhance(path, mask, inputType, suppEnhance, bin)
%%
addpath('~/fMRI_analysis/packages/NIfTI_20140122/')
inputType_list = {'tstat', 'filtered'};
suppEnhance_list = {'sup', 'enhance'};
bin_list = {'bin', 'norm'};
%% load weights
fileName = ['inter_output/regression/train_reg_weights_mask' num2str(mask) '_' inputType_list{inputType} '.mat'];
%     fileName = [path.analysis.firstlevel '/phase1_trialWiseGLM_train_run1.feat/train_reg_ridge_weights.mat'];
load(fileName, 'train_w');%latent(100) x vox(17690)
xWeights = train_w';%latent(100) x vox(17690) --> vox(17690) x latent(100)

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
%% load activation pat (test)
% fileName = ['inter_output/gen_actPat/tstat_masked_pat_test_mask' num2str(mask) '.mat'];
fileName = ['inter_output/gen_actPat/' inputType_list{inputType} '_masked_pat_test_mask' num2str(mask) '.mat'];
load(fileName, 'tstat_masked_pat_test');%tstat_masked_pat_test{oddEven}{xRun}
%% reconstruction
for oddEven = 1:2
    for run = 1:5
        xPat_orig = tstat_masked_pat_test{oddEven}{run}'; %vox x item --> item x vox
        xPat = xPat_orig;
        xPat(:, xVoxIndx{2}) = 0;%set zero for non-selected voxels
        if bin == 2%normalization
            for item = 1:size(xPat,1)
                xPat(item, xVoxIndx{1}) = xPat(item, xVoxIndx{1}).*maskIndx_orig(xVoxIndx{1},2)';%mul nomalized values
            end%for item
        end%if bin
        
        reconVec{oddEven}(:,:,run) = xPat*xWeights;
    end%for run
    
    reconVec_avrgRun(:,:,oddEven) = mean(reconVec{oddEven}(:,:,:), 3);
end%for oddEven

%% comparing with the original latent space
for oddEven = 1:2
    latent_fileName = ['inter_output/regression/' ...
        'test_latMat_run' num2str(oddEven) '.mat'];
    load(latent_fileName);%test_latMat_run1,2
    
    if oddEven == 1
        xLatMat = test_latMat_run1;
    else
        xLatMat = test_latMat_run2;
    end .          
    
    xRecon = reconVec_avrgRun(:,:,oddEven);
    
    for recon = 1:size(xRecon,1)
        others = setdiff(1:size(xRecon,1), recon);
        pat_latCorr{oddEven}(recon,1) = corr(xRecon(recon,:)', xLatMat(recon,:)');%self
        clear tempCorr
        for oth = 1:length(others)
            %             tempCorr(oth) = corr(xRecon(recon,:)', xLatMat(others(oth),:)');%other
            pat_latCorr{oddEven}(recon,1+oth) = corr(xRecon(recon,:)', xLatMat(others(oth),:)');%self
        end%for oth
    end%for recon
end%for oddEven

%% summarizing
temp = [pat_latCorr{1}; pat_latCorr{2}];%collapsing odd & even items (20 items)
val_ori_other = [mean(temp(:,1)) mean(mean(temp(:,2:end), 2),1)];
%%
outputDir = 'inter_output/test_val_com_suppEnhance';
mkdir(outputDir);
prefix = [inputType_list{inputType} '_mask' num2str(mask) '_' suppEnhance_list{suppEnhance} '_' bin_list{bin}];
save([outputDir '/reconVec_' prefix '.mat'], 'reconVec');
save([outputDir '/reconVec_avrgRun_' prefix '.mat'], 'reconVec_avrgRun');
save([outputDir '/pat_latCorr_' prefix '.mat'], 'pat_latCorr');
save([outputDir '/val_ori_other_' prefix '.mat'], 'val_ori_other');


