%% Alternating diffusion
function [K_sym, K_antisym, K_gen] = alternatingDiffusion(frameMat,ep1,accSample,ep2)
% get matrix of frames with its epsilon and accelerators samples with its epsilon
% return [K_sym, K_antisym, K_gen] - the alternating diffusion kernels

W1 = affinityMatrixFrames(frameMat,ep1);
W2 = affinityMatrixAcc(accSample,ep2);

K1 = W1 ./ sum(W1,1);
K2 = W2 ./ sum(W2,1);

K_sym = K1 * K2.' + K2 * K1.';
K_antisym = K1 * K2.' - K2 * K1.';
K_gen = K2 * K1;
