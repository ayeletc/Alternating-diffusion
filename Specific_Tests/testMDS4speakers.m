file = ['Data' filesep 'videos' filesep 'day1_cam1_2230_2430_bw.mp4'];
N = 300;
framesMat = frameExtractor(file, N, 540, 960);
labels = load(['Data' filesep 'CSVs' filesep 'labels.csv']);
ep1 = 1e7;
ep2 = 1;
speaker28 = load(['Data' filesep 'CSVs' filesep 'speaker28.csv']);
speaker28 = speaker28(:);

acc28 = load(['Data' filesep 'CSVs' filesep 'day1_subject28.csv']);
accSamples28 = acc28(27000:27000+N-1, :,:, :);
accSamples28 = accSamples28(:, 2:4);

W1_28 = -log(affinityMatrixFrames(framesMat));
W2_28 = -log(affinityMatrixAcc(accSamples28));

K1_28 = cmdscale(W1_28, 1);
K2_28 = cmdscale(W2_28, 1);


K_28_sym = K1_28 * K2_28.' + K2_28 * K1_28.';
K_28_antisym = K1_28 * K2_28.' - K2_28 * K1_28.';
K_28_gen = K2_28 * K1_28';

[V_28_1,D_28_1] = eig(K_28_sym);
[V_28_2,D_28_2] = eig(K_28_antisym);
[V_28_3,D_28_3] = eig(K_28_gen);
%%
figure('Name', 'V1, V2 colored by speaker28 labels');
subplot(2,2,1);
scatter(V_28_1(:,2),V_28_1(:, 3), 500 ,speaker28, '.');
xlabel('$$ V_1 $$','fontsize',16,'interpreter','latex');
ylabel('$$ V_2 $$','fontsize',16,'interpreter','latex');
title('$$ K1_{28} \cdot K2^T_{28} + K2_{28} \cdot K1^T_{28} $$', 'interpreter', 'latex');
grid on;
subplot(2,2,2);
scatter(real(V_28_2(:,2)),real(V_28_2(:, 3)), 500 ,speaker28, '.');
xlabel('$$ V_1 $$','fontsize',16,'interpreter','latex');
ylabel('$$ V_2 $$','fontsize',16,'interpreter','latex');
title('$$ K1_{29} \cdot K2^T_{28} - K2_{28} \cdot K1^T_{28} $$', 'interpreter', 'latex');
grid on;
subplot(2,2,3);
scatter(V_28_3(:,2),V_28_3(:, 3), 500 ,speaker28, '.');
xlabel('$$ V_1 $$','fontsize',16,'interpreter','latex');
ylabel('$$ V_2 $$','fontsize',16,'interpreter','latex');
title('$$ K2_{28} \cdot K1_{28} $$', 'interpreter', 'latex');
grid on;


