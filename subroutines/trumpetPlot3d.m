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
% create a 3D trumpet plot (timeline) for a bivariate data set

function [offset,allYPositions,finalHeight] = trumpetPlot3d(xdata,ydata,zdata)

for currZ = zdata
offset = 0.05*max(ydata(:));
xoffset  = 2;
allAreas = area(xdata,ydata,'EdgeAlpha',0);
myColors = brewer1(size(ydata,2));

set(allAreas,'FaceAlpha',0);
nexti = offset*2;
for i=1:numel(allAreas)
    myX = allAreas(i).XData(:);
    myY = allAreas(i).YData(:);
    patchX = [myX;flipud(myX)];
    nexti=nexti+max(myY)/2;
    patchY = [myY/2+nexti;nexti-flipud(myY)/2];
    
    patchY(isnan(patchY)) = nexti;
    
    patchZ = 0*patchY+currZ;
    
    allYPositions(i) = nexti;
    finalHeight(i) = myY(end);
    
    patch(patchX,patchY,patchZ,myColors(i,:),'LineWidth',1,'EdgeColor',[.7 .7 .7]);
    
    % add text to the right
%     if writeNumber
%     text(myX(end)+xoffset,nexti,[num2str(round(myY(end))),'%']);
%     end
 
    nexti=offset+nexti+max(myY)/2;
end
end
end