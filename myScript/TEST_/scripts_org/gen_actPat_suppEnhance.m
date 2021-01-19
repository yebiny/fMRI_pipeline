%generating design for GLM
% function gen_actPat_suppEnhance(path)
addpath('~/fMRI_analysis/packages/NIfTI_20140122/')
%% load variables and design matrix
% load([path.behavioralSetting '/var.mat']);
% load([path.behavioralSetting '/param.mat']);
% load([path.behavioralSetting '/time.mat']);
% load([path.behavioralSetting '/key.mat']);
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% phase 1: stim vs. fixation
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
trainTest_list = {'train','test'};
trainTest_condNum = [1 2];

suppEnhance_list = {'sup', 'enhance'};
bin_list = {'bin', 'norm'};
%% load stim info.
path.stim{1} = '~/fMRI_analysis/primeRecon/expt_stim/01/face/female';
path.stim{2} = '~/fMRI_analysis/primeRecon/expt_stim/01/face/male';
var.gender = {'female', 'male'};%from PrimeRecon_setting_0101
var.nGender = length(var.gender);

for gen = 1:var.nGender
    imgList{gen} = dir([path.stim{gen} '/*.jpg']);
end%for loCate
%%
for bin = 1:length(bin_list)
    %%
    for mask = 1:2
        for suppEnhance = 1:length(suppEnhance_list)
            %% getting tstat patterns
            tstat_masked_pat_concat_train = [];%to concatenate runs, training
            
            %% mask index
            maskFile = ['inter_output/gen_masks/' suppEnhance_list{suppEnhance} '_maskCut' num2str(mask) '.nii.gz'];
            maskVol = load_nii(maskFile); maskVol = maskVol.img;
            maskIndx = find(maskVol > 0);
            maskAct = maskVol(maskIndx);
            %normalization (0~1 range)
            maskIndx(:,2) = (maskAct-min(maskAct))/(max(maskAct)-min(maskAct));
            
            %%
            clear imgMat trainTestOrder 
            for run = 1:10
                % for test
                oddEven = mod(run-1, 2)+1;
                xRun = fix((run-1)/2)+1;
                
                clear xDate
                load([path.behavioralData '/data_phase1_run' num2str(run) '.mat']);
                xDate(1,:) = designMat(2,designMat(2,:) < 3);%condition
                xDate(2,:) = 1:length(xDate(1,:));%index
                xDate(3,:) = designMat(3,designMat(2,:) < 3);%gender
                xDate(4,:) = designMat(4,designMat(2,:) < 3);%imgID
                %%
                for trainTest = 1:length(trainTest_list)
                    xtemp = xDate(:,xDate(1,:) == trainTest);
                    if trainTest == 2
                        xtemp = sortrows(xtemp', [3 4])';%sorting by gender and imgID
                    end%if trainTest
                    
                    trainTestOrder{run}{trainTest} = xtemp(2,:);
                    imgMat{run}{trainTest}(1,:) = xtemp(3,:);
                    imgMat{run}{trainTest}(2,:) = xtemp(4,:);
                end%for trainTest
                %% load tstat data
                for trainTest = 1:length(trainTest_list)
                    clear tstat_masked_pat;%house keeping
                    for ii = 1:length(trainTestOrder{run}{trainTest})
                        inputName = [path.analysis.firstlevel '/phase1_trialWiseGLM_train_run' num2str(run) '.feat/stats/' ...
                            'tstat' num2str(trainTestOrder{run}{trainTest}(ii)) '_mask' num2str(mask) '.nii.gz'];
                        xTstatVol = load_nii(inputName); xTstatVol = xTstatVol.img;
                        if bin == 1
                            tstat_masked_pat(:,ii) = xTstatVol(maskIndx(:,1));%binalized
                        else
                            tstat_masked_pat(:,ii) = xTstatVol(maskIndx(:,1)).*maskIndx(:,2);%mul normalized
                        end
                    end%for ii
                    
                    %concatenate runs for training
                    if trainTest == 1
                        tstat_masked_pat_concat_train = [tstat_masked_pat_concat_train tstat_masked_pat];
                    else
                        tstat_masked_pat_test{oddEven}{xRun} = tstat_masked_pat;
                    end
                    
                    outputName = ['inter_output/gen_actPat/' ...
                        'tstat_masked_pat_' trainTest_list{trainTest} '_mask' num2str(mask) '_' suppEnhance_list{suppEnhance} '_' bin_list{bin} '_run' num2str(run) '.mat'];
                    save(outputName, 'tstat_masked_pat');
                end%for trainTest
            end%for run
            
            outputName = ['inter_output/gen_actPat/' ...
                'tstat_masked_pat_concat_train_mask' num2str(mask) '_' suppEnhance_list{suppEnhance} '_' bin_list{bin} '.mat'];
            save(outputName, 'tstat_masked_pat_concat_train');
            outputName = ['inter_output/gen_actPat/' ...
                'tstat_masked_pat_test_mask' num2str(mask) '_' suppEnhance_list{suppEnhance} '_' bin_list{bin} '.mat'];
            save(outputName, 'tstat_masked_pat_test');
        end%for supp
    end%for mask
end%for bin
