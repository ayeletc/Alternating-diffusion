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

ep1 = 1e7;
ep2 = 1;

%% Alternative Diffussion - 29

acc29 = load('day3_subject29.csv');

acc1Samples29 = acc29(24000:24000+N-1, :,:, :);
acc1Samples29 = acc1Samples29(:, 2:4);

W1_29 = -log(affinityMatrixFrames(framesMat,ep1));
W2_29 = -log(affinityMatrixAcc(acc1Samples29,ep2));

Y1_29 = cmdscale(W1_29, 3);
Y2_29 = cmdscale(W2_29, 3);



