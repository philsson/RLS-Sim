% delta time for simulation. Will be updated in main loop
global dt;
%dt = 0.05;
dt = 0.025;

global motorLimitReached;
motorLimitReached = false;


% Index of pid_data structures. Ex "pid_data(pd_index.g_roll)"
pd_index = struct(...
    'height',     1,...     % altitude
    'p_x',        2,...     % position x (roll)
    'p_y',        3,...     %
    'a_roll',     4,...     % acc roll
    'a_pitch',    5,...
    'compass',    6,...     % heading
    'g_roll',     7,...     % gyro Roll
    'g_pitch',    8,...
    'g_yaw',      9);

global pid_data;
pid_data = struct(... %alt |    p_x |   p_y |   a_roll | a_pitch | compass | g_roll | g_pitch | g_yaw
    'Kp',             {0.4,     0.0,    0.0,    1,       1,        10,       0.0018,  0.0025,   0.05},...
    'Ki',             {0,       0,      0,      0,       0,        0,        0.0001,  0.0001,   0.004},...
    'Kd',             {0.5,     0,      0,      0,       0,        0,        0.0001,  0.0001,   0.006},...
    'integral',       {0,       0,      0,      0,       0,        0,        0,       0,        0},...
    'i_max',          {100,     100,    100,    100,     100,      100,      100,     100,      100},...
    'e',              {0,       0,      0,      0,       0,        0,        0,       0,        0},...
    'prev_e',         {0,       0,      0,      0,       0,        0,        0,       0,        0},...
    'saturation',     {4,       2,      2,      20,      20,       90,       800,     800,      90});

% Array of setpoints. Indexed by for ex "set_points(pd_index.roll)"
set_points  = zeros(1,length(fieldnames(pd_index)));
% Array of sensor data
states      = zeros(1,length(fieldnames(pd_index)));
% Array of contro outputs
outputs     = zeros(1,length(fieldnames(pd_index)));
