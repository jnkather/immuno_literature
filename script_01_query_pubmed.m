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
% this script will query the NCBI pubmed database and retrieve all relevant
% research items. Use at you own risk! You could perform a denial of
% service attack, please be careful. 

clear variables, close all, format compact, clc
addpath('subroutines');

% NB: In order not to overload the E-utility servers, NCBI recommends that 
% users post no more than three URL requests per second and limit large 
% jobs to either weekends or between 9:00 PM and 5:00 AM Eastern time 
% during weekdays. Failure to comply with this policy may result in an IP 
% address being blocked from accessing NCBI

baseUrl = ['https://eutils.ncbi.nlm.nih.gov/entrez/eutils/',...
    'esearch.fcgi?db=pubmed&term=']; % basic search URL
[masterTerm, allKeys] = getMasterTerm('merge_keywords_V2_2017_11_10');

yearRange = 1986:2017;   % define range of years for search
retmax = 8000;           % retrieve N PMIDs per query
retstart = 0;            % first queried element (starts with 0)
idleTime = 0.0012;            % time to wait between two queries
idleFactor = 0.01;          % additional random waiting time
cachepath = './cache/';  % where to store the results

allKeys = fliplr(allKeys);

for iterKey = 1:(numel(allKeys)+1) % iterate through key words
    disp(['##########',10,'starting key #',num2str(iterKey)])
    % prepare query string
    if iterKey == (numel(allKeys)+1)
        suffix = []; % general search comes last
        currKey = [];
    else
        suffix = ['+AND+',char(allKeys{iterKey})];
        currKey = char(allKeys{iterKey});
    end
    
    % try to load data from cache. if not possible, get it from pubmed
    if isempty(currKey),currKeyName='_ALL';else,currKeyName=currKey;end
    try    
        load([cachepath,currKeyName,'.mat']);
        disp(['##########',10,'loaded key ',currKey]);
    catch
        disp(['##########',10,'could not load key ',currKey]);
        disp('starting to query from pubmed...');
        currResults = performPubmedQuery(masterTerm,suffix,...
            yearRange,retmax,retstart,idleTime,idleFactor,baseUrl,currKey);
        save([cachepath,currKeyName,'.mat'],'currResults');
    end  
end
