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
labels = load('labels.csv');

%% Alternative Diffussion - 3
acc3 = load('day3_subject3.csv');
acc1Samples = acc3(24000:24000+N-1, :,:, :);
acc1Samples = acc1Samples(:, 2:4);


ep1 = 1e7;
ep2 = 1;

K = alternatingDiffusion(framesMat,ep1,acc1Samples,ep2);

[V,D] = eig(K);
D = diag(D);
%% Alternative Diffussion - 29

acc29 = load('day3_subject29.csv');

acc1Samples29 = acc29(24000:24000+N-1, :,:, :);
acc1Samples29 = acc1Samples29(:, 2:4);

ep1 = 1e7;
ep2 = 1;

K29 = alternatingDiffusion(framesMat,ep1,acc1Samples29,ep2);

[V29,D29] = eig(K29);
D29 = diag(D29);

%% Plots - speaker 3
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


%% Creating video for comparision with the V' 
videoDiff = VideoWriter('yourvideodiff.MPEG','MPEG-4'); 
open(videoDiff); 

scV = rescale(dv, 0, 255);

for ii=1:(size(framesMat, 3)-1)
  vColoredFrame = framesMat(:,:,ii);
  height = round(scV(ii) / 5);
  vColoredFrame(400:400+height,1:50) = scV(ii) ;
  vColoredFrame = vColoredFrame / 255;
  
  writeVideo(videoDiff, vColoredFrame); 
end

close(videoDiff);

%% 
video = VideoWriter('yourvideo3.MPEG','MPEG-4');
open(video); 

scV = rescale(speaker3, 0, 255);

for ii=1:size(framesMat, 3)
  vColoredFrame = framesMat(:,:,ii);
  height = round(scV(ii) / 5);
  vColoredFrame(400:400+height,1:50) = scV(ii) ;
  vColoredFrame = vColoredFrame / 255;
  
  writeVideo(video, vColoredFrame); 
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

%% Plots - eigen values
figure;
x = 1:N;
scatter(x, abs(D));
title('2D comparsion');

%% Plots - eigen values colored by speaking (manual labeling) - speaker 3
speaker3=load('speaker3.csv');
speaker3=speaker3(:);
figure;
subplot(2,1,1)
scatter(V(:,2),V(:,3),500, speaker3, '.');
title('V_2, V_3 colored by speaker_3 speaking labels');
xlabel('$$V_2$$','fontsize',16,'interpreter','latex');
ylabel('$$V_3$$','fontsize',16,'interpreter','latex');
xlim([-0.2 0.2])
ylim([-0.2 0.2])
grid on

speaker3_2=load('speaker3_2.csv');
speaker3_2=speaker3_2(:);
subplot(2,1,2)
scatter(V(:,2),V(:,3),500, speaker3_2, '.');
title('V_2, V_3 colored by speaker_3 speaking labels');
xlabel('$$V_2$$','fontsize',16,'interpreter','latex');
ylabel('$$V_3$$','fontsize',16,'interpreter','latex');
xlim([-0.2 0.2])
ylim([-0.2 0.2])
grid on
%% Plots - eigen values colored by speaking (manual labeling) - speaker3
figure;
for ii=1:9
    speaker3 = labels(20*60*20:20*60*20+N-1, 577+ii-1);
    subplot(3,3,ii)
    scatter(V(:,2),V(:,3),500, speaker3, '.');
    title('V_2, V_3 colored by speaker_3 speaking labels');
    xlabel('$$V_2$$','fontsize',16,'interpreter','latex');
    ylabel('$$V_3$$','fontsize',16,'interpreter','latex');
    xlim([-0.2 0.2])
    ylim([-0.2 0.2])
    grid on
end

%% Plots - eigen values colored by speaking (manual labeling) - speaker 29
speaker29=load('speaker29.csv');
speaker29=speaker29(:);
figure;
scatter(V29(:,2),V29(:,3),500, speaker29, '.');
title('V_2, V_3 colored by speaker_{29} speaking labels');
xlabel('$$V_2$$','fontsize',16,'interpreter','latex');
ylabel('$$V_3$$','fontsize',16,'interpreter','latex');
xlim([-0.2 0.2])
ylim([-0.2 0.2])
grid on

%% Cross-Correlation with speaker3's labels
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

%videoreader
v = VideoReader('2000_2200.mp4');

%% accelerator colored by labels - speaker3
t=linspace(1,300,300);
figure('Name', 'accelerator colored by labels - speaker3');
subplot(3,1,1)
scatter(t,x1,400, speaker3_2, '.')
grid on
line(t,x1)
ylim([-4 4])
xlabel('$$t$$','fontsize',16,'interpreter','latex');
ylabel('$$x$$','fontsize',16,'interpreter','latex');

subplot(3,1,2)
scatter(t,y1,400, speaker3_2, '.')
grid on
line(t,y1)
ylim([-2 2])
xlabel('$$t$$','fontsize',16,'interpreter','latex');
ylabel('$$y$$','fontsize',16,'interpreter','latex');

subplot(3,1,3)
scatter(t,z1,400, speaker3_2, '.')
grid on
line(t,z1)
ylim([-2 2])
xlabel('$$t$$','fontsize',16,'interpreter','latex');
ylabel('$$z$$','fontsize',16,'interpreter','latex');

figure('Name', 'norm of diff - accelerator colored by labels - speaker3');
t = linspace(1, 299, 299);
n = sqrt(diff(x1).^2 + diff(y1).^2 + diff(z1).^2);
scatter(t, n ,400, speaker3_2(1:end-1), '.');
grid on
line(t,n)
ylabel('$$z$$','fontsize',16,'interpreter','latex');
xlabel('$$t$$','fontsize',16,'interpreter','latex');
ylabel('$$ norm $$','fontsize',16,'interpreter','latex');
