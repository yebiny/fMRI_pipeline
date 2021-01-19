% group-level path
function [subj path] = path_setting
path.currDir = pwd;
% subj.NM = path.currDir(end-2:end);
subj.SN = path.currDir(end-1:end);
cd ..
path.subjRoot = pwd;
%%
path.behavioralData = [path.currDir '/behavioralData'];
path.behavioralDesign = [path.currDir '/behavioralDesign'];
path.behavioralSetting = [path.currDir '/behavioralSetting'];
path.designRoot = [path.currDir '/design'];
path.fsf = [path.currDir '/fsf'];
path.regressor = [path.currDir '/regressor'];
path.results = [path.currDir '/results'];
path.behav_results = [path.results '/behavioral'];
path.neural_results = [path.results '/neural'];
path.scripts = [path.currDir '/scripts'];

path.analysis.root = [path.currDir '/analysis'];
path.analysis.firstlevel = [path.analysis.root '/firstlevel'];
path.analysis.secondlevel = [path.analysis.root '/secondlevel'];

path.nifti = [path.currDir '/data/nifti'];
path.standardROIs = ['../../ROIs'];
path.rois = [path.currDir '/rois'];

%% design dir for phase 1 & 2
for ii = 1:10
    path.design.phase{1}{ii} = [path.designRoot '/phase1_run' num2str(ii)];
end

for ii = 1:2
    path.design.phase{2}{ii} = [path.designRoot '/phase2_run' num2str(ii)];
end
%% save
save([path.currDir '/path.mat'], 'path');
save([path.currDir '/subj.mat'], 'subj');
cd(path.currDir)
