% Load data
load("Data/Matlab_data/Suturing_features_data_clean.mat");
load("Common/Feature_Selection/ReliefF/idx_Suturing_relieff.mat", "idx");

% Kinematic data, ordered according to ReliefF Feature Selection
X = dataCellArrayToMatrix(featuresData)';
X = X(idx,:);

% Labels in vec. format
Y = dataCellArrayToMatrix(labelsData)'+1;       % Because lowest index is 0

% Convert gestures from JIGSAWS to our own from our paper
original_gestures = [1, 2, 3, 4, 5, 6, 7, 9, 10, 11, 12];
new_gestures =      [1, 1, 2, 3, 5, 1, 4, 2, 4,  4,  6];

Y = labels_grouping(Y,original_gestures,new_gestures);

Y = full(ind2vec(Y));                           % From sparse to full

% Squeeze out last 8 elements so that dataset can be divided by 10
X = X(:,1:end-8);
Y = Y(:,1:end-8);



% Random shuffling of data with fixed RNG
rng(99);     % Fixed random number generator
idx = randperm(size(X,2));

X = X(:,idx);
Y = Y(:,idx);

% First stage of training, all 24 variables
% Define data and configurations

architectures = {
    [10],
    [10 10],
    [10 10 10],
    [30],
    [30 30],
    [30 30 30],
    [50],
    [50 50],
    [50 50 50],
    [100],
    [100 100],
    [100 100 100],
};

results_24v = cell(5,12);

config.epochs = 3000;
config.validationPercentage = 0.3;
config.patience = 30;
k = 10;


for i = 1:12
    disp('Training architecture:')
    disp(architectures{i})
    [trainedNets, records, pctgs, pctgs_train, meanPctg] = trainAndTestMLPkfolds(X,Y,k,architectures{i},config);
    results_24v{1,i} = trainedNets;
    results_24v{2,i} = records;
    results_24v{3,i} = pctgs;
    results_24v{4,i} = pctgs_train;
    results_24v{5,i} = meanPctg;
    disp('Mean pctg:')
    disp(meanPctg)
    disp('--------------------------------')
end

% Second stage of training, top 10 variables
% Define data and configurations

results_10v = cell(5,12);
X = X(1:10,:);

disp('NOW TRAINING WITH ONLY 10 VARS')

for i = 1:12
    disp('Training architecture:')
    disp(architectures{i})
    [trainedNets, records, pctgs, pctgs_train, meanPctg] = trainAndTestMLPkfolds(X,Y,k,architectures{i},config);
    results_10v{1,i} = trainedNets;
    results_10v{2,i} = records;
    results_10v{3,i} = pctgs;
    results_10v{4,i} = pctgs_train;
    results_10v{5,i} = meanPctg;
    disp('Mean pctg:')
    disp(meanPctg)
    disp('--------------------------------')
end

disp("Saving results of 10 variables...")
save("MLP/results/results_0920.mat", "results_10v", "results_24v")
disp("Results saved to disk")