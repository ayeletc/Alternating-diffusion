function [K, epAcc] = affinityMatrixAcc(accSamples,eps_factor)
% get the accelerators samples (size Nx3 for x,y,z)
% return the affinity Mat of the accelarators data 
if ~exist('eps_factor','var')
    eps_factor = 1;
end
szx = size(accSamples,2); % x of frame
szn = size(accSamples,1); % number of frames

 for i = 1:szn
     for j = 1: szn
         matNorm(i,j)= vecnorm(accSamples(i,:)-accSamples(j,:));
%         matNorm(i,j)= abs(vecnorm(accSamples(i,:))-vecnorm(accSamples(j,:)));
     end
 end

cAcc = matNorm .^ 2;
epAcc = median(cAcc(:))/eps_factor;
% epAcc = 1;%5e-3;
K = exp(-cAcc / epAcc);
end
    

