function [ Kp, Ki, Kd ] = get_K_PID_values( Kp, Ti, Td )
%Convert Kp, Ti and Td to Kp, Ki and Kd

Ki = Kp/Ti;
Kd = Kp*Td;

end

