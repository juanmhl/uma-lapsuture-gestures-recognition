function most_possible_hmm = test_hmm_window(emisions,A,B)
    max_prob = -Inf;
    most_possible_hmm = -5;
    for i = 1:size(A,3)
%         Ak = squeeze(A(i,:,:));
%         Ak = reshape(Ak,[real(sqrt(length(Ak))),real(sqrt(length(Ak)))])
        [~,logpseq] = hmmdecode(emisions,A(:,:,i),B(:,:,i));
%         [~,logpseq] = hmmdecode(emisions,Ak,B(i,:,:));
        if logpseq > max_prob
            max_prob = logpseq;
            most_possible_hmm = i;
        end
    end
end 