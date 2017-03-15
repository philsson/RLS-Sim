% Innan denna filen k?rs m?ste detta g?ras:
%
% 1] K?r "blackbox_decode" mot .blf filen fr?n BB. (Utanf?r Matlab)
%
% 2] ?ppna csv filen. S?tt "coma delimiter" och importera dessa f?lt
% AxisP* AxisD* AxisI* GyroADC* loopiteration timeus

%% Addera alla P+I+D till kontrol signalen U f?r alla axlar
U = zeros(size(axisD0,1),3);

U(1:end,1) = axisP0 + axisI0 + axisD0;
U(1:end,2) = axisP1 + axisI1 + axisD1;
U(1:end,3) = axisP2 + axisI2 + axisD2;

% Rensa on?dig data
clear axisP0 axisP1 axisP2 axisI0 axisI1 axisI2 axisD0 axisD1 axisD2

%% L?gg in output Y fr?n gyrostrukturer
Y = zeros(size(gyroADC0,1),3);

Y(1:end,1) = gyroADC0;
Y(1:end,2) = gyroADC1;
Y(1:end,3) = gyroADC2;

clear gyroADC0 gyroADC1 gyroADC2

%% Plot - It can be noted that all control signals have oposite sign as the outputs
for i=1:3
    fig_UY(i) = figure;
    hold on
    plot(U(1:end,i));
    plot(Y(1:end,i));
    legend('U','Y')
    hold off
end
%% Remove "still samples" when quadcopter is not in the air
% Change this variable depending on what you see in the logs
flight_start_sample = 1500;
flight_end_sample = 2.7*10e3;
U = U(flight_start_sample:flight_end_sample,1:3);
Y = Y(flight_start_sample:flight_end_sample,1:3);

%% Rescale and invert
% From betaflight defines
% #define PID_MIXER_SCALING           1000.0f
PID_MIXER_SCALING = 1000;
U = U / PID_MIXER_SCALING;

%% R?kna ut delta tider

% Konvertering till sekunder
time_s = timeus/10e6;

% Ber?kna alla deltatider och skriv in NaN d?r de inte ?r m?jligt
dt_s = zeros(size(time_s,1),1);
for i=2:size(time_s,1)
    if isnan(time_s(i-1))
        dt_s(i-1) = NaN;
    elseif ~isnan(time_s(i))
        dt_s(i-1) = time_s(i) - time_s(i-1);
    end
end
dt_s(end,1) = NaN;

% Rensa on?dig data
clear timeus time_s loopIteration

%% Init RLS data TODO: Replace for good approximation
%rls_data(1:3) = init_rls_data;
PTERM_SCALE = 0.032029; ITERM_SCALE = 0.244381; DTERM_SCALE = 0.000529;

rls_data(1:3) = johan_reversePIDs(45*PTERM_SCALE,45*ITERM_SCALE,20*DTERM_SCALE,dt_s(200,1)/2);

% B?R motsvara. D termen ?r lite off
% P =  1.4413, I = 10.9971, D = 0.0106


%% Running RLS on BB data

% some global variables have to be created for it to work
global stop_on_imaginary_numbers;
global stop_sim;
stop_on_imaginary_numbers = false;
stop_sim = false;
global dt;
dt = mean(dt_s(2:end-1)); % some random dt value

rls_out = zeros(size(U,1),3);
for i=1:3
    for k=1:min(size(dt_s,1),size(U,1))
        
        rls_data(i) = RLS_FUNC(Y(k,i), U(k,i), rls_data(i));
        rls_out(k,i) = rls_data(i).RlsOut;
          
    end
    % Calculate PIDs with mean of dt. Skipping the NaN fields (Might have
    % to be programmed "safer")
    PIDs(i,1:3) = Get_Tuning_Parameters( Get_FOPDT_Data(rls_data(i).weights,dt ), dt/2);
end

clear stop_sim stop_on_imaginary_numbers

%% Plot RLS prediction ( This is best done on a new file )
for i=1:3
    fig_rls(i) = figure;
    hold on
    plot(U(1:end,i)*PID_MIXER_SCALING)
    plot(Y(1:end,i))
    plot(rls_out(1:end,i))
    legend('U','Y','Y_{RLS}')
    title(num2str(i));
    hold off
end

%% Convert to Betaflight PIDs - Extract from source code
% Kp[axis] = PTERM_SCALE * pidProfile->P8[axis];
% Ki[axis] = ITERM_SCALE * pidProfile->I8[axis];
% Kd[axis] = DTERM_SCALE * pidProfile->D8[axis];

% #define PTERM_SCALE 0.032029f
% #define ITERM_SCALE 0.244381f
% #define DTERM_SCALE 0.000529f

% pidProfile->P8[ROLL] = 44;
% pidProfile->I8[ROLL] = 40;
% pidProfile->D8[ROLL] = 20;
% pidProfile->P8[PITCH] = 58;
% pidProfile->I8[PITCH] = 50;
% pidProfile->D8[PITCH] = 22;
% pidProfile->P8[YAW] = 70;
% pidProfile->I8[YAW] = 45;
% pidProfile->D8[YAW] = 20;

% scaledAxisPIDf[axis] = constrainf(axisPIDf[axis] / PID_MIXER_SCALING,


% These are default values as of the previous comments
pid_profiles = struct(... %roll |  pitch | yaw 
    'P8',                 {44,     58,     70,  },...
    'I8',                 {40,     50,     45,  },...
    'D8',                 {20,     22,     20,  });

PTERM_SCALE = 0.032029; ITERM_SCALE = 0.244381; DTERM_SCALE = 0.000529;


% Creating OUR tuned values for the current RLS data
for i=1:3
    pid_profiles(i).P8 = PIDs(i,1) / PTERM_SCALE;
    pid_profiles(i).I8 = PIDs(i,2) / ITERM_SCALE;
    pid_profiles(i).D8 = PIDs(i,3) / DTERM_SCALE;
end