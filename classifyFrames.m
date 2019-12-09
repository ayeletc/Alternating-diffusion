function [error,predicted] = classifyFrames(labels, mat, Nneighbors, N)
% Classify the eigenvectors we plot to the classes: speak/didnt speak. 
% The classifier tests the quality of the clusters and the loss is the rate
% for the plot.
% labels[Nx1] - speaking labels for one speaker
% mat[Nx2] - 2 eigenvectors of the affinity matrix
% we use KNN classifier and kFold=N for cross-validation
Mdl=fitcknn(mat,labels,'NumNeighbors',Nneighbors);
% [out,score]=resubPredict(Mdl)
%table(labels(1:300),out(1:300),score(1:300,2),'VariableNames',...
 %   {'TrueLabel','PredictedLabel','Score'})
CVMdl = crossval(Mdl,'kfold', N);
error = kfoldLoss(CVMdl);
predicted = kfoldPredict(CVMdl);
end
