clear
close all

% Data:
% 1)
% file: '2000_2200.mp4'
% from day 3 camera 3, minutes 20:00 - 22:00
% speakers: 11 & 35

% 2)
% video: '2000_2200.mp4'
% acc: 'day3_subject3.csv', 'day3_subject29.csv'
% from day 3 camera 3, minutes 20:00 - 22:00
% speakers: 3 & 29

% 3)
% video: 'day1_cam1_2230_2430_bw.mp4'
% acc: 'day1_subject25.csv', 'day1_subject28.csv'
% from day 1 camera 1, minutes 22:30 - 24:30
% speakers: 25 & 28 & 17 & 19


% N = 2000;
N = 300;  % (20 fps)

% file = ['Data' filesep 'videos' filesep '2330_2500.mp4'];
file = ['Data' filesep 'videos' filesep '2000_2200.mp4'];
framesMat = frameExtractor(file, N);
labels = load(['Data' filesep 'CSVs' filesep 'labels.csv']);

%% Alternative Diffussion - 3
acc3 = load(['Data' filesep 'CSVs' filesep 'day3_subject3.csv']);
acc1Samples = acc3(24000:24000+N-1, :,:, :);
acc1Samples = acc1Samples(:, 2:4);


ep1 = 1e7;
ep2 = 1;

[K_sym, K_antisym, K] = alternatingDiffusion(framesMat,ep1,acc1Samples,ep2);

[V,D] = eig(K);
D = diag(D);
%% Alternative Diffussion - 29

acc29 = load(['Data' filesep 'CSVs' filesep 'day3_subject29.csv']);

acc1Samples29 = acc29(24000:24000+N-1, :,:, :);
acc1Samples29 = acc1Samples29(:, 2:4);

ep1 = 1e7;
ep2 = 1;

[K_sym_29, K_antisym_29, K_29] = alternatingDiffusion(framesMat,ep1,acc1Samples29,ep2);

[V29,D29] = eig(K_29);
D29 = diag(D29);


%% Plots - Accelerators colored by eigenvector - speaker 3
figure;
t = 1:N;
scatter(t, abs(D));
title('Eigen values');

x1 = acc1Samples(:, 1);
y1 = acc1Samples(:, 2);
z1 = acc1Samples(:, 3);

figure;
scatter3(x1(:),y1(:),z1(:), 100 ,V(:,2)*10, '.');
title('$$accSamples_{1}$$','fontsize',16,'interpreter','latex');

%% Create video visualizing V2 results 
video = VideoWriter('visualingV2.avi'); % create the video object
open(video); % open the file for writing

scV = rescale(V(:,2), 0, 255);

for ii=1:size(framesMat, 3)
    
  vColoredFrame = framesMat(:,:,ii);
  height = round(scV(ii) / 5);
  vColoredFrame(400:400+height,1:50) = scV(ii) ;
  vColoredFrame = vColoredFrame / 255;
  
  writeVideo(video, vColoredFrame); %write the frame to file
end
close(video);

%% Create video visualizing labels 
% video = VideoWriter('yourvideo3.MPEG','MPEG-4');
% open(video); 
% speaker29=load(['Data' filesep 'CSVs' filesep 'speaker29.csv']);
% speaker29=speaker29(:);
% scV = rescale(speaker29, 0, 255);
% 
% for ii=1:size(framesMat, 3)
%   vColoredFrame = framesMat(:,:,ii);
%   height = round(scV(ii) / 5);
%   vColoredFrame(400:400+height,1:50) = scV(ii) ;
%   vColoredFrame = vColoredFrame / 255;
%   
%   writeVideo(video, vColoredFrame); 
% end
% 
% close(video);

%% Compare results with the Labels:
figure;
speaker3 = labels(20*60*20:20*60*20+N-1, 580);
[c,lags] = xcorr(speaker3, V(:,2));
subplot(2,1,1);
stem(lags,c);
title('$$R(V_2, speaker3)$$','fontsize',16,'interpreter','latex');

subplot(2,1,2);
dv = diff(V(:,2));
[c,lags] = xcorr(speaker3, dv);
stem(lags,c);
title('$$R(dV, speaker3)$$','fontsize',16,'interpreter','latex');

%% Plots - eigen values colored by speaking (manual labeling) - speaker 3
speaker3 = load(['Data' filesep 'CSVs' filesep 'speaker3.csv']);
speaker3 = speaker3(:);
% plotEigenVectorsColoredByLabels(3, speaker3, V);
speaker3_2 = load(['Data' filesep 'CSVs' filesep 'speaker3_2.csv']);
speaker3_2 = speaker3_2(:);
plotEigenVectorsColoredByLabels(3, speaker3_2, V, 2, 3);

%% Plots - eigen values colored by speaking (manual labeling) - speaker 29
speaker29 = load(['Data' filesep 'CSVs' filesep 'speaker29.csv']);
speaker29 = speaker29(:);
plotEigenVectorsColoredByLabels(29, speaker29, V29, 2, 3);

%% Compare kernels for speaker 29
[V_29_1,D_29_1] = eig(K_sym_29);
[V_29_2,D_29_2] = eig(K_antisym_29);
[V_29_3,D_29_3] = eig(K_29);

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
title('$$ K1_{29} \cdot K2_{29} $$', 'interpreter', 'latex');
grid on;

%% Plots - Problematic points - speaker 29
V1 = V29(:,2);
V2 = V29(:,3);
exceptionalPoints = findExceptionalFrames(V1,V2,N,speaker29,55,2);
figure;
scatter(V29(:,2),V29(:,3),500, exceptionalPoints, '.');
title('V_2, V_3 colored by speaker_{29} speaking labels and exceptions');
xlabel('$$V_2$$','fontsize',16,'interpreter','latex');
ylabel('$$V_3$$','fontsize',16,'interpreter','latex');
xlim([-0.2 0.2])
ylim([-0.2 0.2])
grid on

%% Creating video visualizing exceptional points
video = VideoWriter('exceptionalFrames.avi'); 
open(video); 
scV = rescale(exceptionalPoints, 0, 255);

for ii=1:size(framesMat, 3)
  vColoredFrame = framesMat(:,:,ii);
  height = round(scV(ii) / 5);
  vColoredFrame(400:400+height,1:50) = exceptionalPoints(ii) ;
  vColoredFrame = vColoredFrame / 255;
  
  writeVideo(video, vColoredFrame);
end
close(video);

