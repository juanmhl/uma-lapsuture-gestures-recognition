manoeuvre = "Suturing";
featuresPath = strcat("Data/Matlab_data/",manoeuvre,"_features_data_clean.mat");
featuresNamesPath = strcat("Data/Matlab_data/",manoeuvre,"_features_names.mat");
load(featuresPath);
load(featuresNamesPath);

features = dataCellArrayToMatrix(featuresData);
labels = dataCellArrayToMatrix(labelsData);

%% Feature selection with basic Neighborhood Component Analysis
mdl = fscnca(features,labels,'Standardize',true,'Verbose',1,'IterationLimit',10000);
figure()
plot(mdl.FeatureWeights,'ro')
grid on
xlabel('Feature index')
ylabel('Feature weight')

[scores, idx] = sort(mdl.FeatureWeights, ['descend']);
sorted_vars = featuresNames(idx)

% Save results to file
outputPath = strcat("NewFolders/Common/Feature_Selection/NCA/idx_nca_",manoeuvre,".mat");
save(outputPath,"idx","scores");

%% To plot the ordered features
figure;
barh(flip(scores))
xlim([-1,11])
yticks(1:24)
set(gca,'yticklabel',flip(featuresSymbols(idx)))
title("Selección de Componentes con NCA")
ylabel("Variable")
xlabel("Puntuación de cada variable")
