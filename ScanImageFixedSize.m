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
   im = double(rgb2gray(im)); %Convert to grayscale 
end

%% 2.- Move subwindow over image
L = [19,19];
N_MAX_FACES = 1000;

%Pre-allocation
dets = zeros(N_MAX_FACES,4);
z = 0; %Number of detected faces
for i=1:size(im,1)-L(1)+1
    for j=1:size(im,2)-L(2)+1        
        %Get sub-window
        subImage = im(i:i+L(1)-1,j:j+L(1)-1);
        %Normalize and compute image integral
        mu = mean(subImage(:));
        sigma = std(subImage(:));
        if sigma ~=0
            subImage = (subImage-mu)/sigma;
        end
        sub_ii_im = cumsum(cumsum(subImage,1),2);
        %Apply detector
        sc = ApplyDetector(Cparams,sub_ii_im);
        %Classifiy
        if sc > Cparams.thresh
            z = z+1;
            dets(z,:) = [j,i,L(2),L(1)];
        end
    end
end

%Trim the array
dets = dets(1:z,:);
end

