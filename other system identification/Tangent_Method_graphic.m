function [ L T K ] = Tangent_Method_graphic( y, y_inf, y_start, x_intersect, U_impulse, U_start)

global dt;

derivative = (y(x_intersect) - y(x_intersect-1));


m = y(x_intersect)-derivative*x_intersect;

L = (y_start - m)/derivative;

LT = (y_inf*0.63-m)/derivative;

K = (y_inf - y_start)/(U_impulse - U_start);

T = LT - L;

hold on


plot(1:length(y), (1:length(y))*derivative+m, 'r')


L = L*dt;
T = T*dt;

end

