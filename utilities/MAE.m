function [ MAE_Buff ] = MAE( target, state, MAE_Buff, k )
%MISE Mean Integrated Square Error
%   Calculates a mean value of the ISE. Requires the stored value so far,
%   the target value and the current state.


MAE_Buff = ((k-1)*MAE_Buff + abs(target-state)) / k;

end

