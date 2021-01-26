function result = plotEigenVectorsColoredByLabelsOneByOne(id, speakerLabels, eigenVectors, V1id, V2id)
speakerLabels = speakerLabels(:);
figure;
pause(5);
plot = scatter(eigenVectors(:,V1id),eigenVectors(:,V2id),300, speakerLabels, '.');
title(['V_' num2str(V1id-1) ', V_' num2str(V2id-1) ' colored by speaker_{' num2str(id) '} speaking labels']);
xlabel(['$$V_' num2str(V1id-1) '$$'],'fontsize',16,'interpreter','latex');
ylabel(['$$V_' num2str(V2id-1) '$$'],'fontsize',16,'interpreter','latex');
xlim([-0.2 0.2])
ylim([-0.2 0.2])
colorbar;

grid on
for i =1: size(speakerLabels, 1)
    plot.XData = eigenVectors(1:i,V1id);
    plot.YData = eigenVectors(1:i,V2id);
    plot.CData = speakerLabels(1:i);
    colormap(cool(2));
    pause(0.1);
    
end
