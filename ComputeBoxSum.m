function A = ComputeBoxSum(ii_im,x,y,w,h)
% Computes the sum of the pixels values within a 
% rectangular area using the integral image
% 
% Inputs: ii_im: integral image
%         x,y: (x,y) coordinates of the top-left corner
%              of the chosen rectangular area
%         w,h: dimensions of the rectangular area
% Output: A sum of the pixels within the area
% 
% Author: Carlos Gálvez del Postigo Fernández

% Check input parameters
check = BoxCheck(x,y,w,h,size(ii_im,2),size(ii_im,1));

if ~check
    return;
end

A = ii_im(y+h-1,x+w-1);
if x>1 && y>1
    A = A - ii_im(y-1,x+w-1) - ii_im(y+h-1,x-1) + ii_im(y-1,x-1); 
end