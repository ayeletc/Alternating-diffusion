clear
close all


t1 = rand([1000 1]);
t2 = rand([1000 1]);
t3 = rand([1000 1]);

R = 10;
r1 = 4;
r2 = 2;

figure;
x1 = (R+r1*cos(2*pi*t2)).*cos(2*pi*t1);
y1 = (R+r1*cos(2*pi*t2)).*sin(2*pi*t1);
z1 = r1*sin(2*pi*t2);

x2 = (R+r2*cos(2*pi*t3)).*cos(2*pi*t1);
y2 = (R+r2*cos(2*pi*t3)).*sin(2*pi*t1);
z2 = r2*sin(2*pi*t3);

subplot(2, 1, 1);
scatter3(x1(:),y1(:),z1(:),1 ,t1*10000, '.')
title('s1');
subplot(2, 1, 2);
scatter3(x2(:),y2(:),z2(:),1 ,t1*10000, '.')
title('s2');
