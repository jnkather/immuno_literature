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
% for a cell array of char vectors, replace all spaces with '+'
%
function inList = replacePlusesList(inList)
    for i=1:numel(inList)
         inList{i} = strrep(inList{i},'+',' ');
    end
end