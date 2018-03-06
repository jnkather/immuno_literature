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
% this function returns up to eight colors from the color brewer color
% maps, plese refer to http://colorbrewer2.org/
% 

function cmapout = brewer1(numC)

hexout = {'#66c2a5','#fc8d62','#8da0cb','#e78ac3',...
          '#a6d854','#ffd92f','#e5c494','#b3b3b3'};
 
for i=1:numC
   
    currColInd = mod(i-1,numel(hexout))+1;
    cmapout(i,:) = hex2rgb(hexout{currColInd});

end

cmapout = cmapout(1:numC,:);

end