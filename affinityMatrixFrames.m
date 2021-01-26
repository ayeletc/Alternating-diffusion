function [K, ep] = affinityMatrixFrames(samples,eps_factor)
% Calculate the affinity matrix of the frames matrix: s[szx x szy x N], using epislon ep
% szx x szy is the size of a single frame
if ~exist('eps_factor','var')
    eps_factor = 1;
end
szx=size(samples,1); %x of frame
szy=size(samples,2); %y of frame
szn=size(samples,3); %number of frames
    
b = reshape(samples,[szx*szy szn]);
matNorm = zeros(szn);
 for i = 1:szn
     for j = 1: szn
         matNorm(i,j) = vecnorm(b(:, i)-b(:, j));
     end
 end
cFrames = matNorm .^ 2;
ep = median(cFrames(:))/eps_factor;
% ep = 1e7;%8e2;
K = exp(-cFrames / ep);
end