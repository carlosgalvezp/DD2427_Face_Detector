function [theta, p, err] = LearnWeakClassifier(ws, fs, ys)
% Implements a weak classifier
% Inputs:     ws: a set of non-negative weights associated
%                 with each image (N x 1)          
%             fs: the value of a particular feature extracted
%                 from each training image. (N x 1)
%             ys: vector of the labels associated with each training
%                 image (N x 1)
% Outputs:    theta,p: the learnt parameters
%             err: associated error
% Author: Carlos Gálvez del Postigo Fernández            

% 1.- Compute weighted mean for positive and negative examples
mu_P = ws(ys==1)' * fs(ys==1) / sum(ws(ys==1),1);
mu_N = ws(ys==0)' * fs(ys==0) / sum(ws(ys==0),1);

% 2.- Set threshold
theta = 0.5 * (mu_P + mu_N);

% 3.- Error associated with parity
eps_N = ws' * abs(ys - (-fs < -theta));
eps_P = ws' * abs(ys - (+fs < +theta));

% 4.- Set p = argmin_p{eps}
if eps_N < eps_P
    p = -1;
    err = eps_N;
else
    p = 1;
    err = eps_P;
end

end

