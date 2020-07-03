%% Main nuclei segmentation pipeline 
% Author: Nikolaos M. Dimitriou
% McGill University, 2020
clear; clc; close all; delete(gcp('nocreate'));

% import
day	= 'D0';
fname1	= 'AD0-C.tif';
dir     = [day '/8bit_denoised/'];
pathim  = [dir fname1];
pathres = ['res_coord/' day '/'];
info1 = imfinfo(pathim);
z=length(info1);
for count=1:length(info1)
    I(:,:,count)=imread(pathim,count,'Info', info1);
end

[sx, sy, sz]        = size(I)        ;
% Break image into parts 
disp('Splitting image...')
I_split             = im_split(I,3,3);
empty_cell          = cellfun('isempty',I_split);
I_split(empty_cell) = [];
[x_split,y_split]   = size(I_split)  ;
len_split           = x_split*y_split; % the length of linearly indexed splits
Ns                  = 10             ; % interpolation points for each dimension in 2D


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Nuclei segmentation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create a "local" cluster object
% Start the parallel pool
parpool(len_split);
disp(['Started segmenting ' fname1 ' ...'])
parfor j=1:len_split
    
    I_part = I_split{j};
    disp(['Segmenting part ' num2str(j) '/' num2str(len_split) ' ...'])
    for i=1:z

    I_cropped = I_part(:,:,i);
    F         = griddedInterpolant(double(I_cropped),'spline');
    [sx,sy]   = size(I_cropped);
    xq        = (0:1/Ns:sx)';
    yq        = (0:1/Ns:sy)';
    I_cropped = uint8(F({xq,yq}));
    
    % Segment nuclei
    L         = segmn(I_cropped); 
       
    % Refine segmentation and split connected nuclei
    [L1,L2]   = split_nc(L);
    
    I_sg{j}(:,:,i)  = I_cropped;
    %L_sg{j}(:,:,i) = L;
    %L1_sg{j}(:,:,i) = L1;
    L2_sg{j}(:,:,i) = L2;
    
    end
    
end
delete(gcp('nocreate'));

%% Assemble the final watershed 
disp('Assembling back interpolated and segmented images ...')
I_final  = im_stitch(I_sg ,x_split,y_split);
%L_final  = im_stitch(L_sg ,x_split,y_split);
%L1_final = im_stitch(L1_sg,x_split,y_split);
L2_final = im_stitch(L2_sg,x_split,y_split);

%% Find the centroids of the nuclei
disp('Calculating the coordinates of segmented nuclei ...')
[coord,ncc_final,LM] = find_nc(L2_final,z);
clear L2_final

%% Rescale
disp('Rescaling ...')
[LM_rsc,ncc_rsc,coord_rsc] = im_rsc(LM,ncc_final,Ns);
writematrix(ncc_rsc,[pathres fname1 '.txt']);

%% Visualize
disp('Visualizing ...')
for i=1:z    
    
    F = labeloverlay(adapthisteq(I(:,:,i)),LM_rsc(:,:,i),'Colormap','jet','Transparency',0.55);
    figH(i) = figure('visible','off','Name',sprintf([fname1 ' Stack %d'], i),'NumberTitle','off');
    ha(1)=subplot(1,2,1); imshow(F);
    ha(2)=subplot(1,2,2); 
    imshow(I(:,:,i));
    hold on;
    plot(coord_rsc{i}(:,1),coord_rsc{i}(:,2),'.r','MarkerSize',20);
    hold off;
    pause(0.02);
    linkaxes(ha, 'xy');        
end
savefig(figH,[pathres fname1 '_stacks.fig']);
%%

f3=figure('visible','off');
plot3(ncc_rsc(:,1),ncc_rsc(:,2),ncc_rsc(:,3),'.','MarkerSize',12)

savefig(f3,[pathres fname1 '_plot3D.fig']);

%out=0;
disp(['Finished ' fname1])
%
