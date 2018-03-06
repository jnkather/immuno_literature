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
% calculate median line and confidence interval for control trumpets
%

function [medianTrumpet,lowCITrumpet,hiCITrumpet,currTrumpetData] = getRandomTrumpetStats(myControlTrumpet)

    currTrumpetData = cell2mat(myControlTrumpet')';
    
    % calculate the median number of publications +/- confidence interval
    medianTrumpet  = median(currTrumpetData');
    lowCITrumpet   = median(currTrumpetData') - 1.96 * std(currTrumpetData'); % 95% CI
    hiCITrumpet    = median(currTrumpetData') + 1.96 * std(currTrumpetData'); % 95% CI
    
%     % calculate the rate of change for each year
%     myDiff =diff(currTrumpetData);
%     size(myDiff)
%     size(zeros(1,size(currTrumpetData,2)))
%     roc = [zeros(1,size(currTrumpetData,2));diff(currTrumpetData)];
%     % relative change
%     relC = roc./currTrumpetData;
%     % calculate the median +/- CI relative change
%     rrelC = relC;
%     rrelC(isnan(relC)) = 0;
%     rrelC(isinf(relC)) = 0;
%     median_relC = median(relC','omitnan')
%     std_relC = std(rrelC','omitnan')
end