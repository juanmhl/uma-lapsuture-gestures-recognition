function last_state = test_vmm_window(emisions,A,B)
    states = hmmviterbi(emisions,A+1e-30,B+1e-30);
    last_state = states(end);
end