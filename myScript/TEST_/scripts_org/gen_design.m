%generating design for GLM
function gen_design(path)

%% load variables and design matrix
% load([path.behavioralSetting '/var.mat']);
% load([path.behavioralSetting '/param.mat']);
% load([path.behavioralSetting '/time.mat']);
% load([path.behavioralSetting '/key.mat']);
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% phase 1: stim vs. fixation
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
condName = {'stim','fix'};
condNum = [1 4];

for run = 1:10
    load([path.behavioralData '/data_phase1_run' num2str(run) '.mat']);
    
    for stimFix = 1:length(condName)
        fileName = [path.design.phase{1}{run} '/phase1_' condName{stimFix} '.txt'];
        fid = fopen(fileName, 'w');
        
        xOnsetList = designMat(6,designMat(2,:) == condNum(stimFix)) - 6;
        
        for ii = 1:length(xOnsetList)
            fprintf(fid, '%s\t %s\t %s\n', num2str(xOnsetList(ii)), num2str(1), num2str(1));
        end%for ii
        fclose all;
    end
end%for run

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% phase 1: trial-wise onset for training and test set separately (note taht there was a glm problem for using training + test)
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for run = 1:10
    load([path.behavioralData '/data_phase1_run' num2str(run) '.mat']);
    
    xOnsetList = designMat(6,designMat(2,:) < 3) - 6;
%     xOnsetList = designMat(6,designMat(2,:) == 1) - 6;%trainning data only
    
    for onset = 1:length(xOnsetList)
        fileName = [path.design.phase{1}{run} '/onset_train' num2str(onset) '.txt'];
        fid = fopen(fileName, 'w');
        fprintf(fid, '%s\t %s\t %s\n', num2str(xOnsetList(onset)), num2str(1), num2str(1));
        fclose all;
    end%for onset
    
    xOnsetList = designMat(6,designMat(2,:) == 2) - 6;%test data only
    
    for onset = 1:length(xOnsetList)
        fileName = [path.design.phase{1}{run} '/onset_test' num2str(onset) '.txt'];
        fid = fopen(fileName, 'w');
        fprintf(fid, '%s\t %s\t %s\n', num2str(xOnsetList(onset)), num2str(1), num2str(1));
        fclose all;
    end%for onset
end%for run





%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% phase 2: init vs. rep
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
condName = {'init','rep'};

for run = 1:2
    load([path.behavioralData '/data_phase2_run' num2str(run) '.mat']);
    
    for initRep = 1:2
        fileName = [path.design.phase{2}{run} '/phase2_' condName{initRep} '.txt'];
        fid = fopen(fileName, 'w');
        
        xOnsetList = designMat(7,designMat(3,:) == initRep) - 6;
        
        for ii = 1:length(xOnsetList)
            fprintf(fid, '%s\t %s\t %s\n', num2str(xOnsetList(ii)), num2str(1), num2str(1));
        end%for ii
        fclose all;
    end
end%for run

