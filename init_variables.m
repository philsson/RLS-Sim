%----------------------------- CONFIG SECTION ----------------------------%

adjust_heading = false;       % Heading will be adjust to the trajectory (vrider nosen mot gröna bollen true/false)
nav_heading_threshold = 0.4; % The distance required for the heading to be set (avstånd från grön kula)
follow_target = false;        % Follow the position of the green boll 

use_philips_rls = false;      % RLS phillip
apply_evo_freq = 100;        % in milliseconds (hur ofta pid tuninge rules ska tillämpas)

calcISE = true;             % If this is true then we will log "ISE_samples" many iterations and calculate the ISE (mean error).
ISE_samples = 1000;        % Hur många iterationer simuleringen kör

global stop_on_imaginary_numbers;       % Säger sig själv
stop_on_imaginary_numbers = false;

%                   X(roll)   Y(pitch)      Z(yaw)
logs_enabled   =  [  false      false       true]; % Enable log
step_enabled   =  [  false      false       false]; % Didact Delta, korrigerar set points, fjärkontroll och görna kula eller step rerefernser

adapt_enabled  =  [  true      true       true]; % RLS startas tillsammans med tuning reglerna men appliceras inte
apply_evo      =  [  true      true       false]; % Tillämpar tuning reglerna under realtid
rand_RLS_data  =  [  false      false       false]; % If false then its loaded from files
save_RLS_data  =  [  true      true       true]; % Vikterna för RLS data sparas (obs måste skrivas i command window först)
log_PID_evo    =  [  true      true       true]; % Logar pidarna

freq_resp_test =  [ false     false     false]; % Overwrides the control signal and induces a sine wave

freq_resp_params = [ 0.1 20 ]; %  [Amplitude Frequency] Freq in hz

rand_steps = false; % if enabled steps will be random in time and amplitude constrained by the next two variables
step_amplitude   = 30;  % Rotational rate to give as target value
step_interval_ms = 10000; % Needs LDM to work. Revise implementation (in run_control)
rand_target = false;
rand_target_amplitude = [2 2 2]; % 
smooth_moving_target = false;

% plot settings
plot_FOPDT = false;
plot_RLS = false;
plot_MISE = true;

% Joystick config. 
% INFO: If sticks are centered normal behaviour will resume
use_joystick = true;         % If enabled joystick can be used
joy_gyro = true;             % Override the gyro output with RC
joy_throttle = true;         % Override throttle with RC
joy_rate = 100; throttle_rate = 1; % Rc rate på radion 

%------------------------------- END CONFIG ------------------------------%

%--- Workspace variables
time_fraction = 1; % for rand step. Desides how much of the time step is used. Initialized 1
time_since_last_step = 0; % Actually interations
step_sign = 1;


rlsfileX = 'rlsdataX.mat'; rlsfileY = 'rlsdataY.mat'; rlsfileZ = 'rlsdataZ.mat';

% Initialize random rls data or load stored data for axis 'i'
for i=1:3
    if adapt_enabled(i)
        FOPDT_Data(i,1:2) = [1 1]; % TODO:  Not sure what good initial values for this is
        if rand_RLS_data(i)
            if use_philips_rls
                rls_data(i) = philip_init_rls_data(2);
                
                disp('temp fix. Setting manual tuning backtracked values')
                %rls_data(i).weights = [0.8088; 46.2830]
            else
                [rls_data(i) FOPDT_data(i,1:2)] = init_rand_rls_data();
                
                % TODO: Temp fix. Giving "optimal values" (From tuning)
                %disp('temp fix. Setting manual tuning backtracked values')
                %rls_data(i).weights = [0.8088; 46.2830]
            end

        else
            switch i
                case 1
                    disp('loading data from file for x-axis')
                    rls_data(1) = load(rlsfileX);
                case 2
                    disp('loading data from file for y-axis')
                    rls_data(2) = load(rlsfileY);
                case 3
                    disp('loading data from file for z-axis')
                    rls_data(3) = load(rlsfileZ);
                otherwise
                    disp('no data available')
            end
        end
    end
