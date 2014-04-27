function b_vec = VecBoxSum(x,y,w,h,W,H)
% Outputs a vector b_vec such that:
% ii_im(:)' * b_vec = ComputeBoxSum(ii_im,...)
% 
% Inputs: (x,y): top-left corner of the box
%         (w,h): size of the box
%         (W,H): size of the image
% Output: b_vec
% 
% Author: Carlos Gálvez del Postigo Fernández

im = zeros(H,W);
im(y+h-1,x+w-1) = 1;
if x>1 && y>1
    im(y-1,x+w-1) = -1;
    im(y+h-1,x-1) = -1;
    im(y-1,x-1) = 1; 
end
b_vec = im(:);
end

