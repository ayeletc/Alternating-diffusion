function result = testPHATE_4speakers(N, id1, id2, eigenVectors, dim)
speakerLabels = load(['Data' filesep 'CSVs' filesep 'speakers' num2str(id1) '_' num2str(id2) '.csv']);
speakerLabels = speakerLabels';
speakerLabels = speakerLabels(1:N);

Y = phate(real(eigenVectors), 't', 20, 'ndim', dim);

figure;
scatter(Y(:,1),Y(:,2), 300, speakerLabels, '.');
title(['PHATE for spekers' num2str(id1) ', ' num2str(id2) ' colored by speaking labels']);
xlabel('$$ phate_1 $$','fontsize',16,'interpreter','latex');
ylabel('$$ phate_2 $$','fontsize',16,'interpreter','latex');
grid on
colormap([0 0 0;
         1 0 0;
         0 1 0
         0 0 1]);
colorbar;

result = Y;

if 0
%% TEST 1:
% video: 'day1_cam1_2230_2430_bw.mp4'
% acc: 'day1_subject25.csv', 'day1_subject28.csv'
% from day 1 camera 1, minutes 22:30 - 24:30
% speakers: 25 & 28 & 17 & 19

N = 100;
Nx = 540;
Ny = 960;

file = ['Data' filesep 'videos' filesep 'day1_cam1_2230_2430_bw.mp4'];
framesMat = frameExtractor(file, N, Nx, Ny);
ep1 = 0.03;
ep2 = 0.03;

acc25 = load(['Data' filesep 'CSVs' filesep 'day1_subject25.csv']);
accSamples25 = acc25(27000:27000+N-1, :,:, :);
accSamples25 = accSamples25(:, 2:4);
acc28 = load(['Data' filesep 'CSVs' filesep 'day1_subject28.csv']);
accSamples28 = acc28(27000:27000+N-1, :,:, :);
accSamples28 = accSamples28(:, 2:4);

[K_sym_25, K_antisym_25, K_25] = alternatingDiffusion(framesMat,ep1,accSamples25,ep2);
K_25 = diffusionMaps(K_25, ep2);
[V25,D25] = eig(K_25);
D25 = diag(D25);
[K_sym_28, K_antisym_28, K_28] = alternatingDiffusion(framesMat,ep1,accSamples28,ep2);
K_28 = diffusionMaps(K_28, ep2);
[V28,D28] = eig(K_28);
D28 = diag(D28);

V = [V25(:, 2:4), V28(:, 2:4)];

testPHATE_4speakers(N, 25, 28, V, 2);
%%
%% TEST 2:
% video: 'day1_cam1_2230_2430_bw.mp4'
% acc: 'day1_subject14.csv', 'day1_subject32.csv'
% from day 1 camera 1, minutes 22:30 - 24:30
% speakers: 14 & 32

N = 2000;
N0 = 22.5 * 60 * 20;

file = ['Data' filesep 'videos' filesep 'day1_cam1_2230_2430_bw.mp4'];
framesMat = frameExtractor(file, N);
ep1 = 0.03;
ep2 = 0.03;

acc14 = load(['Data' filesep 'CSVs' filesep 'day1_subject14.csv']);
accSamples14 = acc14(N0+1:N0+N, :,:, :);
accSamples14 = accSamples14(:, 2:4);
acc32 = load(['Data' filesep 'CSVs' filesep 'day1_subject32.csv']);
accSamples32 = acc32(N0+1:N0+N, :,:, :);
accSamples32 = accSamples32(:, 2:4);

[K_sym_14, K_antisym_14, K_14] = alternatingDiffusion(framesMat,ep1,accSamples14,ep2);
K_14 = diffusionMaps(K_14, ep2);
[V14,D14] = eig(K_14);
[K_sym_32, K_antisym_32, K_32] = alternatingDiffusion(framesMat,ep1,accSamples32,ep2);
K_32 = diffusionMaps(K_32, ep2);
[V32,D32] = eig(K_32);

V = [V14(:, 2:4), V32(:, 2:4)];

testPHATE_4speakers(N, 14, 32, V, 2);
end