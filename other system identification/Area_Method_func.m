function [ L, T, K ] = Area_Method( y_inf, y_start, y, U_impulse, U_start )

% Observe page 167 in the book "Advances in Industrial Control"

A1 = 0;
for i = 1:length(y)
    A1 = A1 + (y_inf - y(i));
end

K = (y_inf-y_start)/(U_impulse-U_start);
LT = A1/K;

% Finds the index value of y where y(index) represents the closets value to L+T
% Don't mind c 
[c, index] = min(abs(y-LT));     

A2 = 0;
for i = 1:index
    A2 = A2 + (y(i)- y_start);
end

T = exp(1)*A2/K;
L = (A1 - K*T)/K;
end

