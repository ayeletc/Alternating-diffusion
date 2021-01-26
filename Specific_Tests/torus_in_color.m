clear
close all


N = 1000;

t1 = rand([N 1])*2*pi;
t2 = rand([N 1])*2*pi;
t3 = rand([N 1])*2*pi;

R = 10;
r1 = 4;
r2 = 2;

figure;
x1 = (R+r1*cos(t2)).*cos(t1);
y1 = (R+r1*cos(t2)).*sin(t1);
z1 = r1*sin(t2);

x2 = (R+r2*cos(t3)).*cos(t1);
y2 = (R+r2*cos(t3)).*sin(t1);
z2 = r2*sin(t3);

subplot(2, 1, 1);
scatter3(x1(:),y1(:),z1(:),50 ,t1*10, '.')
title('s1');
subplot(2, 1, 2);
scatter3(x2(:),y2(:),z2(:),50 ,t1*10, '.')
title('s2');

s1 = [x1 y1 z1];
s2 = [x2 y2 z2];

%% Alternating Diffusion

eps1 = 0.5;
eps2 = 0.5;
m = 1;
d1 = zeros(N);
d2 = zeros(N);

W1 = affinityMatrix(s1, eps1);
W2 = affinityMatrix(s2, eps2);

K1 = W1 ./ sum(W1,1);
K2 = W2 ./ sum(W2,1);
Ktot = K2*K1;
 
% Ktotm = Ktot ^ m; 
% for i = 1:N
%     for j = 1:N
%         d2m(i,j) = sum((Ktotm(:,i)-Ktotm(:,j)) .^ 2, 1);
%     end
% end

%% Diffusion Maps (appendix A)

t = 1;

[V,D] = eig(Ktot);
D = diag(D^t);
phi = V(:, 2:4) ./ V(:, 1);

figure;
subplot(3, 1, 1);
scatter3(x1(:),y1(:),z1(:), 100 ,V(:,2)*10, '.');
title('$$s_{1}$$','fontsize',16,'interpreter','latex');
subplot(3, 1, 2);
scatter3(x2(:),y2(:),z2(:), 100 ,V(:,2)*10, '.');
title('$$s_{2}$$','fontsize',16,'interpreter','latex');
subplot(3, 1, 3);
scatter(cos(t1), sin(t1),100 ,V(:,2)*10, '.');

xlabel('$$cos(x_{i})$$','fontsize',16,'interpreter','latex');
ylabel('$$sin(x_{i})$$','fontsize',16,'interpreter','latex');


