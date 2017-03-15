function [ K Ti Td ] = K2T_Values( Kp, Ki, Kd )
%Takes in the Kp, Ki and Kd parameters and returns K, Ti and Td
K = Kp;
Ti = Kp / Ki;
Td = Kd / Kp;

end

