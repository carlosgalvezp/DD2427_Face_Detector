clear all, clc;
%% LoadIm
close all;

fprintf('Test 1: LoadIm...')
[im, ii_im] = LoadIm('face00001.bmp');
dinfo1 = load('debuginfo1.mat');
eps = 1e-6;

s1 = sum(abs(dinfo1.im(:) - im(:)) > eps);
s2 = sum(abs(dinfo1.ii_im(:) - ii_im(:)) > eps);

ii_im;
dinfo1.ii_im;
if s1 || s2
    fprintf('FAIL \n');
else
    fprintf('OK \n');
end

figure;
subplot(121);
imagesc(im);
subplot(122);
imagesc(ii_im);
colormap(gray);

%% ComputeBoxSum
clc;
fprintf('Test 2: ComputeBoxSum...')

x = 1;
y = 1;
w = 13;
h = 3;

B = ComputeBoxSum(ii_im,x,y,w,h);

s3 = abs(B - sum(sum(im(y:y+h-1,x:x+w-1)))) > eps;
if s3
    fprintf('FAIL\n')
else
    fprintf('OK\n');
end

%% Haar-like features
dinfo2 = load('DebugInfo/debuginfo2.mat');
x = dinfo2.x; y = dinfo2.y; w = dinfo2.w; h = dinfo2.h;
s1 = abs(dinfo2.f1 - FeatureTypeI(ii_im, x, y, w, h)) > eps;
s2 = abs(dinfo2.f2 - FeatureTypeII(ii_im, x, y, w, h)) > eps;
s3 = abs(dinfo2.f3 - FeatureTypeIII(ii_im, x, y, w, h)) > eps;
s4 = abs(dinfo2.f4 - FeatureTypeIV(ii_im, x, y, w, h)) > eps;

if s1
    disp('Test 3.1: Haar-like Feature I...FAIL');
else
    disp('Test 3.1: Haar-like Feature I...OK');
end

if s2
    disp('Test 3.2: Haar-like Feature II...FAIL');
else
    disp('Test 3.2: Haar-like Feature II...OK');
end

if s3
    disp('Test 3.3: Haar-like Feature III...FAIL');
else
    disp('Test 3.3: Haar-like Feature III...OK');
end

if s4
    disp('Test 3.4: Haar-like Feature IV...FAIL');
else
    disp('Test 3.4: Haar-like Feature IV...OK');
end

%% Enumerate features
all_ftypes = EnumAllFeatures(19,19);
size(all_ftypes)
%% ComputeFeatures
% Read the first 100 images
N = 100;
DirName = '../Web Info/TrainingImages/FACES/';
im_files = dir(DirName);

ii_ims = cell(N);
for i = 1:N
   [~,ii_ims{i}] = LoadIm([DirName,im_files(i+2).name]);
end

% Test
dinfo3 = load('DebugInfo/debuginfo3.mat');
ftype = dinfo3.ftype;

s1 = sum(abs(dinfo3.fs - ComputeFeature(ii_ims,ftype)) > eps);

if s1
   disp('Test 4: ComputeFeature...FAIL'); 
else
   disp('Test 4: ComputeFeature...OK');
end

%% VecBoxSum
x = 1;
y = 3;
h = 7;
w = 9;
b_vec = VecBoxSum(x,y,w,h,19,19);

