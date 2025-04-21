clear all

% Data selection
manoeuvre = 'Suturing';    % Must be written with simple ' instead of "
vars_per_experiment = 8;

% Load experiment labels
load(strcat('E2_csv_to_matlab/MATLAB_data/',manoeuvre,'_labels.mat'));
% Load kinematic data
load(strcat('E2_csv_to_matlab/MATLAB_data/',manoeuvre,'.mat'));
% Load kinematic data (raw)
load(strcat('E2_csv_to_matlab/MATLAB_data/',manoeuvre,'_all_data.mat'));
% Load gripper angles
load(strcat('E2_csv_to_matlab/MATLAB_data/',manoeuvre,'_gripper_angle.mat'));

% Labeled training data will consist of:
% - Relative data (Belen, 4 vars) + dist velocity
% - Gripper aperture angles
% - All kinematic data (relative, not absolute measures)
%   - Orientation in Euler angles (ZYX)
%   - All velocity components (in x, y and z)

%% Store all data samples in matrix X 
% (each row is a data sample, for all 'Manouevre' experiments, and each row
% is a variable)

% Select all vars in workspace
vars = who;

% Iterate through all variable names in the workspace, calc metrics, ands
% strore them in seq and states vectors
i = 1;

% Initial vectors

X = [];
% Each sample point in X is a column
% X = [X1 X2 ... Xn]

% Order of the variables:
Xn_names = [ "dist"
    "angle"
    "vel_norm_left"
    "vel_norm_right"
    "gripper_angle_left "
    "gripper_angle_right"
    "eulerZ_left"
    "eulerY_left"
    "eulerX_left"
    "eulerZ_right"
    "eulerY_right"
    "eulerX_right"
    "vel_left_x "
    "vel_left_y"
    "vel_left_z"
    "vel_right_x"
    "vel_right_y"
    "vel_right_z"
    "vel_ang_left_x"
    "vel_ang_left_y"
    "vel_ang_left_z"
    "vel_ang_right_x"
    "vel_ang_right_y"
    "vel_ang_right_z"];

% Also, store all labels in a variable
X_labels = [];

while(i <= length(vars))
    varname = vars{i};

    % Check if the variable name starts with the expected prefix and other
    % subchains
    if startsWith(varname, manoeuvre)
