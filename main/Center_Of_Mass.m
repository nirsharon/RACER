function [p] = Center_Of_Mass(A)
% A simple implementation of CoM calculation over an image A
%
% Input
% A -- an image (2D array), pixels over regular grid
% Ouput
% p -- the coordinates of the CoM
%
% NS, Jan 19

% get the size of the image and its central pixel
[sx , sy] = size(A);
central_pixel = [floor(sx/2)+1, floor(sy/2)+1];

% main loop
total_energy = sum(sum(abs(A))); % to average the intensities
relative_CoM = 0;
for j=1:length(A(:))   
    [ind1,ind2]  = ind2sub([sx sy],j);
    pixel_vec    = ([ind1,ind2]-central_pixel); % relative location
    relative_CoM = relative_CoM + pixel_vec*A(j)/total_energy;
end

% a summary
p = round(relative_CoM) + central_pixel;
p = fliplr(p);      % NOTE -- a recent change
end

