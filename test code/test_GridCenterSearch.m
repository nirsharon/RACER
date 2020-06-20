% script name: "test_GridCenterSearch"

clear;

% prepare test images
load('projs.mat');
projs = projs - min(projs(:));          % non-negativity
half_support_size = 17;                 % The radius! (L)
support_size = 2*half_support_size + 1; % diameter of the projection
support = zeros(49);
support(25,25) = 1;
element = imdilate(support, strel('disk', half_support_size) );
spImg = zeros(89);
inner_range = (45-24):(45+24);
spImg(inner_range,inner_range) = projs.*element;

centerGrid = zeros(size(spImg));
jump_range = (half_support_size+1):half_support_size:(size(spImg,1)-half_support_size);
centerGrid(jump_range,jump_range) = 1;

% prepare prolates
PSWF = PrepareProlates(half_support_size);

% prepare weights
x_1d_grid = -half_support_size:1:half_support_size ; 
[x_2d_grid,y_2d_grid]    = meshgrid(x_1d_grid,x_1d_grid);
r_2d_grid_dist           = sqrt(x_2d_grid.^2 + y_2d_grid.^2);
w_vec = zeros(half_support_size+1,1);
w_vec(1) = 1;
for i = 2:(half_support_size+1)
    inds = ( (i-1)<=r_2d_grid_dist )&( r_2d_grid_dist < i );
    w_vec(i) = nnz(r_2d_grid_dist(inds));
end

% test
tic
[res, ValArray] = GridCenterSearch(spImg, support_size, centerGrid, PSWF, w_vec);
t1 = toc()

tic
[res2, ValArray2] = FastGridCenterSearch_PSWFsV2(spImg, support_size, centerGrid, PSWF);
t2 = toc()

[ValArray2(ValArray2~=0), ValArray(ValArray~=0)]
