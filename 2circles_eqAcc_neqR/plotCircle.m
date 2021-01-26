function circles = plotCircle(x,y,r,c)
% hold on
th = 0:pi/50:2*pi;
x_circle = r * cos(th) + x;
y_circle = r * sin(th) + y;
circles = plot(x_circle, y_circle);
fill(x_circle, y_circle, c)
% hold off
% axis equal

if 0
%%
circleout = circle2(3, 4, 2, 'g')  
end