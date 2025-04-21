manoeuvre = "Suturing";
rawDataPath = strcat("Data/Matlab_data/",manoeuvre,"_raw_data.mat");
disp("Loading raw matlab data...")
load(rawDataPath);

disp("Extracting features from raw data...")
featuresData = lextractFeaturesFromRaw(kinematicsData);

featuresDataPath = strcat("NewFolders/Data/Matlab_data/",manoeuvre,"_features_data.mat");
disp(strcat("Saving data to ",featuresDataPath,"..."))
save(featuresDataPath,"featuresData","labelsData");
disp(strcat("Saved data to ",featuresDataPath))

% Because Suturing experiment H002 has no labels, I will also save a copy
% of the features data to a .mat in which the featuresData cell array won't
% have any values for the H002 experiment, although JIGSAWS does include
% them.
if strcmp(manoeuvre,"Suturing")
    featuresData{7,2} = [];
    featuresDataPath = strcat("NewFolders/Data/Matlab_data/",manoeuvre,"_features_data_clean.mat");
    disp(strcat("Saving SUTURING data without experiment H002 to ",featuresDataPath,"..."))
    save(featuresDataPath,"featuresData","labelsData");
    disp(strcat("Saved data to ",featuresDataPath))
end

% To have a reference of the feature names, it will also be saved to a .mat
featuresNames = [ "dist"
    "angle"
    "vel\_norm\_left"
    "vel\_norm\_right"
    "gripper\_angle\_left "
    "gripper\_angle\_right"
    "eulerZ\_left"
    "eulerY\_left"
    "eulerX\_left"
    "eulerZ\_right"
    "eulerY\_right"
    "eulerX\_right"
    "vel\_left\_x "
    "vel\_left\_y"
    "vel\_left\_z"
    "vel\_right\_x"
    "vel\_right\_y"
    "vel\_right\_z"
    "vel\_ang\_left\_x"
    "vel\_ang\_left\_y"
    "vel\_ang\_left\_z"
    "vel\_ang\_right\_x"
    "vel\_ang\_right\_y"
    "vel\_ang\_right\_z"];

featuresSymbols = [ "D"
    "\alpha"
    "v_{L}"
    "v_{D}"
    "\theta_{L}"
    "\theta_{R}"
    "\phi_{L,Z}"
    "\phi_{L,Y}"
    "\phi_{L,X}"
    "\phi_{R,Z}"
    "\phi_{R,Y}"
    "\phi_{R,X}"
    "v_{L,X}"
    "v_{L,Y}"
    "v_{L,Z}"
    "v_{R,X}"
    "v_{R,Y}"
    "v_{R,Z}"
    "\omega_{L,X}"
    "\omega_{L,Y}"
    "\omega_{L,Z}"
    "\omega_{R,X}"
    "\omega_{R,Y}"
    "\omega_{R,Z}"];

featuresNamesPath = strcat("NewFolders/Data/Matlab_data/",manoeuvre,"_features_names.mat");
disp(strcat("Saving features names to ",featuresNamesPath,"..."))
save(featuresNamesPath,"featuresNames","featuresSymbols");
disp(strcat("Saved features names to ",featuresNamesPath))