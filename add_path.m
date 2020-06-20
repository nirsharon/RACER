% script name: "add_path"
% Setting the path for ANCHOR
%
fprintf('Adding path: \n');

addpath(genpath('Main'));
addpath(genpath('Prolates generating code'));
addpath(genpath('test code'));
addpath(genpath('simple_example'));

x = input('Do you need to make figures? press ''y'' for yes \n','s');
if strcmp(x, 'y')
    addpath(genpath('Make figures'));
    addpath(genpath('cc'));
    fprintf(' "/Make figures" is added \n');
end

fprintf('Done! \n');

