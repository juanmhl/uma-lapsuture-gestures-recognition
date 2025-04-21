function [model, pctg, pctg_train, pctg_window, pctg_filter, pctg_circle] = trainAndEvalVMM(E_train, S_train, E_test, S_test, config)

% Model building
[A,B] = hmmestimate(E_train,S_train);
A = A+1e-30;    % For some reason I dont remember
B = B+1e-30;
model.A = A;
model.B = B;

% Model testing
S_test_estimate = hmmviterbi(E_test, model.A, model.B);
pctg = sum(S_test==S_test_estimate)/length(S_test);

S_train_estimate = hmmviterbi(E_train, model.A, model.B);
pctg_train = sum(S_train==S_train_estimate)/length(S_train);

if config.compute_additional_pctgs
    S_test_estimate = test_vmm_experiment(E_test,model.A,model.B,config.window_width);
    pctg_window = sum(S_test==S_test_estimate)/length(S_test);
    
    S_test_estimate = mov_mode(S_test_estimate, config.filter_pond, config.filter_width);
    pctg_filter = sum(S_test==S_test_estimate)/length(S_test);
    
    S_test_estimate = circshift(S_test_estimate,-config.circle_offset);
    pctg_circle = sum(S_test==S_test_estimate)/length(S_test);
else
    pctg_window = NaN;
    pctg_filter = NaN;
    pctg_circle = NaN;
end


end

