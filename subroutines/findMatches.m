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
% finds research items that match a given keyword, output will be used for
% trumpet plot
%
function [myTrumpetData,legendTable,target_PMID_preserve] = ...
    findMatches(LIST_KEY,PMID_KEY,PMID_YEAR,targetKeys,FILTparent1,legendTable,cnst)

targetKeys = replaceSpacesList(targetKeys); % REPLACE SPACE BY PLUS FOR MATCHING

% find matches for all keys
for i = 1:numel(LIST_KEY)
   myMatch(i) = sum(strcmp(LIST_KEY(i),targetKeys));
end
% prepare legend table
legendTable.(matlab.lang.makeValidName(FILTparent1)) = targetKeys;

% match current keywords to large matrices
[all_years, target_years, target_PMID_preserve] = ...
    matchKeywFilter(PMID_KEY,PMID_YEAR,myMatch);

% count items for each year
for i = 1:numel(cnst.FILTyear)
    myTrumpetData(i) = sum(target_years==cnst.FILTyear(i));
    % optional: normalize to population
    if cnst.normalizeToPopulation
        myTrumpetData(i) = myTrumpetData(i) / sum(all_years==cnst.FILTyear(i)); 
    end
end
end