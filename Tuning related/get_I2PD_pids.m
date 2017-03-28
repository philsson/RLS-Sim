function [ C ] = get_I2PD_pids( weight, tau,h  )

K = weight/((h^2));


% Johan fixade riktiga tuning regler
Kp = 0.02140/(K*(tau^2));
Ti = 17.570*tau;
Td = 14.019*tau;




% Gemensam test från riktiga regler
Ti = 2.1552e+03 *tau;
Td = 1.7586 *tau;


C = [Kp Ti Td];
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Old rules from wrong model
% Tuning regler till seriella
%Kp = 0.0625/(K*(tau^2));
%Ti = 8*tau;
%Td = 8*tau;


% Philips bullshit (med Philips taus)
%dead_time_L = [0.0115 0.0115 0.0105];
%Kp = 0.0625/(K*(tau^2));
%Ti = 12*tau;
%Td = 1*tau;