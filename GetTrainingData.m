function GetTrainingData(all_ftypes,np,nn)
% Gets training data for both faces and non-faces,
% and saves them into corresponding files
% 
% Inputs: all_ftypes: features to use
%         np: number of face images
%         nn: number of non-face images
% 
% Author: Carlos Gálvez del Postigo Fernández.

LoadSaveImData('../Web info/TrainingImages/FACES/',np,'FaceData');
LoadSaveImData('../Web info/TrainingImages/NFACES/',nn,'NonFaceData');

ComputeSaveFData(all_ftypes,'FeaturesToUse');

end

