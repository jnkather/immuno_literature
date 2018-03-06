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
% auxiliary file for querying pubmed database (get request)

function pmstruct = getpubmed(searchterm,varargin)
% GETPUBMED Search PubMed database & write results to MATLAB structure
% Error checking for required input SEARCHTERM
if(nargin<1)
    error(message('bioinfo:getpubmed:NotEnoughInputArguments'));
end
% Create base URL for PubMed db site
baseSearchURL = 'https://www.ncbi.nlm.nih.gov/sites/entrez?cmd=search';

% Set default settings for property name/value pairs, 
% 'NUMBEROFRECORDS' and 'DATEOFPUBLICATION'
maxnum = 50; % NUMBEROFRECORDS default is 50
pubdate = ''; % DATEOFPUBLICATION default is an empty string
% Parsing the property name/value pairs 
num_argin = numel(varargin);
for n = 1:2:num_argin
    arg = varargin{n};
    switch lower(arg)
        
        % If NUMBEROFRECORDS is passed, set MAXNUM
        case 'numberofrecords' % can be only 20,50,100,200
            maxnum = varargin{n+1};
        
        % If DATEOFPUBLICATION is passed, set PUBDATE
        case 'dateofpublication'
            pubdate = varargin{n+1};          
            
    end     
end

% Set db parameter to pubmed
dbOpt = '&db=pubmed';

% Set term parameter to SEARCHTERM and PUBDATE 
% (Default PUBDATE is '')
termOpt = ['&term=',searchterm,'+AND+',pubdate];

reportOpt = '&report=medline'; % Set report parameter to medline
formatOpt = '&format=text'; % Set format parameter to text
maxOpt = ['&dispmax=',num2str(maxnum)]; % Set dispmax to MAXNUM, default 50

% Create search URL
searchURL = [baseSearchURL,dbOpt,termOpt,reportOpt,formatOpt,maxOpt];

disp('starting to read URL...'); tic
medlineText = urlread(searchURL); toc
hits = regexp(medlineText,'PMID-.*?(?=PMID|</pre>$)','match');
numel(hits)

pmstruct = struct('PMID','','PublicationDate','','Title','',...
             'Abstract','','Authors','','Citation','');
numhits=numel(hits);
for n = 1:numhits
    pmstruct(n).PMID = regexp(hits{n},'(?<=PMID- ).*?(?=\n)','match', 'once');
    pmstruct(n).PublicationDate = regexp(hits{n},'(?<=DP  - ).*?(?=\n)','match', 'once');
    pmstruct(n).Title = regexp(hits{n},'(?<=TI  - ).*?(?=PG  -|AB  -)','match', 'once');
    pmstruct(n).Abstract = regexp(hits{n},'(?<=AB  - ).*?(?=AD  -)','match', 'once');
    pmstruct(n).Authors = regexp(hits{n},'(?<=AU  - ).*?(?=\n)','match');
    pmstruct(n).Citation = regexp(hits{n},'(?<=SO  - ).*?(?=\n)','match', 'once');
    % disp(['saved ',num2str(n), ' of ' , num2str(numhits)]);
end          

end