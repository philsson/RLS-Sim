
clear all
close all
clc


%-- rls_data. --


rls_data.complexity = 2;
rls_data.weights(1,1) = -0.5892;
rls_data.weights(2,1) = 0.0111;
rls_data.V = ones(rls_data.complexity,rls_data.complexity)*1e10;
rls_data.fi = zeros(1,rls_data.complexity)';


fi_test = rls_data.weights;

for i = 1:200
    
    
    y(i) = 5*cos(i*0.1);
    rls_data = RLS_FUNC(y(i), i, rls_data);
    y_rls(i) = rls_data.RlsOut;
    
    y_rls_fejk(i) = rls_data.fi'*fi_test;
    
    weights_rls(i,:) = rls_data.weights';
    
    
    fi_rls(i) = rls_data.fi(1);
    
end

figure
hold on
grid on

plot(1:i,y, 'b')
plot(1:i,y_rls, 'r')
%plot(1:i,y_rls_fejk, 'c')

figure
hold on
grid on
plot(1:i,weights_rls(:,1), 'b')
plot(1:i,weights_rls(:,2), 'r')

rls_data.weights
