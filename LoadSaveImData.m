function LoadSaveImData(dirname, ni, im_sfn)
% Takes 'ni' random images from the FACES/ directory
% to create the training dataset, and store 
% their integral image into a file
% 
% Inputs: dirname: Directory from which images are taken
%         ni: number images to take.
%         im_sfn: name of the file into which to save the data
%         
% Author: Carlos Gálvez del Postigo Fernández

% Get a list of 'ni' random images
face_fnames = dir(dirname);
aa = 3:length(face_fnames);
a = randperm(length(aa));
fnums = aa(a(1:ni));

% Load first one and preallocate
[~,ii_im1] = LoadIm([dirname,face_fnames(fnums(1)).name]);
ii_ims = zeros(ni,size(ii_im1,1)*size(ii_im1,2));
ii_ims(1,:) = ii_im1(:)';

% Load the rest
for i=2:ni
    [~,ii_im_tmp] = LoadIm([dirname,face_fnames(fnums(i)).name]);
    ii_ims(i,:) = ii_im_tmp(:)';
end

% Save to file
save(im_sfn,'dirname','fnums','ii_ims');
end

