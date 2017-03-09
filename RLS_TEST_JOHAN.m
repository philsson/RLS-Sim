
clear all
close all
clc


%-- rls_data. --


rls_data.complexity = 1;
rls_data.weights(1,1) = 1;
%rls_data.weights(2,1) = 0.0111;
rls_data.V = ones(rls_data.complexity,rls_data.complexity)*1e10;
rls_data.fi = zeros(1,rls_data.complexity)';


fi_test =   -1.2884e-04;

for i = 1:800
    
    
    y(i) = 8*cos(i*0.04);
    rls_data = RLS_FUNC_Simple(y(i), i, rls_data);
    y_rls(i) = rls_data.RlsOut;
    
    %y_rls_fejk(i) = rls_data.fi'*fi_test;
    
    weights_rls(i,:) = rls_data.weights';
    
    
    fi_rls(i) = rls_data.fi(1);
    
end

hf = figure
hold on
grid on

plot(1:i,y, 'b')
plot(1:i,y_rls, 'r')
%plot(1:i,y_rls_fejk, 'c')

plot(1:i,weights_rls(:,1), 'k')

legend('y', 'y rls', 'weights');
%set(hf, 'Position', [500 500 600 600])
axis([0 i min(y) max(y)])


%figure
%hold on
%grid on
%plot(1:i,weights_rls(:,1), 'b')
%plot(1:i,weights_rls(:), 'r')



rls_data.weights
