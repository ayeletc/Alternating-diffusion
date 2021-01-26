function result = testTSNE_4speakers(id, eigenVectors, V1id, V2id, perplexity)
% Plots - eigen values colored by speaking (manual labeling) - speaker 25
% 2 eigen vectors in comparison to TSNE 
speakerLabels = load(['Data' filesep 'CSVs' filesep 'speaker' num2str(id) '.csv']);
speakerLabels = speakerLabels(:);

meas = real(eigenVectors(:, 2:10));
Y = tsne(meas, 'Perplexity', perplexity);

figure;
subplot(1,2,1)
scatter(eigenVectors(:,V1id),eigenVectors(:,V2id),300, speakerLabels, '.');
title(['V_' num2str(V1id) ', V_' num2str(V2id) ' colored by speaker_{' num2str(id) '} speaking labels']);
xlabel(['$$V_' num2str(V1id) '$$'],'fontsize',16,'interpreter','latex');
ylabel(['$$V_' num2str(V2id) '$$'],'fontsize',16,'interpreter','latex');
grid on
colormap([1 0 0;
          0 1 0 ]);
colorbar;

subplot (1,2,2)
scatter(Y(:,1),Y(:,2),300, speakerLabels, '.');
title(['TSNE colored by speaker_{' num2str(id) '} speaking labels']);
xlabel('$$X_{TSNE}$$','fontsize',16,'interpreter','latex');
ylabel('$$Y_{TSNE}$$','fontsize',16,'interpreter','latex');
grid on
colormap([1 0 0;
          0 1 0 ]);
colorbar;

result = Y;

if 0
%% TEST:
% video: 'day1_cam1_2230_2430_bw.mp4'
% acc: 'day1_subject25.csv', 'day1_subject28.csv'
% from day 1 camera 1, minutes 22:30 - 24:30
% speakers: 25 & 28 & 17 & 19
N = 300;
file = ['Data' filesep 'videos' filesep 'day1_cam1_2230_2430_bw.mp4'];
framesMat = frameExtractor(file, N);
ep1 = 0.03;
ep2 = 0.03;

acc25 = load(['Data' filesep 'CSVs' filesep 'day1_subject25.csv']);
[K_sym_25, K_antisym_25, K_25] = alternatingDiffusion(framesMat,ep1,accSamples25,ep2);
K_25 = diffusionMaps(K_25, ep2);
[V25,D25] = eig(K_25);
D25 = diag(D25);
%%
testTSNE_4speakers(25, V25, 2, 4, 20);
end