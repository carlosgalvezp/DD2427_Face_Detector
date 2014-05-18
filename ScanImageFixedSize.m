function dets = ScanImageFixedSize(Cparams,im)
% Scans the input image and outputs the set
% of detected faces
% 
% Inputs:     Cparams: parameters of the strong classifier
%             im: path to the input image
% Output:     dets: ndx4 array of the bounding boxes
%             of the detected faces (x,y,L,L)
% 
% Author: Carlos Gálvez del Postigo Fernández            

%% 1.- Load image and pre-process
if ischar(im)
    im = imread(im);    
end
if(size(im,3) > 1)
   im = rgb2gray(im); %Convert to grayscale 
end
im = double(im);
ii_im = cumsum(cumsum(im,1),2);
ii_im2 = cumsum(cumsum(im.*im,1),2);

%% 2.- Move subwindow over image
L = 19;
L2 = L^2;
N_MAX_FACES = 1000;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%APPLY DETECTOR CODE
chosen_f = Cparams.Thetas(:,1); %Tx1
thetas = Cparams.Thetas(:,2); %Tx1
pars = Cparams.Thetas(:,3); %Tx1
parsxthetas = pars.*thetas; %Tx1

alphas = Cparams.alphas; %Tx1
all_ftypes = Cparams.all_ftypes;
fmatT = (Cparams.fmat(:,chosen_f))';
indexes1 = find(all_ftypes(chosen_f,1)==3);
indexes2 = all_ftypes(chosen_f,1) == 3;
wh = all_ftypes(chosen_f(indexes1),4).*all_ftypes(chosen_f(indexes1),5);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Pre-allocation
dets = zeros(N_MAX_FACES,5);
z = 0; %Number of detected faces
for i=2:size(im,1)-L+1
    for j=2:size(im,2)-L+1        
        %Normalize and compute image integral
        mu = (ii_im(i+L-1,j+L-1) - ...
              ii_im(i+L-1,j-1) -...
              ii_im(i-1,j+L-1) + ...
              ii_im(i-1,j-1))/L2;
        sigma = sqrt((ii_im2(i+L-1,j+L-1) - ...
                 ii_im2(i+L-1,j-1) -...
                 ii_im2(i-1,j+L-1) + ...
                 ii_im2(i-1,j-1) - L2*mu^2)/(L2-1));                
        %------------Apply detector2-----------------
        %         sc = ApplyDetector2(Cparams,sub_ii_im,mu,sigma);
        sub_ii_im = ii_im(i:i+L-1,j:j+L-1);
        f = fmatT*sub_ii_im(:)/sigma; %Tx1 
        f(indexes2) = f(indexes2) + wh*mu/sigma;        
        sc = alphas' * (pars.*f < parsxthetas);
        %--------------------------------------------
        if sc > Cparams.thresh
            z = z+1;
            dets(z,:) = [j,i,L,L,sc];
            if z == N_MAX_FACES
                return
            end
        end
    end
end

%Trim the array
dets = dets(1:z,:);
end

