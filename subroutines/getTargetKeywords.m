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
% get target keywords for a keyword group
%
% usage: targetKeys = getTargetKeywords(myKeywTable,'chemotherapy','TREATMENTS')

function [ targetKeys, controlKeys ] = ...
    getTargetKeywords(myKeywTable,FILTparent1,FILTparent2,cnst)
    
    % generate parent level 1 filter mask
    if ~strcmp(FILTparent1,'*')
        mask1 = strcmp(myKeywTable.level_1_parent,FILTparent1);
    else % '*' means select all
        mask1 = ones(size(myKeywTable.level_1_parent)); 
    end
    
    % generate parent level 2 filter mask
    if ~strcmp(FILTparent2,'*')
        mask2 = strcmp(myKeywTable.level_2_parent,FILTparent2);
    else % '*' means select all
        mask2 = ones(size(myKeywTable.level_2_parent));
    end
    
    % generate target keys
    targetMask = mask1&mask2;
    targetKeys = myKeywTable.keyword(targetMask);
    
    % generate control keys, same length as target keys
    for i = 1:cnst.numelContrKeys
        controlMasks{i} = targetMask(randperm(numel(targetMask)));
        controlKeys{i} = myKeywTable.keyword(controlMasks{i});
    end
 
    % preprocess: replace all spaces by plus
    targetKeys = replaceSpacesList(targetKeys);
    controlKeys = replaceSpacesList(controlKeys);
end