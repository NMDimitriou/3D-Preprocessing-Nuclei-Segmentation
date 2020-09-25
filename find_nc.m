function [coord,ncc_final,LM] = find_nc(L2_final,z)
%% This function finds the centroids of the segmented nuclei
% input: the binarized result from the last watershed
% output: the centroids of the nuclei and the label matrix
%Author: N.M. Dimitriou
CC           = bwconncomp(L2_final       );
LM           = labelmatrix(CC            );
% Correct nuclear merge from out of focus planes
%for i=1:z-1
%   temp= (LM(:,:,i)&LM(:,:,i+1));
%   idx = find(temp==1);
%end
ncc          = regionprops(CC, 'Centroid'); 
ncc_table    = struct2table(ncc          );
ncc_final    = table2array(ncc_table     );
ncc_final    = round(ncc_final           );
%idx          = sub2ind(size(mat_ncc),ncc_final(:,1),ncc_final(:,2),ncc_final(:,3));
%mat_ncc(idx) = 1;

for i=1:z
    
    idx=find(ncc_final(:,3)==i);
    coord{i}=[ncc_final(idx,1),ncc_final(idx,2)]; 
    %perim(:,:,i)=bwperim(L2_final(:,:,i));
    
end

end
