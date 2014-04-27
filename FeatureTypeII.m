function f = FeatureTypeII(ii_im,x,y,w,h)
% Computes Haar-kie Feature II
% 
% Inputs: ii_im: integral image
%         x,y: (x,y) coordinates of the top-left corner
%              of the chosen rectangular area
%         w,h: dimensions of the rectangular area
% Output: Haar-like Feature II
% 
% Author: Carlos Gálvez del Postigo Fernández

f = ComputeBoxSum(ii_im,x+w,y,w,h) - ComputeBoxSum(ii_im,x,y,w,h);

end

