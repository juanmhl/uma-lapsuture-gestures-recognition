clear all

load("E4_surgeme_identification/E10_DataPreparation/Suturing_mixed_data.mat");

manoeuvre = "Suturing";
featuresPath = strcat("NewFolders/Data/Matlab_data/",manoeuvre,"_features_data_clean.mat");
featuresNamesPath = strcat("NewFolders/Data/Matlab_data/",manoeuvre,"_features_names.mat");
load(featuresPath);
load(featuresNamesPath);

features = dataCellArrayToMatrix(featuresData);
labels = categorical(dataCellArrayToMatrix(labelsData));

sum(categorical(X_labels')==labels)/length(labels)

sum(sum(X'==features))/(size(features,1)*size(features,2))