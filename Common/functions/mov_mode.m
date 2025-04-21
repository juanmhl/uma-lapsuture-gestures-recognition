function output = mov_mode(input,pond,L)
% Moving mode filter, takes as an input a vector, and outputs a vector of
% the moving mode, when using a window of length L. (most repeated value in
% each window).
% 
% The parameter pond lets the user decide the ponderation of the vector
% elements.

assert(length(pond)==L, 'pond vector is not of length L');
assert(~isempty(input), 'empty input vector')

output = zeros(size(input));

for i = 1:length(input)
    if (i<L)
        output(i) = mode(input(1:i));
    else
        interm_vector = input(i-L+1:i);
        for j = 1:length(pond)
            for k = 1:pond(j)
                interm_vector = [interm_vector, interm_vector(j)];
            end
        end
        output(i) = mode(interm_vector);
    end
end
