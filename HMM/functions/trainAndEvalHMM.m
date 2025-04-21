function [model, pctgTest, pctgTrain] = trainAndEvalHMM(gesturesTrain, gesturesTest, nStates, nEmissions, nTriangular, config)

% ---- Training ---- %
A_gestures = zeros(nStates,nStates,length(gesturesTrain));
B_gestures = zeros(nStates,nEmissions,length(gesturesTrain));

for i = 1:length(gesturesTrain)

    % Initial seeds
    Ak=tril(ones(nStates),nTriangular)-tril(ones(nStates),-nTriangular);
    for ak=1:nStates
        Ak(ak,:)=Ak(ak,:)./sum(Ak(ak,:));
    end
    Bk = ones( nStates, nEmissions ).*( 1/nEmissions );

    % Training each gesture
    try
        disp(strcat("---------  Training for gesture G", num2str(i-1),"  -------------"))
        e = gesturesTrain{i};
        [ A, B ] = hmmtrain(e, Ak, Bk, ...
            'Algorithm', 'BaumWelch', ...
            'Verbose', config.verbose, ...
            'Maxiterations', config.max_iter, ...
            'Tolerance',config.tolerance ...
            );
        % disp(strcat("---------  Trained for gesture G", num2str(i-1),"  -------------"))
        % disp("-----------------------------------------------")

        A_gestures(:,:,i) = A;
        B_gestures(:,:,i) = B;

    catch ME
        disp(strcat("Exception raised: ", ME.message))
        A_gestures(:,:,i) = ones(size(Ak))*NaN;
        B_gestures(:,:,i) = ones(size(Bk))*NaN;
    end
end

model.A = A_gestures;
model.B = B_gestures;


% ---- Testing ---- %
% pctg = evalua(e,X_labels,Aj,Bj,w)

[eTest, eLabels] = build_e_from_gestures(gesturesTest);
eLabelsPredicted = test_hmm_experiment(eTest,A_gestures,B_gestures,config.test_window_width);

% As there is no gesture 7 (8) the model is one gesture short so that has
% to be fixed somewhere. eTest are emissions (no problem there) but
% eLabelsPredicted are the corresponding labels between 1 and 11 so:
% 8 means 9, 9 means 10 and so on because !!!!!!  HALT eLabelsPredicted 
% should be the same so there would  be no problem there --> nothing to fix

pctgTest = sum((eLabelsPredicted)==eLabels)/length(eLabels);

% We compute pctgTrain similarly
[eTrain, eLabels] = build_e_from_gestures(gesturesTrain);
eLabelsPredicted = test_hmm_experiment(eTrain,A_gestures,B_gestures,config.test_window_width);
pctgTrain = sum((eLabelsPredicted)==eLabels)/length(eLabels);
% pctgTrain = NaN;

% for i = 1:length(eLabelsPredicted)
%     if eLabelsPredicted(i) == -5
%         eLabelsPredicted(i) = 0;
%     end
% end

% eLabelsPredicted = eLabelsPredicted+1;
% eLabels = eLabels+1;


end