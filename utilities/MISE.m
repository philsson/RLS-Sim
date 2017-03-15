function [ ISE_Buff ] = MISE( target, state, ISE_Buff, k )
%MISE Mean Integrated Square Error
%   Calculates a mean value of the ISE. Requires the stored value so far,
%   the target value and the current state.


ISE_Buff = ((k-1)*ISE_Buff + (target-state)^2) / k;

end

