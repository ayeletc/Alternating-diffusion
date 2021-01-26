%% setup
%setup image
Nx          = 540;
Ny          = 960;
imageSize   = [Nx Ny];
r1 = 30;
r2 = 30;

%% create video and record imu
outputpath = '2dSimulation';

%sphere 1
f_ax1 =0.3*pi; % cos frequency
ax1_a = 150; % [1/sec^2]
ax1 = 0;
tau_x_1 = 0.05;
vx1_0 = 0;
vx1 = vx1_0;

f_ay1 = 2; % sin frequency
ay1_a = 0; % [1/sec^2]
ay1 = ay1_a;
tau_y_1 = 1.5;
vy1_0 = ax1_a;
vy1 = ax1_a;

offsetx1 = 480;
offsety1 = 270;

%sphere2
f_ay2 = 2; % sin frequency
ay2_a = -100; % [1/sec^2]
ay2 = ay2_a;
tau_y_2 = 3;
vy2_0 = -10;
vy2 = vy2_0;

f_ax2 = 2; % sin frequency
ax2_a = 0; % [1/sec^2]
ax2 = ax2_a;
tau_x_2 = 0.5;
vx2_0 = 0;
vx2 = vx2_0;

offsetx2 = 100;
offsety2 = 450;


%video cofig
l   = 60; %[sec]
fps = 20;
figure(10)
t = 0;

video = VideoWriter('simulationVideo_withAcc.avi');
video.FrameRate = fps;
open(video); % open the file for writing
acc1 = zeros(fps*l,3);
tags1 = zeros(fps*l,1);
acc2 = zeros(fps*l,3);
tags2 = zeros(fps*l,1);

x_cum = [];
y_cum = [];
t_cum = [];
for ii=1:(fps*l)
    t = t +1/fps;
    t_cum = [t_cum t];
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
    x_cum = [x_cum ax1];
    y_cum = [y_cum ay1];
    plotCircle(offsetx1, double(offsety1), r1, 'k');
    hold on
    plotCircle(offsetx2, double(offsety2), r2, 'k');
    
    scatter(t_cum(1:ii)*20, x_cum(1:ii)/4+180, 350, '.y')
    line(t_cum(1:ii)*20,x_cum(1:ii)/4+180)
    
    scatter(t_cum(1:ii)*20, y_cum(1:ii)/4+60, 350, '.r')
    line(t_cum(1:ii)*20,y_cum(1:ii)/4+60)
    hold off
    axis equal
    xlim([0 Ny])
    ylim([0 Nx])
    set(gca,'visible','off')
    set(gca,'xtick',[])
    frame = getframe(gcf);
    

    %sphere1 movement
    ax1 = -ax1_a*cos(f_ax1*t);
    ay1 = -ax1_a*sin(f_ax1*t);
    %sphere2 movement
    ax2 = 0;
    ay2 = ay2_a*exp(-tau_y_2*t);
    
    writeVideo(video, frame);
%     record acc and tags
    acc1(ii,:) = [ax1, ay1, 0];
    acc2(ii,:) = [ax2, ay2, 0];

end
close(video);
%%
csvwrite('simulationAcc_fast.csv', acc1)
csvwrite('simulationAcc_slow.csv', acc2)

    