function fs = ComputeFeature(ii_ims,ftype)
% Computes the feature ftype for a set of integral images
% 
% Input: ii_ims: cell array with a set of integral images
%        ftype: feature information: [type,x,y,w,h]
% 
% Output: fs: array of features (1 x length(ii_ims))
% 
% Author: Carlos Gálvez del Postigo Fernández

% Pre-allocate
fs = zeros(1,length(ii_ims));

% Get information and select feature
type = ftype(1); x = ftype(2); y = ftype(3); w = ftype(4); h = ftype(5);

% Select feature
switch type
    case 1
        feature = @FeatureTypeI;
    case 2
        feature = @FeatureTypeII;
    case 3
        feature = @FeatureTypeIII;
    case 4
        feature = @FeatureTypeIV;
end

% Compute features
for i=1:length(ii_ims)
    fs(i) = feature(ii_ims{i},x,y,w,h);
end

end