end

%%%%%%% TEMP INITIALIZATION FOR DEBUG %%%%%%%%
if plot_FOPDT
    logFOPDT = zeros(2,ISE_samples);
end

%rls
if plot_RLS
    %rls.weights = zeros(2,ISE_samples);
    %rls.V = zeros(4,ISE_samples);
    %rls.fi = zeros(2,ISE_samples);
    %rls.K = zeros(2,ISE_samples);
    %rls.error = zeros(ISE_samples);
    %for i = 1:3
     %   if logs_enabled(i)
      %      rls(i).out = zeros(ISE_samples);
       % end
   % end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if log_PID_evo(1) && logs_enabled(1)
    xPIDlog = zeros(3,ISE_samples);
end
if log_PID_evo(2) && logs_enabled(2)
    yPIDlog = zeros(3,ISE_samples);
end
if log_PID_evo(3) && logs_enabled(3)
    zPIDlog = zeros(3,ISE_samples);
end


if use_joystick
    joy = vrjoystick(1);
end

if calcISE
    if logs_enabled(1)
        xLOG = zeros(3,ISE_samples);
        MISEx = zeros(1,ISE_samples);
        TotMISEx = 0;
        rls(1).out = zeros(1,ISE_samples);
    end
    if logs_enabled(2)
        yLOG = zeros(3,ISE_samples);
        MISEy = zeros(1,ISE_samples);
        TotMISEy = 0;
        rls(2).out = zeros(1,ISE_samples);
    end
    if logs_enabled(3)
        zLOG = zeros(3,ISE_samples);
        MISEz = zeros(1,ISE_samples);
        TotMISEz = 0;
        rls(3).out = zeros(1,ISE_samples);
    end
    U = zeros(3,ISE_samples);
end

% delta time for simulation. Will be updated in main loop
global dt;
%dt = 0.010;
dt = 0.025;

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
f_cut = 100; % cutt off frequency
ASF = [0, dt, 1/(2*pi*f_cut)];

global pid_data;
pid_data = struct(... %alt |   p_x | p_y | v_x |  v_y |  a_roll | a_pitch | compass | g_roll | g_pitch | g_yaw
    'Kp',             {0.3,    2.5,  2.5,  1.0,   1.0,   2.2,     2.2,      5,        0.0013,  0.0025,   0.05},...
    'Ki',             {0,      0,    0,    0,     0,     0,       0,        0,        0.0001,  0.0001,   0.004},...
    'Kd',             {0.3,    6,    6,    1,     1,     0,       0,        0,        0.0001,  0.0001,   0.00051},...
    'integral',       {0,      0,    0,    0,     0,     0,       0,        0,        0,       0,        0},...
    'i_max',          {100,    100,  100,  100,   100,   100,     100,      100,      100,     100,      100},...
    'e',              {0,      0,    0,    0,     0,     0,       0,        0,        0,       0,        0},...
    'prev_e',         {0,      0,    0,    0,     0,     0,       0,        0,        0,       0,        0},...
    'saturation',     {1,      2,    2,    25,    25,     50,      50,       90,       1.5,       1.5,        1.5},...
    'filter',         {ASF,     ASF,    ASF,    ASF,    ASF,    ASF,     ASF,      ASF,      ASF,     ASF,      ASF});

% Zirgel Niclos method
% Z-axis Mindre Tu ger mindre D men större I
pid_data(pd_index.g_yaw).Kp = 0.0294%00482;% 0.095 is Ku
pid_data(pd_index.g_yaw).Ki =  0.2941%.5588%.2891;
pid_data(pd_index.g_yaw).Kd = 7.3529e-04%588;

% Array of setpoints. Indexed by for ex "set_points(pd_index.roll)"
set_points  = zeros(1,length(fieldnames(pd_index)));
% Array of sensor data
states      = zeros(1,length(fieldnames(pd_index)));
% Array of contro outputs
global outputs;
outputs     = zeros(1,length(fieldnames(pd_index)));
