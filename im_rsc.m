function [LM_rsc,ncc_rsc,coord_rsc] = im_rsc(LM,ncc_final,Ns)
%% This function rescales the segementation results and the 
% centroids to the size of the original image
% input: the label matrix with the segmented cells, the
% coordinates of the centroids, and the rescale factor
% output: the rescaled quantities
% Author: N.M. Dimitriou

G          = griddedInterpolant(double(LM));
[sx,sy,sz] = size(LM);
xq         = (1:Ns:sx)';
yq         = (1:Ns:sy)';
zq         = (1:sz)'   ;
LM_rsc     = uint8(G({xq,yq,zq}));
LM_rsc     = LM_rsc(2:end,2:end,:);

ncc_rsc(:,1) = ncc_final(:,1)./Ns;
ncc_rsc(:,2) = ncc_final(:,2)./Ns;
ncc_rsc(:,3) = ncc_final(:,3)   ;
ncc_rsc      = floor(ncc_rsc);

for i=1:sz
    
    idx=find(ncc_rsc(:,3)==i);
    coord_rsc{i}=[ncc_rsc(idx,1),ncc_rsc(idx,2)]; 
   
end

end

