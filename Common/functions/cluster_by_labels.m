function clustered_data = cluster_by_labels(labels, data)
% CLUSTER_BY_LABELS Clusters data based on labels, preserving consecutive occurrences.
%   clustered_data = CLUSTER_BY_LABELS(labels, data) returns a cell array of
%   clustered data, where each cell corresponds to a unique label and contains
%   another cell array of data clusters for that label.
%
%   Inputs:
%       labels - A vector of labels corresponding to each data point
%       data - A vector or matrix of data points to be clustered
%
%   Output:
%       clustered_data - A cell array where each cell contains clusters for a unique label

    unique_labels = unique(labels);
    clustered_data = cell(length(unique_labels), 1);
    
    for i = 1:length(unique_labels)
        label = unique_labels(i);
        label_indices = find(labels == label);
        
        % Find breaks in consecutive indices
        breaks = find(diff(label_indices) > 1);
        
        % Create cell array for this label
        label_clusters = cell(length(breaks) + 1, 1);
        
        % Extract clusters
        start_idx = 1;
        for j = 1:length(breaks)
            end_idx = breaks(j);
            label_clusters{j} = data(label_indices(start_idx:end_idx), :);
            start_idx = end_idx + 1;
        end
        
        % Last cluster
        label_clusters{end} = data(label_indices(start_idx:end), :);
        
        clustered_data{i} = label_clusters;
    end
end