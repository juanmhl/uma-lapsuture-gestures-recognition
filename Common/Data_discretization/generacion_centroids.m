% Load data
load("Data\Matlab_data\Suturing_features_data_clean.mat");
load("Common\Feature_Selection\ReliefF\idx_Suturing_relieff.mat", "idx");

% Kinematic data, ordered according to ReliefF Feature Selection
X = dataCellArrayToMatrix(featuresData)';
X = X(idx,:);

X = normalize(X,2,"range");

n_emisions_hmm = [30 60 120];
n_emisions_vmm = [500 2000 5000];
% n_emisions_hmm_reduced = [20 40 80 160 320 640 1280 2560 5100];

max_iter = 300;

centroids_hmm_24v = cell(size(n_emisions_hmm));
centroids_hmm_10v = cell(size(n_emisions_hmm));
centroids_vmm_24v = cell(size(n_emisions_vmm));
centroids_vmm_10v = cell(size(n_emisions_vmm));
% centroids_hmm_reduced_24v = cell(size(n_emisions_hmm_reduced));
% centroids_hmm_reduced_10v = cell(size(n_emisions_hmm_reduced));

rng(0)  % For reproducibility

for i = 1:length(n_emisions_hmm)
    [~, centroids] = kmeans(X', n_emisions_hmm(i), "MaxIter", max_iter);
    centroids_hmm_24v{i} = centroids;
end

for i = 1:length(n_emisions_vmm)
    [~, centroids] = kmeans(X', n_emisions_vmm(i), "MaxIter", max_iter);
    centroids_vmm_24v{i} = centroids;
end

% for i = 1:length(n_emisions_hmm_reduced)
%     [~, centroids] = kmeans(X', n_emisions_hmm_reduced(i), "MaxIter", max_iter);
%     centroids_hmm_reduced_24v{i} = centroids;
% end


% Reducing the number of variables in X
X = X(1:10,:);

for i = 1:length(n_emisions_hmm)
    [~, centroids] = kmeans(X', n_emisions_hmm(i), "MaxIter", max_iter);
    centroids_hmm_10v{i} = centroids;
end

for i = 1:length(n_emisions_vmm)
    [~, centroids] = kmeans(X', n_emisions_vmm(i), "MaxIter", max_iter);
    centroids_vmm_10v{i} = centroids;
end

% for i = 1:length(n_emisions_hmm_reduced)
%     [~, centroids] = kmeans(X', n_emisions_hmm_reduced(i), "MaxIter", max_iter);
%     centroids_hmm_reduced_10v{i} = centroids;
% end

% save("Common/Data_discretization/centroids.mat", "centroids_vmm_10v", "centroids_hmm_10v", "centroids_vmm_24v", "centroids_hmm_24v");
% save("Common/Data_discretization/centroids_vmm_reduced.mat", "centroids_hmm_reduced_10v", "centroids_hmm_reduced_24v");
save("Common/Data_discretization/centroids_norm.mat", "centroids_vmm_10v", "centroids_hmm_10v", "centroids_vmm_24v", "centroids_hmm_24v");

% %% Example: how to use the centroids to encode data
% data = X(:,500:600);
% 
% e = dsearchn(centroids_hmm_10v{1}, data');     % Data elements must be row vectors
% min(e)
% max(e)
