function [e,labels] = build_e_from_gestures(gesture_discrete)

e = [];
labels = [];
% seq_cells = {};
% labels_cells = {};
% for i = 1:length(gesture_discrete)
%     seq_cells{end+1} = gesture_discrete{i};
%     labels_cells{end+1} = i;
% end
% 
% for i = 1:length(seq_cells)
%     e_step = seq_cells{i}{1};
%     l_step = ones(1,length(e_step))*labels_cells{i};
%     e = [e e_step];
%     labels = [labels l_step];
% end

for i = 1:length(gesture_discrete)
    e_step = gesture_discrete{i};
    l_step = ones(1,length(e_step))*i;
    e = [e e_step'];
    labels = [labels l_step];
end

end