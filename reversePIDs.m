function [ rls_data ] = reversePIDs( Kp, Ki, Kd, L )
%This function will give the RLS data based on current PIDs. L is not used
%now
% For example:
% reversePIDs(pid_data(pd_index.g_yaw).Kp,pid_data(pd_index.g_yaw).Kd...
%   L id the deadtime. For us normally dt/2 or less

%------------------ Step 1: Recognition of T and K -----------------------%
global dt;
use_const_index = 1;

Ti = Kp/Ki;
Td = Kd/Kp;


% tau <= 1 gives first index else second
% ex. constants.a1(1) else constants.a1(2)
constants = struct(...
    'a1', {1.048, 1.154},...
    'a2', {1.195, 1.047},...
    'a3', {0.489, 0.490},...
    'b1', {-0.897, -0.567},...
    'b2', {-0.368, -0.220},...
    'b3', {0.888, 0.708});

% T = - (2*a2) / (b2*dt + 2*Ti). OBS! Based on L being dt/2
% But as we don't know the size of tau at this point we solve T for both
% cases.
% these outcommented calculations might be wrong
%T1 = -(2*constants(1).a2)/(constants(1).b2*dt + 2*Ti);
%T2 = -(2*constants(2).a2)/(constants(2).b2*dt + 2*Ti);
T1 = (1/2)*...
    (Ki*sqrt(constants(1).a2^2 - 2*Ki*constants(1).b2*dt) +...
    Ki * constants(1).a2);
T2 = (1/2)*...
    (Ki*sqrt(constants(2).a2^2 - 2*Ki*constants(2).b2*dt) +...
    Ki * constants(2).a2);

% Are both T1 and T2 in agreement? OBS! Also based on L being dt/2
if ((dt/2*T1) <= 1 && (dt/2*T2) <= 1) % Both agree tau <= 1
    disp('tau is <= 1')
    T = T1
    use_const_index = 1;
elseif ((dt/2*T1) > 1 && (dt/2*T2) > 1) % Both agree tau > 1
    disp('tau is > 1')
    T = T2
    use_const_index = 2;
else % Not in agreement. We take the midle way
    T = (T1+T2)/2;
    % Leave use_const_index at 1
    disp('tau not in consistent agreement')
end


K = (constants(use_const_index).a1/Kp)*(dt/(2*T))^constants(use_const_index).b1
if ~isreal(K)
    disp('K is imaginary because of root of  negative T')
end

%------------------ Step 2: Backtrace RLS weights  -----------------------%
% FOPDT_Data = [T K]
w = [0;0];

w(1) = 1 - dt/T;
w(2) = K * (1 - w(1));

%------------------ Step 3: Find the RLS data ----------------------------%

% Creating the empty struct
rls_data = struct(...
    'complexity',   2,...           % Don't change
    'weights',      [w(1); w(2)],...      % 
    'V',            [0 0; 0 0],...  %
    'fi',           [0; 0],...      % Can leave empty 
    'K',            [0; 0],...      % 
    'error',        0,...           % 
    'RlsOut',       0);             % 


if (rls_data.weights(1) >= 1)
    rls_data.weights(1) = 0.9999;
    disp('rls weights(1) was above 1 at initialization!')
end

end

