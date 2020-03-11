function result = patchHitmap(framesMat, s0, N, imuStr, NpatchX, NpatchY)
% N0 - initial sample
% N - number of samples
% NpatchX - number of rows in the new frame
% NpatchY - number of columns in the new frame
%% Load IMU
accSamples = load(imuStr);
accSamples = accSamples(s0+1:s0+N, :,:, :);
accSamples = accSamples(:, 2:4);
[W2, ep2] = affinityMatrixAcc(accSamples);
K2 = W2 ./ sum(W2,1);

%% Calculate Patches Frobenius Norm
sx = size(framesMat, 1) / NpatchX;
sy = size(framesMat, 2) / NpatchY;

froNorm = zeros(NpatchX ,NpatchY);
for ix = 1:NpatchX
    for iy = 1:NpatchY
        patchMat = framesMat(1+(ix-1)*sx:ix*sx, 1+(iy-1)*sy:iy*sy,:);
        [W1, ep1] = affinityMatrixFrames(patchMat);
        K1 = W1 ./ sum(W1,1);
        
%         K_sym = K1 * K2.' + K2 * K1.';
%         K_antisym = K1 * K2.' - K2 * K1.';
        K = K2 * K1;
        
        froNorm(ix, iy) = norm(K); % Euclidean norm
        froNorm(ix, iy) = norm(K , 'fro'); % Frobenius norm
%         froNorm(ix, iy) = norm(cov(K) , 'fro'); % covariance        
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
