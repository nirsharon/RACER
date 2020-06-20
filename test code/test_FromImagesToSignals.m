% script name: "test_FromImagesToSignals"


clc;
close all;
printit = 1;

%%%%%%%%% prepare stack %%%%%%%%%%

% Load example dataset
load 70S_proj_10_s4     % Example with 10 projection images

% prepare positivity and noise
projections_clean = projections;% - min(projections(:));
sigma = .125 ;
noise_term = sigma*randn(size(projections));
projections = projections_clean + noise_term;

% choose just one
ind = 5;
snr_val = 10^(snr(projections_clean(:,:,ind),noise_term(:,:,ind))/10);
projections = projections - min(projections(:));

%shifted projections
one_projections = projections(:,:,ind);
shift = [15,10];
shiftim                = circshift(one_projections(:,:,1),shift(1));
one_projections(:,:,2) = circshift(shiftim,shift(2),2);

spImg = one_projections(:,:,1:2);
support_size = 61;
centerGrid = zeros(size(spImg));
centerGrid(floor(size(spImg,1)/2),floor(size(spImg,2)/2)) = 1;

L = floor(size(spImg,1)/2);
pre_PSWFs = PrepareProlates(L);

tic
support_signal_new = FromImagesToSignals(spImg, pre_PSWFs);
toc()

if exist('pswf_DC_t_f')   % ...exists under "Old code"
    tic
    [coeffs] = pswf_DC_t_f(spImg, L, 1, 1e-03, 1, []);
    [support_signal] = eval_angular_avg(coeffs, pre_PSWFs );
    toc()
    norm(support_signal - support_signal_new)
end

