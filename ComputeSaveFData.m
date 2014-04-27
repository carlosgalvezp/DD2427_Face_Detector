function ComputeSaveFData(all_ftypes,f_sfn)
% Computes all the feature vectors and saves the resulting
% 'fmat' matrix into a file.
% 
% Inputs:     all_ftypes: feature types from which to compute fmat.
%             f_sfn: filename where fmat will be saved
%             
% Author: Carlos G�lvez del Postigo Fern�ndez            
W = 19; 
H = 19;
fmat = VecAllFeatures(all_ftypes,W,H);

save(f_sfn, 'fmat','all_ftypes','W','H');

end

