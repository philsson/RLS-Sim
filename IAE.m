function [ IAE_Buff ] = IAE( target, state, IAE_Buff, k )
%MISE Mean Integrated Square Error
%   Calculates a mean value of the ISE. Requires the stored value so far,
%   the target value and the current state.


IAE_Buff = ((k-1)*IAE_Buff + (target-state)) / k;

end

