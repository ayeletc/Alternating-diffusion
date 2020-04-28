%% Read IMU
imuString   = ['Data' filesep 'CSVs' filesep 'sphereSim.csv'];

%% setup
%setup image
Nx          = 540;
Ny          = 960;
imageSize   = [Nx Ny];
%setup camera with focal length 200, centre 500,500
% cam = [500,0,500;0,500,500;0,0,1];
%setup camera with focal length 200, centre Nx/2,Ny/2
cam = [500,0,0;0,500,0;0,0,1];
% focalLength    = [800, 800]; 
% principalPoint = [Nx/2, Ny/2];
% imageSize      = [Nx, Ny];
% intrinsics = cameraIntrinsics(focalLength,principalPoint,imageSize);

%create a tform matrix
% angles = [5,-5,75]*pi/180;
% angles = [0,-90,0]*pi/180;
angles = [0,0,-90]*pi/180;
% position = [-25,-25,70];
position = [Ny/2 Nx/2 700];
tform = eye(4);
tform(1:3,1:3) = angle2dcm([angles(1),angles(2),angles(3)]);
tform(1:3,4) = position;

%add a little lens distortion
dist = [0,0,0];


%% generate a set of 3d points
% z = peaks;
% x = repmat(1:size(z,1),size(z,1),1);
% y = x';
% sphere1
r1 = 50;
offset = 250;
[x1,y1,z1] = sphere(100);
x1 = x1*r1;
y1 = y1*r1;
z1 = z1*r1;

c1 = z1 - min(z1(:));
c1 = c1./max(c1(:));
c1 = round(255*c1) + 1;
cmap = colormap(jet(256));
c1 = cmap(c1,:);
points1 = [x1(:)+offset,y1(:)+offset,z1(:),c1];

%sphere2
r2 = 50;
offset2 = 80;
[x2,y2,z2] = sphere(100);
x2 = x2*r2-offset2;
y2 = y2*r2-offset2;
z2 = z2*r2;

c2 = z2 - min(z2(:));
c2 = c2./max(c2(:));
c2 = round(255*c2) + 1;
cmap = colormap(jet(256));
c2 = cmap(c2,:);
points2 = [x2(:), y2(:), z2(:), c2];

%% project the points into image coordinates
[projected1, valid1] = projectPoints(points1, cam, tform, dist, imageSize,true);
projected1 = projected1(valid1,:);
[projected2, valid2] = projectPoints(points2, cam, tform, dist, imageSize,true);
projected2 = projected2(valid2,:);
%show the projection
subplot(1,2,1);
scatter3(points1(:,1),points1(:,2),points1(:,3),20,points1(:,4:6),'fill');
axis equal;
title('Original Points');
subplot(1,2,2);
scatter(projected1(:,1),projected1(:,2),20,projected1(:,3:5),'fill');
hold on
scatter(projected2(:,1),projected2(:,2),20,projected2(:,3:5),'fill');
hold off
axis equal;

xlim([0 Ny])
ylim([0 Nx])
axis ij
grid on
title('Points projected with camera model');

%% create video and record imu
outputpath = 'sphereSimulation';

%sphere 1
ay1_0 = -250; % [1/sec^2]
ay1 = ay1_0;
vy1_0 = 20;
vy1 = vy1_0;
offsetx1 = 300;
offsety1 = 200;

%sphere2
ax2_0 = 250; % [1/sec^2]
ax2 = ax2_0;
vx2_0 = -20;
vx2 = vx2_0;
offsetx2 = 0;
offsety2 = 400;


%video cofig
l   = 60; %[sec]
fps = 20;
figure(10)
t = 0;

video = VideoWriter([outputpath filesep 'simulationVideo.avi']); % create the video object
video.FrameRate = fps;
open(video); % open the file for writing
acc1 = zeros(fps*l,3);
tags1 = zeros(fps*l,1);
acc2 = zeros(fps*l,3);
tags2 = zeros(fps*l,1);

for ii=1:(fps*l)
    t = t +1/fps;
    %sphere1
    vy1 = vy1 + ay1*1/fps;
    offsety1 = offsety1 + vy1 * 1/fps;
    
    points1 = [x1(:)+offsetx1, y1(:)+offsety1, z1(:), c1];
    [projected1, valid1] = projectPoints(points1, cam, tform, dist, imageSize,true);
    projected1 = projected1(valid1,:);

    %sphere2
    vx2 = vx2 + ax2*1/fps;
    offsetx2 = offsetx2 + vx2 * 1/fps; % x = v0*t+0.5*a*t^2

    points2 = [x2(:)+offsetx2, y2(:)+offsety2, z2(:), c2];
    [projected2, valid2] = projectPoints(points2, cam, tform, dist, imageSize,true);
    projected2 = projected2(valid2,:);

    %plot
    scatter(projected1(:,1),projected1(:,2),20,projected1(:,3:5),'fill', 'MarkerFaceColor', 'k');
    hold on
    scatter(projected2(:,1),projected2(:,2),20,projected2(:,3:5),'fill', 'MarkerFaceColor', 'k');
    hold off
    
    axis equal
    xlim([0 Ny])
    ylim([0 Nx])
    frame = getframe(gcf);

    %sphere1 movement
     if mod(ii, 15) == 0 % must be odd!
        if mod(ii, 2) == 1
            ay1_0   = ay1;
            ay1     = 0;
            vy1_0   = vy1;
            vy1     = 0;
        else
           ay1_0 = -ay1_0+10*round(rand(1))-5;
           vy1_0 = -sign(vy1)*10+10*round(rand(1))-5;
           ay1   = ay1_0;
        end
    end
    
    %sphere2 movement
     if mod(ii, 19) == 0 % must be odd!
        if mod(ii, 2) == 1
            ax2_0   = ax2;
            ax2     = 0;
            vx2_0   = vx2;
            vx2     = 0;
        else
           ax2_0 = -ax2_0+10*round(rand(1))-5;
           vx2_0 = -sign(vx2)*10+10*round(rand(1))-5;
           ax2   = ax2_0;
        end
    end
    
    
    writeVideo(video, frame);
%     record acc and tags
    acc1(ii,:) = [0, vy1, 0];
    acc2(ii,:) = [vx2, 0, 0];

    if vecnorm(acc1(ii,:)) ~= 0
        tags1(ii) = 1;
    end
    if vecnorm(acc2(ii,:)) ~= 0
        tags2(ii) = 1;
    end
end
close(video);

csvwrite([outputpath filesep 'simulationAcc1.csv'], acc1)
csvwrite([outputpath filesep 'tag1.csv'], tags1)

csvwrite([outputpath filesep 'simulationAcc2.csv'], acc2)
csvwrite([outputpath filesep 'tag2.csv'], tags2)
