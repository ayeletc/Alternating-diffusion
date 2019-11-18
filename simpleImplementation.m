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

N = 300;  % (20 fps)

% file = '2330_2500.mp4';
file = '2000_2200.mp4';
framesMat = frameExtractor(file, N);
acc1 = load('day3_subject29.csv');
%%
acc1Samples = acc1(24000:24000+300-1, :,:, :);
acc1Samples = acc1Samples(:, 2:4);

%% Alternating Diffusion
ep1 = 1e7;
ep2 = 1;

K = alternatingDiffusion(framesMat,ep1,acc1Samples,ep2);

[V,D] = eig(K);
D = diag(D);

%% Plots
figure;
x = 1:300;
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



for ii=1:size(framesMat, 3) %where N is the number of images
  vColoredFrame = framesMat(:,:,ii);
  vColoredFrame(1:50,1:50) = rescale(V(ii,2), 0, 255) ;
%   vColoredFrame = uint8(vColoredFrame);
  
  writeVideo(video, vColoredFrame); %write the frame to file
end

close(video);
