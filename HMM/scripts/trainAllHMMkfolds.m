load("Data\Matlab_data\Suturing_features_data_clean.mat");
clear;
load("Data\Matlab_data\Suturing_features_data_clean.mat");
load("Common\Feature_Selection\ReliefF\idx_Suturing_relieff.mat", "idx");
load("Common\Data_discretization\centroids.mat", "centroids_hmm_10v", "centroids_hmm_24v");

X = dataCellArrayToMatrix(featuresData);
Y = dataCellArrayToMatrix(labelsData)+1;

% Convert gestures from JIGSAWS to our own from our paper
original_gestures = [1, 2, 3, 4, 5, 6, 7, 9, 10, 11, 12];
new_gestures =      [1, 1, 2, 3, 5, 1, 4, 2, 4,  4,  6];

Y = labels_grouping(Y,original_gestures,new_gestures);

% Data downsampling to 10 Hz
downsamplingRate = 3;
X = X(1:downsamplingRate:end,:);
Y = Y(1:downsamplingRate:end,:);

X = X(:,idx);
X_10v = X(:,1:10);

% Convert kinematic variables to emissions
E_24v = cell(size(centroids_hmm_24v));
E_10v = cell(size(centroids_hmm_10v));

for i = 1:length(E_10v)
    E_10v{i} = dsearchn(centroids_hmm_10v{i}, X_10v);
end

for i = 1:length(E_24v)
    E_24v{i} = dsearchn(centroids_hmm_24v{i}, X);
end


% For each possible gesture, extract each gesture occurrence
G_24v = cell(size(E_24v));
G_10v = cell(size(E_10v));


for i = 1:length(G_24v)
    G_24v{i} = cluster_by_labels(Y,E_24v{i});
end

for i = 1:length(G_10v)
    G_10v{i} = cluster_by_labels(Y,E_10v{i});
end


% Shuffle and concatenate all occurrences so that k-folds partition can be
% performed

G_cat_24v = cell(size(G_24v));
C_cat_10v = cell(size(G_10v));

% rng(0)
% for nEmissions = 1:length(G_24v)
%     for gesture = 1:length(G_24v{nEmissions})
%         % Shuffling
%         randomIdx = randperm(size(G_24v{nEmissions}{gesture},1));
%         G_24v{nEmissions}{gesture} = G_24v{nEmissions}{gesture}(randomIdx,:);
%         G_10v{nEmissions}{gesture} = G_10v{nEmissions}{gesture}(randomIdx,:);
%         % Concatenation
%         temp_24v = [];
%         temp_10v = [];
%         for occurence = 1:length(G_24v{nEmissions}{gesture})
%             temp_24v = [temp_24v; G_24v{nEmissions}{gesture}{occurence}];
%             temp_10v = [temp_10v; G_10v{nEmissions}{gesture}{occurence}];
%         end
%         G_cat_24v{nEmissions}{gesture} = temp_24v;
%         G_cat_10v{nEmissions}{gesture} = temp_10v;
%     end
% end

% Model configurations definition
% nsta, ntrg, nobs, iter, tol
Mq = [5 10 30]; % Number of hidden states
nTrg = [2 3 5]; % Number of null elements in the matriz ergódica
nEmissions = [];
for i = 1:length(E_24v)
    nEmissions = [nEmissions max(E_24v{i})];
end

config.max_iter = 300;
config.tolerance = 1e-6;
config.test_window_width = 30;
config.verbose = 1;

% Train everything together

results_24v = cell(length(G_24v)*length(Mq),1);
results_10v = cell(length(G_24v)*length(Mq),1);

k = 10;

