function [dist_norm, angle, vel_left_norm, vel_right_norm] = calc_metrics(T_left, T_right, vel_left, vel_right)
    % CALC_METRICS - Calculate metrics between two robot configurations.
    %
    % [DIST_NORM, ANGLE, VEL_LEFT_NORM, VEL_RIGHT_NORM] = CALC_METRICS(T_LEFT, T_RIGHT, VEL_LEFT, VEL_RIGHT) 
    % calculates various metrics between two robot configurations given their
    % homogeneous transformation matrices T_LEFT and T_RIGHT and their corresponding
    % velocity vectors VEL_LEFT and VEL_RIGHT. The function returns the normalized
    % Euclidean distance between the two configurations, DIST_NORM; the angle between
    % the two configuration's z-axes, ANGLE; and the normalized Euclidean norm of the
    % velocity vectors, VEL_LEFT_NORM and VEL_RIGHT_NORM, respectively.
    %
    % Inputs:
    % T_LEFT: 4x4 homogeneous transformation matrix representing the left robot's configuration
    % T_RIGHT: 4x4 homogeneous transformation matrix representing the right robot's configuration
    % VEL_LEFT: 3x2 velocity vector of the left robot [lin_vel_col ang_vel_col]
    % VEL_RIGHT: 3x2 velocity vector of the right robot [lin_vel_col ang_vel_col]
    %
    % Outputs:
    % DIST_NORM: normalized Euclidean distance between the two configurations
    % ANGLE: angle between the two configuration's z-axes in degrees
    % VEL_LEFT_NORM: normalized Euclidean norm of the velocity vector of the left robot
    % VEL_RIGHT_NORM: normalized Euclidean norm of the velocity vector of the right robot
    
    dist_norm = norm(T_left(1:3,4)-T_right(1:3,4));

    % Calculo de angulo mucho mas simple, como el que hizo belen en la
    % tesis
    % Trasponiendo R:
%     z1 = T_left(1:3,3);
%     z2 = T_right(1:3,3);1:
    % No trasponinedo R:
    z1 = T_left(3,1:3);
    z2 = T_right(3,1:3);
    angle = acosd(dot(z1,z2)/(norm(z1)*norm(z2)));

    vel_left_norm = norm(vel_left(1:3,1));
    vel_right_norm = norm(vel_right(1:3,1));

end