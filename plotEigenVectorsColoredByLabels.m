function result = plotEigenVectorsColoredByLabels(id, speakerLabels, eigenVectors, V1id, V2id)
speakerLabels = load(['Data' filesep 'CSVs' filesep 'speaker' num2str(id) '.csv']);
speakerLabels = speakerLabels(:);

figure;
scatter(eigenVectors(:,V1id),eigenVectors(:,V2id),500, speakerLabels, '.');
title(['V_' num2str(V1id) ', V_' num2str(V2id) ' colored by speaker_{' num2str(id) '} speaking labels']);
xlabel(['$$V_' num2str(V1id) '$$'],'fontsize',16,'interpreter','latex');
ylabel(['$$V_' num2str(V2id) '$$'],'fontsize',16,'interpreter','latex');
xlim([-0.2 0.2])
ylim([-0.2 0.2])
grid on
end
