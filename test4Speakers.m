% test4Speakers
%%
% video: 'day1_cam1_2230_2430_bw.mp4'
% acc: 'day1_subject25.csv', 'day1_subject28.csv'
% from day 1 camera 1, minutes 22:30 - 24:30
% speakers: 25 & 28 & 17 & 19
N = 300;
file = ['Data' filesep 'videos' filesep 'day1_cam1_2230_2430_bw.mp4'];
framesMat = frameExtractor(file, N);
labels = load(['Data' filesep 'CSVs' filesep 'labels.csv']);
ep1 = 1e7;
ep2 = 1;

%% Alternative Diffusion - speaker 25
acc25 = load(['Data' filesep 'CSVs' filesep 'day1_subject25.csv']);
accSamples25 = acc25(27000:27000+N-1, :,:, :);
accSamples25 = accSamples25(:, 2:4);

[K_sym_25, K_antisym_25, K_25] = alternatingDiffusion(framesMat,ep1,accSamples25,ep2);
K_25 = diffusionMaps(K_25, ep2);

[V25,D25] = eig(K_25);
D25 = diag(D25);

%% Alternative Diffusion - speaker 28
acc28 = load(['Data' filesep 'CSVs' filesep 'day1_subject28.csv']);
accSamples28 = acc28(27000:27000+N-1, :,:, :);
accSamples28 = accSamples28(:, 2:4);

[K_sym_28, K_antisym_28, K_28] = alternatingDiffusion(framesMat,ep1,accSamples28,ep2);
K_28 = diffusionMaps(K_28, ep2);

[V28,D28] = eig(K_28);
D28 = diag(D28);

%% Plots - eigen values colored by speaking (manual labeling) - speaker 25
speaker25 = load(['Data' filesep 'CSVs' filesep 'speaker25.csv']);
speaker25 = speaker25(:);
plotEigenVectorsColoredByLabels(25, speaker25, V25, 2, 4);

%% Plots - eigen values colored by speaking (manual labeling) - speaker 28
speaker28 = load(['Data' filesep 'CSVs' filesep 'speaker28.csv']);
speaker28 = speaker28(:);
plotEigenVectorsColoredByLabels(28, speaker28, V28, 2, 4);
%% Visualize clusters - speaker 25
Nclusters = 11;
I = kmeans([real(V25(:,2)) , real(V25(:,3))], Nclusters);
figure;
scatter(V25(:,2), V25(:,3), 500, I, '.');

figure('Name', 'Speaker25');
subplot(2,1,1)
scatter(V25(:,2), V25(:,3), 500, I, '.');
xlabel('V_2')
ylabel('V_3')
colorbar;
colormap(jet)
grid on
speakingClusters = I .* speaker25;
title('Clusters in (V2,V3)')

subplot(2,1,2);
histogram(speakingClusters,12, 'Normalization','probability');
xlim([1,Nclusters]);
ylim([0,0.1]);
title('Histogram(speakingClusters)')

%% Visualize clusters - speaker 28
Nclusters = 11;
I = kmeans([real(V28(:,2)) , real(V28(:,3))], Nclusters);
figure;
scatter(V28(:,2), V28(:,3), 500, I, '.');

figure('Name', 'Speaker28');
subplot(2,1,1)
scatter(V28(:,2), V28(:,3), 500, I, '.');
xlabel('V_2')
ylabel('V_3')
colorbar;
colormap(jet)
speakingClusters = I .* speaker28;
grid on
title('Clusters in (V2,V3)')

subplot(2,1,2);
histogram(speakingClusters,Nclusters, 'Normalization','probability');
xlim([1,11]);
ylim([0,0.5]);
title('Histogram(speakingClusters)')

%% Create a video displaying the index of the cluster that includes the current frame 
video = VideoWriter('clustersFrames.avi'); 
open(video); 
for ii=1:size(framesMat, 3)
  frame = framesMat(:,:,ii);
  tFrame = uint8(AddTextToImage(frame,num2str(I(ii)),[1, 1],0.5));
  writeVideo(video, tFrame);
end
close(video);

%% classify
% Classify the eigenvectors we plot to the classes: speak/didnt speak . 
% The classifier tests the quality of the clusters and the loss is the rate
% for the plot.
% we use this to understand what are the optimal eigenvectors we need to
% take.
id = 28;
V1id = 2;
V2id = 3;
Nneighbors = 4;
Vid = eval(['V' num2str(id)]);
speakerID = eval(['speaker' num2str(id)]);
ErrorMat=ones(N);
for V1id = 2:10
    for V2id = (V1id+1):10
        if V1id == V2id
            continue
        end
        mat = [Vid(:,V1id),Vid(:,V2id)];
        [error, predicted] = classifyFrames(speakerID, abs(mat), Nneighbors, N); 
        ErrorMat(V1id,V2id) = error;
    end
end
minError = 100 * min(ErrorMat);
disp(['error = ' num2str(minError) '%']);
