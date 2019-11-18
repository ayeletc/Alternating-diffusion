function frameMat = frameExtractor(file, N)
%% Video Load
v = VideoReader(file);
frames = read(v,[1 N]);
numberOfFrames = size(frames, 4);

%% Dealing with specific frame
gray_frames=zeros(540,960,1,numberOfFrames);
for i = 1:N
    frame = frames(:,:,:,i);
    gray_frames(:,:,:,i) = rgb2gray(frame);
end
%% finding eps
% 
% 
% 
%% return
frameMat = squeeze(gray_frames);


if 0
%% TEST:
frameMat = frameExtractor('2000_2200.mp4', 300);
totalEnergyInFrame_i = sum(frameMat(:))
grayFrame_1 = gray_frames(:,:,:,1);
end
