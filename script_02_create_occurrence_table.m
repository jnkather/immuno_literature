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
%
% just creates a table from the cached results

clear variables, close all, format compact, clc
rng('default'); % for reproducibility
addpath('subroutines');

load('./results/summary_immuno.mat');
%load('./results/summary_clinical_reformatted.mat');
disp('loaded results');
myKeywTable = readtable('./keywords/merge_keywords_V2_2017_11_10.xlsx');
disp('loaded keyword table');

% clean 
LIST_KEY_2 = LIST_KEY(~cellfun('isempty',LIST_KEY));
PMID_KEY_2 = PMID_KEY(:,~cellfun('isempty',LIST_KEY));

% count hits
occurrences_raw = sum(PMID_KEY_2);
occurrences_frac = sum(PMID_KEY_2) / size(PMID_YEAR,1);

% replace ' ' by '+'
myKeys = myKeywTable.keyword';
myKeys = replaceSpacesList(myKeys);

% match up
[joined,ia,ib] = intersect(myKeys,LIST_KEY_2);

% summarize results
outputTable.Key = LIST_KEY_2(ib)';
outputTable.occurrences_raw = occurrences_raw(ib)';
outputTable.occurrences_frac = occurrences_frac(ib)';
outputTable.parent1 = myKeywTable.level_1_parent(ia);
outputTable.parent2 = myKeywTable.level_2_parent(ia);

writetable(struct2table(outputTable),'./keywords/sortedOutputTable.xlsx');