s  = abs(ii_im(:)' * b_vec - ComputeBoxSum(ii_im,x,y,w,h)) > eps;
if s
    display('Test 5: VecBoxSum...FAIL');
else
    display('Test 5: VecBoxSum...OK');
end


%% VecFeature
x = 1;
y = 3;
h = 4;
w = 4;

functions = {@FeatureTypeI,@FeatureTypeII, @FeatureTypeIII,@FeatureTypeIV};
names = {'I','II','III','IV'};

for i=1:4  
    ftype_vec = VecFeature([i,x,y,w,h],19,19);
    f = functions{i};
    s  = abs(ii_im(:)' * ftype_vec - f(ii_im,x,y,w,h)) > eps;
    if s
        fprintf('Test 5.%d: VecFeature %s...FAIL\n',i,names{i});
    else
        fprintf('Test 5.%d: VecFeature %s...OK\n',i,names{i});
    end
end

%% VecComputeFeature
fmat = VecAllFeatures(all_ftypes,19,19);
ii_ims2 = zeros(size(ii_ims,1),19*19);
for i=1:size(ii_ims,1)
    ii_ims2(i,:) = ii_ims{i}(:)';
end

fs1 = VecComputeFeature(ii_ims2,fmat(:,1));
fs2 = ComputeFeature(ii_ims,all_ftypes(1,:));

s = sum(abs(fs1-fs2')) > eps;

if s
    disp('Test 6. VecComputeFeature...FAIL');
else
    disp('Test 6. VecComputeFeature...OK');
end

%% LoadSaveImData and ComputeSaveFData

dinfo4 = load('DebugInfo/debuginfo4.mat');
ni = dinfo4.ni;
all_ftypes = dinfo4.all_ftypes;
im_sfn = 'FaceData.mat';
f_sfn = 'FeaturesToMat.mat';
rng(dinfo4.jseed);

dirname = '../Web info/TrainingImages/FACES/';
LoadSaveImData(dirname,ni,im_sfn);
ComputeSaveFData(all_ftypes,f_sfn);

load FaceData;
load FeaturesToMat;

s1 = sum(abs(ii_ims(:) - dinfo4.ii_ims(:))) > eps;
s2 = sum(abs(fmat(:) - dinfo4.fmat(:))) > eps;

if s1 || s2
    disp('Test 7. LoadSaveImData and ComputeSaveFData...FAIL');
else
    disp('Test 7. LoadSaveImData and ComputeSaveFData...OK');
end

%% GetTrainingData

dinfo5 = load('DebugInfo/debuginfo5.mat');
np = dinfo5.np;
nn = dinfo5.nn;
all_ftypes = dinfo5.all_ftypes;
rng(dinfo5.jseed);
GetTrainingData(all_ftypes,np,nn);

Fdata = load('FaceData.mat');
NFdata = load('NonFaceData.mat');
FTdata = load('FeaturesToUse.mat');

fprintf('Getting training data...OK');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% LearnWeakClassifier
fmat = FTdata.fmat;
fs = [Fdata.ii_ims ; NFdata.ii_ims];
ys = [ones(size(Fdata.ii_ims,1),1);...
      zeros(size(NFdata.ii_ims,1),1)];
  
fs = fs * fmat(:,12028);      
ws = ones(size(fs,1),1)/size(fs,1); %Uniform

[theta,p,err] = LearnWeakClassifier(ws,fs,ys);

eps = 1e-4;
if (theta - (-3.6453)) < eps && (p-1) < eps
    disp('Test 8. LearnWeakClassifier...OK');
else
    disp('Test 8. LearnWeakClassifier...FAIL');
end

[h1,x1] = hist(fs(ys==1));
[h2,x2] = hist(fs(ys==0));

% Normalize
h1 = h1/sum(h1);
h2 = h2/sum(h2);
figure;
plot(x1,h1,'r-x','LineWidth',2); hold on;
plot(x2,h2,'b-o','LineWidth',2);
plot([theta,theta],[0,0.45],'k','LineWidth',2);
xlabel('feature response');
ylabel('frequency');

%% MakeFeaturePic
fpic = MakeFeaturePic([4,5,5,5,5],19,19);
figure;
imagesc(fpic);
colormap(gray);

%% MakeClassifierPic

cpic = MakeClassifierPic(all_ftypes, [5192, 12765], [1.8725,1.467],[1,-1],19,19);
figure;
imagesc(cpic);
colormap(gray);


%% Boosting Algorithm
close all
profile on
Cparams = BoostingAlg(Fdata,NFdata,FTdata,3);
profile viewer
%%
% Display features
iis={};
for i=1:size(Cparams.Thetas,1)
   j = Cparams.Thetas(i,1);
   ftype = Cparams.all_ftypes(j,:);
   iis{i} =MakeFeaturePic(ftype,19,19);
end
montage(iis);
% Display classifier
figure;
classifier = MakeClassifierPic(Cparams.all_ftypes,...
                               Cparams.Thetas(:,1),...
                               Cparams.alphas, ones(size(Cparams.alphas)), 19, 19);
imagesc(classifier);
colormap(gray);

%% Boosting algorithm. Debug point

dinfo6 = load('DebugInfo/debuginfo6.mat');
T = dinfo6.T;
Cparams = BoostingAlg(Fdata,NFdata,FTdata,T);

eps = 1e-6;
s1 = sum(abs(dinfo6.alphas - Cparams.alphas));
s2 = sum(abs(dinfo6.Thetas(:) - Cparams.Thetas(:)));

if s1>eps || s2>eps
    disp('Test 8. Boosting Algorihm...FAIL');
else
    disp('Test 8. Boosting Algorihm...OK');
end

%% Boosting algorithm. All features
close all
dinfo7 = load('DebugInfo/debuginfo7.mat');
T = dinfo7.T;

Cparams = BoostingAlg(Fdata,NFdata,FTdata,T);

%% Boosting algorithm. Profile
close all;
profile on; profile clear;
T = 10;
BoostingAlg(Fdata,NFdata,FTdata,10);
profile viewer;

%% Display features
im_classifiers = {};
for i=1:size(Cparams.Thetas,1)
   j = Cparams.Thetas(i,1);
   ftype = Cparams.all_ftypes(j,:);
   im_classifiers{i}=MakeFeaturePic(ftype,19,19);
end
figure;
montage(im_classifiers);

% Display classifier
figure;
classifier = MakeClassifierPic(Cparams.all_ftypes,...
                               Cparams.Thetas(:,1),...
                               Cparams.alphas, ones(size(Cparams.alphas)), 19, 19);
imagesc(classifier);
colormap(gray);

% Numeric error
eps = 1e-6;
s1 = sum(abs(dinfo7.alphas - Cparams.alphas));
s2 = sum(abs(dinfo7.Thetas(:) - Cparams.Thetas(:)));

if s1>eps || s2>eps
    disp('Test 9. Boosting Algorihm (All features)...FAIL');
else
    disp('Test 9. Boosting Algorihm (All features)...OK');
end

%% ApplyDetector
[~,ii_im] = LoadIm('face00001.bmp');
sc = ApplyDetector(Cparams,ii_im)

if abs(sc - 9.1409) < 1e-4
    disp('Test 10. ApplyDetector...OK');
else
    disp('Test 10. ApplyDetector...FAIL');
end


%% ComputeROC
clc;
ComputeROC(Cparams100,Fdata,NFdata);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ScanImageFixedSize
clc;
im = 'one_chris.png';
Cparams.thresh = 6.5;
profile on, profile clear
dets = ScanImageFixedSize(Cparams,im);
profile viewer
% DisplayDetections
DisplayDetections(im,dets);
fdets = PruneDetections(dets);
DisplayDetections(im,fdets);
%% ScanImageOverScale

im = 'big_one_chris.png';
Cparams2 = Cparams;
Cparams2.thresh = 8;
profile on, profile clear
dets = ScanImageOverScale(Cparams2,im,0.6,1.3,0.06);
profile viewer
% DisplayDetections
DisplayDetections(im,dets);
fdets = PruneDetections(dets);
DisplayDetections(im,fdets);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Train super strong classifier
T = 100;
Cparams100 = BoostingAlg(Fdata,NFdata,FTdata,T); %Takes around 25 minutes!!

%%
%% Other test
close all, clc

dirname = '../Web info/TestImages/';
face_fnames = dir(dirname);

Cparams100_2 = Cparams100;
Cparams100_2.thresh = 28;
smin = 0.01; %0.01
smax = 0.5; %0.5
sstep = 0.01; %0.01
for i=3:length(face_fnames)    
    im =[dirname,face_fnames(i).name];
    fprintf('Processing %s...',i);
    dets = ScanImageOverScale(Cparams100_2,im,smin,smax,sstep);
    DisplayDetections(im,dets);
%     % Prune
%     fdets = PruneDetections(dets);
%     DisplayDetections(im,fdets);
end

%% Special case for "many_faces"
im = 'big_many_faces.jpg';
Cparams100_2 = Cparams100;
Cparams100_2.thresh = 28;
smin = 0.1;
smax = 0.7;
sstep = 0.1;

dets = ScanImageOverScale(Cparams100_2,im,smin,smax,sstep);
DisplayDetections(im,dets);