%     if (contains(varname,manoeuvre) && contains (varname, surgeon) && ~contains(varname,'1') && ~contains(varname,'2'))
%     if (contains(varname,manoeuvre) && contains (varname, surgeon))
%     if (contains(varname,manoeuvre) && contains(varname, surgeon) && ~contains(varname, '2'))
        try

            % Extract the suffix of the variable name (e.g. Suturing_B001, Suturing_B002, etc.)
            experiment_name = varname(1:length(manoeuvre)+5);

            % Load the variables from the workspace
            T_left  = eval(strcat(experiment_name,'_T_left'));
            T_right = eval(strcat(experiment_name,'_T_right'));
            vel_left  = eval(strcat(experiment_name,'_vel_left'));
            vel_right = eval(strcat(experiment_name,'_vel_right'));
            gripper_angle_left  = eval(strcat(experiment_name,'_gripper_angle_left'));
            gripper_angle_right = eval(strcat(experiment_name,'_gripper_angle_right'));
            data = eval(strcat(experiment_name,'_all_data'));
            labels = eval(strcat(experiment_name,'_labels'));
            labels = [labels, zeros(1,length(data)-length(labels))];

            % Generate column samples for a given experiment

            dv = [];
            av = [];
            vlv = [];
            vrv = [];
            euler_left_v = [];
            euler_right_v = [];
            vel_left_xyz_v = [];
            vel_right_xyz_v = [];
            vel_ang_left_xyz_v = [];
            vel_ang_right_xyz_v = [];

            for k = 1:length(T_right)
                % Calc. belen metrics from kinematic data
                [d, a, vl, vr] = calc_metrics(T_left(:,:,k), T_right(:,:,k), ...
                    vel_left(:,:,k), vel_right(:,:,k));
                dv = [dv d];
                av = [av a];
                vlv = [vlv vl];
                vrv = [vrv vr];
    
                % Calc euler angles
                euler_left = rotm2eul(T_left(1:3,1:3,k))';
                euler_right = rotm2eul(T_right(1:3,1:3,k))';
                euler_left_v = [euler_left_v euler_left];
                euler_right_v = [euler_right_v euler_right];

                % Calc. raw velocities
                vel_left_xyz = vel_left(:,1,k);
                vel_ang_left_xyz = vel_left(:,2,k);
                vel_right_xyz = vel_right(:,1,k);
                vel_ang_right_xyz = vel_right(:,2,k);
                vel_left_xyz_v = [vel_left_xyz_v vel_left_xyz];
                vel_right_xyz_v = [vel_right_xyz_v vel_right_xyz];
                vel_ang_left_xyz_v = [vel_ang_left_xyz_v vel_ang_left_xyz];
                vel_ang_right_xyz_v = [vel_ang_right_xyz_v vel_ang_right_xyz];

            end

            % Set up Xn matrix
            Xn = [ dv;
                av;
                vlv;
                vrv;
                gripper_angle_left';
                gripper_angle_right';
                euler_left_v;
                euler_right_v;
                vel_left_xyz_v;
                vel_right_xyz_v;
                vel_ang_left_xyz_v;
                vel_ang_right_xyz_v];

            X = [X Xn];
            X_labels = [X_labels, labels];
            

        catch ME
            disp(strcat("Exception raised: ", ME.message))

        end

        i = i+vars_per_experiment;

    else
        i = i+1;

    end
end

