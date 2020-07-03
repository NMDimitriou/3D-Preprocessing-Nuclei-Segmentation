function L = segmn(I_cropped)
    %% This function performs marker based watershed segmentation
    % of cropped/interpolated images of nuclei
    % The input is a part of the initial image that is interpolated
    % in order to increase the number of pixels.
    
    % 1. Gaussian filter and Stretch histogram
    %I_gauss = imgaussfilt(I_cropped,3);
    I_eq = adapthisteq(I_cropped);
    %I_eq = I_cropped; % no stretching
    
    % 2. Binarize
    %bw = imbinarize(I_eq,'adaptive');

    % 3. Fill holes, open, dilate
    %bw2 = imfill(bw,'holes');
    se1 = strel('disk',10); %10
    Ie = imerode(I_eq,se1);
    Iobr = imreconstruct(Ie,I_eq,8);
    Iobrd = imdilate(Iobr,se1);
    Iobrcbr = imreconstruct(imcomplement(Iobrd),imcomplement(Iobr),8);
    Iobrcbr = imcomplement(Iobrcbr);
    fgm = imregionalmax(Iobrcbr);
    %bw3 = imopen(bw2, se1);
    %bw4 = bwareaopen(bw3, 50);
    %bw5 = imdilate(bw4,(strel('disk',3)));
    
    % 4. Find maxima
    %mask_em = bw4.*imregionalmax(I_eq);
    %mask_em = imdilate(mask_em,(strel('disk',5)));
    
    % 5. Close, fill, boundaries
    se2  = strel('disk',5); % was 15
    fgm2 = imclose(fgm,se2);
    fgm3 = imerode(fgm2,se2);
    fgm4 = bwareaopen(fgm3,10);
    fgm4 = imfill(fgm4,'holes');
    bw   = imbinarize(Iobrcbr,'adaptive');
    %mask_em = imclose(mask_em, se2);
    %mask_em = mask_em.*bw4;
    %mask_em = imfill(mask_em, 'holes');
    %mask_em = bwareaopen(mask_em, 10);

    % 6. Complement, Impose minima , Watershed
    gmag        = imgradient(I_eq); 
    %gmagfilt    = imgaussfilt(gmag,1);
    %gmag2       = imimposemin(gmag,bgm | fgm4); % 
    gmag2       = imimposemin(gmag,~bw | fgm4);
    L           = watershed(gmag2);
    %I_eq_c = imcomplement(I_eq);
    %I_mod = imimposemin(I_eq_c, ~bw5 | mask_em);
    %L = watershed(I_mod,8);
    
    % 7. Binarize the watershed map 
    L=imbinarize(L,'adaptive');
    L=bwareafilt(L,[200,30000]);
    L=imfill(L,'holes');
    
end

