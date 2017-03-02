function [ PID_Values ] = Get_Tuning_Parameters( FOPDT_data, L )

    % used to stop simulation on error
    global stop_sim;
    global stop_on_imaginary_numbers;
    global dt;
    stop = false;

    T = FOPDT_data(1);
    K = FOPDT_data(2);
    
    if (T < 0 || K < 0)
        disp(['T or K are < 0.    T:' num2str(T) ' and K: ' num2str(K)]);
    end

    tau = L/T;
    %tau = L/max(T,dt); % På förslag av Alexander, men fungerade inge bra.

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
    Ki = 0; %not calculated yet
    Kd = 0; %not calculated yet

    %PID_Values = [Kp Ti Td];

  
    % Konvert to K values
    if ~isreal(Kp)
        disp('Kp not real')
        stop = true;
    end
    
    if isreal(Ti)
        Ki = (1/Ti)*Kp; % Eller Kp/Ti
    else
        disp('Ti not real')
        stop = true;
    end
    
    if isreal(Td)
        Kd = Kp*Td;
    else
        disp('Td not real')
        stop = true;
    end

    if ~isreal(Kd)
        disp('Kd not real')
        stop = true;
    end

    if ~isreal(Ki)
        disp('Ki not real')
        stop = true;
    end
    
    if stop
        disp(['Kp:' num2str(Kp) ' Ti:' num2str(Ti) ' Td:' num2str(Td) ' Ki:' num2str(Ki) ' Kd:' num2str(Kd)]);
        %[Kp Ti Td Ki Kd]
    end
    
    if (stop_on_imaginary_numbers && stop)
        stop_sim = true;
    end
    
    PID_Values = [Kp Ki Kd];

end


