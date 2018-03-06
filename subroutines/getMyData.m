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
% auxiliary function for parsing of XML files for clinical trials
%
function Data = getMyData(structIn)

    keyChildTerms = {'outcome_measure','condition','intervention','phase'};
    compressText = @(varargin) char(varargin);

    if any(contains(fieldnames(structIn),'Children'))
        numChildren = numel(structIn.Children);
        
        if numChildren == 1
         if any(contains(fieldnames(structIn.Children(1)),'Data'))  
             Data = structIn.Children(1).Data;
         else
            disp(['has 1 child but no data']); 
            Data = '#+#+#';
         end
        elseif numChildren >1  % FOUND >1 CHILD. LOOK FOR FIELD NAMES               
            Data = '';
            for ch = 1:numChildren % iterate all children
             if any(contains(keyChildTerms, structIn.Children(ch).Name))  
                 
                 Data = [compressText(structIn.Children(ch).Children.Data), ' # ', Data];
                % disp(['match ' structIn.Children(ch).Name ' -> ' compressText(structIn.Children(ch).Children.Data)]);
                 
               %  pause
                 %Data = [Data ' ' structIn.Children(ch).Data];
             end 
            end
        else
            disp(['has ' num2str(numChildren) ' (zero) children']);
            Data = '#-#-#';
        end
            
    end
end