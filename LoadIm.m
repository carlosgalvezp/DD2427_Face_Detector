function [im,ii_im] = LoadIm(im_fname)
% Reads the image from the filename and 
% outputs the normalized image and the 
% integral image
% 
% Inputs: im_fname. Path to the image
% Outputs:    im. normalized image (HxW)
%             ii_im. integral image (HxW)
%             
% Author: Carlos Gálvez del Postigo Fernández (cgdpf@kth.se)

%% Read the image
im = double(imread(im_fname));

%% Normalize
sigma = std(im(:));
mu =  mean(im(:));
%Divide only if it's zero
if sigma ~=0
    im = (im-mu)/sigma;
end

%% Compute image integral
ii_im = cumsum(cumsum(im,1),2);
end

