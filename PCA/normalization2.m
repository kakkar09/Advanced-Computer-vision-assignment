%% Meldick Reimmer, Danie Sonizara and Selma Boudissa
% Applied Maths project
% PCA - Face recognition
%Date: 15/01/18


function normalised_faces = normalization()

%read the coordinates of feature points
filename = 'dataface.xlsx';
xlrange = 'B2:K51';
fac_loc = xlsread(filename,xlrange); 

%read first face cordinates
F_1 = fac_loc(1,:);
F_1 = vec2mat(F_1,2);
F_bar(:,:,2) = F_1;

%flag to check threshold
flag = true;

while flag
    
    %for first face image
    F_1 = [F_bar(:,:,2) ones(5,1)];
    
    %predetermined locations in 64 x 64 image
    F_x = [13 50 34 16 48]';
    F_y = [20 20 34 50 50]';
    c_1 = pinv(F_1)*F_x;  % to calculate parameters of affine transform
    c_2 = pinv(F_1)*F_y;
    
    A = [c_1(1:2,:) c_2(1:2,:)];
    B = [c_1(3,1) c_2(3,1)]';
    
    F_bar_dash = F_1 * [c_1 c_2]; %new average location in 64 x 64 image
    F_bar(:,:,1) = F_bar_dash;
    F_sum = 0;
    
    %compute for all images
    for img_idx = 1:50
        F_1 = vec2mat(fac_loc(img_idx,:),2);
        F_1 = [F_1 ones(5,1)];
        c_1(:,img_idx) = pinv(F_1) * F_bar(:,1);
        c_2(:,img_idx) = pinv(F_1) * F_bar(:,2);
        F_dash = F_1 * [c_1(:,img_idx) c_2(:,img_idx)];
        
        
        F_sum = F_sum + F_dash;
        
    end
    F_bar(:,:,2) = F_sum/50; %average of aligned feature locations
    error = max(max(abs(F_bar(:,:,2)-F_bar(:,:,1))));
    if  error < 1  % to check error
        flag = false;
    end
end

% After calculating affine transforms we need to apply transform to images
% and save the transformed images to a folder

DatabasePath = './faces_resized/faces/';
savepath = './faces_resized/faces_norm/';
imagefiles = dir('./faces_resized/faces/*.jpg');
nfiles = length(imagefiles);   % Number of files found
for img_idx = 1:nfiles
    
    % read images from directory
    currentfilename_1 = imagefiles(img_idx).name;
    
    currentfilename = strcat(DatabasePath,currentfilename_1);
    currentimage = imread(currentfilename);
    %transformation to grayscale images
    %currentimage = rgb2gray(currentimage);
    images = currentimage;
    
    temp = [0 0 1]';
    tform = maketform('affine',[c_1(:,img_idx) c_2(:,img_idx) temp]);  % affine transform for particular image
    img_upd{img_idx} = imtransform(images,tform,'XData',[1 64],'YData',[1 64]); % transformed image to 64 x 64
    
    %save file to disk
    savefilename = strcat(savepath,currentfilename_1);
   imwrite(img_upd{img_idx},savefilename,'jpg');
    
end

