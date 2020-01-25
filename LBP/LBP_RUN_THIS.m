clear all;

% load image
img = rgb2gray(imread('ha.png'));

% run descriptor
filtered_img = lbp(img);

% plot results
subplot(1,2,1);
imshow(img);
subplot(1,2,2);
imshow(filtered_img);
