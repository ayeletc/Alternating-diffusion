function result = plotEigenVectorsColoredByLabels(id, speakerLabels, eigenVectors, V1id, V2id)
speakerLabels = load(['Data' filesep 'CSVs' filesep 'speaker' num2str(id) '.csv']);
speakerLabels = speakerLabels(:);

figure;
hold on;
scatter(eigenVectors(:,V1id),eigenVectors(:,V2id),100, speakerLabels, '.');
title(['V_' num2str(V1id) ', V_' num2str(V2id) ' colored by speaker_{' num2str(id) '} speaking labels']);
xlabel(['$$V_' num2str(V1id) '$$'],'fontsize',16,'interpreter','latex');
ylabel(['$$V_' num2str(V2id) '$$'],'fontsize',16,'interpreter','latex');
grid on
colormap(cool(2));
colorbar;
end
