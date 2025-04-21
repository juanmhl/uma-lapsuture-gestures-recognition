function [trained_net, train_records, Y_predicted, pctg, pctg_train] = trainAndTestMLP(X_train, Y_train, X_test, Y_test, architecture, config)


% Define NN structure
net = patternnet(architecture);
net = configure(net,X_train,Y_train);

%% Change final transfer function to something

% %% openExample('nnet/ConstructAndTrainAPatternRecognitionNeuralNetworkExample')
% Mirar ese ejemplo para sacar una red neuronal con capas densas internas
% pero con mas de una salida (doc en
% https://es.mathworks.com/help/deeplearning/ref/patternnet.html )

% % Training options
% net.trainFcn = ;
net.trainParam.epochs = config.epochs;
% net.trainParam.goal = ;
% net.trainParam.lambda = ;
net.trainParam.max_fail = config.patience;
% net.trainParam.min_grad = ;
% net.trainParam.show = ;
% net.trainParam.showCommandLine = ;
% net.trainParam.showWindow = ;
% net.trainParam.sigma = ;
% net.trainParam.time = 30;

%% Change transfer functions
% for i = 1:(length(net.layers)-1)
%     net.layers{i}.transferFcn = 'poslin';       % ReLu
% end


%% Dataset partiotioning options (for validation procedure)
net.divideFcn = 'dividerand';
net.divideParam.trainRatio = 1 - config.validationPercentage;
net.divideParam.valRatio = config.validationPercentage;
net.divideParam.testRatio = 0;

%% For some reason to be able to use gpu:
net.output.processFcns = {'mapminmax'};

%% Training
[trained_net,train_records] = train(net,X_train,Y_train,...
            'showResources', 'no', ...
            'useGPU', 'yes' ...
           );

%% Porcentaje de acierto
Y_predicted = sim(trained_net,X_test);
pctg = sum(vec2ind(Y_predicted) == vec2ind(Y_test))/length(vec2ind(Y_test));

%% Compara con el de entrenamiento
Y_train_predicted = sim(trained_net,X_train);
pctg_train = sum(vec2ind(Y_train_predicted) == vec2ind(Y_train))/length(vec2ind(Y_train));

disp(pctg)



end
