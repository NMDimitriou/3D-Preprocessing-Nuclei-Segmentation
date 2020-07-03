function [splitImage]  = im_split(image,splitX,splitY)
% This function splits image into smaller parts
% input: image to be splitted, 
%  splitX, splitY are the number of splits to be performed in each of 
%  the two planar dimensions
% output: a cell array the contains the splitted image

[x, y, z]              = size(image);

wholeBlockRows         = floor(x / splitX);
wholeBlockCols         = floor(y / splitY);
blockVectorX           = [wholeBlockRows * ones(1, splitX), rem(x,splitX)];
blockVectorX(blockVectorX==0)=[]                                          ;
blockVectorY           = [wholeBlockCols * ones(1, splitY), rem(y,splitY)];
blockVectorY(blockVectorY==0)=[]                                          ;



if z>1
    splitImage = mat2cell(image, blockVectorX, blockVectorY, z);
else
    splitImage = mat2cell(image, blockVectorX, blockVectorY   );
    
end

end
