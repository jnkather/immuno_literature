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
% get master search term for pubmed query

function [masterTerm, allKeys] = getMasterTerm(inputTerm)
        
        % global search term for immunotherapy    
        masterTerm = ['("tumour"[All+Fields]+OR+"tumor"[All+Fields]+OR+"',...
            'neoplasms"[MeSH+Terms]+OR+"neoplasms"[All+Fields]+OR+"cancer"',...
            '[All+Fields])+AND+("immunotherapy"[MeSH+Terms]+OR+',...
            '"immunotherapy"[All+Fields])'];

        % read keywords
        myKeyTable = readtable(['./keywords/',inputTerm,'.xlsx']);
        allKeys = myKeyTable.keyword';
             
        % preprocess: replace all spaces by plus
        for i=1:numel(allKeys)
             allKeys{i} = strrep(allKeys{i},' ','+');
        end

end