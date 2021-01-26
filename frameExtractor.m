function frameMat = frameExtractor(file, N, Nx, Ny)
%% Video Load

v = VideoReader(file);

frames = read(v,[1 N]);
numberOfFrames = size(frames, 3);

%% Dealing with specific frame
gray_frames=zeros(Nx,Ny,1,numberOfFrames);
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
N=3000;
frameMat = frameExtractor('2000_2200.mp4', N);
totalEnergyInFrame_i = sum(frameMat(:))
grayFrame_1 = gray_frames(:,:,:,1);
end