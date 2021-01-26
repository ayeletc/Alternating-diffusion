%% Plots - Accelerator colored by labels - speaker 3
speaker3_2 = load(['Data' filesep 'CSVs' filesep 'speaker3_2.csv']);
speaker3_2=speaker3_2(:);
acc3 = load(['Data' filesep 'CSVs' filesep 'day3_subject3.csv']);
acc1Samples = acc3(24000:24000+N-1, :,:, :);
acc1Samples = acc1Samples(:, 2:4);

x1 = acc1Samples(:, 1);
y1 = acc1Samples(:, 2);
z1 = acc1Samples(:, 3);

t = linspace(1,300,300);
figure('Name', 'accelerator colored by labels - speaker3');
subplot(3,1,1)
scatter(t,x1,400, speaker3_2, '.')
grid on
line(t,x1)
ylim([-4 4])
xlabel('$$t$$','fontsize',16,'interpreter','latex');
ylabel('$$x$$','fontsize',16,'interpreter','latex');

subplot(3,1,2)
scatter(t,y1,400, speaker3_2, '.')
grid on
line(t,y1)
ylim([-2 2])
xlabel('$$t$$','fontsize',16,'interpreter','latex');
ylabel('$$y$$','fontsize',16,'interpreter','latex');

subplot(3,1,3)
scatter(t,z1,400, speaker3_2, '.')
grid on
line(t,z1)
ylim([-2 2])
xlabel('$$t$$','fontsize',16,'interpreter','latex');
ylabel('$$z$$','fontsize',16,'interpreter','latex');

figure('Name', 'norm of diff - accelerator colored by labels - speaker3');
t = linspace(1, 299, 299);
n = sqrt(diff(x1).^2 + diff(y1).^2 + diff(z1).^2);
scatter(t, n ,400, speaker3_2(1:end-1), '.');
grid on
line(t,n)
ylabel('$$z$$','fontsize',16,'interpreter','latex');
xlabel('$$t$$','fontsize',16,'interpreter','latex');
ylabel('$$ norm $$','fontsize',16,'interpreter','latex');
