function [difFromImpulse] = stack_score(signal)
% Return the score according to the EMD
% Input
%  signal -- 2D array: stack of accumulated energy functions (along the
%  radial direction)
% Output
%  difFromImpulse -- Earth Moving Distance (EMD) from a centered pulse
%
% October 24, 2018


signal = bsxfun(@rdivide, signal, max(signal(:)) );
% ============= L2 ===================
% difFromImpulse = sum((signal - ones(size(signal))).^2, 1);
% ============= L1 ===================
difFromImpulse = sum(abs(signal - ones(size(signal))), 1);

% -- distance to uniform instead of to delta --
% uniform = cumsum(ones(size(signal)))/size(signal, 1);
% difFromUniform = sum((signal - uniform).^2, 1);

end

