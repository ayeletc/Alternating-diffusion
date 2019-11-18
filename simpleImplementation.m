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
file = '2000_2200.mp4';
framesMat = frameExtractor(file, N);
acc1 = load('day3_subject3.csv');
%%
acc1Samples = acc1(24000:24000+N-1, :,:, :);
acc1Samples = acc1Samples(:, 2:4);

labels = load('labels.csv');

%% Alternating Diffusion
ep1 = 1e7;
ep2 = 1;

K = alternatingDiffusion(framesMat,ep1,acc1Samples,ep2);

[V,D] = eig(K);
D = diag(D);

%% Plots
figure;
x = 1:N;
scatter(x, abs(D));
title('Eigen values');

x1 = acc1Samples(:, 1);
y1 = acc1Samples(:, 2);
z1 = acc1Samples(:, 3);

figure;
scatter3(x1(:),y1(:),z1(:), 100 ,V(:,2)*10, '.');
title('$$accSamples_{1}$$','fontsize',16,'interpreter','latex');

%% 
video = VideoWriter('yourvideo.avi'); %create the video object
open(video); %open the file for writing

scV = rescale(V(:,2), 0, 255);

for ii=1:size(framesMat, 3) %where N is the number of images
  vColoredFrame = framesMat(:,:,ii);
  height = round(scV(ii) / 5);
  vColoredFrame(400:400+height,1:50) = scV(ii) ;
  vColoredFrame = vColoredFrame / 255;
  
  writeVideo(video, vColoredFrame); %write the frame to file
end

close(video);

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
%%
figure;
x = V(:,2);
y = speaker3;
Normalized_CrossCorr = (1/N) * sum((x-mean(x)) .* (y-mean(y))) / sqrt(var(x)*var(y));
stem(Normalized_CrossCorr);
%% Crossc-correlation with all the speakers
% we expect to see maximum for the speakers (3 for example)

% speakersCol = 562:9:823;
firstID = 63;
speakersCol = 4+9*firstID:9:823;
speakersN = size(speakersCol, 2);
x = V(:,2);
Normalized_CrossCorr = zeros(speakersN, 1);
for ii=1:speakersN
    y = labels(20*60*20:20*60*20+N-1, ii);
    Normalized_CrossCorr(ii) = (1/N) * sum((x-mean(x)) .* (y-mean(y))) / sqrt(var(x)*var(y));
end
figure;
stem(firstID:(823-4)/9, Normalized_CrossCorr);
xlabel('speakers - absolute ID')
title('Normalized Cross-Correlation(Speak-Labels, V(2))');
