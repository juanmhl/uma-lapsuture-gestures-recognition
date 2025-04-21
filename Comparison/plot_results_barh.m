close

%% HMM

clear
load('NewFolders\HMM\results\results0912.mat');

r10 = cell2mat(results_10v(:,4));
r24 = cell2mat(results_24v(:,4));

resultados_hmm = [r10; r24].*100;

labels = ["30 emissions, 5 states, V''";
          "30 emissions, 10 states, V''";
          "30 emissions, 30 states, V''";
          "60 emissions, 5 states, V''";
          "60 emissions, 10 states, V''";
          "60 emissions, 30 states, V''";
          "120 emissions, 5 states, V''";
          "120 emissions, 10 states, V''";
          "120 emissions, 30 states, V''";
          "30 emissions, 5 states, V'";
          "30 emissions, 10 states, V'";
          "30 emissions, 30 states, V'";
          "60 emissions, 5 states, V'";
          "60 emissions, 10 states, V'";
          "60 emissions, 30 states, V'";
          "120 emissions, 5 states, V'";
          "120 emissions, 10 states, V'";
          "120 emissions, 30 states, V'";];


% Sort results and labels in descending order
[sortedResults, sortIndex] = sort(resultados_hmm, 'descend');
sortedLabels = labels(sortIndex);

% Create the horizontal bar plot
figure('Position', [100, 100, 450 350]);
barh(sortedResults)

ax = gca;
ax.FontName = "Times New Roman";
% xlim([0,1.05])  % Uncomment if you want to set a specific x-axis limit
yticks(1:length(labels))
set(gca, 'YTickLabel', sortedLabels)
title({"Accuracies of the models,", "one HMM per G_i"})
ylabel("Classifier configuration")
xlabel("Accuracy")
xlim([40, 75])

% Invert the y-axis to have highest value at the top
set(gca, 'YDir', 'reverse')

% Add text labels with accuracy values
labelOffset = 0.5; % Offset for labels from the end of bars
for i = 1:length(sortedResults)
    text(sortedResults(i) + labelOffset, i, sprintf('%.2f%%', sortedResults(i)), ...
         'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle', ...
         'FontName', 'Times New Roman')
end

% Adjust the position of the text labels to avoid overlap with bars
ax = gca;
ax.XLim(2) = ax.XLim(2) + 3; % Extend x-axis limit to make room for labels

%% VMM

clear
load('NewFolders\VMM\results\results1007.mat');

r10 = cell2mat(results_10v(:,4));
r24 = cell2mat(results_24v(:,4));

resultados_hmm = [r10; r24].*100;

labels = ["500 emissions, 5 Hz, V''";
          "500 emissions, 1 Hz, V''";
          "500 emissions, 0.5 Hz, V''";
          "2000 emissions, 5 Hz, V''";
          "2000 emissions, 1 Hz, V''";
          "2000 emissions, 0.5 Hz, V''";
          "5000 emissions, 5 Hz, V''";
          "5000 emissions, 1 Hz, V''";
          "5000 emissions, 0.5 Hz, V''";
          "500 emissions, 5 Hz, V'";
          "500 emissions, 1 Hz, V'";
          "500 emissions, 0.5 Hz, V'";
          "2000 emissions, 5 Hz, V'";
          "2000 emissions, 1 Hz, V'";
          "2000 emissions, 0.5 Hz, V'";
          "5000 emissions, 5 Hz, V'";
          "5000 emissions, 1 Hz, V'";
          "5000 emissions, 0.5 Hz, V'";];


% Sort results and labels in descending order
[sortedResults, sortIndex] = sort(resultados_hmm, 'descend');
sortedLabels = labels(sortIndex);

% Create the horizontal bar plot
figure('Position', [100, 100, 450 350]);
barh(sortedResults)

ax = gca;
ax.FontName = "Times New Roman";
% xlim([0,1.05])  % Uncomment if you want to set a specific x-axis limit
yticks(1:length(labels))
set(gca, 'YTickLabel', sortedLabels)
title({'Accuracies of the models,'; 'one HMM per manoeuvre'})
ylabel("Classifier configuration")
xlabel("Accuracy")
xlim([15, 30])

% Invert the y-axis to have highest value at the top
set(gca, 'YDir', 'reverse')

% Add text labels with accuracy values
labelOffset = 0.5; % Offset for labels from the end of bars
for i = 1:length(sortedResults)
    text(sortedResults(i) + labelOffset, i, sprintf('%.2f%%', sortedResults(i)), ...
         'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle', ...
         'FontName', 'Times New Roman')
end

% Adjust the position of the text labels to avoid overlap with bars
ax = gca;
ax.XLim(2) = ax.XLim(2) + 3; % Extend x-axis limit to make room for labels


%% MLP

clear
load('..\..\Mi unidad\results_mlp_0924.mat');

r10 = cell2mat(results_10v(5,:));
r24 = cell2mat(results_24v(5,:));

resultados_mlp = [r10, r24].*100;

labels = ["1 layer, 10 neurons, V''";
          "2 layers, 10 neurons, V''";
          "3 layers, 10 neurons, V''";
          "1 layer, 30 neurons, V''";
          "2 layers, 30 neurons, V''";
          "3 layers, 30 neurons, V''";
          "1 layer, 50 neurons, V''";
          "2 layers, 50 neurons, V''";
          "3 layers, 50 neurons, V''";
          "1 layer, 100 neurons, V''";
          "2 layers, 100 neurons, V''";
          "3 layers, 100 neurons, V''";
          "1 layer, 10 neurons, V'";
          "2 layers, 10 neurons, V'";
          "3 layers, 10 neurons, V'";
          "1 layer, 30 neurons, V'";
          "2 layers, 30 neurons, V'";
          "3 layers, 30 neurons, V'";
          "1 layer, 50 neurons, V'";
          "2 layers, 50 neurons, V'";
          "3 layers, 50 neurons, V'";
          "1 layer, 100 neurons, V'";
          "2 layers, 100 neurons, V'";
          "3 layers, 100 neurons, V'";];


% Sort results and labels in descending order
[sortedResults, sortIndex] = sort(resultados_mlp, 'descend');
sortedLabels = labels(sortIndex);

% Create the horizontal bar plot
figure('Position', [100, 100, 450 450]);
barh(sortedResults)

ax = gca;
ax.FontName = "Times New Roman";
% xlim([0,1.05])  % Uncomment if you want to set a specific x-axis limit
yticks(1:length(labels))
set(gca, 'YTickLabel', sortedLabels)
title("Accuracies of the models, MLP")
ylabel("Classifier configuration")
xlabel("Accuracy")
xlim([60, 97])

% Invert the y-axis to have highest value at the top
set(gca, 'YDir', 'reverse')

% Add text labels with accuracy values
labelOffset = 0.5; % Offset for labels from the end of bars
for i = 1:length(sortedResults)
    text(sortedResults(i) + labelOffset, i, sprintf('%.2f%%', sortedResults(i)), ...
         'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle', ...
         'FontName', 'Times New Roman')
end

% Adjust the position of the text labels to avoid overlap with bars
ax = gca;
ax.XLim(2) = ax.XLim(2) + 3; % Extend x-axis limit to make room for labels