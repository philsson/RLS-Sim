function [ PID_Values ] = Get_Tuning_Parameters( FOPDT_data, L )

T = FOPDT_data(1);
K = FOPDT_data(2);

tau = L/T;

if tau <= 1

a1 = 1.048;
a2 = 1.195;
a3 = 0.489;

b1 = -0.897;
b2 = -0.368;
b3 = 0.888;

else
    
a1 = 1.154;
a2 = 1.047;
a3 = 0.490;

b1 = -0.567;
b2 = -0.220;
b3 = 0.708;

end

Kp = (a1/K)*(tau^b1);
Ti = (T/(a2 + b2*tau));
Td = a3*T*(tau^b3);

PID_Values = [Kp Ti Td];

end


