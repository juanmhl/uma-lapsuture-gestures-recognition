manoeuvre = "Suturing";
featuresPath = strcat("Data/Matlab_data/",manoeuvre,"_features_data_clean.mat");
featuresNamesPath = strcat("Data/Matlab_data/",manoeuvre,"_features_names.mat");
load(featuresPath);
load(featuresNamesPath);

features = dataCellArrayToMatrix(featuresData);
labels = categorical(dataCellArrayToMatrix(labelsData));

%% Feature selection con reliefF
[idx, scores] = relieff(features,labels,10,'updates',2000);
sorted_vars = featuresNames(idx)

figure()
bar(scores(idx))

%% Feature selection con reliefF y data normalization
[featuresNorm,C,S] = normalize(features);
[idx_norm, scores_norm] = relieff(featuresNorm,labels,10,'updates',2000);
sorted_vars_norm = featuresNames(idx_norm)

%% Para plotear
close;
figure;

sortedFeaturesSymbols = featuresSymbols(idx);
sortedFeaturesNames = featuresNames(idx);

barh(flip(scores_norm(idx_norm)/max(scores_norm)))
xlim([0,1.05])
yticks(1:24)
set(gca,'yticklabel',flip(featuresSymbols(idx)))
title("Feature Selection with ReliefF")
ylabel("Variable")
xlabel("Normalized score")

%% Saving all
outputPath = strcat("Common/Feature_Selection/ReliefF/idx_",manoeuvre,"_relieff.mat");
save(outputPath, 'idx', 'scores', "sortedFeaturesNames", "sortedFeaturesSymbols");

