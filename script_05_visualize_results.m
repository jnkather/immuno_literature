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
% this script is used to visualize the trend of specific topics over time.
% It will create a "2D trumpet plot"
% 
% input: .mat file in results directory (either for pubmed items or for
% clinical trials)
% output: figures
%

close all;
clear variables;
clc 

rng('default'); % for reproducibility
addpath('subroutines');

%load('./results/summary_clinical_EU');
%load('./results/summary_immuno.mat');
load('./results/summary_clinical_reformatted.mat');
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

selectExperiment =  {'TREATMENTS_NOOTHER','CANCER_TYPES'};
%'TREATMENTS_NOOTHER','CANCER_TYPES','CELL_TYPE','TRANSLATIONAL','METHODS','CHECKPOINT','ATTRIBUTION','PHASES',...
  %  'CANCER_TYPES_TOP5'
for currentExperiment = selectExperiment
clear legend_output timeline_output FILTparent2 filter_bank targetKeys legendTable

[FILTparent2,filter_bank] = getExperimentMetadata(currentExperiment,myKeywTable);

count = 1;
legendTable = [];
for FILTparent1 = filter_bank 

FILTparent1 = char(FILTparent1);
    
% retrieve keywords that match the desired parent 1 and 2 class
[targetKeys, ~] = getTargetKeywords(myKeywTable,FILTparent1,FILTparent2,cnst);
targetKeys = replacePlusesList(targetKeys); % replace '+' by ' ' to match up correctly

% get trumpet data for current keys
[myTrumpetData,legendTable,~] = ...
    findMatches(LIST_KEY,PMID_KEY,PMID_YEAR,targetKeys,FILTparent1,legendTable,cnst);
 
if cnst.dosmooth % smooth timelines (optional)
    myTrumpetData = smooth(myTrumpetData,cnst.smoothMethod);
end
timeline_output(:,count) = myTrumpetData(:); % write to output container
legend_output{count} = strrep(FILTparent1,'_',' '); % create legend
count = count+1;
end

% prepare plotting
if cnst.normalizeAgain % normalize data again (optional)
   timeline_output = timeline_output./sum(timeline_output,2); 
end

[~,myorder]=sort(timeline_output(end,:),'descend'); % sort trumpets

% compute differences (approximate derivative)
mydiff = diff(timeline_output(:,myorder));
mythreshPos = repmat(mean(mydiff)+1.96*std(mydiff),size(mydiff,1),1);
mythreshNeg = repmat(mean(mydiff)-1.96*std(mydiff),size(mydiff,1),1);

% equalize size (add 0 for first year)
mydiff = [zeros(1,size(mydiff,2));mydiff]; 
mythreshPos = [ones(1,size(mythreshPos,2));mythreshPos]; 
mythreshNeg = [-ones(1,size(mythreshNeg,2));mythreshNeg]; 
myThreshMap = rot90(mydiff>=mythreshPos)-rot90(mydiff<=mythreshNeg);

if cnst.plotGrowthMap
% plot rate of change map = growth map
figure()
imagesc(rot90(mydiff)),axis square
set(gca,'YTick',1:numel(legend_output));
set(gca,'YTickLabel',fliplr(legend_output(myorder)));
set(gca,'XTick',1:2:numel(cnst.FILTyear));
set(gca,'XTickLabel',cnst.FILTyear(1:2:numel(cnst.FILTyear)));
set(gca,'XTickLabelRotation',90)
colormap parula
colorbar
title(['growth rate of ',char(strrep(FILTparent2,'_',' '))]);
axis equal tight
set(gcf,'Color','w');
xlabel('year of publication')
drawnow

% threshold map
figure()
imagesc(myThreshMap);
set(gca,'YTick',1:numel(legend_output));
set(gca,'YTickLabel',fliplr(legend_output(myorder)));
set(gca,'XTick',1:2:numel(cnst.FILTyear));
set(gca,'XTickLabel',cnst.FILTyear(1:2:numel(cnst.FILTyear)));
set(gca,'XTickLabelRotation',90)
axis square 
colormap([0 0 1;1 1 1; 1 0 0]);
colorbar
axis equal tight
set(gcf,'Color','w');
caxis([-1 1]);
title(['growth rate of ',char(strrep(FILTparent2,'_',' ')), ' exceeds 1.96\sigma']);
xlabel('year of publication')
drawnow
end

% plot trumpet timeline
figure()
[offset,allYPos,finalHeight] = trumpetPlot(cnst.FILTyear,timeline_output(:,myorder)*100,true);
set(gca,'XTick',cnst.FILTyear(1:2:numel(cnst.FILTyear)));
set(gca,'XTickLabel',cnst.FILTyear(1:2:numel(cnst.FILTyear)));
set(gca,'XTickLabelRotation',90)
set(gca,'YTick',allYPos);
set(gca,'YTickLabel',legend_output(myorder));
axis tight
myax = axis();
axis([myax(1)-1 myax(2)+1, myax(3),myax(4)+offset]);
set(gcf,'Color','w')
title(['timeline of ',char(strrep(FILTparent2,'_',' '))]);
xlabel('year of publication')
hold on
% overlay significant changes
myXPositionMap = repmat(cnst.FILTyear,size(timeline_output,2),1);
myYPositionMap = flipud(repmat(allYPos',1,size(timeline_output,1)));
symbXOffs = 0; % symbol X offset
symbYOffs = .25; % symbol Y offset
text(myXPositionMap(myThreshMap==-1)+symbXOffs,myYPositionMap(myThreshMap==-1)+symbYOffs,'\diamondsuit','FontWeight','bold','HorizontalAlignment','center','Color','k','VerticalAlignment','middle')
text(myXPositionMap(myThreshMap==1)+symbXOffs,myYPositionMap(myThreshMap==1)+symbYOffs,'+','FontWeight','bold','HorizontalAlignment','center','Color','k','VerticalAlignment','middle')
text(myXPositionMap(myThreshMap==0)+symbXOffs,myYPositionMap(myThreshMap==0)+symbYOffs,'\cdot','FontWeight','normal','HorizontalAlignment','center','Color','k','VerticalAlignment','middle')
drawnow
end
