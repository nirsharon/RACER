function[res, ValArray] = GridCenterSearch(spImg, support_size, centerGrid, pre_PSWFs, confidence_vec)
% 
% We check potential centers in "centerGrid" using prolates respresentation
%
% Input 
% spImg        -- Single particle image
% support_size -- the diameter of the particle support
% centerGrid   -- binary grid of the size of "spImg" for indicating
%                 possible centers
% pre_PSWFs    -- structure that includes the prolates basis functions
%
% Output
% res         -- the grid location with "best" centering
% ValArray    -- size of "centerGrid" with the values according to
%                "criterion"
%
% Jan 4, 2019

% basic parameters
N            = nnz(centerGrid(:));
[IndX, IndY] = find(centerGrid);
ValArray     = zeros(size(centerGrid));

% crop the big pic to a stack of images with different centers
imStack = zeros(support_size,support_size,N);
for j=1:N
    
    % setting the current center and image boundaries
    current_center = [IndX(j), IndY(j)]; 
    rangeX = (current_center(1)-floor(support_size/2) ):(current_center(1)+ceil(support_size/2)-1);
    rangeY = (current_center(2)-floor(support_size/2) ):(current_center(2)+ceil(support_size/2)-1);
    
    % cropoing the image sccording to the center
    imStack(:,:,j) = spImg(rangeX,rangeY);
end

% angular averaging
support_signal = FromImagesToSignals(imStack, pre_PSWFs);

% adding weights and accumulate the sum
%one = ones(size(imStack,1));
if nargin<5
    confidence_vec = ones(size(support_signal,1),1);
end

w_support_signal = support_signal.*repmat(confidence_vec,1,size(support_signal,2));
support_signal = w_support_signal; %cumsum(w_support_signal,2);  % pretty sure it was missing. DEBUG.

% scoring according to the criterion
ValArray(sub2ind(size(centerGrid),IndX, IndY)) = stack_score(support_signal);

% a summary
[~, ind] = min(ValArray(sub2ind(size(ValArray),IndX, IndY)));
res      = [IndX(ind), IndY(ind)];

end