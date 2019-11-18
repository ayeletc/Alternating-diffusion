function K = affinityMatrixAcc(accSamples,ep)
% get the accelerators samples (size Nx3 for x,y,z)
% return the affinity Mat of the accelarators data 

szx = size(accSamples,2); % x of frame
szn = size(accSamples,1); % number of frames

 for i = 1:szn
     for j = 1: szn
         matNorm(i,j)= vecnorm(accSamples(i,:)-accSamples(j,:));
     end
 end
 
K = (exp(-(matNorm .^ 2) / ep));
