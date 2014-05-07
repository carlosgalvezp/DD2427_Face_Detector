function fs = VecComputeFeature(ii_ims,ftype_vec)
% It extracts the desired feature for a set of
% integral images, using vectorized (faster) code.
% 
% Inputs: ii_ims: Integral images (ni x W*H)
%         ftype_vec: desired feature (W*H x 1)
% Output: fs: features (ni x 1)
% 
% Author: Carlos Gálvez del Postigo Fernández

fs = ii_ims*ftype_vec;

end

