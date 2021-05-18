% script name: "run_simple_example_ANCHOR"
%
% This script introduces a simple example for how to run the ANCHOR
%
% August 7, 2019

% initiate path
add_path
clear; clc; 

% data setting
load('shifted_70S_proj_10_s4.mat'); % including projections and their shifts
N       = size(shifted_projections,1);
support = 91;                % the estimated diameter of the particle's projection
r       = floor(support/2);  % the radius

% preprocessing
[PSWF, weight_vec] = Preprocess(r);    % the basis functions and a weight vector for the angular averaging

% call main file
fprintf('Start simple example...');
choosen_im = shifted_projections(:,:,7);
tic
[est_shifts, cIm] = CenterPyramid(choosen_im, PSWF, weight_vec);
%[est_shifts, cIm] = FastCenterPyramid(choosen_im, PSWF, weight_vec);
tt = toc();

% the result
pn = Center_Of_Mass(cIm);
figure;
imagesc(choosen_im); title('Original image');
figure; 
imagesc(cIm); title('The output, with CoM marked');
hold on; plot(pn(1),pn(2),'bx','LineWidth',10,'MarkerSize',10);
fprintf('done in about %f seconds \n', tt);




