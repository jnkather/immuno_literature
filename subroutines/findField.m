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
% auxiliary script for parsing clinical trial XMLs
%
function myData = findField(currItem)
myData = [];
    for i=1:numel(currItem.Children)
        if ~isempty(currItem.Children(i).Children)         
            currChildren = currItem.Children(i).Children;
            if numel(currChildren) == 1
                if ~isempty(currChildren.Data)
                    myData = [myData, '#', currItem.Children(i).Children.Data];
                end    
            else
            % more than one child
                for k = 1:numel(currChildren)
                    currGrandchildren = currChildren(k).Children;
                    if ~isempty(currGrandchildren)
                        myData = [myData, '#' , currGrandchildren.Data];
                    end
                end
            end        
        end
    end
end