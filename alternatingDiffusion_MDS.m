clear
close all

% Data:
% 1) lack of data
% file: '2330_2500.mp4'
% from day 3 camera 3, minutes 23:30-25:00
% speakers: 8 & 24

% 2)
% file: '2000_2200.mp4'
% from day 3 camera 3, minutes 20:00 - 22:00
% speakers: 11 & 35

% 3)
% video: '2000_2200.mp4'
% acc: 'day3_subject3.csv', 'day3_subject29.csv'
% from day 3 camera 3, minutes 20:00 - 22:00
% speakers: 3 & 29
% 
% N = 2000;
N = 300;  % (20 fps)

% file = '2330_2500.mp4';
file = ['Data' filesep 'videos' filesep '2000_2200.mp4'];
framesMat = frameExtractor(file, N);
labels = load(['Data' filesep 'CSVs' filesep 'labels.csv']);
speaker29 = load(['Data' filesep 'CSVs' filesep 'speaker29.csv']);
speaker29 = speaker29(:);


ep1 = 1e7;
ep2 = 1;


%% Alternative Diffussion - 29

acc29 = load(['Data' filesep 'CSVs' filesep 'day3_subject29.csv']);
acc1Samples29 = acc29(24000:24000+N-1, :,:, :);
acc1Samples29 = acc1Samples29(:, 2:4);

W1_29 = -log(affinityMatrixFrames(framesMat,ep1));
W2_29 = -log(affinityMatrixAcc(acc1Samples29,ep2));

K1_29 = cmdscale(W1_29, 1);
K2_29 = cmdscale(W2_29, 1);


K_29_sym = K1_29 * K2_29.' + K2_29 * K1_29.';
K_29_antisym = K1_29 * K2_29.' - K2_29 * K1_29.';
K_29_gen = K2_29 * K1_29';

[V_29_1,D_29_1] = eig(K_29_sym);
[V_29_2,D_29_2] = eig(K_29_antisym);
[V_29_3,D_29_3] = eig(K_29_gen);


%%
figure('Name', 'V1, V2 colored by speaker29 labels');
subplot(2,2,1);
scatter(V_29_1(:,2),V_29_1(:, 3), 500 ,speaker29, '.');
xlabel('$$ V_1 $$','fontsize',16,'interpreter','latex');
ylabel('$$ V_2 $$','fontsize',16,'interpreter','latex');
title('$$ K1_{29} \cdot K2^T_{29} + K2_{29} \cdot K1^T_{29} $$', 'interpreter', 'latex');
grid on;
subplot(2,2,2);
scatter(real(V_29_2(:,2)),real(V_29_2(:, 3)), 500 ,speaker29, '.');
xlabel('$$ V_1 $$','fontsize',16,'interpreter','latex');
ylabel('$$ V_2 $$','fontsize',16,'interpreter','latex');
title('$$ K1_{29} \cdot K2^T_{29} - K2_{29} \cdot K1^T_{29} $$', 'interpreter', 'latex');
grid on;
subplot(2,2,3);
scatter(V_29_3(:,2),V_29_3(:, 3), 500 ,speaker29, '.');
xlabel('$$ V_1 $$','fontsize',16,'interpreter','latex');
ylabel('$$ V_2 $$','fontsize',16,'interpreter','latex');
title('$$ K2_{29} \cdot K1_{29} $$', 'interpreter', 'latex');
grid on;
