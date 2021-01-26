function result = patchHeatmap(framesMat, s0, N, imuStr, NpatchX, NpatchY,eps_factor_acc,eps_factor_frame)
if ~exist('eps_factor_acc', 'var')
    eps_factor_acc = 1;
end
if ~exist('eps_factor_frame', 'var')
    eps_factor_frame = 1;
end
% N0 - initial sample
% N - number of samples
% NpatchX - number of rows in the new frame
% NpatchY - number of columns in the new frame
%% Load IMU
accSamples = load(imuStr);
accSamples = accSamples(s0+1:s0+N, :,:, :);
% accSamples(:,2:3) = 0; % TODO raise!!!

% accSamples = accSamples(:, 2:4); % real video
% accSamples = accSamples(:, :); %simulation
[W2, ep2] = affinityMatrixAcc(accSamples,eps_factor_acc);
K2 = W2 ./ sum(W2,1);

%% Calculate Patches Frobenius Norm
sx = size(framesMat, 1) / NpatchX;
sy = size(framesMat, 2) / NpatchY;

froNorm = zeros(NpatchX ,NpatchY);
for ix = 1:NpatchX
    for iy = 1:NpatchY
        patchMat = framesMat(1+(ix-1)*sx:ix*sx, 1+(iy-1)*sy:iy*sy,:);
        [W1, ep1] = affinityMatrixFrames(patchMat,eps_factor_frame);
        K1 = W1 ./ sum(W1,1);
        
%         K = K1 * K2.' + K2 * K1.'; %sym
%         K_antisym = K1 * K2.' - K2 * K1.';
        K = K2 * K1;
        
        froNorm(ix, iy) = norm(K , 'fro');
%         froNorm(ix, iy) = norm(cov(K) , 'fro');
%         temp = sqrt((log(eigs(K1, K2).^2)));
%         froNorm(ix, iy) = abs(sum(temp(2:end)));
%         if(isinf(froNorm(ix, iy)))
%            print(2)
%         end
        
    end
end
result = froNorm;

%% 
if 0
%% load video
N = 1000;
s0 = 22.5 * 60 * 20;

file = ['Data' filesep 'videos' filesep 'day1_cam1_2230_2430_bw.mp4'];
framesMat = frameExtractor(file, N);

%%
result = patchHitmap(framesMat, s0, N, 14, 6, 8)

%%
fr = uint8(framesMat(:,:, 1));
im = 1e3 * (imresize(result,[540,960]) - median(result(:)));
numberOfRows = 256; 
myColorMap = jet(numberOfRows);
fr = ind2rgb(fr,myColorMap);
fr(:,:,1) = im;
fr(:,:,2) = 0;
imshow(fr)
%%
fr = uint8(framesMat(:,:, 1));
im = 1e3 * (imresize(result,[540,960]) - median(result(:)));
figure;
imshow(im,[]);
Ffr = im .* fftshift(fft2(fr));
figure;
transformed = real(ifft2(fftshift(Ffr)));
imshow(max(transformed)-transformed ,[]);
end