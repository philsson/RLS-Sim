%----------------------------- CONFIG SECTION ----------------------------%

adjust_heading = true;              % Heading will be adjust to the trajectory (vrider nosen mot gr??na bollen true/false)
nav_heading_threshold = 0.4;        % The distance required for the heading to be set (avst??nd fr??n gr??n kula)
follow_target = true;               % Follow the position of the green boll

rls_complexity = 3;
apply_evo_freq = 50;               % in milliseconds (hur ofta pid tuninge rules ska till??mpas)
apply_evo_first_offset = 50; %50

logSim = true;                      % If this is true then we will log "SIM_samples" many iterations and calculate the ISE (mean error).
SIM_samples = 1600;                  % Hur m??nga iterationer simuleringen k??r

impulse_enabled_count = 100;        % Enables the impulse at the current count of iterations

global stop_on_imaginary_numbers;
stop_on_imaginary_numbers = false;

%                   X(roll)   Y(pitch)      Z(yaw)
logs_enabled    =  [ 1 0 0 ];    % Enable log
step_enabled    =  [ 1 0 0 ];    % Didact Delta, korrigerar set points, fj??rkontroll och g??rna kula eller step rerefernser
impulse_enabled =  [ 0 0 0 ];

adapt_enabled       =  [ 1 1 1 ];    % RLS startas tillsammans med tuning reglerna men appliceras inte
apply_gain_tuning   =  [ 0 0 0 ];    % Startar Gain tuning ist�llet f�r de vanliga FOPDT tuning reglerna
apply_evo           =  [ 1 0 0 ];    % Till??mpar tuning reglerna under realtid

init_RLS_data   =  [ 0 0 0 ];    % If false then its loaded from files
save_RLS_data   =  [ 1 1 1 ];    % Vikterna f??r RLS data sparas (obs m??ste skrivas i command window f??rst)
log_PID_evo     =  [ 0 0 0 ];    % DONT USED NOW

freq_resp_test  =  [ 0 0 0 ];    % Overwrides the control signal and induces a sine wave


freq_resp_params = [ 0.5 0.2 ]; %[Amplitude Frequency] Freq in hz

rand_steps = false;             % if enabled steps will be random in time and amplitude constrained by the next two variables
step_amplitude   = 5;           % Rotational rate to give as target value
step_interval_ms = 1000;        % Needs LDM to work. Revise implementation (in run_control)
impulse_amplitude = 0.5;        % On the control signal
rand_target = false;
rand_target_amplitude = [2 2 2];
smooth_moving_target = false;   % Follow the green boll in a smooth way

global Gain_rescale_axis;
Gain_rescale_axis = [ 0 0 0 ];
global Gain_rescale;
Gain_rescale = 10;
global battery_scaling;
battery_reduction = 0.4; % How much will we discharge the battery
global use_battery_scaling;
use_battery_scaling = false;

% plot settings
plot_FOPDT_Data = false;   % Provides a plot on the FOPDT data and current PID values
plot_RLS_Data = true;     % Provides a plot on current outputs and estimated rls data and weights
plot_Error_Data = true;   % Provides a plot on different error data (MISE, MISE blocks, MAE, MAE blocks)
plot_PID_Data = false;   %


% PIDC_V2 settings
%PID_Gain_my = 0.01;
PID_Gain_my = 1000; % 2 weights
use_PIDC_V2 = true;

change_inertias = [ 0 1 0 0 ];
inertias = [ ...
%   0%   33%  66%
    1.0, 0.5, 1.5;...    % weight
%    200, 0.4, 1000;...   % roll
    1, 1000, 1000;...   % roll
    1.0, 0.4, 1000;...   % pitch
    %1.0, 0.004, 25;...   % yaw
    5, 0.5, 25;...   % yaw
];

% BAckup
%    1.0, 0.5,   1.5;...    % weight
%    1.0, 0.4,   1000;...   % roll
%    1.0, 0.4,   1000;...   % pitch
%    1.0, 0.004, 25;...     % yaw

% Joystick config.
% INFO: If sticks are centered normal behaviour will resume
use_joystick = false;         % If enabled joystick can be used
joy_gyro = true;             % Override the gyro output with RC
joy_throttle = true;         % Override throttle with RC
joy_rate = 100; throttle_rate = 1; % Rc rate p?? radion
