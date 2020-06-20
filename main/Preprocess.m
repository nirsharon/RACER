function [PSWFs, w_vec] = Preprocess(L)
% A function to generate the 2D prolates functions of zero
% angular frequency and calculates a vector of weights to be assigned to
% every ring, according to the number of pixels it contains.
% A variant of @Boris Landa code.
%
% Input
% L -- Image resolution, assume our image is of (2*L+1)X(2*L+1)
%
% Output
% PSWFs -- A struct which contains the PSWFs with their generation parameters, specifically:
%             samples:    PSWF basis functions, samplned on the Cartesian grid inside the unit disk. Columns correspond to different indices. 
%             Alpha_Nn:   PSWF associated eigenvalues.
%             ang_freq:   Angular frequency ('N' indices) of the PSWFs.
%             rad_freq:   Radial frequency ('n' indices) of the PSWFs.
% w_vec -- the weight vector

x_1d_grid = -L:1:L;   % - Odd number of points
[x_2d_grid,y_2d_grid]    = meshgrid(x_1d_grid,x_1d_grid);
r_2d_grid_dist           = sqrt(x_2d_grid.^2 + y_2d_grid.^2);
points_inside_the_circle = (r_2d_grid_dist <= L);
x = x_2d_grid(points_inside_the_circle);
y = y_2d_grid(points_inside_the_circle);

% filling the structure
T = 1e-3;    % Truncation parameter
[PSWFs.samples, PSWFs.alpha_Nn, PSWFs.ang_freq, PSWFs.rad_freq ] = PSWF_gen_DC( L+1, L, 1, eps, T, x, y );
PSWFs.L = L;
PSWFs.beta = 1; % Bandlimit ratio
PSWFs.T = T;

% query users
fprintf('Preprocessing: \n');
x = input('Remove potential outliers? press ''y'' for faster reconstrunction, ''n'' for better resolution (recommended)  \n','s');
if strcmp(x, 'y')
    PSWFs.remove_outliers = true;
else
    PSWFs.remove_outliers = false;
end

w_vec    = zeros(L+1,1);
w_vec(1) = 1;

for j = 2:(L+1)
    inds = ( (j-1)<=r_2d_grid_dist )&( r_2d_grid_dist < j );
    w_vec(j) = nnz(r_2d_grid_dist(inds));
end
fprintf('Done! \n');
end

