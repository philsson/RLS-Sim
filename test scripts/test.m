
clc
clear all
close all

                rls_data_simple.V = 0.1;
                rls_data_simple.weights = 0;
                rls_data_simple.fi = 0;
                rls_data_simple.RlsOut = 0;
                rls_data_simple.error = 0;


                
max_r = 2000;


for r = 1 : max_r
    
    u(r) = 3*sin(r*pi*0.02);
    if r < max_r/2
        
        %u(r) = 3*sin(r*pi*0.02) + r/2;
       y(r) = 2*u(r);
    else
        
         %u(r) = 3*sin(r*pi*0.02);
        
        y(r) = 4*u(r);
    end
   
   
    
    
    
    rls_data_simple = RLS_FUNC_Simple(y(r), u(r), rls_data_simple);
    
    y_rls(r) = rls_data_simple.RlsOut;
    
    weights_rls(r) = rls_data_simple.weights; 
    
    
end

figure(); 

subplot(211)
grid on
hold on
plot(1:r, y);
plot (1:r, y_rls);
plot (1:r, u);

legend('y', 'RLS','U','weights');

subplot(212)
grid on
hold on
plot (1:r, weights_rls);
legend('weights');
