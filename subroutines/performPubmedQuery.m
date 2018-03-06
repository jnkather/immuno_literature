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
% send pubmed query. be extremely careful, you do not want to cause a DOS
% attack

function currResults = performPubmedQuery(masterTerm,suffix,...
    yearRange,retmax,retstart,idleTime,idleFactor,baseUrl,currKey)

    currResults.key = currKey;
    
    for iterYr = 1:numel(yearRange)
            disp(['*****',10,'starting year ',num2str(yearRange(iterYr))])

        % prepare and perform search query
        currQuery = [masterTerm, suffix, '+AND+', num2str(yearRange(iterYr)),'[pdat]',...
            '&RetMax=',num2str(retmax),'&RetStart=',num2str(retstart)];
        disp('starting query...');

        trials=1;
        while trials<30
            pause(idleTime+idleFactor*rand()); % be nice and do not perform DOS attack                
            try
                currData = xmlread([baseUrl,currQuery]);  % send database query
                trials = 100;
                disp('query succeeded');
                disp([baseUrl,currQuery]);
            catch
                warning(['query failed... this was attempt ',num2str(trials)]);
                pause(trials*2);    
                trials = trials+1;
            end
        end, disp('finished query');

        % parse XML
        currStruct = parseXML(currData);
        currResults.year{iterYr} = yearRange(iterYr);
        
        % get (hard-coded) results: article count, elements per query
        % COUNT
        disp(['processing: ',currStruct(2).Children(2).Name]);
        countdata = str2double(currStruct(2).Children(2).Children.Data);
        currResults.count{iterYr} = countdata;
        
        if countdata>0
        % PMIDs
        disp(['processing: ',currStruct(2).Children(6).Name]);
        currChildren = currStruct(2).Children(6).Children;
        allPMIDs = [];
        for i=1:numel(currChildren)
            if ~isempty(currChildren(i).Children)
            currPMID = str2double(currChildren(i).Children.Data);
            allPMIDs = [allPMIDs;currPMID];
            end
        end

        % save results to summary
        currResults.PMIDs{iterYr} = allPMIDs;
        else
            disp('NO RESULTS');
            currResults.PMIDs{iterYr} = [];
        end

    end