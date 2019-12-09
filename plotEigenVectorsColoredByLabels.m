function result = plotEigenVectorsColoredByLabels(id, speakerLabels, eigenVectors)
speakerLabels = load(['Data' filesep 'CSVs' filesep 'speaker29.csv']);
speakerLabels = speakerLabels(:);

figure;
scatter(eigenVectors(:,2),eigenVectors(:,3),500, speakerLabels, '.');
title(['V_2, V_3 colored by speaker_{' num2str(id) '} speaking labels']);
xlabel('$$V_2$$','fontsize',16,'interpreter','latex');
ylabel('$$V_3$$','fontsize',16,'interpreter','latex');
xlim([-0.2 0.2])
ylim([-0.2 0.2])
grid on
end
