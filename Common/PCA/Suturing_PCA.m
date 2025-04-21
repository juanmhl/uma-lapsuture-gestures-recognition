clear all

% Data selection
manoeuvre = 'Suturing';    % Must be written with simple ' instead of "
surgeon = "B";
vars_per_experiment = 5;

% Load experiment labels
load(strcat('E2_csv_to_matlab/MATLAB_data/',manoeuvre,'_labels.mat'));
% Load kinematic data
load(strcat('E2_csv_to_matlab/MATLAB_data/',manoeuvre,'.mat'));

%% Store all data samples in matrix X 
% (each row is a data sample, for all 'Manouevre' experiments, and each row
% is a variable)

% Select all vars in workspace
vars = who;

% Iterate through all variable names in the workspace, calc metrics, ands
% strore them in seq and states vectors
i = 1;

% Initial vectors
% eval(strcat(manoeuvre,'_X = [];'))
X = [];
X_gestures = {[],[],[],[],[],[],[],[],[],[],[],[]};    % In each cell save the equivalent to X but only for an specific gesture

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
            T_left = eval(strcat(experiment_name,'_T_left'));
            T_right = eval(strcat(experiment_name,'_T_right'));
            vel_left = eval(strcat(experiment_name,'_vel_left'));
            vel_right = eval(strcat(experiment_name,'_vel_right'));
            labels = eval(strcat(experiment_name,'_labels'));
            labels = [labels, zeros(1,length(T_left)-length(labels))];
            X_labels = [X_labels labels];
            
            for j=1:length(T_left)
                % Gesture label?
                label = labels(j)+1;

                [dist, angle, vel_left_norm, vel_right_norm] = ...
                calc_metrics(T_left(:,:,j), T_right(:,:,j), vel_left(:,:,j), vel_right(:,:,j));
    
                X = [X; dist angle vel_left_norm vel_right_norm];
                X_gestures{label} = [X_gestures{label}; dist angle vel_left_norm vel_right_norm];
            end

        catch ME
            disp(strcat("Exception raised: ", ME.message))

        end

        i = i+vars_per_experiment;

    else
        i = i+1;

    end
end

X_labels = X_labels';

%% Compute PCA for X matrix, using Covariance Matrix and Eigenv

% Normalize the data matrix X using the zscore function
X_norm = zscore(X);

% Compute covariance matrix
C = cov(X_norm);

% Compute eigenvectors and eigenvalues
[V, D] = eig(C);

% Sort eigenvectors and eigenvalues in descending order vased on
% eigenvalues -> that gives more weight to higher eigenvalues (principal
% components)
[eigval_sorted, idx] = sort(diag(D), 'descend');
eigvec_sorted = V(:,idx);

% Select top k eigenvectors (largest k eigenvalues)
k = 2; % number of principal components to keep
W = eigvec_sorted(:,1:k);

% Project original data matrix X onto new lower dimensional space
Z = X*W;

% Plot Z in a graphic to distinguish clusters
figure; plotpv(Z',X_labels); axis auto;

%% Compute PCA for X matrix, using pca() function

[coeff, score, latent] = pca(X);    % X is automatically normalized

% Extract the top k principal components
k = 2; % number of principal components to keep
W = coeff(:,1:k);   % From this I understand that coeff are the sorted
                    % eigenvectors (one at each column)

% Project the original data matrix X onto the new lower-dimensional space
Z = X*W;

%% Compute PCA discriminating gestures
X = zeros(11,4);
j = 1;

% Build X matrix where cols are the variables means and rows are gestures
for i = 1:length(X_gestures)
    try
        samples = X_gestures{i};
        X(j,1) = mean(samples(:,1));
        X(j,2) = mean(samples(:,2));
        X(j,3) = mean(samples(:,3));
        X(j,4) = mean(samples(:,4));
        j = j+1;
    end
end

[coeff, score, latent] = pca(X);

% Extract the top k principal components
k = 2; % number of principal components to keep
W = coeff(:,1:k);   % From this I understand that coeff are the sorted
                    % eigenvectors (one at each column)

% Project the original data matrix X onto the new lower-dimensional space
Z = X*W;


%% 3D visualization of all samples points in new coord system

% % Analisis de componentes principales para poder visualizar el dataset
% Paux=P'; % se disponen los patrones por filas para
% % calcular matriz convarianza, en P aparecen por columnas
% S=cov(Paux); % se calcula la matriz de covarianzas
% [V,D]=eig(S);
% % V es una matriz de N x N con los autovectores por
% % columnas (N es el numero de componentes de los
% % patrones de entrada), D es una matriz diagonal con
% % los autovalores en la diagonal principal.
% % La 1a Comp. Ppal. se calcula con el ultimo autovector
% % La 2a Comp. Ppal. con el penultimo, etc.
% [N N]=size(V); % si no se conoce N, se determina
% A1=Paux*V(:,N);
% % A1 vector columna con la 1era componente ppal.
% A2=Paux*V(:,N-1);
% % A2 vector columna con la 2da componente ppal.
% Paux2=[A1 A2];
% % Paux2: matriz de 2 columnas con cada componente ppal
% 
% % Se requiere una tercera dimension para visualizar el dataset
% % correctamente
% % Hago lo mismo para sacar el 3er autovector
% A3=Paux*V(:,N-2);
% Paux3=[A1 A2 A3];
% 
% figure; plotpv(Paux3',T); axis auto;    % T son las etiquetas
% % Se traspone para presentar entradas frente salidas

% Total, lo que está representando es los datos en el nuevo sistema de
% coord, etiquetados por la var T. Esos datos los tengo yo en Z, y las
% etiquetas por ahí tambien estaran
