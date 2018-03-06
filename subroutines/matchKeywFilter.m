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
% reformat years for research items, auxiliary function

function [all_years, target_years, target_PMID_preserve] = matchKeywFilter(PMID_KEY,PMID_YEAR,myMatch)

% reduce the large matrices to only the items that match the filters
subset_PMID_KEY = PMID_KEY(:,logical(myMatch));
hitmask = sum(subset_PMID_KEY,2)>0;
subset_PMID_YEAR = PMID_YEAR(hitmask,:);
target_PMID_preserve = subset_PMID_YEAR(:,1);  % for downstream analysis
target_years = subset_PMID_YEAR(:,2); % year numbers for target articles
all_years = PMID_YEAR(:,2); % year numbers for all articles

end