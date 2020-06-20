% script name: "test_Center_Of_Mass"
clear;

I=imread('cameraman.tif');
res = 21;
I_center = floor(res/2);
ref_im = imresize(double(I),[res,res])/255;

im_size = 61;
im_center = floor(im_size/2)+1;
gt_im = zeros(im_size);
I_range = (im_center-I_center):(im_center+I_center);
gt_im(I_range,I_range) = ref_im;

trans = [0,0];
current_img = imtranslate(gt_im,trans) ;
[p] = Center_Of_Mass(current_img);
figure; imagesc(current_img); 
hold on; plot(p(1),p(2),'rx','LineWidth',10,'MarkerSize',10)

sigma = .1;
noise_im = sigma*randn(size(gt_im));
%mean(mean(noise_im))
[pn] = Center_Of_Mass(noise_im);
figure; imagesc(noise_im); 
hold on; plot(pn(1),pn(2),'bx','LineWidth',10,'MarkerSize',10)

trans = [5,15];
current_img = imtranslate(gt_im,trans);
[p] = Center_Of_Mass(current_img);
figure; imagesc(current_img); 
hold on; plot(p(1),p(2),'rx','LineWidth',10,'MarkerSize',10)

current_img = imtranslate(gt_im,trans);
[p] = Center_Of_Mass(current_img+noise_im);
figure; imagesc(current_img+noise_im); 
hold on; plot(p(1),p(2),'bx','LineWidth',10,'MarkerSize',10)

