clear all
close all

% Data selection
% Data selection
manoeuvre = 'Suturing';    % Must be written with simple ' instead of "
surgeon = "E";
vars_per_experiment = 8;
trial = '1';

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
% Xn = [ dist
%        angle
%        vel_norm_left
%        vel_norm_right
%        gripper_angle_left
%        gripper_angle_right
%        eulerZYX_left
%        eulerZYX_right
%        vel_left_x
%        vel_left_y
%        vel_left_z
%        vel_right_x
%        vel_right_y
%        vel_right_z
%        vel_ang_left_x
%        vel_ang_left_y
%        vel_ang_left_z
%        vel_ang_right_x
%        vel_ang_right_y
%        vel_ang_right_z];

% Also, store all labels in a variable
X_labels = [];

while(i <= length(vars))
    varname = vars{i};

    % Check if the variable name starts with the expected prefix and other
    % subchains
    if startsWith(varname, manoeuvre) && contains (varname, surgeon) && contains (varname, trial)

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


%% Predict with NN
load("E4_surgeme_identification\E4_NN\resultados_net.mat");
labels_nn = sim(net_24v_100_100_100,X);
labels_nn = vec2ind(labels_nn)-1;
% labels_nn = mov_mode(labels_nn,[0 0 0],3);

%% Predict with VMM
load("E4_surgeme_identification\E1_VMM\modelos.mat");
load("E4_surgeme_identification\E1_VMM\centroids_24vars_5000.mat");
model = vmm_24v_5000c_3dsr;
Xin = X(:,1:3:end);
labels_vmm = test_vmm_experiment(Xin,centroids,model.A,model.B,20)-1;
% labels_vmm = mov_mode(labels_vmm,[0 0 0],3);

%% Plotting
figure;
t = 1:(1/30):2000;
t = t(1:length(X));
plot(t,X_labels,'g-');
hold on
% plot(t,labels_nn,'b.');
t = 1:(1/10):2000;
t = t(1:length(labels_vmm));
plot(t,labels_vmm,'r.');
title(strcat("Clasificación de frames para el experimento ", surgeon, num2str(trial), " - HMM"));
xlabel("Tiempo (s)")
ylabel("Gesto")
legend("Ground truth", "Clasifier output",'Location','northwest')
grid on

figure;
t = 1:(1/30):2000;
t = t(1:length(X));
plot(t,X_labels,'g-');
hold on
plot(t,labels_nn,'b.');
% title(strcat("Clasificación de frames para el experimento ", surgeon, num2str(trial), " - NN"));
title(strcat("Frame by frame classification for experiment ", surgeon, num2str(trial)));
xlabel("Time (s)")
ylabel("Gesture")
legend("Ground truth", "Clasifier output",'Location','northwest')
grid on

%% Plotting tras movmean
figure;
t = 1:(1/30):2000;
t = t(1:length(X));
plot(t,X_labels,'g-');
hold on
% plot(t,labels_nn,'b.');
t = 1:(1/10):2000;
t = t(1:length(labels_vmm));
% labels_vmm = mov_mode(labels_vmm,[0 0 0],3);
labels_vmm = mov_mode(labels_vmm,[0 0 0 0 0],5);
plot(t,labels_vmm,'r.');
title(strcat("Clasificación de frames para el experimento ", surgeon, num2str(trial), " - HMM (Moda Móvil)"));
xlabel("Tiempo (s)")
ylabel("Gesto")
legend("Ground truth", "Clasifier output",'Location','northwest')
grid on

figure;
t = 1:(1/30):2000;
t = t(1:length(X));
plot(t,X_labels,'g-');
hold on
% labels_nn = mov_mode(labels_nn,[0 0 0],3);
labels_nn = mov_mode(labels_nn,[0 0 0 0 0],5);
plot(t,labels_nn,'b.');
% title(strcat("Clasificación de frames para el experimento ", surgeon, num2str(trial), " - NN (Moda Móvil)"));
title(strcat("Frame by frame classification for experiment ", surgeon, num2str(trial)));
xlabel("Time (s)")
ylabel("Gesture")
legend("Ground truth", "Clasifier output",'Location','northwest')
grid on

%% Pctg acierto
pctg_nn = sum((X_labels==labels_nn)/length(X_labels))
pctg_vmm = sum((X_labels(1:3:end)==labels_vmm)/length(labels_vmm))








%%%%%%%%%%%%%%%%%%%%%%%%   VMM Functions   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function states = test_vmm_experiment(X,centroids,A,B,window_size)
    emisions = dsearchn(centroids, X')';
    l = length(emisions);
    states = zeros(size(emisions));
    for i = 1:l
        if i<=window_size
            states(i) = test_vmm_window_robust(emisions(1:i),A,B);
        else
            states(i) = test_vmm_window_robust(emisions((i-window_size):i),A,B);
        end
    end
end

function last_state = test_vmm_window(emisions,A,B)
    states = hmmviterbi(emisions,A+1e-30,B+1e-30);
    last_state = states(end);
end

function last_state_robust = test_vmm_window_robust(emisions,A,B)
    states_1 = hmmviterbi(emisions,A+1e-30,B+1e-30);
    states_2 = hmmviterbi(emisions,A+1e-30,B+1e-30);
    states_3 = hmmviterbi(emisions,A+1e-30,B+1e-30);
    last_state_robust = mode([states_1(end), states_2(end), states_3(end)]);
end














