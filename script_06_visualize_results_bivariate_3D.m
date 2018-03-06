% Copyright (c) 2017-2018, Jakob Nikolas Kather. 
% 
% Please cite our publication:
% "Large-scale database mining reveals hidden trends and future directions
% for cancer immunotherapy", DOI 10.1080/2162402X.2018.1444412
% 
% License: please refer to the license file in the root directory
%
% -------------------------------------------------------------
%
% this script is used to visualize the trend of specific topics over time
% in a bivariate manner
% It will create a "3D trumpet plot"
% 
% input: .mat file in results directory (either for pubmed items or for
% clinical trials)
% output: figures
%
% 

% initialize
clear all, close all, format compact, clc
rng('default'); % for reproducibility
addpath('subroutines');

%load('./results/summary_clinical_EU');
load('./results/summary_immuno.mat');
%load('./results/summary_clinical_reformatted.mat');
disp('loaded results');
myKeywTable = readtable('./keywords/merge_keywords_V2_2017_11_10.xlsx');
disp('loaded keyword table');

% define parameters
cnst.numelContrKeys = 5; % number of control experiments
cnst.FILTyear = 2000:2017;
cnst.normalizeToPopulation = true; % normalize all values to the sum of all items
cnst.dosmooth = true; % perform smoothing
cnst.smoothMethod = 'moving'; % type of filter, e.g. 'moving' or 'lowess'
cnst.normalizeAgain = false;
cnst.plotGrowthMap = false;
cnst.showDebugMap = false;
cnst.discardLowerThird = false; 
cnst.plotOnlySignificantChanges = false;
cnst.plotOnlyLargeTrumpets = false;
cnst.LargeTrumpetMaxCutoff = 0.0005;
cnst.Zscaling = .2;% .32 or .2 or .04; % scale down shapes in z direction
cnst.saveSVG = true; % save result as svg
cnst.xspace = 0.005;
cnst.yspace = 0.005;
cnst.az = 58; % azimuth
cnst.el = 30; % elevation

%DRUG_NETWORK_ANALYSIS
selectExperiment_A =  {'CANCER_TYPES_TOP5'}; %{'TRANSLATIONAL_DYNAMIC','CANCER_TYPES_TOP5','TREATMENT_TOP6','CANCER_TYPES','TRANSLATIONAL'};  % colors fixed for A
selectExperiment_B =  {'TREATMENTS'};%,'CELL_TYPE','TREATMENTS'}; %{'TRANSLATIONAL','CANCER_TYPES'}; 

% ----------------------------------------------
% retrieve keywords for bivariate dimension A

for currentExperiment_A = selectExperiment_A % ITERATE PARENT_2 FOR A
    
[FILTparent2_A,filter_bank_A] = getExperimentMetadata(currentExperiment_A,myKeywTable);

for currentExperiment_B = selectExperiment_B % ITERATE PARENT_2 FOR B

[FILTparent2_B,filter_bank_B] = getExperimentMetadata(currentExperiment_B,myKeywTable);

% this is in a separate function to prevent data spillover
[g, newZscale] = goRun3DAnalysis(FILTparent2_A,filter_bank_A,FILTparent2_B,filter_bank_B,...
    currentExperiment_A,currentExperiment_B,LIST_KEY,PMID_KEY,PMID_YEAR,...
    myKeywTable,cnst); % is the 3d object group

% scale down shapes
for i = 1:numel(g),g{i}(1).ZData = g{i}(1).ZData * newZscale;end

for i = 1:numel(g),g{i}(1).FaceAlpha = 0.95;end

for i = 1:numel(g),g{i}(1).DiffuseStrength = .7;end
%for i = 1:numel(g),g{i}(1).SpecularExponent = 100;end

axis tight

% save figure (optional)
if cnst.saveSVG
    % set(gcf,'Renderer','Painters');
    set(gcf,'Renderer','opengl');
    drawnow
    currFn = ['FIG_3D_',num2str(round(rand()*100000))];
    %print(gcf,['./saveFigures/',currFn,'.svg'],'-dsvg');
    %saveas(gca,['./saveFigures/',currFn,'.svg'],'svg');
end

end
end


