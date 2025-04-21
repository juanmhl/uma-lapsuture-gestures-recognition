function [models, pctgs, pctgs_train, meanPctg, pctgs_window, pctgs_filter, pctgs_circle] = trainAndEvalVMMkfolds(E, S, downsampling_rate, k, config)

% Downsampling of the emisions and states
E = E(1:downsampling_rate:end);
S = S(1:downsampling_rate:end);

nEmissions = max(E);

% Resize to make divisible by k
excess = mod(length(E),10);
E = E(1:end-excess);
S = S(1:end-excess);

l = size(E,2)/k;
models = cell(k,1);
pctgs = cell(k,1);
pctgs_train = cell(k,1);
pctgs_window = cell(k,1);
pctgs_filter = cell(k,1);
pctgs_circle = cell(k,1);

for i = 1:k         % For each fold
    
    test_idx = zeros(1,size(E,2));
    train_idx = ones(1,size(E,2));
    
    test_idx(1,((i-1)*l+1):(i*l)) = 1;
    train_idx = train_idx - test_idx;

    train_idx = logical(train_idx);
    test_idx = logical(test_idx);

    E_train = E(:,train_idx);
    S_train = S(:,train_idx);
    E_test = E(:,test_idx);
    S_test = S(:,test_idx);

    E_train(end) = nEmissions;    % Para evitar un error algo aleatorio que hay

    [model, pctg, pctg_train, pctg_window, pctg_filter, pctg_circle] = trainAndEvalVMM(E_train, S_train, E_test, S_test, config);

    models{i,1} = model;
    pctgs{i,1} = pctg;
    pctgs_train{i,1} = pctg_train;
    pctgs_window{i,1} = pctg_window;
    pctgs_filter{i,1} = pctg_filter;
    pctgs_circle{i,1} = pctg_circle;
    
end

pctgs = cell2mat(pctgs);
pctgs_train = cell2mat(pctgs_train);
pctgs_window = cell2mat(pctgs_window);
pctgs_filter = cell2mat(pctgs_filter);
pctgs_circle = cell2mat(pctgs_circle);
meanPctg = mean(pctgs);



end

