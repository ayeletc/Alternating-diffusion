%% Plot IMU on video
%% load video 
path        = ['2dSimulation' filesep '2circles_sin_neq_acc'];
cur_video   = fullfile(path, 'simulationVideo.m4v');
Nx          = 448;%864;
Ny          = 560;%1120;
N           = 1000; % 60 [sec]
framesMat   = frameExtractor(cur_video, N, Nx, Ny);
%% load imu
accString   = fullfile(path, 'simulationAcc_fast.csv');
acc         = load(accString);

% acc3 = load(['Data' filesep 'CSVs' filesep 'day3_subject3.csv']);
% acc1Samples = acc3(24000:24000+N-1, :,:, :);
% acc1Samples = acc1Samples(:, 2:4);
x = acc(:, 1)/8;
y = acc(:, 2)/8;
z = acc(:, 3)/8;

t = linspace(1,N,N);

for ii=1:size(framesMat, 3)
    vColoredFrame = framesMat(:,:,ii);
    figure(1);
    imshow(vColoredFrame, []);
    hold on;
    scatter(t(1:ii), x(1:ii)+500, 350, '.y')
    line(t(1:ii),x(1:ii)+500)
    
    scatter(t(1:ii), y(1:ii)+650, 350, '.r')
    line(t(1:ii),y(1:ii)+650)
    
    scatter(t(1:ii), z(1:ii)+800, 350, '.c')
    line(t(1:ii),z(1:ii)+800)
    
%     scatter(3.1*t(1:ii), 10*(1-speaker3(1:ii))+260, 350, speaker3(1:ii), '.g')
%     line(3.1*t(1:ii),10*(1-speaker3(1:ii))+260)
    
    axis ij
    hold off;
    Fr(ii) = getframe(gcf) ;
    drawnow
end

video = VideoWriter(fullfile(path, 'IMU_on_video.avi')); 
video.FrameRate = 15;
open(video); 
for i=1:length(Fr)
    frame = Fr(i) ;    
    writeVideo(video, frame);
end
close(video);




