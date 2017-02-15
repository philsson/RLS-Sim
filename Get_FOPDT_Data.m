function [ Data  ] = Get_FOPDT_Data( weights, h )

                                            % h = sample time

Data(1) = h / (1 - weights(1));             % Represents T
Data(2) = weights(2) / (1 - weights(1));    % Represents K

end

