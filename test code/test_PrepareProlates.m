% script name: " test_PrepareProlates"

clear all
L = 10;

% new code
pp = PrepareProlates(L);

% show result
x_1d_grid = -L:1:L;   % - Odd number of points
[x_2d_grid,y_2d_grid]    = meshgrid(x_1d_grid,x_1d_grid);
r_2d_grid_dist           = sqrt(x_2d_grid.^2 + y_2d_grid.^2);
points_inside_the_circle = (r_2d_grid_dist <= L);
x = x_2d_grid(points_inside_the_circle);
y = y_2d_grid(points_inside_the_circle);

%visualize
figure;
n = min([9,size(pp.samples,2) ] );
ns = ceil(sqrt(n));
for i=1:ns^2
    subplot(ns,ns,i);
    current_p = zeros(2*L+1);
    current_p(points_inside_the_circle) = pp.samples(:,i);
    imagesc(current_p);
    if i ~= (ns^2 - ns + 1)
      set(gca,'XTick',[]);
      set(gca,'YTick',[]);
    end 
end

% original code, if in path
%if exist
