function fdets = PruneDetections(dets)
% It detects overlapping detections and fuses them
% into a single detection per face.
% 
% Inputs: dets: raw detections (ndx4)
% Outputs: filtered detections (Nx4)
% 
% Author: Carlos G�lvez del Postigo Fern�ndez

nd = size(dets,1);
D = zeros(nd,nd);

rho = 0.5;
% Check overlapping regions
for i=1:nd
    for j=i:nd     
        d1 = dets(i,:);
        d2 = dets(j,:);
        same = (rectint(d1,d2)/(max(d1(3)*d1(4),...
                                   d2(3)*d2(4))))>rho;
        D(i,j) = same;
        D(j,i) = same;
    end
end

% Find connected components
[S,C] = graphconncomp(sparse(D));

% Create new dets
fdets = zeros(S,4);
for i=1:S
    fdets(i,:) = mean(dets(C==i,:),1); %Take the average of them    
end
end

