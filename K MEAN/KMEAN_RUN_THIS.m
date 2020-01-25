% function main
clc;
clear all;
close all;

im = imread('ha.png');
subplot(2,1,1),imshow(im);
subplot(2,1,2),imhist(im(:,:,1));
title('INPUT IMAGE HISTOGRAM');%figure,imhist(im(:,:,2)),title('blue');figure,imhist(im(:,:,3)),title('Green');

figure;
I = imnoise(rgb2gray(im),'salt & pepper',0.02);
subplot(1,2,1),imshow(I);
title('Noise adition and removal using median filter');
K = medfilt2(I);
subplot(1,2,2),imshow(K);


im = double(im);
s_img = size(im);
r = im(:,:,1);
g = im(:,:,2);
b = im(:,:,3);
% [c r] = meshgrid(1:size(i,1), 1:size(i,2));
data_vecs = [r(:) g(:) b(:)];

k= 4;

[ idx C ] = kmeansK( data_vecs, k );
% d = reshape(data_idxs, size(i,1), size(i,2));
% imagesc(d);

palette = round(C);

%Color Mapping
idx = uint8(idx);
outImg = zeros(s_img(1),s_img(2),3);
temp = reshape(idx, [s_img(1) s_img(2)]);
for i = 1 : 1 : s_img(1)
    for j = 1 : 1 : s_img(2)
        outImg(i,j,:) = palette(temp(i,j),:);
    end
end

cluster1 = zeros(size(r));
cluster2 = zeros(size(r));
cluster3 = zeros(size(r));
cluster4 = zeros(size(r));

figure;
cluster1(find(outImg(:,:,1)==palette(1,1))) = 1;
subplot(2,2,1), imshow(cluster1);
cluster2(find(outImg(:,:,1)==palette(2,1))) = 1;
subplot(2,2,2), imshow(cluster2);
cluster3(find(outImg(:,:,1)==palette(3,1))) = 1;
subplot(2,2,3), imshow(cluster3);
cluster4(find(outImg(:,:,1)==palette(4,1))) = 1;
subplot(2,2,4), imshow(cluster4);

cc = imerode(cluster4,[1 1]);
figure,imshow(imerode(cluster4,[1 1]));
title('eroded image');

[label_im, label_count] = bwlabel(cc,8); 
stats = regionprops(label_im, 'centroid');

for i=1:label_count
    area(i) = stats(i).Area;
end

[maxval, maxid] = max(area);

label_im(label_im ~= maxid) = 0;
label_im(label_im == maxid) = 1;

figure,imshow(label_im);
title('tumour');

% outImg = uint8(outImg);
% imtool(outImg);


code_end = 1;