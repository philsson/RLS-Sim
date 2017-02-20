%----------------------------- CONFIG SECTION ----------------------------%

adjust_heading = true;       % Heading will be adjust to the trajectory
nav_heading_threshold = 0.4; % The distance required for the heading to be set
follow_target = true;        % Follow the position of the green boll

calcISE = true;             % If this is true then we will log "ISE_samples" many iterations and calculate the ISE.

ISE_samples = 1000;

% Enable log for: X(roll)   Y(pitch)      Z(yaw)
logs_enabled =  [  true      false       false];
step_enabled =  [  true      false       false];
step_amplitude   = 10;  % Rotational rate to give as target value
step_interval_ms = 500; % Needs LDM to work. Revise implementation (in run_control)

% Joystick config. 
% INFO: If sticks are centered normal behaviour will resume
use_joystick = false;         % If enabled joystick can be used
joy_gyro = true;             % Override the gyro output with RC
joy_throttle = true;         % Override throttle with RC
joy_rate = 100; throttle_rate = 1;

%------------------------------- END CONFIG ------------------------------%

if use_joystick
    joy = vrjoystick(1);
end

if calcISE
    if logs_enabled(1)
        xLOG = zeros(3,ISE_samples);
        MISEx = 0;
    end
    if logs_enabled(2)
        yLOG = zeros(3,ISE_samples);
        MISEy = 0;
    end
    if logs_enabled(3)
        zLOG = zeros(3,ISE_samples);
        MISEz = 0;
    end
end

% delta time for simulation. Will be updated in main loop
global dt;
%dt = 0.05;
dt = 0.025;

% Global value for antiwindup
global motorLimitReached;
motorLimitReached = false;

RC = struct(...
    'roll',     0,...
    'pitch',    0,...
    'yaw',      0,...
    'throttle', 0,...
    'aux1',     0);

% Index of pid_data structures. Ex "pid_data(pd_index.g_roll)"
pd_index = struct(...
    'height',     1,...     % altitude
    'p_x',        2,...     % position x (roll)
    'p_y',        3,...     %
    'v_x',        4,...
    'v_y',        5,...
    'a_roll',     6,...     % acc roll
    'a_pitch',    7,...
    'compass',    8,...     % heading
    'g_roll',     9,...     % gyro Roll
    'g_pitch',    10,...
    'g_yaw',      11);

global filter_index;
filter_index = struct(...
    'state',   1,...
    'dT',      2,...
    'RC',      3);

% A standard filter to initialize them all with something
f_cut = 100; % cutt off frequency
ASF = [0, dt, 1/(2*pi*f_cut)];

global pid_data;
pid_data = struct(... %alt |   p_x | p_y | v_x |  v_y |  a_roll | a_pitch | compass | g_roll | g_pitch | g_yaw
    'Kp',             {0.3,    2.5,  2.5,  1.0,   1.0,   2.2,     2.2,      5,        0.0018,  0.0025,   0.05},...
    'Ki',             {0,      0,    0,    0,     0,     0,       0,        0,        0.0001,  0.0001,   0.004},...
    'Kd',             {0.3,    6,    6,    1,     1,     0,       0,        0,        0.0001,  0.0001,   0.00051},...
    'integral',       {0,      0,    0,    0,     0,     0,       0,        0,        0,       0,        0},...
    'i_max',          {100,    100,  100,  100,   100,   100,     100,      100,      100,     100,      100},...
    'e',              {0,      0,    0,    0,     0,     0,       0,        0,        0,       0,        0},...
    'prev_e',         {0,      0,    0,    0,     0,     0,       0,        0,        0,       0,        0},...
    'saturation',     {1,      3,    3,    10,    10     50,      50,       90,       2,       2,        2},...
    'filter',         {ASF,     ASF,    ASF,    ASF,    ASF,    ASF,     ASF,      ASF,      ASF,     ASF,      ASF});


% Array of setpoints. Indexed by for ex "set_points(pd_index.roll)"
set_points  = zeros(1,length(fieldnames(pd_index)));
% Array of sensor data
states      = zeros(1,length(fieldnames(pd_index)));
% Array of contro outputs
outputs     = zeros(1,length(fieldnames(pd_index)));
