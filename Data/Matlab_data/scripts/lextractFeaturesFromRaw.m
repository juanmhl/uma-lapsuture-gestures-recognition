function data = lextractFeaturesFromRaw(raw)
% This function applies over the kinematicsData cell matrix and applies
% the 24 vars extraction for each sample of each experiment of each user.

    data = cell(size(raw));
    nFeatures = 24;
    for i = 1:size(raw,1)   % iterates users
        for j = 1:size(raw,2)   % iterates experiments
            experimentFeatures = zeros(size(raw{i,j},1),nFeatures);
            for k = 1:length(raw{i,j})  % iterates samples
                sample = raw{i,j}(k,:);
                features = featuresFromSample(sample);
                experimentFeatures(k,:) = features;
            end
            data{i,j} = experimentFeatures;
        end
    end
end