function [ Data  ] = Get_FOPDT_Data( weights, h )

 global stop_sim;
 global stop_on_imaginary_numbers
                                            % h = sample time

Data(1) = h / (1 - weights(1));             % Represents T
Data(2) = weights(2) / (1 - weights(1));    % Represents K

if (Data(1) < 0)
    disp(['FOPDT Data (1) is negative!   :' num2str(Data(1))])
end
if (Data(2) < 0)
    disp(['FOPDT Data (2) is negative!   :' num2str(Data(2))])
end

if ~isreal(Data)
    disp('FOPDT Data not real!!!');
    if stop_on_imaginary_numbers
        stop_sim = true;
    end
end

end

