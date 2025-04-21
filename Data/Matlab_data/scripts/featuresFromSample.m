function features = featuresFromSample(sample)

% kinematic variables
% 1-3    (3) : Master left tooltip xyz                    
% 4-12   (9) : Master left tooltip R    
% 13-15  (3) : Master left tooltip trans_vel x', y', z'   
% 16-18  (3) : Master left tooltip rot_vel                
% 19     (1) : Master left gripper angle                  
% 20-38  (19): Master right
% 39-41  (3) : Slave left tooltip xyz
% 42-50  (9) : Slave left tooltip R
% 51-53  (3) : Slave left tooltip trans_vel x', y', z'   
% 54-56  (3) : Slave left tooltip rot_vel
% 57     (1) : Slave left gripper angle                   
% 58-76  (19): Slave right

offset = 19;
position_left = sample(39:41);
position_right = sample(39+offset:41+offset);
R_left = reshape(sample(42:50),[3,3]);
R_left = R_left';
R_right = reshape(sample(42+offset:50+offset),[3,3]);
R_right = R_right';
euler_left = rotm2eul(R_left,"ZYX");
euler_right = rotm2eul(R_right,"ZYX");
trans_vel_left = sample(51:53);
trans_vel_right = sample(51+offset:53+offset);
rot_vel_left = sample(54:56);
rot_vel_right = sample(54+offset:56+offset);
gripper_angle_left = sample(57);
gripper_angle_right = sample(57+offset);

% Belén's features
dist = norm(position_right-position_left);
Z_left = R_left(1:3,3);
Z_right = R_right(1:3,3);
angle = acos(dot(Z_left,Z_right));
% angle = rad2deg(angle);
vel_norm_left = norm(trans_vel_left);
vel_norm_right = norm(trans_vel_right);

% % features vector format:
% features = [ "dist"
%     "angle"
%     "vel\_norm\_left"
%     "vel\_norm\_right"
%     "gripper\_angle\_left "
%     "gripper\_angle\_right"
%     "eulerZ\_left"
%     "eulerY\_left"
%     "eulerX\_left"
%     "eulerZ\_right"
%     "eulerY\_right"
%     "eulerX\_right"
%     "vel\_left\_x "
%     "vel\_left\_y"
%     "vel\_left\_z"
%     "vel\_right\_x"
%     "vel\_right\_y"
%     "vel\_right\_z"
%     "vel\_ang\_left\_x"
%     "vel\_ang\_left\_y"
%     "vel\_ang\_left\_z"
%     "vel\_ang\_right\_x"
%     "vel\_ang\_right\_y"
%     "vel\_ang\_right\_z"];

features = [dist angle vel_norm_left vel_norm_right gripper_angle_left gripper_angle_right...
    euler_left(1) euler_left(2) euler_left(3) euler_right(1) euler_right(2) euler_right(3)...
    trans_vel_left(1) trans_vel_left(2) trans_vel_left(3) trans_vel_right(1) trans_vel_right(2) trans_vel_right(3)...
    rot_vel_left(1) rot_vel_left(2) rot_vel_left(3) rot_vel_right(1) rot_vel_right(2) rot_vel_right(3)];

end