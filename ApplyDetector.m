function sc = ApplyDetector(Cparams, ii_im)
% Applies the strong classifier to a test image of size 19x19.
% 
% Inputs:     Cparams: the strong classifier
%             ii_im: integral image
% Output:     it returns the score of the classifier
    
chosen_f = Cparams.Thetas(:,1); %Tx1
thetas = Cparams.Thetas(:,2); %Tx1
pars = Cparams.Thetas(:,3); %Tx1
alphas = Cparams.alphas; %Tx1

f = Cparams.fmat(:,chosen_f)'*ii_im(:); %Tx1
sc = alphas' * (pars.*f < pars.*thetas);
end

