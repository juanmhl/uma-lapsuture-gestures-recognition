%% Load data
clear all
close all
load("NewFolders/Data/Matlab_data/Suturing_features_data_clean.mat");
load("NewFolders/Common/Feature_Selection/ReliefF/idx_Suturing_relieff.mat", "idx");

user = 4;
trial = 1;

% Extract experiment
X = featuresData{user,trial}';
X = X(idx,:);
Y = labelsData{user,trial}'+1;

% Convert gestures from JIGSAWS to our own from our paper
original_gestures = [1, 2, 3, 4, 5, 6, 7, 9, 10, 11, 12];
new_gestures =      [1, 1, 2, 3, 5, 1, 4, 2, 4,  4,  6];

Y = labels_grouping(Y,original_gestures,new_gestures);

%% Figure configuration

vertical = 500;
relation = 1.2;
size = [vertical floor(vertical/relation)];
lineWidth =  1.7;
markerSize =   8;
titleSize =   13.5;
axisSize =    16;
legendSize =  14;
numbersSize = 16;

%% Apply HMM

close all

load("NewFolders\HMM\results\results0912.mat", "results_24v");
load("NewFolders\Common\Data_discretization\centroids.mat", "centroids_hmm_10v", "centroids_hmm_24v");

color = 'r';

% fold = 5;

tit = "One HMM per gesture, experiment E1";

for fold = 1:10
model_hmm = results_24v{8,1}{fold};

E = dsearchn(centroids_hmm_24v{3}, X(:,1:3:end)');
t = 1:length(E);
t = t./10;

Y_hmm = test_hmm_experiment(E, model_hmm.A, model_hmm.B, 20);

pond = ones(1,15);
Y_hmm = mov_mode(Y_hmm', pond, length(pond))';

shift = ceil(length(pond)/2);

Y_hmm = circshift(Y_hmm,-shift);

% acc = sum(Y_hmm == Y(:,1:3:end)')/length(Y_hmm);
% tit = strcat("Fold: ", num2str(fold), ", Accuracy: ", num2str(acc));

plot_a_figure(t,Y(:,1:3:end),Y_hmm, color, size, lineWidth, markerSize, titleSize, axisSize, legendSize, numbersSize, tit)


end


%% Apply VMM

load("NewFolders\VMM\results\results1007.mat", "results_24v");
load("NewFolders\Common\Data_discretization\centroids_norm.mat", "centroids_hmm_24v");
close all

% fold = 7;
downsampling_rate = 6;
model = 1;
emissions = 1;

color = 'm';

tit = "One HMM for the manoeuvre, experiment E1";

for fold = 1:10
    model_vmm = results_24v{model,1}{fold};

    % X_norm = normalize(X(:,1:downsampling_rate:end)',2,"range");
    X_nonorm = X(:,1:downsampling_rate:end)';
    E = dsearchn(centroids_hmm_24v{emissions}, X_nonorm);

    freq = 30 / downsampling_rate;

    t = 1:length(E);
    t = t./freq;

    Y_vmm = test_vmm_experiment(E,model_vmm.A, model_vmm.B, 20);

    pond = ones(1,15);
    Y_vmm = mov_mode(Y_vmm', pond, length(pond))';

    shift = ceil(length(pond)/2);

    Y_vmm = circshift(Y_vmm,-shift);

    % acc = sum(Y_vmm == Y(:,1:downsampling_rate:end)')/length(Y_vmm);
    % tit = strcat("Fold: ", num2str(fold), ", Accuracy: ", num2str(acc));

    plot_a_figure(t,Y(:,1:downsampling_rate:end),Y_vmm, color, size, lineWidth, markerSize, titleSize, axisSize, legendSize, numbersSize, tit)


end


%% Apply MLP

load("..\..\Mi unidad\results_mlp_0924.mat", "results_24v");
close all

% fold = 1;
model = 11 % [100 100]

color = 'b';

tit = "MLP classifier, experiment E1";

for fold = 1:10
    model_mlp = results_24v{1,model}{fold};

    Y_mlp = sim(model_mlp,X);
    Y_mlp = vec2ind(Y_mlp);

    pond = ones(1,15);
    Y_mlp = mov_mode(Y_mlp, pond, length(pond));

    shift = ceil(length(pond)/2);

    Y_mlp = circshift(Y_mlp,-shift);

    t = (1:length(Y))/30;

    % acc = sum(Y_mlp == Y)/length(Y_mlp);
    % tit = strcat("Fold: ", num2str(fold), ", Accuracy: ", num2str(acc))
    
    plot_a_figure(t,Y,Y_mlp, color, size, lineWidth, markerSize, titleSize, axisSize, legendSize, numbersSize, tit)

end



%% Functions

function plot_a_figure(t, Y, Y_out, color, size, lineWidth, markerSize, titleSize, axisSize, legendSize, numbersSize, tit)

figure('Position', [100, 100, size]);
hold on

% Increase line width for the green plot
plot(t, Y, 'g', 'LineWidth', lineWidth)

% Increase marker size for the magenta plot
plot(t, Y_out, strcat(color,'.'), 'MarkerSize', markerSize)

% Increase title font size
title(tit, 'FontSize', titleSize)

ax = gca;
ax.FontName = "Times New Roman";
% xlim([0,1.05]) % Uncomment if you want to set a specific x-axis limit
yticks(1:6)
xticks(0:20:120)
xlim([0,121])
ylim([1,6.05])
grid on

% Increase font size for x and y labels
xlabel('Time (s)', 'FontSize', axisSize)
ylabel('Gesture G_i', 'FontSize', axisSize)

% Increase font size for legend
legend('Ground truth', 'Classifier output', 'Location', 'northwest', 'FontSize', legendSize)

% Increase line width for grid lines
set(gca, 'GridLineStyle', '-', 'GridAlpha', 0.3, 'GridColor', [0.8 0.8 0.8], 'LineWidth', 1)

% Increase font size for axis tick labels
ax.FontSize = numbersSize;



end


