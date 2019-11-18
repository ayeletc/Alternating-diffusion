function K = affinityMatrix(samples,ep)
% Calculate the affinity matrix of the frames matrix: s[szx x szy x N], using epislon ep
% szx x szy is the size of a single frame

szx=size(samples,1); %x of frame
szy=size(samples,2); %y of frame
szn=size(samples,3); %number of frames
    
b = reshape(samples,[szx*szy szn]);

 for i = 1:szn
     for j = 1: szn
         matNorm(i,j)= vecnorm(b(i,:)-b(j,:));
     end
 end
 
K = (exp(-(matNorm .^ 2) / ep));
