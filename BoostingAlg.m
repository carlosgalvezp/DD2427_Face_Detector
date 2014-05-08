function Cparams = BoostingAlg(Fdata, NFdata, FTdata, T)
% Boostign algorithm (Adaboost) using weak classifiers.
% 
% Inputs:   Fdata: training data (faces)
%           NFdata: training data (non-faces)
%           FTdata: feature data
%           T: number of weak classifiers
% Outputs:  Cparams: strong classifier
%             -Cparams.alphas
%             -Cparams.Thetas
%             -Cparams.fmat
%             -CParams.all_ftypes
% Author: Carlos Gálvez del Postigo Fernández            
      
%% 1.- Initialize weights

nP = size(Fdata.ii_ims,1); % # positive examples
m = size(NFdata.ii_ims,1);% # negative examples
n =  nP + m; 
Nfeatures = size(FTdata.fmat,2); %1000

y = [ones(nP,1) ; zeros(m,1)];

w = [1/(2*(n-m))*ones(nP,1) ;
     1/(2*m) * ones(m,1)];
 
Data = [Fdata.ii_ims; NFdata.ii_ims]; % n x H*W

%Output variables
Thetas = zeros(T,3);
alphas = zeros(T,1);
%% 2.- For each weak classifier

for t=1:T
   % Normalize weights
   w = w/sum(w,1);
   
   % Train a weak classifier for each feature   
   eps = 1000*ones(Nfeatures,1);
   thetas = zeros(Nfeatures,1);
   pars = zeros(Nfeatures,1);
   
   fss = zeros(n,Nfeatures);
   
   for j=1:Nfeatures
       clc
       fprintf('Boosting...%d %%',floor(100*((t-1)*Nfeatures + j)/(T*Nfeatures)));
       fss(:,j) = Data*FTdata.fmat(:,j);
       [thetas(j),pars(j),eps(j)] = LearnWeakClassifier(w,fss(:,j),y);
   end
   
   % Get values from minimum error
   [epsT,j] = min(eps);
   
   Thetas(t,1) = j;
   Thetas(t,2) = thetas(j);
   Thetas(t,3) = pars(j);
   
   % Update the weights
   beta = epsT/(1-epsT);
   w = w .* beta.^( 1- abs( (pars(j)*fss(:,j) < pars(j)*thetas(j)) - y)) ;
   alphas(t) = -log(beta);
   
end

% Output as struct
Cparams.alphas = alphas;
Cparams.Thetas = Thetas;
Cparams.fmat = sparse(FTdata.fmat);
Cparams.all_ftypes = FTdata.all_ftypes;

end

