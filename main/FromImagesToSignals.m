function [signal_stack] = FromImagesToSignals(images, PSWFs)
% This function execute the prolates tranform and forming the angular
% averaged images. Then, it chooses a radius from the image to sample as the 1D radial signal
%
% Input
%  images -- stack of images
%  PSWFs  -- a structure of the prolate basis functions
%  
% Output
%  signal_stack -- the stack of the associated 1D signals
%
% Jan, 4, 2019

%% Generating regular grid and basis functions (if needed)
L         = PSWFs.L;
x_1d_grid = -L:1:L ;   % - Odd number of points
[x_2d_grid,y_2d_grid]    = meshgrid(x_1d_grid,x_1d_grid);
r_2d_grid_dist           = sqrt(x_2d_grid.^2 + y_2d_grid.^2);
points_inside_the_circle = (r_2d_grid_dist <= L);

%% computing expansion coefficients
nImages  = size(images,3);
images_c = reshape(images,size(images,1)*size(images,2),nImages); % Reshape from 3d array to a matrix
images_c = images_c(points_inside_the_circle(:),:);               % Take points inside the unit disk
coeffs   = PSWFs.samples' * images_c;    % can theoretically achieve better complexity here


%% finding the indices of the hand (the 1D radial signal) in samples
hand = (y_2d_grid>=0)&(x_2d_grid==0); % arbitrary chosen as the "six o'clock"
supp = zeros(2*L+1,2*L+1);
supp(points_inside_the_circle) = 1;
supp(supp~=0) = 1:nnz(supp);
ind_hand      = supp(hand);

%% getting the values along the hand
signal_stack = PSWFs.samples(ind_hand,:)*coeffs;

end

