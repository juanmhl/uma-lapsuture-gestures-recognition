function [trainedNets, records, pctgs, pctgs_train, meanPctg] = trainAndTestMLPkfolds(X, Y, k, architecture, config)

l = size(X,2)/k;
trainedNets = cell(k,1);
pctgs = cell(k,1);
pctgs_train = cell(k,1);
records = cell(k,1);

for i = 1:k         % For each fold

    test_idx = zeros(1,size(X,2));
    train_idx = ones(1,size(X,2));
    
    test_idx(1,((i-1)*l+1):(i*l)) = 1;
    train_idx = train_idx - test_idx;

    train_idx = logical(train_idx);
    test_idx = logical(test_idx);

    X_train = X(:,train_idx);
    Y_train = Y(:,train_idx);
    X_test = X(:,test_idx);
    Y_test = Y(:,test_idx);

    [net, record, Y_predicted, pctg, pctg_train] = trainAndTestMLP(X_train, Y_train, ...
        X_test, Y_test, architecture, config);

    trainedNets{i,1} = net;
    pctgs{i,1} = pctg;
    pctgs_train{i,1} = pctg_train;
    records{i,1} = record;
    
end

pctgs = cell2mat(pctgs);
pctgs_train = cell2mat(pctgs_train);
meanPctg = mean(pctgs);

end

