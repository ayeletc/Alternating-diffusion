%% Alternating diffusion
function result = alternatingDiffusion(frameMat,ep1,accSample,ep2)
% get matrix of frames with its epsilon and accelerators samples with its epsilon
% return K - the alternating diffusion kernel 

W1 = affinityMatrix(frameMat,ep1);
W2 = affinityMatrixAcc(accSample,ep2);

K1 = W1 ./ sum(W1,1);
K2 = W2 ./ sum(W2,1);

result = K2 * K1;
