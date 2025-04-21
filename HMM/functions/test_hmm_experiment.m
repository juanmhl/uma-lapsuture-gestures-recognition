function states = test_hmm_experiment(emisions,A,B,window_size)
    l = length(emisions);
    states = zeros(size(emisions));
    for i = 1:l
        if i<=window_size
            states(i) = test_hmm_window(emisions(1:i),A,B);
        else
            states(i) = test_hmm_window(emisions((i-window_size):i),A,B);
        end
    end
end