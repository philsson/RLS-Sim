logs_enabled    =  [ 1 1 1 ];    % Enable log
step_enabled    =  [ 0 0 0 ];    % Didact Delta, korrigerar set points, fj??rkontroll och g??rna kula eller step rerefernser
impulse_enabled =  [ 0 0 0 ];

logSim = true;                      % If this is true then we will log "SIM_samples" many iterations and calculate the ISE (mean error).
SIM_samples = 4000;                  % Hur m??nga iterationer simuleringen k??r

rand_target_amplitude = [3 3 1];

global use_battery_scaling;
use_battery_scaling = true;


