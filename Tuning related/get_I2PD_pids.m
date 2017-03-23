function [ Kp, Ti, Td ] = get_I2PD_pids( weight, tau,h  )

K = weight/((h^2));

Kp = 0.0625/(K*(tau^2));
Ti = 8*tau;
Td = 8*tau;

end

