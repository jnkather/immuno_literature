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
% run bivariate analysis for 3D trumpet plot

function [g, newZscale] = goRun3DAnalysis(FILTparent2_A,filter_bank_A,FILTparent2_B,filter_bank_B,...
    currentExperiment_A,currentExperiment_B,LIST_KEY,PMID_KEY,PMID_YEAR,...
    myKeywTable,cnst)
% this is in a separate function to prevent data spillover

count_A = 1; 
legendTable_A = []; legendTable_B = [];
for FILTparent1_A = filter_bank_A % ITERATE PARENT_1 FOR A
FILTparent1_A = char(FILTparent1_A);

% retrieve keywords that match the desired parent 1 and 2 class FOR A
[targetKeys_A, ~] = ...
    getTargetKeywords(myKeywTable,FILTparent1_A,FILTparent2_A,cnst);
targetKeys_A = replacePlusesList(targetKeys_A); % replace '+' by ' ' to match up correctly

% --- GET THE ACTUAL TRUMPET DATA ---
% get trumpet data for current keys FOR A
[~,~,target_PMID_preserve_A] = ...
    findMatches(LIST_KEY,PMID_KEY,PMID_YEAR,targetKeys_A,FILTparent1_A,[],cnst);
% ----------------------------
count_B = 1;
for FILTparent1_B = filter_bank_B % ITERATE PARENT_1 FOR B
FILTparent1_B = char(FILTparent1_B);

% retrieve keywords that match the desired parent 1 and 2 class FOR B
[targetKeys_B, ~] = ...
    getTargetKeywords(myKeywTable,FILTparent1_B,FILTparent2_B,cnst);
targetKeys_B = replacePlusesList(targetKeys_B); % replace '+' by ' ' to match up correctly

% --- GET THE ACTUAL TRUMPET DATA ---
% get trumpet data for current keys FOR B
[~,~,target_PMID_preserve_B] = ...
    findMatches(LIST_KEY,PMID_KEY,PMID_YEAR,targetKeys_B,FILTparent1_B,[],cnst);
% ----------------------------

% --- MATCH THEM (INTERSECTION BETWEEN A & B) --------
[target_PMID_AB,iA,iB] = intersect(target_PMID_preserve_A,target_PMID_preserve_B);
% summarize total article number
summaryAB(count_A,count_B) = numel(target_PMID_AB);

% look up year for each target PMID
[~,~,iyear] = intersect(target_PMID_AB,PMID_YEAR(:,1));
target_years = PMID_YEAR(iyear,2);
% summarize article number by year
for count_Y = 1:numel(cnst.FILTyear) % iterate year AND NORMALIZE
    summaryAB_YEAR(count_A,count_B,count_Y) = ...
        sum(target_years==cnst.FILTyear(count_Y));
    if cnst.normalizeToPopulation
    summaryAB_YEAR(count_A,count_B,count_Y) = ...
        summaryAB_YEAR(count_A,count_B,count_Y) ...
        / sum(PMID_YEAR(:,2)==cnst.FILTyear(count_Y));
    end
end

% % debug
% disp(['i: ',num2str(count_A),', j: ',num2str(count_B),...
%     '; parent 1 A: ',FILTparent1_A,', parent 1 B: ',FILTparent1_B]);
myXlabel{count_B} = FILTparent1_B;
count_B = count_B+1;
end
myYlabel{count_A} = FILTparent1_A;
count_A = count_A+1;
end

% plot heatmap of total article number
if cnst.showDebugMap
figure(),imagesc(summaryAB)
set(gca,'XTick',1:numel(myXlabel));
set(gca,'XTickLabel',(myXlabel));
set(gca,'YTick',1:numel(myYlabel));
set(gca,'YTickLabel',(myYlabel));
set(gca,'XTickLabelRotation',90);
set(gcf,'Color','w')
axis equal tight
drawnow
end

% % plot 3D trumpets
% figure(), hold on
% for i=1:size(summaryAB_YEAR,1)
%     currTimelines = squeeze(summaryAB_YEAR(i,:,:))';
%     [offset,allYPositions,finalHeight] = ...
%         trumpetPlot3d(cnst.FILTyear,currTimelines,i);
% end
% grid on

newZscale = cnst.Zscaling;% / median(summaryAB_YEAR(:));

