function [splitImage]  = im_split(image,splitX,splitY)

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
