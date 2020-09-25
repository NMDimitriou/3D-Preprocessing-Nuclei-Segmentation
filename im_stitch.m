function I_final = im_stitch(I_sg,x_split,y_split)
%% Reshapes the lineal watershed array to matrix, stiches back the images and
% reshapes to original size (optional)
%Author: N.M. Dimitriou

% Assemble the final image and ...
I_sg    = reshape(I_sg,[x_split y_split]);
I_sg    = cell2mat(I_sg);
I_final = I_sg;
% ... downscale to original size
%I_final = imresize3(I_sg,[sx sy sz]);
end

