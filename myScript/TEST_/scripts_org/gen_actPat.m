%generating design for GLM
function gen_actPat(path, inputType)
addpath('~/fMRI_analysis/packages/NIfTI_20140122/')
inputType_list = {'tstat', 'filtered'};

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
%% load stim info.
path.stim{1} = '~/fMRI_analysis/primeRecon/expt_stim/01/face/female';
path.stim{2} = '~/fMRI_analysis/primeRecon/expt_stim/01/face/male';
var.gender = {'female', 'male'};%from PrimeRecon_setting_0101
var.nGender = length(var.gender);

for gen = 1:var.nGender
    imgList{gen} = dir([path.stim{gen} '/*.jpg']);
end%for loCate
%%
for mask = 1:2
    %% mask index
    maskFile = ['inter_output/gen_masks/mask' num2str(mask) '.nii'];
    maskVol = load_nii(maskFile); maskVol = maskVol.img;
    maskIndx = find(maskVol == 1);
%     %% temp dir
%     tempDir = [pwd '/temp'];
%     mkdir(tempDir);
    %% getting tstat patterns
    tstat_masked_pat_concat_train = [];%to concatenate runs, training
    %note that test pat should be divided by odd, even runs
%     tstat_masked_pat_concat_test = [];% test
    
%     %% img list concat
%     fileName = [path.analysis.firstlevel '/phase1_trialWiseGLM_train_run' num2str(1) '.feat/imgList_cocat_train.csv'];
%     fid_train = fopen(fileName, 'w');
%     
%     fileName = [path.analysis.firstlevel '/phase1_trialWiseGLM_train_run' num2str(1) '.feat/imgList_cocat_test.csv'];
%     fid_test = fopen(fileName, 'w');
    
    %% img list concat
    mkdir inter_output/gen_actPat;
    fileName = ['inter_output/gen_actPat/imgList_cocat_train.csv'];
    fid_train = fopen(fileName, 'w');
    
    fileName = ['inter_output/gen_actPat/imgList_cocat_test.csv'];
    fid_test = fopen(fileName, 'w');
    %%
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
            %% file open
            fileName = ['inter_output/gen_actPat/imgList_' ...
                trainTest_list{trainTest} '_run' num2str(run) '.csv'];
            fid = fopen(fileName, 'w');
            
            clear tstat_masked_pat;%house keeping
            for ii = 1:length(trainTestOrder{run}{trainTest})
%                 inputName = [path.analysis.firstlevel '/phase1_trialWiseGLM_train_run' num2str(run) '.feat/stats/' ...
%                     'tstat' num2str(trainTestOrder{run}{trainTest}(ii)) '_mask' num2str(mask) '.nii.gz'];
                inputName = [path.analysis.firstlevel '/phase1_trialWiseGLM_train_run' num2str(run) '.feat/stats/' ...
                    inputType_list{inputType} num2str(trainTestOrder{run}{trainTest}(ii)) '_mask' num2str(mask) '.nii.gz'];
                xTstatVol = load_nii(inputName); xTstatVol = xTstatVol.img;
                tstat_masked_pat(:,ii) = xTstatVol(maskIndx);
                %% img file name
                xGen = imgMat{run}{trainTest}(1,ii);%gen
                xImgID = imgMat{run}{trainTest}(2,ii);%imgID
                xImgFileName = [path.stim{xGen} '/' imgList{xGen}(xImgID).name];
                fprintf(fid, '%s\n', xImgFileName);
                
                if trainTest == 1
                    fprintf(fid_train, '%s\n', xImgFileName);
                else
                    fprintf(fid_test, '%s\n', xImgFileName);
                end
            end%for ii
            
            %concatenate runs for training
            if trainTest == 1
                tstat_masked_pat_concat_train = [tstat_masked_pat_concat_train tstat_masked_pat];
            else
                tstat_masked_pat_test{oddEven}{xRun} = tstat_masked_pat;
            end

            fclose(fid);
            
%             outputName = ['inter_output/gen_actPat/' ...
%                 'tstat_masked_pat_' trainTest_list{trainTest} '_mask' num2str(mask) '_run' num2str(run) '.mat'];
            outputName = ['inter_output/gen_actPat/' ...
                inputType_list{inputType} '_masked_pat_' trainTest_list{trainTest} '_mask' num2str(mask) '_run' num2str(run) '.mat'];
            save(outputName, 'tstat_masked_pat');
        end%for trainTest
    end%for run
    %% save concat pat
    fclose(fid_train);
    fclose(fid_test);
    
    outputName = ['inter_output/gen_actPat/' ...
        inputType_list{inputType} '_masked_pat_concat_train_mask' num2str(mask) '.mat'];
    save(outputName, 'tstat_masked_pat_concat_train');
    outputName = ['inter_output/gen_actPat/' ...
        inputType_list{inputType} '_masked_pat_test_mask' num2str(mask) '.mat'];
    save(outputName, 'tstat_masked_pat_test');
end




