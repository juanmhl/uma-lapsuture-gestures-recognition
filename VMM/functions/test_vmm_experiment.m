function states = test_vmm_experiment(emisions,A,B,window_size)
    l = length(emisions);
    states = zeros(size(emisions));
    for i = 1:l
        if i<=window_size
            states(i) = test_vmm_window_robust(emisions(1:i),A,B);
        else
            states(i) = test_vmm_window_robust(emisions((i-window_size):i),A,B);
        end
    end
end


% 
% function states = test_vmm_experiment(X,centroids,A,B,window_size)
%     emisions = dsearchn(centroids, X')';
%     l = length(emisions);
%     states = zeros(size(emisions));
%     for i = 1:l
%         if i<=window_size
%             states(i) = test_vmm_window_robust(emisions(1:i),A,B);
%         else
%             states(i) = test_vmm_window_robust(emisions((i-window_size):i),A,B);
%         end
%     end
% end