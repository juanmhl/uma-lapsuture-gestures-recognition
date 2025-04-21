function last_state_robust = test_vmm_window_robust(emisions,A,B)
    states_1 = hmmviterbi(emisions,A,B);
    states_2 = hmmviterbi(emisions,A,B);
    states_3 = hmmviterbi(emisions,A,B);
    last_state_robust = mode([states_1(end), states_2(end), states_3(end)]);
end

% function last_state_robust = test_vmm_window_robust(emisions,A,B)
%     states_1 = hmmviterbi(emisions,A+1e-30,B+1e-30);
%     states_2 = hmmviterbi(emisions,A+1e-30,B+1e-30);
%     states_3 = hmmviterbi(emisions,A+1e-30,B+1e-30);
%     last_state_robust = mode([states_1(end), states_2(end), states_3(end)]);
% end