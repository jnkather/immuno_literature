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
% create color map by interpolation

function cmap = myCmap( numLevel,lo,hi )

cmap = zeros(numLevel,3);

for ch=1:3
   cmap(:,ch) = linspace(lo(ch),hi(ch),numLevel);
end

end

