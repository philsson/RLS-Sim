function [ value ] = keepPositive( value )
%if value gets below 0 it returns just 0

    if (value < 0)
        value = 0;
    end

end

