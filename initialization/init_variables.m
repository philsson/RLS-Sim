%----------------------------- CONFIG SECTION ----------------------------%

adjust_heading = true;              % Heading will be adjust to the trajectory (vrider nosen mot gr??na bollen true/false)
nav_heading_threshold = 0.4;        % The distance required for the heading to be set (avst??nd fr??n gr??n kula)
follow_target = true;               % Follow the position of the green boll 

use_rls_data_simple = false;
apply_evo_freq = 100;               % in milliseconds (hur ofta pid tuninge rules ska till??mpas)
apply_evo_first_offset = 50;

logSim = true;                      % If this is true then we will log "SIM_samples" many iterations and calculate the ISE (mean error).
SIM_samples = 500;                  % Hur m??nga iterationer simuleringen k??r

impulse_enabled_count = 100;        % Enables the impulse at the current count of iterations

global stop_on_imaginary_numbers;
stop_on_imaginary_numbers = false;

%                   X(roll)   Y(pitch)      Z(yaw)
logs_enabled    =  [ 0 0 1 ];    % Enable log
step_enabled    =  [ 0 0 1 ];    % Didact Delta, korrigerar set points, fj??rkontroll och g??rna kula eller step rerefernser
impulse_enabled =  [ 0 0 0 ];

adapt_enabled   =  [ 1 1 1 ];    % RLS startas tillsammans med tuning reglerna men appliceras inte
apply_evo       =  [ 0 0 0 ];    % Till??mpar tuning reglerna under realtid

init_RLS_data   =  [ 1 1 1 ];    % If false then its loaded from files
save_RLS_data   =  [ 1 1 1 ];    % Vikterna f??r RLS data sparas (obs m??ste skrivas i command window f??rst)
log_PID_evo     =  [ 1 1 1 ];    % DONT USED NOW

freq_resp_test  =  [ 0 0 0 ];    % Overwrides the control signal and induces a sine wave


freq_resp_params = [ 0.5 0.2 ]; %[Amplitude Frequency] Freq in hz

rand_steps = false;             % if enabled steps will be random in time and amplitude constrained by the next two variables
step_amplitude   = 5;           % Rotational rate to give as target value
step_interval_ms = 1500;        % Needs LDM to work. Revise implementation (in run_control)
impulse_amplitude = 0.5;        % On the control signal
rand_target = false;
rand_target_amplitude = [2 2 2]; 
smooth_moving_target = false;   % Follow the green boll in a smooth way

global U_rescale_axis;
U_rescale_axis = [ 0 0 0 ];
global U_rescale;
U_rescale = 1/100;

% plot settings
plot_MISE = false;

% PIDC_V2 settings
PID_Gain_my = 0.3;
use_PIDC_V2 = false;

% Joystick config. 
% INFO: If sticks are centered normal behaviour will resume
use_joystick = false;         % If enabled joystick can be used
joy_gyro = true;             % Override the gyro output with RC
joy_throttle = true;         % Override throttle with RC
joy_rate = 100; throttle_rate = 1; % Rc rate p?? radion 

%------------------------------- END CONFIG ------------------------------%



%--- Workspace variables
% delta time for simulation. Will be updated in main loop
global dt;
%dt = 0.010;
dt = 0.025;

time_fraction = 1; % for rand step. Desides how much of the time step is used. Initialized 1
time_since_last_step = step_interval_ms*dt*1000; % Actually interations
step_sign = 1;

rlsfileX = [pwd,'/rls_data/rls_dataX.mat']; rlsfileY = [pwd,'/rls_data/rls_dataY.mat']; rlsfileZ = [pwd,'/rls_data/rls_dataZ.mat'];


% Initialize rls data or load stored data for axis 'i'
for i=1:3
    if adapt_enabled(i)
        FOPDT_Data(i,1:2) = [1 1]; % TODO:  Not sure what good initial values for this is
        if init_RLS_data(i)
                rls_data(i) = init_rls_data(2);
                
                rls_data_simple(i) = init_rls_data(1);
        else
            switch i
                case 1
                    disp('loading data from file for x-axis')
                    rls_data(1) = load(rlsfileX);
                    rls_data(1).error = 0;
                case 2
                    disp('loading data from file for y-axis')
                    rls_data(2) = load(rlsfileY);
                    rls_data(2).error = 0;
                case 3
                    disp('loading data from file for z-axis')
                    rls_data(3) = load(rlsfileZ);
                    rls_data(3).error = 0;
                otherwise
                    disp('no data available')
            end
        end
    end
end

% Joystick enabled
if use_joystick
    joy = vrjoystick(1);
end

% All values that are logged and used for analysis or plotting
log_types = {...
    'r', 'u', 'y', 'y_rls',...
    'Kp', 'Kd', 'Ki','Ti','Td'...
    'MISE', 'MAE', 'MISE_blocks', 'MAE_blocks',...
    'rls_w1', 'rls_w2'...
};
 
for i = 1:3
     for j=1:length(log_types)
         log(i).(log_types{j}) = zeros(1,SIM_samples);
     end
end



%converting it to iterations
apply_evo_freq = (apply_evo_freq/1000)/dt;

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
global pd_index;
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
% This filter is only used for the PIDC_V1
f_cut = 100; % cutt off frequency
ASF = [0, dt, 1/(2*pi*f_cut)];

defaultPIDs;

%pid_data(pd_index.g_yaw).saturation = 0.5;

for i = 1:3
    if U_rescale_axis(i)
        fields = fieldnames(pid_data(i))
        for j = 1:numel(fields)-1 % Excluding the filter
            pid_data(pd_index.g_roll -1 + i).(fields{j}) = abs(pid_data(pd_index.g_roll -1 + i).(fields{j})*U_rescale);
          
        end
    end
end

Manual_PID_Scale = 1.0;
for i= 3:3
    pid_data(pd_index.g_roll -1 +i).Kp = pid_data(pd_index.g_roll -1 +i).Kp*Manual_PID_Scale;
    pid_data(pd_index.g_roll -1 +i).Ki = pid_data(pd_index.g_roll -1 +i).Ki*Manual_PID_Scale;
    pid_data(pd_index.g_roll -1 +i).Kd = pid_data(pd_index.g_roll -1 +i).Kd*Manual_PID_Scale;
end


% Array of setpoints. Indexed by for ex "set_points(pd_index.roll)"
set_points  = zeros(1,length(fieldnames(pd_index)));
% Array of sensor data
states      = zeros(1,length(fieldnames(pd_index)));
% Array of contro outputs
global outputs;
outputs     = zeros(1,length(fieldnames(pd_index)));


