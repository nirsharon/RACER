function [shift, centeredImg, Initial_grid_values] = CenterPyramid(sp_img, pre_PSWFs, weight_vec)
% 
% The main file for the centering scheme --> no FAST pyramid
%
% Input 
% sp_img        -- Single particle image, that is, the frame where the particle is
%
% Output
% shift        -- the shift from the current center
% centeredImg  -- the estimated centered particle
% Initial_grid_values -- the values of centers on the initial grid for
% statistical evaluation in case of outliers
%
% July, 2020

% support_size -- the size of the particle frame (diameter)
L = pre_PSWFs.L;
support_size = pre_PSWFs.L*2+1;

% assert input
assert(nargin>=1,'Not enough input parameters');
assert(nargin>=2,'Run Preprocessing.m');
assert(isnumeric(support_size),'Input of support size is not a numeric type')
assert(numel(support_size)==1,'Input of support size must be scalar')
assert(support_size==abs(round(support_size)),'Input support size must be a positive integer')

% verify image is square
sp_img = sp_img(1:min(size(sp_img,1), size(sp_img, 2)), 1:min(size(sp_img,1), size(sp_img, 2)));
assert(2*L<size(sp_img,1), 'Input image is smaller than the diameter of the particle.');

% make sure the pixel intensity is positive
sp_img = sp_img - min(sp_img(:));

% initial grid size (how many center searches are in the first level)
initial_grid_size = floor((size(sp_img,1)-2*L)/2); %min(21, size(sp_img,1)-2*L);

% prepare initial grid 
centerGrid        = zeros(size(sp_img));
jump_range        = floor(linspace(L+1,size(sp_img,1)-L,initial_grid_size)); % (half_support_size+1):shift_size:(size(currentImg,1)-half_support_size);
current_shift     = jump_range(2) - jump_range(1);
%centerGrid(jump_range,jump_range) = 1;   % sign places to check (potential centers)
% centerGrid(floor(size(sp_img,1)/2)-10:floor(size(sp_img,1)/2)+10, ...
%     floor(size(sp_img,1)/2)-10:floor(size(sp_img,1)/2)+10) = 1;
centerGrid(L+1:end-L, L+1:end-L) = 1;
current_shift = 1;

% run initial search
[current_center, grid_values] = GridCenterSearch(sp_img, support_size, centerGrid, pre_PSWFs, weight_vec);
Initial_grid_values = grid_values;

if pre_PSWFs.remove_outliers
    condition_a = any(current_center==jump_range(1));
    condition_b = any(current_center==jump_range(end));
    if or(condition_a, condition_b)
        shift = inf;
        centeredImg = inf;
        return
    end
end

% refined searches
current_shift = floor(current_shift/2);

% main refinement loop
while current_shift>0

    % define the new centers
    centerGrid  = zeros(size(sp_img));
    jump_rangeX = (current_center(1)-current_shift):current_shift:(current_center(1)+current_shift);
    jump_rangeY = (current_center(2)-current_shift):current_shift:(current_center(2)+current_shift);
    centerGrid(jump_rangeX,jump_rangeY) = 1;
    
    % ignore centers outside the search zone
    centerGrid(1:L, :) = 0; centerGrid(:, 1:L) = 0;
    centerGrid(end:-1:end-(L-1), :) = 0; centerGrid(:, end:-1:end-(L-1)) = 0;
    
    % assign values to the centers
    [current_center, ~] = GridCenterSearch(sp_img, support_size, centerGrid, pre_PSWFs, weight_vec);
    
    % for next iteration
    current_shift = floor(current_shift/2);
    
end

% summary
[n1, n2] = size(sp_img);
shift    = current_center - [floor(n1/2)+1,floor(n2/2)+1];
rangeX   = (current_center(1) - L):(current_center(1) + L);
rangeY   = (current_center(2) - L):(current_center(2) + L);
centeredImg = sp_img(rangeX,rangeY);
end



