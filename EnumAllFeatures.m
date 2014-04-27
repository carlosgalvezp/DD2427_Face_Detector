function all_ftypes = EnumAllFeatures(W,H)
% Enumerates all the features.
% 
% Inputs: (W,H): size of the image
% 
% Outputs: all_ftypes. nf x 5, where each row:
%          [type, x, y, w, h]
%          
% Author: Carlos Gálvez del Postigo Fernández

%% Pre-allocate 
all_ftypes = zeros(100000,5);
p = 0; % Pointer to position in all_ftypes

%% Enumerate
% Type I
disp('Enumerating Features I...');
for w = 1:W
    for h = 1:floor(H/2)
        for x = 1:W-w
            for y = 1:H-2*h
                c = BoxCheck(x,y,w,h,W,H);
                if c
                    p = p+1;
                    all_ftypes(p,:) = [1,x,y,w,h];
                end
            end
        end
    end
end

% Type II
disp('Enumerating Features II...');
for w = 1:floor(W/2)
    for h = 1:H
        for x = 1:W-2*w
            for y = 1:H-h
                c = BoxCheck(x,y,w,h,W,H);
                if c                    
                    p = p+1;
                    all_ftypes(p,:) = [2,x,y,w,h];
                end
            end
        end
    end
end

% Type III
disp('Enumerating Features III...');
for w = 1:floor(W/3)
    for h = 1:H
        for x = 1:W-3*w
            for y = 1:H-h
                c = BoxCheck(x,y,w,h,W,H);
                if c
                    p = p+1;
                    all_ftypes(p,:) = [3,x,y,w,h];                    
                end
            end
        end
    end
end

% Type IV
disp('Enumerating Features IV...');
for w = 1:floor(W/2)
    for h = 1:floor(H/2)
        for x = 1:W-2*w
            for y = 1:H-2*h
                c = BoxCheck(x,y,w,h,W,H);
                if c                    
                    p = p+1;
                    all_ftypes(p,:) = [4,x,y,w,h];
                end
            end
        end
    end
end

%% Trim array
all_ftypes = all_ftypes(1:p,:);
fprintf('Total number of features: %d\n',p);
end

