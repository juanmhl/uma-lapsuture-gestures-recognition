function [models, pctgsTest, pctgsTrain, meanPctg] = trainAndEvalHMMkfolds(gestures, nStates, nEmissions, nTriangular, config, k)

models = cell(k,1);
pctgsTest = cell(k,1);
pctgsTrain = cell(k,1);


for fold = 1:k
    % Construct train and test datasets
    gesturesTrain = cell(size(gestures));
    gesturesTest = cell(size(gestures));

    for g = 1:length(gestures)
        l = fix(size(gestures{g},1)/k);
        testIdx = zeros(1,size(gestures{g},1));
        trainIdx = ones(1,size(gestures{g},1));

        testIdx(1,((fold-1)*l+1):(fold*l)) = 1;
        trainIdx = trainIdx - testIdx;

        testIdx = logical(testIdx);
        trainIdx = logical(trainIdx);

        gesturesTest{g} = gestures{g}(testIdx);
        gesturesTrain{g} = gestures{g}(trainIdx);        
    end

    % Train and eval
    [model, pctgTest, pctgTrain] = trainAndEvalHMM(gesturesTrain, ...
        gesturesTest, nStates, nEmissions, nTriangular, config);

    models{fold,1} = model;
    pctgsTest{fold,1} = pctgTest;
    pctgsTrain{fold,1} = pctgTrain;

end

pctgsTrain = cell2mat(pctgsTrain);
pctgsTest = cell2mat(pctgsTest);
meanPctg = mean(pctgsTest);

end