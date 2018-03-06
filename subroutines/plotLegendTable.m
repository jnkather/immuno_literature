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
% auxiliar function to plot a legend

function plotLegendTable(legendTable,axh,myOrder)

titles = fieldnames(legendTable);
titles=titles(myOrder);
myPos = get(axh,'Position');
offset = 0.2;
xspa = (myPos(1)-offset+myPos(2)+offset)/numel(titles);
maxel = 0;
for i=1:numel(titles)
    currel = numel(legendTable.(titles{i}));
    if currel>maxel
        maxel= currel;
    end
end

if numel(titles)>3
    myrot = 15;
else
    myrot = 0;
end

for i=1:numel(titles)
    text(xspa*(i-1),1,strrep(titles{i},'_',' '),'Rotation',myrot,'FontWeight','bold');
    currItems = legendTable.(titles{i});
    yspa = 0.9/maxel;
    for j = 1:numel(currItems)
       text(xspa*(i-1),0.95-yspa*(j-1),strrep(currItems{j},'_',' '),'Rotation',myrot); 
    end
end

axis off

% 
% for i=1:numel(titles)
%     dat{i} =  legendTable.(titles{i});
% end
% 
% dat
% 
% columnname =   titles;
% 
% t = uitable( 'Data', dat,... 
%             'ColumnName', columnname,...
%             'RowName',[]); 
%         
% set(t,'Units',get(axh,'Units'));
% set(t,'Position',get(axh,'Position'));


end