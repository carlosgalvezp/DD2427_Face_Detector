function cpic = MakeClassifierPic(all_ftypes, chosen_f, alphas, ps, W, H)
% Displays the weighted sum of the weak classifiers
% 
% Input: all_ftypes: array defining each feature
%        chosen_f: features used in the classifier
%        alphas: associated with each feature/weak classifier
% Output: cpic: output picture
% 
% Author: Carlos Gálvez del Postigo Fernández

cpic = zeros(H,W);

for i=1:length(chosen_f)
   cpic = cpic + alphas(i)*ps(i)*MakeFeaturePic(all_ftypes(chosen_f(i),:),W,H);
end

end

