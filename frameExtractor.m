clear
close all

% We cannot use 30 min video, Matlab camnnot load it

% Data:

% 1)
% file: '2330_2500.mp4'
% from day 3 camera 3, minutes 23:30-25:00
% speakers: 8 & 24

% 2)
% file: '2000_2200.mp4'
% from day 3 camera 3, minutes 20:00 - 21:30
% speakers: 11 & 35

%% Video Reader
N = 120;  % 50 sec (20 fps)
% v = VideoReader('2330_2500.mp4');
v = VideoReader('2000_2200.mp4');
frames = read(v,[N Inf]);
numberOfFrames = size(frames, 4)

%% Dealing with specific frame
i = 10;
frame_i = frames(:,:,:,i);
grayFrame_i = rgb2gray(frame_i);
figure;
imshow(grayFrame_i);
totalEnergyInFrame_i = sum(grayFrame_i(:))







