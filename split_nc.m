function  [L1,L2]= split_nc(bwL)
%% This function performs distance based watershed transform
% on the binarized result of the previous segmentation
% and binarizes the result
% output: L1 the result of watershed, L2 the binarized result.

    ebwL      = bwareaopen(bwL,500);
    bwLD      = double(ebwL);
    bwD       = -bwdist(~bwLD);
    I1        = imhmin(bwD,1) ;
    L1        = watershed(I1) ;
    L1(~bwLD) = 0             ;
    
    L2  = (L1~=0);
    se2 = strel('disk',2);
    L2  = imerode(L2,se2);
    L2  = bwareaopen(L2,150);

end
