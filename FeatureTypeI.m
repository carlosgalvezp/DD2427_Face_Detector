function f = FeatureTypeI(ii_im,x,y,w,h)
% Computes Haar-kie Feature I
% 
% Inputs: ii_im: integral image
%         x,y: (x,y) coordinates of the top-left corner
%              of the chosen rectangular area
%         w,h: dimensions of the rectangular area
% Output: Haar-like Feature I
% 
% Author: Carlos Gálvez del Postigo Fernández

f = ComputeBoxSum(ii_im,x,y,w,h) - ComputeBoxSum(ii_im,x,y+h,w,h);

end