% X matrix should be a matrix where each row corresponds to one sample
X_fs = X';
Y_fs = categorical(X_labels');

%% Feature selection con PCA
X_fs_avg = mean(X,2);
nPoints = size(X_fs,1);
B = X_fs - (X_fs_avg*ones(1,nPoints))';
[coeff,score,latent,tsquared,explained,mu] = pca(B);
explained

% % Ponderacion de componentes principales por la varianza asociada
coeff_pond = latent'*coeff';
coeff_pond_norm = abs(coeff_pond);

[scores, idx_pca] = sort(coeff_pond_norm, ['descend']);
save('idx_pca.mat',"idx_pca")
save("pca_w.mat","coeff")

% Order of the variables:
Xn_names = [ "dist"
    "angle"
    "vel_norm_left"
    "vel_norm_right"
    "gripper_angle_left "
    "gripper_angle_right"
    "eulerZ_left"
    "eulerY_left"
    "eulerX_left"
    "eulerZ_right"
    "eulerY_right"
    "eulerX_right"
    "vel_left_x "
    "vel_left_y"
    "vel_left_z"
    "vel_right_x"
    "vel_right_y"
    "vel_right_z"
    "vel_ang_left_x"
    "vel_ang_left_y"
    "vel_ang_left_z"
    "vel_ang_right_x"
    "vel_ang_right_y"
    "vel_ang_right_z"];

% New order of the variables:
Xn_sorted = Xn_names(idx_pca)

%% Para plotear
figure;
somenames = [ "dist"
    "angle"
    "vel\_norm\_left"
    "vel\_norm\_right"
    "gripper\_angle\_left "
    "gripper\_angle\_right"
    "eulerZ\_left"
    "eulerY\_left"
    "eulerX\_left"
    "eulerZ\_right"
    "eulerY\_right"
    "eulerX\_right"
    "vel\_left\_x "
    "vel\_left\_y"
    "vel\_left\_z"
    "vel\_right\_x"
    "vel\_right\_y"
    "vel\_right\_z"
    "vel\_ang\_left\_x"
    "vel\_ang\_left\_y"
    "vel\_ang\_left\_z"
    "vel\_ang\_right\_x"
    "vel\_ang\_right\_y"
    "vel\_ang\_right\_z"];

barh(flip(coeff_pond_norm(idx_pca)))
xlim([-1,14.5])
yticks(1:24)
set(gca,'yticklabel',flip(somenames(idx_pca)))
title("Selección de Componentes con PCA")
ylabel("Variable")
xlabel("Aportación de cada variable a la varianza de X")

%%
[U,S,V] = svd(B,'econ');
S
size(V)
%% Testeo de idx con una red neuronal
% Probar a entrenar modelo con los N mas significativos
% Sort original X according to idx
X = X(idx_pca,:);
% Select top 10 features
X = X(1:10,:);
% Selecto bottom 22 features
% X = X(15:24,:);

% Hay que construir el vector de etiquetas en condiciones, vectores columna con solo 1 en 
% la fila que se corresponda al gesto que sea, el resto, 0
X_labels_norm = zeros([max(X_labels)+1, length(X_labels)]);

for i = 1:length(X_labels)
    index = X_labels(i)+1;
    X_labels_norm(index,i) = 1;
end

% Define NN structure

hidden_layers = [50 50 50]

% net = feedforwardnet(hidden_layers);
net = patternnet(hidden_layers);
net = configure(net,X,X_labels_norm);
% view(net);

% Change final transfer function to something
% net.layers{2}.transferFcn = 'logsig';
% view(net);

% %% openExample('nnet/ConstructAndTrainAPatternRecognitionNeuralNetworkExample')
% Mirar ese ejemplo para sacar una red neuronal con capas densas internas
% pero con mas de una salida (doc en
% https://es.mathworks.com/help/deeplearning/ref/patternnet.html )

% % Training options
% net.trainFcn = ;
net.trainParam.epochs = 2000;
% net.trainParam.goal = ;
% net.trainParam.lambda = ;
% net.trainParam.max_fail = ;
% net.trainParam.min_grad = ;
% net.trainParam.show = ;
% net.trainParam.showCommandLine = ;
% net.trainParam.showWindow = ;
% net.trainParam.sigma = ;
% net.trainParam.time = ;

% Divide dataset into train and test for later evaluation

% Define your training percentage
trainPercentage = 0.7;

% Define your testing percentage
testPercentage = 0.3;

% Define a random partition of your data into training and testing sets
c = cvpartition(size(X,2),'HoldOut',testPercentage);

% Define your training and testing indices
trainIdx = c.training(1);
testIdx = c.test(1);

% Extract your training and testing data and labels
trainData = X(:,trainIdx);
trainLabels = X_labels_norm(:,trainIdx);
testData = X(:,testIdx);
testLabels = X_labels_norm(:,testIdx);

% Dataset partiotioning options
net.divideFcn = 'dividerand';
net.divideParam.trainRatio = 0.8;
net.divideParam.valRatio = 0.2;
net.divideParam.testRatio = 0;

% Training
net = train(net,trainData,trainLabels,...
            'showResources', 'yes' ...
           );

labels_out = sim(net,testData);

% Porcentaje de acierto
pctg = sum(vec2ind(labels_out) == vec2ind(testLabels))/length(vec2ind(testLabels))
% Solo un 0.8835, bajo en comparacion a nca, que era del 0.9360

% Analisis de la matriz de confusion
conf = confusionmat(vec2ind(labels_out),vec2ind(testLabels));
figure; plotconfusion(vec2ind(labels_out),vec2ind(testLabels));
c_prctg = zeros(2,length(conf));

muestras = zeros(1,length(conf));

for i = 1:length(conf)
    c_prctg(1,i) = 1 - (conf(i,i)/sum(conf(i,:))); 
    c_prctg(2,i) = 1 - (conf(i,i)/sum(conf(:,i))); 
    muestras(i) = sum(conf(:,i));
end

figure;
plot(muestras,c_prctg(2,:),'*')

[fitdata, gof, output] = fit(muestras',c_prctg(2,:)','poly1')
figure;
plot(fitdata,muestras,c_prctg(2,:))
