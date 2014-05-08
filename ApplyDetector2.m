function sc = ApplyDetector2(Cparams, ii_im,mu,sigma)
% Applies the strong classifier to a test image of size 19x19.
% 
% Inputs:     Cparams: the strong classifier
%             ii_im: integral image
% Output:     it returns the score of the classifier
    
chosen_f = Cparams.Thetas(:,1); %Tx1
thetas = Cparams.Thetas(:,2); %Tx1
pars = Cparams.Thetas(:,3); %Tx1
alphas = Cparams.alphas; %Tx1
all_ftypes = Cparams.all_ftypes;
fmatT = (Cparams.fmat(:,chosen_f))';

indexes1 = find(all_ftypes(chosen_f,1)==3);%Particular case for the Type III: add w*h*mu/sigma
indexes2 = all_ftypes(chosen_f,1) == 3;

f = fmatT*ii_im(:)/sigma; %Tx1
f(indexes2) = f(indexes2) + all_ftypes(chosen_f(indexes1),4).*all_ftypes(chosen_f(indexes1),5)*mu/sigma;
sc = alphas' * (pars.*f < pars.*thetas);
end

