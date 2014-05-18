function DisplayDetections(imName,dets)
% Displays the original image and the bounding
% boxes corresponding to the detected faces
% 
% Inputs:     imName: path to the input image
%             dets: bounding boxes of the faces
%             (nd x 5)
%             
% Author: Carlos G�lvez del Postigo Fern�ndez            

im = imread(imName);

figure;
%Display original image
image(im); hold on; axis image;
%Display bounding boxes
for i=1:size(dets,1);
    rectangle('Position',dets(i,1:4),'LineWidth',2,'EdgeColor','r');
end
title(imName);
end

