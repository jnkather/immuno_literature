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
% another auxiliary function to reformat data

function data = mysqueezedouble(varargin)
    data = str2double(varargin');
    %data = cell2mat(cellfun(@str2num,data,'un',0));
end