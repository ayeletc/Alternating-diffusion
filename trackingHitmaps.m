%% Tracking hitmaps
%     possible tests: 
%     30min_day1_cam1_20fps_960x540.MP4 min 1:00-2:00 id=8
%     30min_day3_cam3_20fps_960x540.MP4 MIN 18:30-19:30 id=8
%     XX day1_cam1_2230_2430_bw.mp4 min 0:1 id=24 - no imu data
%     min2000_2100_day3_cam3.mp4 id=11

%% flags 
createVideo             = 1;
createColoredMovie       = 0;
creatAvgImage           = 1;
%% speaker 
id              = 8;
% id = 29;
day             = 3;
imuString       = ['Data' filesep 'CSVs' filesep 'day' num2str(day) '_subject' num2str(id) '.csv'];
%% load video
t0          = 20; % imu start in [minutes]
N           = 200; % 10 [sec]
s0          = t0 * 60 * 20; % initial sample
totLen      = 1 * 60; % total length of the given video [sec]
file        = ['Data' filesep 'videos' filesep 'min2000_2100_day3_cam3.mp4'];
framesMat   = frameExtractor(file, N);
%%
f               = 20; % video frequency
windowLen       = N / f;
numOfWindows    = totLen / windowLen;
%% Calculate hitmap for each time window
hitmaps = zeros(12,16,numOfWindows);
for ii = 1:numOfWindows
    winFramesMat = framesMat(:,:,1+(ii-1)*numSamplesInWindow : ii*numSamplesInWindow);
    s0_ii = s0 + (ii-1)*numSamplesInWindow;
    hitmaps(:,:,ii) = patchHitmap(winFramesMat, s0_ii, numSamplesInWindow, imuString, 12, 16);
end
%% 
if(createColoredMovie)
    myColorMap = hot(256);
    video = VideoWriter('tracking_hitmap.avi'); % create the video object
    video.FrameRate = f/numSamplesInWindow;
    open(video); % open the file for writing
    for ii=1:size(hitmaps, 3)
        hitmap = imresize(hitmaps(:,:,ii), [540,960]);
        hitmap = rescale(hitmap-median(hitmap), 0, 255);
        fr = framesMat(:,:,1+(ii-1)*numSamplesInWindow);
        fr = ind2rgb(fr,myColorMap);
        fr = rescale(fr, 0, 255); 

        fr(:,:,1) = 0.9*fr(:,:,1) + 0.1*hitmap;
        fr(:,:,2) = 0.9*fr(:,:,2) + 0.1*hitmap;
        fr(:,:,3) = 0.9*fr(:,:,3) + 0.1*hitmap;

        writeVideo(video, uint8(fr)); %write the frame to file
    end
    close(video);
end
%%
if(createVideo)
    video = VideoWriter('timevar_hitmap.avi'); % create the video object
    video.FrameRate = 1;
    open(video); % open the file for writing
    for ii=1:size(hitmaps, 3)
        hitmap = imresize(hitmaps(:,:,ii), [540,960]);
        hitmap = rescale(hitmap, 0, 255);
        writeVideo(video, uint8(hitmap)); %write the frame to file
        figure;
        imshow(uint8(hitmap));
    end
    close(video);
end
%% hitmaps to average image
if(creatAvgImage)
    hita = fillmissing(hitmaps,'constant',0);
    hitb = mean(hita, 3);
    hitc = imresize(hitb, [540 960]);
    figure;
    imshow(hitc,[])
end
