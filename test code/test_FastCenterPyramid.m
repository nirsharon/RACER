% script name: "test_FastCenterPyramid"
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

% preprocessing
PSWF       = PrepareProlates(floor(res/2)); 
weight_vec = PrepareWeightVec(floor(res/2));
% ================================
trans = [5,15];
current_img = imtranslate(gt_im,-trans);

com = Center_Of_Mass(current_img);
com = com - (floor(size(current_img,1)/2)+1);

[shift, cIm] = FastCenterPyramid(current_img, res, PSWF, weight_vec);
x = shift(1); y = shift(2);
fprintf('Clean test: true CoM is (%d, %d) and estimation is (%d, %d) \n', ...
    com(1), com(2), y, x);

trans = [9,-8];
sigma = .1;
noise_term = sigma*randn(size(gt_im));
current_img = imtranslate(gt_im,-trans);
com = Center_Of_Mass(current_img);
com = com - (floor(size(current_img,1)/2)+1);

current_img = current_img + noise_term;
[shift, cIm] = FastCenterPyramid(current_img, res, PSWF, weight_vec);
x = shift(1); y = shift(2);
fprintf('Noisy test: true CoM is (%d, %d) and estimation is (%d, %d) \n', ...
    com(1), com(2), y, x);

