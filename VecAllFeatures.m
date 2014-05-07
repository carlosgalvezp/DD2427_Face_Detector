function fmat = VecAllFeatures(all_ftypes,W,H)
% It creates a matrix whose columns are the
% ftype_vec for each feature defined by all_ftypes.
% 
% Input:  all_ftypes: vector of feature descriptors (nfx5)
%         (W,H): size of the image
% Output: fmat (W*H x nf)
% 
% Author: Carlos Gálvez del Postigo Fernández

nf = size(all_ftypes,1);

% Pre-allocate
fmat = zeros(W*H,nf);

for i=1:nf
    fmat(:,i) = VecFeature(all_ftypes(i,:),W,H);
end

end

