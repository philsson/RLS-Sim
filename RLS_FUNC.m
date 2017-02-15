function [ RlsOut, weightsOut, errorOut] = RLS_FUNC( u, y, complexity)

% complexity = should be even numbers. Always start with 2

% --- Init values ---

persistent weights error;
persistent fi K V;

if isempty(weights)
    
    weights = rand(1,complexity)';
    V = rand(complexity,complexity);
    fi = rand(1,complexity)';     
    K = rand(1,complexity)';  
    error = 0; 
    
end

% -- RLS  --- 

b = 1 + fi'*V*fi;
weights = weights + K*error;
K = V*fi;
error = y - fi'*weights;
V = V - inv(b)*V*fi*fi'*V;

%-- Update fi values ---
y_in = circshift(fi(1:(length(fi))/2),1)';
u_in = circshift(fi(((length(fi))/2) + 1:end),1)';

y_in(1) = y;
u_in(1) = u;

fi = [y_in u_in]';

%-- Update outputs ---

RlsOut = fi'*weights;
weightsOut = weights;
errorOut = error;

end

