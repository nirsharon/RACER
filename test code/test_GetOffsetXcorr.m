% script name: "test_GetOffsetXcorr"
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

% ================================
trans = [5,15];
current_img = imtranslate(gt_im,-trans);
[x, y] = GetOffsetXcorr(current_img, ref_im);
fprintf('Clean test: true shift is (%u, %u) and estimation is (%u, %u) \n', ...
    trans(1), trans(2), x, y);

trans = [9,-8];
sigma = 1;
noise_term = sigma*randn(size(gt_im));
current_img = imtranslate(gt_im,-trans) + noise_term;
[x, y] = GetOffsetXcorr(current_img, ref_im);
fprintf('Noisy test: true shift is (%u, %u) and estimation is (%u, %u) \n', ...
    trans(1), trans(2), x, y);

