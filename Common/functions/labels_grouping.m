function new_vector = labels_grouping(input_vector, original_values, new_values)
    if length(original_values) ~= length(new_values)
        error('original_values and new_values must have the same length');
    end
    
    new_vector = zeros(size(input_vector));
    
    for i = 1:length(input_vector)
        value = input_vector(i);
        index = find(original_values == value, 1);
        
        if isempty(index)
            error('Value %d not found in original_values', value);
        else
            new_vector(i) = new_values(index);
        end
    end
end