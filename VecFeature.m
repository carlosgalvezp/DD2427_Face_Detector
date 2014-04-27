function ftype_vec = VecFeature(ftype, W, H)
% Computes the vector ftype_vec so that
% ii_im(:)' * ftype_vec = FeatureTypeX(ii_im,...)
% 
% Inputs: ftype = [type,x,y,w,h]
%         (W,H) = size of the image
% Output:
%         ftype_vec
%         
% Author: Carlos Gálvez del Postigo Fernández        

% Get information
type = ftype(1); x = ftype(2); y = ftype(3); w = ftype(4); h = ftype(5);

% Compute feature
switch type
    case 1
        ftype_vec = VecBoxSum(x,y,w,h,W,H)...
                   -VecBoxSum(x,y+h,w,h,W,H);
    case 2
        ftype_vec = VecBoxSum(x+w,y,w,h,W,H)...
                   -VecBoxSum(x,y,w,h,W,H);
    case 3
        ftype_vec = VecBoxSum(x+w,y,w,h,W,H)...
                   -VecBoxSum(x,y,w,h,W,H)...
                   -VecBoxSum(x+2*w,y,w,h,W,H);
    case 4
        ftype_vec = VecBoxSum(x+w,y,w,h,W,H)...
                   +VecBoxSum(x,y+h,w,h,W,H)...
                   -VecBoxSum(x,y,w,h,W,H)...
                   -VecBoxSum(x+w,y+h,w,h,W,H);
end
end

