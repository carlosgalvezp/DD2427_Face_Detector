function DisplayDetections(im,dets)
% Displays the original image and the bounding
% boxes corresponding to the detected faces
% 
% Inputs:     im: path to the input image
%             dets: bounding boxes of the faces
%             (nd x 4)
%             
% Author: Carlos Gálvez del Postigo Fernández            

im = imread(im);

figure;
%Display original image
image(im); hold on; axis image;
%Display bounding boxes
for i=1:size(dets,1);
    rectangle('Position',dets(i,:),'LineWidth',2,'EdgeColor','r');
end
end

