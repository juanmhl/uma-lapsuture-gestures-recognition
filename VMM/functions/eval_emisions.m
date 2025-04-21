function state = eval_emisions(e,A,B)

    w = [1 2 3 4 5];
    
    s = hmmviterbi(e,A+1e-15,B+1e-15);
    
    if length(s)>length(w)
        last_s = s(end-length(w)+1:end);
        state = weightedmode(last_s,w);
    else
        state = s(end);
    end

end


function mode_val = weightedmode(x, w)
    % x: vector of values
    % w: vector of corresponding weights
    [unique_x, ~, idx] = unique(x);
    weighted_count = accumarray(idx, w);
    [~, max_idx] = max(weighted_count);
    mode_val = unique_x(max_idx);
end

    