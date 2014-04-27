function f = FeatureTypeIII(ii_im,x,y,w,h)
% Computes Haar-kie Feature III
% 
% Inputs: ii_im: integral image
%         x,y: (x,y) coordinates of the top-left corner
%              of the chosen rectangular area
%         w,h: dimensions of the rectangular area
% Output: Haar-like Feature III
% 
% Author: Carlos Gálvez del Postigo Fernández

f = ComputeBoxSum(ii_im,x+w,y,w,h)...
  - ComputeBoxSum(ii_im,x,y,w,h)...
  - ComputeBoxSum(ii_im,x+2*w,y,w,h);

end

