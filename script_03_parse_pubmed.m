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
% this script is used to parse previously downloaded data from pubmed and
% to match each item to one or more keywords provided in a separate list
% 
% input: .mat files in cache directory 
% output: summary_immuno.mat structure
%

close all;
clear variables;
clc 

addpath('subroutines');
inputPath = './cache/';                 % define input folder
dirContent = dir([inputPath,'*.mat']);  % load all results files

cumulPMID_YR = zeros(0,2);

% CREATE PMID_YEAR
for i=1:numel(dirContent)            % iterate through all keywords
    currFN = dirContent(i).name;     % get current filename
    load([inputPath,currFN]);        % load current file        
    LIST_KEY{i} = currResults.key;   % extract current keyword
    allCurrPMIDs = currResults.PMIDs; % get all PMIDs for current keyword
    allCurrYears = cell2mat(currResults.year); % get all years for current selection
    for j=1:numel(allCurrPMIDs) % iterate through years for this keyword
        currYearPMIDs = allCurrPMIDs{j};
        % add PMID with current year to PMID_YEAR
        if ~isempty(currYearPMIDs)
            addInfo = zeros(numel(currYearPMIDs),2); % preallocate
            addInfo(:,1) = currYearPMIDs(:);
            addInfo(:,2) = allCurrYears(j);
            cumulPMID_YR = [cumulPMID_YR; addInfo];
        end
        
    end
    disp(['progress: ',num2str(round(i/numel(dirContent)*100)),'%']);    
end
[C,ia,ic] = unique(cumulPMID_YR(:,1)); % remove duplicates
PMID_YEAR = cumulPMID_YR(ia,:);  % final matrix

% CREATE PMID_KEY
PMID_KEY = zeros(size(PMID_YEAR,1),numel(LIST_KEY));
for i=1:numel(dirContent)           % iterate through all keywords
        currFN = dirContent(i).name;    % get current filename
    load([inputPath,currFN]);       % load current file        
    LIST_KEY{i} = currResults.key;   % extract current keyword
    allCurrPMIDs = currResults.PMIDs; % get all PMIDs for current keyword
    for j=1:numel(allCurrPMIDs) % iterate through years for this keyword
        currYearPMIDs = allCurrPMIDs{j};
        % add PMID with current year to PMID_YEAR
        if ~isempty(currYearPMIDs)
            [Lia,Locb] = ismember(PMID_YEAR(:,1),currYearPMIDs);
            PMID_KEY(find(Locb),i) = 1;
        end
    end
    disp(['progress: ',num2str(round(i/numel(dirContent)*100)),'%']);   
end

save('./results/summary_immuno.mat','PMID_YEAR','PMID_KEY','LIST_KEY');