% sort data for 3D trumpets
summaryAB_YEAR_END = sum(summaryAB_YEAR,3); %squeeze(summaryAB_YEAR(:,:,end));
[~,order_1] = sort(sum(summaryAB_YEAR_END,2));
[~,order_2] = sort(sum(summaryAB_YEAR_END,1));
summaryAB_YEAR_sorted = summaryAB_YEAR(order_1,order_2,:);
% plot 3D trumpets
figure(), hold on
count = 1;

% spacing of vases
%lastsizes = squeeze(summaryAB_YEAR_sorted(:,:,end));
lastsizes = max(summaryAB_YEAR_sorted,[],3);
maxsizesX = max(lastsizes,[],2);
maxsizesY = max(lastsizes,[],1);
xoffs = cumsum(maxsizesX(:)) + cumsum(cnst.xspace * max(summaryAB_YEAR_sorted(:)) * (1:numel(maxsizesX)))' - maxsizesX/2;
yoffs = cumsum(maxsizesY(:)) + cumsum(cnst.yspace * max(summaryAB_YEAR_sorted(:)) * (1:numel(maxsizesY)))' - maxsizesY'/2;

size(lastsizes)
size(summaryAB_YEAR_sorted)


myColors = flipud(brewer1(size(summaryAB_YEAR_sorted,1)));
for i=1:size(summaryAB_YEAR_sorted,1)
    for j = 1:size(summaryAB_YEAR_sorted,2)
        myTimelineData = squeeze(summaryAB_YEAR_sorted(i,j,:))/2; % /2 for diameter radius correction
        if cnst.dosmooth % smooth timelines (optional)
            myTimelineData = smooth(myTimelineData,cnst.smoothMethod);
        end
       [X Y Z]= cylinder(myTimelineData);
       s = surfl(X+xoffs(i),Y+yoffs(j),Z,'light'); % ACTUAL PLOTTING
       g{count} = s;     % save 3d object to output variable
       count = count+1;
       s(1).EdgeColor = 'none'; % [.7 .7 .7];
       s(1).FaceColor = myColors(i,:); % [.7 .7 .7];
       s(1).FaceLighting = 'gouraud';
       s(2).Visible = 'off';
       
       % plot only significant changes
       if cnst.plotOnlySignificantChanges
          s(1).Visible = 'off';       
          % compute differences (approximate derivative)
            mydiff = diff(myTimelineData);
            mythreshPos = mean(mydiff)+1.96*std(mydiff);
            mythreshNeg = mean(mydiff)-1.96*std(mydiff);        
           % find significant locations
           sigmap = mydiff>=mythreshPos | mydiff<=mythreshNeg;
           if any(sigmap)
              s(1).Visible = 'on';   
           end
       end
       
       if cnst.plotOnlyLargeTrumpets
           s(1).Visible = 'off';   
           if max(myTimelineData) >= cnst.LargeTrumpetMaxCutoff
              s(1).Visible = 'on';    
           end
       end
       
       % discard lower third for better visibility
       if cnst.discardLowerThird
           s(1).Visible = 'off';
       if i>(size(summaryAB_YEAR_sorted,1)/3) && j>(size(summaryAB_YEAR_sorted,2)/3)
           s(1).Visible = 'on';
       end
       end
    end
end
li = light;
axis equal %tight
set(gcf,'Color','w');
grid on
xlabel(strrep(currentExperiment_A,'_',' '));
ylabel(strrep(currentExperiment_B,'_',' '));
set(gca,'XTick',xoffs)
set(gca,'XTickLabel',myYlabel(order_1))
%set(gca,'XTickLabelRotation',90);
set(gca,'YTick',yoffs)
set(gca,'YTickLabel',myXlabel(order_2))
set(gca,'ZTick',(1:5:numel(cnst.FILTyear))/numel(cnst.FILTyear)*newZscale);%linspace(0,1,numel(cnst.FILTyear)));
set(gca,'ZTickLabel',[cnst.FILTyear(1:5:end)]);
zlabel('year');
view(cnst.az,cnst.el);
suptitle(['timeline of cancer immunotherapy & ' lower(strrep(char(currentExperiment_A),'_',' ')) ...
    ' & ' lower(strrep(char(currentExperiment_B),'_',' '))]);
drawnow

end

% set(g,'Matrix',makehgtform('scale',10))
% AlphaData