rng(0);
for i = 1:length(G_24v)
    for j = 1:length(Mq)

        % Data preparation
        for nEms = 1:length(G_24v)
            for gesture = 1:length(G_24v{nEms})
                % Shuffling
                randomIdx = randperm(size(G_24v{nEms}{gesture},1));
                G_24v{nEms}{gesture} = G_24v{nEms}{gesture}(randomIdx,:);
                G_10v{nEms}{gesture} = G_10v{nEms}{gesture}(randomIdx,:);
                % Concatenation
                temp_24v = [];
                temp_10v = [];
                for occurence = 1:length(G_24v{nEms}{gesture})
                    temp_24v = [temp_24v; G_24v{nEms}{gesture}{occurence}];
                    temp_10v = [temp_10v; G_10v{nEms}{gesture}{occurence}];
                end
                G_cat_24v{nEms}{gesture} = temp_24v;
                G_cat_10v{nEms}{gesture} = temp_10v;
            end
        end

        disp('Number of hidden states:')
        disp(Mq(j))

        disp(' % ----- 24 variables ---- %')
        [models, pctgsTest, pctgsTrain, meanPctgs] = trainAndEvalHMMkfolds(G_cat_24v{i}, Mq(j), nEmissions(i), nTrg(j), config, k);
        idx = (i - 1) * length(Mq) + j;
        results_24v{idx, 1} = models;
        results_24v{idx, 2} = pctgsTest;
        results_24v{idx, 3} = pctgsTrain;
        results_24v{idx, 4} = meanPctgs;
        disp("%%%%%%%%%%%%%%% Training summary %%%%%%%%%%%%%%%")
        disp(meanPctgs)
        
        disp(' % ----- 10 variables ---- %')
        [models, pctgsTest, pctgsTrain, meanPctgs] = trainAndEvalHMMkfolds(G_cat_10v{i}, Mq(j), nEmissions(i), nTrg(j), config, k);
        idx = (i - 1) * length(Mq) + j;
        results_10v{idx, 1} = models;
        results_10v{idx, 2} = pctgsTest;
        results_10v{idx, 3} = pctgsTrain;
        results_10v{idx, 4} = meanPctgs;
        disp(meanPctgs)
    end
end


% % Running k-folds training and evaluation on all model configurations
% % For 24 vars:
% 
% k = 10;
% 
% results_24v = cell(length(G_24v)*length(Mq),1);
% 
% disp(" ------ Training with 24 variables ------ ")
% for i = 1:length(G_24v)
%     for j = 1:length(Mq)
%         disp('Number of hidden states:')
%         disp(Mq(j))
%         [models, pctgsTest, pctgsTrain, meanPctgs] = trainAndEvalHMMkfolds(G_24v{i}, Mq(j), nEmissions(i), nTrg(j), config, k);
%         idx = (i - 1) * length(Mq) + j;
%         results_24v{idx, 1} = models;
%         results_24v{idx, 2} = pctgsTest;
%         results_24v{idx, 3} = pctgsTrain;
%         results_24v{idx, 4} = meanPctgs;
%         disp("%%%%%%%%%%%%%%% Training summary %%%%%%%%%%%%%%%")
%         disp(meanPctgs)
%     end
% end
% 
% 
% % For 10 vars:
% 
% results_10v = cell(length(G_24v)*length(Mq),1);
% 
% disp(" ------ Training with 10 variables ------ ")
% for i = 1:length(G_10v)
%     for j = 1:length(Mq)
%         disp('Number of hidden states:')
%         disp(Mq(j))
%         [models, pctgsTest, pctgsTrain, meanPctgs] = trainAndEvalHMMkfolds(G_10v{i}, Mq(j), nEmissions(i), nTrg(j), config, k);
%         idx = (i - 1) * length(Mq) + j;
%         results_10v{idx, 1} = models;
%         results_10v{idx, 2} = pctgsTest;
%         results_10v{idx, 3} = pctgsTrain;
%         results_10v{idx, 4} = meanPctgs;
%         disp(meanPctgs)
%     end
% end


% Saving everything
save("HMM\results\results0912.mat", "results_10v", "results_24v");

% function results = execution_loop(G, Mq, nEmissions, nTrg, config, k)
% 
% results = cell(length(G)*length(Mq),1);
% 
% for i = 1:length(G)     % Outer loop: iterate over different number of possible emissions
%     for j = 1:length(Mq)    % Inner loop: over different number of possible hidden states
%         disp('Number of hidden states:')
%         disp(Mq(j))
%         [models, pctgsTest, pctgsTrain, meanPctgs] = trainAndEvalHMMkfolds(G{i}, Mq(j), nEmissions(i), nTrg(j), config, k);
%         idx = (i - 1) * length(Mq) + j;
%         results{idx, 1} = models;
%         results{idx, 2} = pctgsTest;
%         results{idx, 3} = pctgsTrain;
%         results{idx, 4} = meanPctgs;
%         disp("%%%%%%%%%%%%%%% Training summary %%%%%%%%%%%%%%%")
%         disp(meanPctgs)
%     end
% end
% 
% end
