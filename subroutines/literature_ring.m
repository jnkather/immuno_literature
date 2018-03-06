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
% auxiliary function for additional visualization
% depends on output from "visualizeResults"

function p = literature_ring(LIST_KEY,myMatch,target_PMID_preserve,...
    subset_PMID_KEY_preserve2,target_years,rmSMALLER,rmLARGER,loThresh)

allKeys = LIST_KEY(find(myMatch)); 
allPMIDs = target_PMID_preserve;
myDataArray = subset_PMID_KEY_preserve2;

size(allKeys)
size(allPMIDs)
size(myDataArray)

BallScaling = 5; % 5 for checkpoint and therapy
%loThresh = 10; % 3 for therapy
fontsize = 8;
% - % - %

% restrict year range
removeYears = target_years<rmSMALLER | target_years>rmLARGER; % years to DELETE
myDataArray(removeYears,:) = 0;

% - % - % - % - % - %

% prepare variables
adjacencyMatrix = zeros(size(myDataArray,2)); % preallocate
allSubjects = 1:size(myDataArray,1);
allClasses  = 1:size(myDataArray,2);

% update sum
sumHits = sum(myDataArray,1); % number of subjects reporting syn type

% create adjacency matrix
for i = allClasses    
    PositiveSubjectIDs = myDataArray(:,i)>0;    
    for j = allClasses        
        adjacencyMatrix(i,j) = sum(myDataArray(PositiveSubjectIDs,j));
    end
end

size(adjacencyMatrix)

% remove sub-threshold connections
adjacencyMatrix(adjacencyMatrix<=loThresh) = 0;

% remove sub-threshold keys
removeKeys = sum(adjacencyMatrix,1)<=loThresh;
adjacencyMatrix(removeKeys,:) = [];
adjacencyMatrix(:,removeKeys) = [];
synNames = allKeys(~removeKeys);
sumHits = sumHits(~removeKeys);
% show heatmap of adjacency
% figure()
% image(adjacencyMatrix);

% create adjacency graph
G = graph(adjacencyMatrix,synNames,'OmitSelfLoops');
edgeColorData = (G.Edges.Weight);

% show graph of adjacency

% layouts: circle, force, subspace
p = plot(G,'Layout','force','EdgeCData',edgeColorData,...
    'LineWidth',(log2(G.Edges.Weight)/2)+1);
p.NodeLabelMode = 'manual';
p.NodeLabel = [];

p.Marker = 'o';
p.NodeColor = [.4 .4 .9];
myMarkerSize = 0.001+(log(sumHits))*BallScaling;
myMarkerSize(isinf(myMarkerSize)) = min(myMarkerSize(myMarkerSize>0));
p.MarkerSize = myMarkerSize;
p.NodeCData = (sumHits);

%p.EdgeLabel = G.Edges.Weight;
colormap((autumn)) %(myCmap(max(G.Edges.Weight),[0 0 1],[.8 0 0]));
%colorbar
colorbar

set(gcf,'Color','w')
axis normal equal off

hold on
for i=1:numel(synNames)
    synNames{i} = strrep(synNames{i},'+',' ');
end
text(p.XData,p.YData,synNames,'FontWeight',...
    'Bold','FontSize',fontsize,'HorizontalAlignment',...
    'Center','VerticalAlignment','Middle','Color','k')

end
