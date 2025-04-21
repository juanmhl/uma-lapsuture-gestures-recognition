% Load data
load("Data\Matlab_data\Suturing_features_data_clean.mat");
load("Common\Feature_Selection\ReliefF\idx_Suturing_relieff.mat", "idx");
% load("Common\Data_discretization\centroids.mat", "centroids_hmm_10v", "centroids_hmm_24v");
% load("Common\Data_discretization\centroids.mat", "centroids_vmm_10v", "centroids_vmm_24v");
% load("Common\Data_discretization\centroids_vmm_reduced.mat")
load("Common\Data_discretization\centroids_norm.mat");

% Data preparation and partition
% Kinematic data, ordered according to ReliefF Feature Selection
X = dataCellArrayToMatrix(featuresData)';
X = X(idx,:);
X = normalize(X,2,"range");
X_10v = X(1:10,:);

% % Use only 80, 160 and 320 centroids
% centroids_hmm_reduced_24v = centroids_hmm_reduced_24v(3:5);
% centroids_hmm_reduced_10v = centroids_hmm_reduced_10v(3:5);

% Labels in vec. format
Y = dataCellArrayToMatrix(labelsData)'+1;       % Because lowest index is 0

% Convert gestures from JIGSAWS to our own from our paper
original_gestures = [1, 2, 3, 4, 5, 6, 7, 9, 10, 11, 12];
new_gestures =      [1, 1, 2, 3, 5, 1, 4, 2, 4,  4,  6];

Y = labels_grouping(Y,original_gestures,new_gestures);

% Squeeze out last 8 elements so that dataset can be divided by 40
X = X(:,1:end-18);
X_10v = X_10v(:,1:end-18);
Y = Y(:,1:end-18);

% Convert kinematic variables to emissions
E_24v = cell(size(centroids_vmm_10v));
E_10v = cell(size(centroids_vmm_10v));

for i = 1:length(E_10v)
    E_10v{i} = dsearchn(centroids_vmm_10v{i}, X_10v')';
end

for i = 1:length(E_24v)
    E_24v{i} = dsearchn(centroids_vmm_24v{i}, X')';
end

%% Data partition and all that

numChunks = 40;
rng(33)      % Fixed random number generator for reproducibility
randomIdx = randperm(numChunks);

for i = 1:length(E_10v)
    chunkSize = length(E_10v{i}) / numChunks;
    chunks = reshape(E_10v{i}, chunkSize, numChunks);
    permuted_chunks = chunks(:,randomIdx);
    E_10v{i} = permuted_chunks(:)';
end

for i = 1:length(E_24v)
    chunkSize = length(E_24v{i}) / numChunks;
    chunks = reshape(E_24v{i}, chunkSize, numChunks);
    permuted_chunks = chunks(:,randomIdx);
    E_24v{i} = permuted_chunks(:)';
end


%% Model configurations definition
% downsampling_rate = [1, 3, 6, 30, 60, 120, 240, 480, 960, ];   % 30Hz, 10Hz, 5Hz, 1Hz, 0.5Hz, 0.25Hz, ...
downsampling_rate = [6 30 60];
% Best results are for dsrate 30 and higher, with not much difference after 30

config.window_width = 20;
config.filter_pond  = [0 0 0];
config.filter_width = 3;
config.circle_offset= 1;
config.compute_additional_pctgs = false;

k = 10;

% Model training

% Order of the results:
% 500 emissions, 30 Hz
% 500 emissions, 10 Hz
% 500 emissions, 5 Hz
% 2000 emissions, 30 Hz
% 2000 emissions, 10 Hz
% 2000 emissions, 5 Hz
% 5000 emissions, 30 Hz
% 5000 emissions, 10 Hz
% 5000 emissions, 5 Hz

%%
% [models, pctgs, pctgs_train, pctgs_mean, pctgs_window, pctgs_filter, pctgs_circle] = trainAndEvalVMMkfolds(E_10v{3}, Y, downsampling_rate(j), k, config);
%%

results_24v = cell(length(downsampling_rate)*length(E_10v),7);

disp(" ------ Training with 24 variables ------ ")

for i = 1:length(E_24v)
    disp("Number of emissions:")
    disp(max(E_10v{i}))
    for j = 1:length(downsampling_rate)
        [models, pctgs, pctgs_train, pctgs_mean, pctgs_window, pctgs_filter, pctgs_circle] = trainAndEvalVMMkfolds(E_24v{i}, Y, downsampling_rate(j), k, config);
        idx = (i - 1) * length(downsampling_rate) + j;
        results_24v{idx , 1} = models;
        results_24v{idx , 2} = pctgs;
        results_24v{idx , 3} = pctgs_train;
        results_24v{idx , 4} = pctgs_mean;
        results_24v{idx , 5} = pctgs_window;
        results_24v{idx , 6} = pctgs_filter;
        results_24v{idx , 7} = pctgs_circle;
        % disp(pctgs')
        % disp(pctgs_train')
        % disp("Mean:")
        disp(pctgs_mean)
    end
end


results_10v = cell(length(downsampling_rate)*length(E_10v),7);

disp(" ------ Training with 10 variables ------ ")

for i = 1:length(E_10v)
    disp("Number of emissions:")
    disp(max(E_10v{i}))
    for j = 1:length(downsampling_rate)
        [models, pctgs, pctgs_train, pctgs_mean, pctgs_window, pctgs_filter, pctgs_circle] = trainAndEvalVMMkfolds(E_10v{i}, Y, downsampling_rate(j), k, config);
        idx = (i - 1) * length(downsampling_rate) + j;
        results_10v{idx , 1} = models;
        results_10v{idx , 2} = pctgs;
        results_10v{idx , 3} = pctgs_train;
        results_10v{idx , 4} = pctgs_mean;
        results_10v{idx , 5} = pctgs_window;
        results_10v{idx , 6} = pctgs_filter;
        results_10v{idx , 7} = pctgs_circle;
        % disp(pctgs')
        % disp(pctgs_train')
        % disp("Mean:")
        disp(pctgs_mean)
    end
end

for i = 1:size(results_10v,1)
    results_10v{i,8} = mean(results_10v{i,3});
    results_24v{i,8} = mean(results_24v{i,3});
end

% save("VMM/results/results1008.mat", "results_10v", "results_24v");