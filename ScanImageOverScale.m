function dets = ScanImageOverScale(Cparams,im, min_s, max_s,step_s)
% Detects a face using a multi-scale search: the sliding
% window is moved throughout the image, which is also
% rescaled.
% 
% Inputs:     Cparams: the strong classifier
%             im: path to the input image
%             min_s: minimum scale
%             max_s: maximum scale
%             step_s: step change in scale
% Output:     dets: face detections (nd x 4), where
%             each detection is the bounnding box
%             defined by (x,y,L,L)
% 
% Author: Carlos Gálvez del Postigo Fernández

%% 1.- Load image and pre-process
if ischar(im)
    im = imread(im);
end
if(size(im,3) > 1)
   im = double(rgb2gray(im)); %Convert to grayscale 
end
%% 2.- Scan over scale
scales = min_s:step_s:max_s;
dets = [];

for i=1:length(scales)
    clc;
    fprintf('Scanning over scale...%d %%',round(100*(i-1)/length(scales)));
    s = scales(i);
    imS = imresize(im, round(s*size(im)));
    detsS = ScanImageFixedSize(Cparams,imS);
    dets = [dets; round(detsS/s)];
end

end

