%% setup
%setup image
Nx          = 540;
Ny          = 960;
imageSize   = [Nx Ny];
r1 = 50;
r2 = 30;

%% create video and record imu
outputpath = '2dSimulation';

%sphere 1
f_ax1 = 2; % sin frequency
ax1_0 = -10; % [1/sec^2]
ax1 = ax1_0;
vx1_0 = -10;
vx1 = vx1_0;

f_ay1 = 2; % sin frequency
ay1_0 = 0; % [1/sec^2]
ay1 = ay1_0;
vy1_0 = 0;
vy1 = vy1_0;

offsetx1 = 800;
offsety1 = 100;

%sphere2
f_ay2 = 2; % sin frequency
ay2_0 = -10; % [1/sec^2]
ay2 = ay2_0;
vy2_0 = -10;
vy2 = vy2_0;

f_ax2 = 2; % sin frequency
ax2_0 = 0; % [1/sec^2]
ax2 = ax2_0;
vx2_0 = 0;
vx2 = vx2_0;

offsetx2 = 100;
offsety2 = 450;


%video cofig
l   = 60; %[sec]
fps = 20;
figure(10)
t = 0;

video = VideoWriter('simulationVideo_eq.avi');
video.FrameRate = fps;
open(video); % open the file for writing
acc1 = zeros(fps*l,3);
tags1 = zeros(fps*l,1);
acc2 = zeros(fps*l,3);
tags2 = zeros(fps*l,1);

for ii=1:(fps*l)
    t = t +1/fps;
    %sphere1
    vx1 = vx1 + ax1*1/fps;
    offsetx1 = offsetx1 + vx1 * 1/fps; % x = v0*t+0.5*a*t^2
    vy1 = vy1 + ay1*1/fps;
    offsety1 = offsety1 + vy1 * 1/fps; % x = v0*t+0.5*a*t^2

    %sphere2
    vx2 = vx2 + ax2*1/fps;
    offsetx2 = offsetx2 + vx2 * 1/fps; % x = v0*t+0.5*a*t^2
    vy2 = vy2 + ay2*1/fps;
    offsety2 = offsety2 + vy2 * 1/fps; % x = v0*t+0.5*a*t^2

    %plot
    plotCircle(offsetx1, offsety1, r1, 'k');
    hold on
    plotCircle(offsetx2, offsety2, r2, 'k');
    hold off
    axis equal
    xlim([0 Ny])
    ylim([0 Nx])
    set(gca,'visible','off')
    set(gca,'xtick',[])
    frame = getframe(gcf);
    

    %sphere1 movement
    ax1 = ax1_0*sin(f_ax1*t);
    ay1 = ay1_0*sin(f_ay1*t);
    %sphere2 movement
    ax2 = ax2_0*sin(f_ax2*t);
    ay2 = ay2_0*sin(f_ay2*t);

    writeVideo(video, frame);
%     record acc and tags
    acc1(ii,:) = [ax1, ay1, 0];
    acc2(ii,:) = [ax2, ay2, 0];

    if vecnorm(acc1(ii,:)) ~= 0
        tags1(ii) = 1;
    end
    if vecnorm(acc2(ii,:)) ~= 0
        tags2(ii) = 1;
    end
end
close(video);
%%
csvwrite('simulationAcc_big.csv', acc1)
csvwrite('tag_big.csv', tags1)

csvwrite('simulationAcc_small.csv', acc2)
csvwrite('tag_small.csv', tags2)

    