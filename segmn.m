function [Lv,L] = segmn(I_cropped)
    %% This function performs marker based watershed segmentation
    % of cropped/interpolated images of nuclei
    % The input is a part of the initial image that is interpolated
    % in order to increase the number of pixels.
    % Input: the image to be segmented
    % Output: (L)  The binary mask of the watershed map, and
    %         (Lv) The boundaries of the watershed
    % Author: Nikolaos M. Dimitriou, 
    % McGill University, 2020
    
    % 1. CLAHE
    I_eq = adapthisteq(I_cropped);
    %I_eq = I_cropped; % no stretching
    
    % 2. Opening-Closing by Reconstruction, Regional Maxima as foreground
    % markers
    se1 = strel('disk',10); 
    Ie = imerode(I_eq,se1);
    Iobr = imreconstruct(Ie,I_eq,8);
    Iobrd = imdilate(Iobr,se1);
    Iobrcbr = imreconstruct(imcomplement(Iobrd),imcomplement(Iobr),8);
    Iobrcbr = imcomplement(Iobrcbr);
    fgm = imregionalmax(Iobrcbr);
    
    % 3. Close, erode maxima, and compute background markers  
    se2  = strel('disk',5); 
    fgm2 = imclose(fgm,se2);
    fgm3 = imerode(fgm2,se2);
    fgm4 = bwareaopen(fgm3,10);
    fgm4 = imfill(fgm4,'holes');
    bw   = imbinarize(Iobrcbr,'adaptive');

    % 4. Gradient, Complement, Impose minima , Watershed
    gmag        = imgradient(I_eq); 
    %gmagfilt    = imgaussfilt(gmag,1);
    %gmag2       = imimposemin(gmag,bgm | fgm4); % 
    gmag2       = imimposemin(gmag,~bw | fgm4);
    L           = watershed(gmag2);
    
    Lv          = (L==0);
    % 5. Binarize the watershed map 
    L=imbinarize(L,'adaptive');
    L=bwareafilt(L,[200,30000]);
    L=imfill(L,'holes');
    
end

