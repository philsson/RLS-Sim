close all
clear all
clc



    T = 1;

    for ii = 1 :2
        
        r = ii;
        
        if ii == 2
           
            r = 18;
            
        end
    
    for i = 1:20
        
        tau(i) = i*0.1;
        
        L = tau(i)*T;
                
        PID_Values = Get_Tuning_Parameters( [1 10*r], L );
        
        kp(i) = PID_Values(1);
        ki(i) = PID_Values(2);
        kd(i) = PID_Values(3);
        
        
    end
    
    hold on
    grid on
    
    plot(tau, kp);
    plot(tau, ki);
    plot(tau, kd);
    
    legend('kp', 'ki', 'kd');
    xlabel('tau')
    
    end