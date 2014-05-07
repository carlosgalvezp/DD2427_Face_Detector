function ComputeROC(Cparams, Fdata, NFdata)
% Computes the ROC curve that relates the true positive
% rate with the false positive rate while varying
% the threshold of the classifier.
% 
% Inputs:     Cparams: strong classifier
%             Fdata: face data
%             NFdata: non-face data
% Author: Carlos Gálvez del Postigo Fernández            

%% 1.- Get test images and scores

dirnameF = '../Web info/TrainingImages/FACES/';
dirnameNF = '../Web info/TrainingImages/NFACES/';

face_fnames = dir(dirnameF);
nface_fnames = dir(dirnameNF);

lf = 3:length(face_fnames);
lnf = 3:length(nface_fnames);

Fnums = setdiff(lf,Fdata.fnums); %The ones not already used
NFnums = setdiff(lnf,NFdata.fnums); %The ones not already used

size(Fnums)
size(NFnums)
% Pre-allocate space 
scoresF = zeros(size(Fnums'));
scoresNF = zeros(size(NFnums'));

% Load images and apply detector
for i=1:length(Fnums)
    clc
    fprintf('Loading Face images... %d %%',floor(100*i/length(Fnums)));
    [~,ii_im] = LoadIm([dirnameF,face_fnames(Fnums(i)).name]);
    scoresF(i) = ApplyDetector(Cparams,ii_im);
end
for i=1:length(NFnums)
    clc
    fprintf('Loading Non-Face images... %d %%',floor(100*i/length(NFnums)));
    [~,ii_im] = LoadIm([dirnameNF,nface_fnames(NFnums(i)).name]);
    scoresNF(i) = ApplyDetector(Cparams,ii_im);
end

%% 2.- Plot ROC Curve

Npoints = 1000;
minTh = min([scoresF;scoresNF]);
maxTh = max([scoresF;scoresNF]);

ths = linspace(minTh,maxTh,Npoints);
tpr = zeros(size(ths));
fpr = zeros(size(ths));

f = figure;
axis([-0.1 1.1 -0.1 1.1]);
foundTh = 0;
for t=1:length(ths)        
    clc
    fprintf('Computing ROC (th = %f)... %d %% \n',ths(t),floor(100*t/length(ths)));
    ntp = sum(scoresF >= ths(t));
    nfp = sum(scoresNF >= ths(t));
    ntn = sum(scoresNF < ths(t));
    nfn = sum(scoresF < ths(t));
    
    tpr(t) = ntp/(ntp+nfn);
    fpr(t) = nfp/(ntn+nfp);
    
    if(~foundTh && tpr(t) < 0.7)
       foundTh = 1;
       thresh = ths(t-1);
    end
        
    % Dynamic plot
    figure(f)
    plot(fpr(1:t),tpr(1:t),'LineWidth',2);
    xlabel('fpr');
    ylabel('tpr');
    title('ROC curve');
end
fprintf('Final Threshold: %f\n',thresh);
end

