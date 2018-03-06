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
% this script is used to parse a previously downloaded XML data set of
% clinical trials and to match each trial to one or more relevant keywords
% provided in a separate list
% 
% input: raw XML file of all relevant publications downloaded from
% clinicaltrials.gov AND a list of relevant search terms
% output: summary_clinical_reformatted.mat structure
%

close all;
clear variables;
clc 

keyTerms = {'title','outcome_measures','conditions','interventions','phases'};
addpath('subroutines');

% LOAD KEYWORD TABLE
[masterTerm, allKeys] = getMasterTerm('merge_keywords_V2_2017_11_10');

% LOAD SCRAPED DATA
source_folder = './cache_CLINICALTRIALS_FULL/';
all_files = dir([source_folder,'*.xml']);

for i=1:numel(all_files)
   currentFile = [source_folder,all_files(i).name];
   disp(['#####',10,'starting to process file: ', currentFile]);
   currData = xmlread(currentFile);
   disp('starting to parse XML');
   tic
   currStruct = parseXML(currData); 
   toc
   disp('finished parsing XML');

   % START TO PARSE CURRENT FILE ------------------------------------
   % in late 2017 raw data, there is only one file for all 
   % assume currStruct is defined
clc
keyTerms = {'title','outcome_measures','conditions','interventions','phases'};

% START TO PARSE CURRENT FILE ------------------------------------
countStudy = 1; % study count
% in late 2017 raw data, there is only one file for all 
allItems = currStruct.Children;
disp(['found ',num2str(numel(allItems)),' children']);
for co1=1:numel(allItems)
    currName = allItems(co1).Name;
    if strcmp(currName,'study')                  % IF IS A STUDY
        if numel(allItems(co1).Children) > 0     % IF HAS CHILDREN
            
            myStudies{countStudy} = allItems(co1);
            mySummary(countStudy).('DETAILS') = '';
            % ------- extract relevant fields for current study
            
            % iterate fields
            for co2=1:numel(allItems(co1).Children) % GET ALL CHILD DATA FOR STUDY
                currChildName = allItems(co1).Children(co2).Name;
                if strcmp('nct_id',currChildName)                           % FOUND STUDY ID
                    currChildData = getMyData(allItems(co1).Children(co2));
                    mySummary(countStudy).(currChildName) = currChildData;
                elseif strcmp('study_first_submitted',currChildName)               % FOUND STUDY YEAR
                    currChildData = getMyData(allItems(co1).Children(co2));
                    mySummary(countStudy).(currChildName) = currChildData;
                    mySummary(countStudy).('year') = str2double(datestr(currChildData,'yyyy'));
                end
                % LOOK FOR ALL INTERESTING FIELDS AND MERGE THEM INTO DETAILS
                if any(contains(keyTerms,currChildName))
                   % disp(['matched interesting Term ',currChildName]);
                    currChildData = getMyData(allItems(co1).Children(co2));
                    mySummary(countStudy).('DETAILS') = strcat(mySummary(countStudy).('DETAILS'),' ## ', currChildData);
                end
                
            end            
            disp(['finished study ' mySummary(countStudy).nct_id]); 
            countStudy = countStudy+1; % NEXT STUDY
        else % this should never happen
            warning('this study does not have any children');
        end
    end
end
end

% REFORMAT 

% GET NUMERICAL LIST OF NCT IDS AND TREAT AS PMID
mycompress = @(varargin) varargin';
comprNCT_id = mycompress(mySummary.nct_id);
for i=1:numel(comprNCT_id)
    currnum = comprNCT_id{i};
    nct_id_num(i) = str2double(currnum(4:end));
end
% GET NUMERICAL LIST OF YEARS AND CONCATENATE
mycompressNum = @(varargin) cell2mat(varargin)';
PMID_YEAR = [(nct_id_num)',mycompressNum(mySummary.year)];

% GET LIST OF KEYWORDS
myKeywTable = readtable('./keywords/merge_keywords_V2_2017_11_10.xlsx');
LIST_KEY = table2cell(myKeywTable(:,1))';

% CREATE PMID _ KEY _ MATRIX
PMID_KEY = zeros(size(PMID_YEAR,1),numel(LIST_KEY)); % preallocate

% CREATE PMID_YEAR
for i=1:numel(LIST_KEY)            % iterate through all keywords
   
    % iterate through all clinical trials
    match = 0;
    for j = 1:numel(mySummary)
        
       match = contains(squeezetext(mySummary(j).DETAILS),...
           LIST_KEY{i},'IgnoreCase',true);
       
       PMID_KEY(j,i) = match;
       
    end
    
       disp(['overall progress %',num2str(100*i/numel(LIST_KEY))]);
end

% REPLACE SPACE BY PLUS IN CLINI TRIALS FOR CONSISTENCY
LIST_KEY = replaceSpacesList(LIST_KEY);

disp('DONE ALL');
save('./results/summary_clinical_reformatted.mat','PMID_YEAR','PMID_KEY','LIST_KEY');
