function result = getHlayersStr(hlayers)
    % Convert each element of the vector to a string
    str_hlayers = cellfun(@(x) num2str(x), num2cell(hlayers), 'UniformOutput', false);
    
    % Join the elements with an underscore delimiter
    result = strjoin(str_hlayers, '_');
end
