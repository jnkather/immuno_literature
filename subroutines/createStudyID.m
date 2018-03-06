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
% auxiliary script for clinical trial parsing
%
function IDsout = createStudyID(varargin)

for i=1:nargin
    currStr = varargin{i};
    match = strfind(currStr,'NCT');
    IDsout(i) = str2double(currStr((match(end)+3):end));
end

end