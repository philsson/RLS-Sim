    



close all    
hold on
grid on

z_axis = zLOG(2,impulse_enabled_count+1:end)


plot(1:length(z_axis), z_axis, 'b');

%[ L, T, K ] = Tangent_Method( z_axis, impulse_amplitude, 0 )
%Tangent_Method_graphic( z_axis, y_inf, y_start, x_intersect, U_impulse, U_start)




%% -- Go Area method --

[ L, T, K ] = Tangent_Method_graphic( z_axis, 0.65, -1.4, 4, impulse_amplitude, 0)

PID_Values_Z = Get_Tuning_Parameters( [T K] , L)
