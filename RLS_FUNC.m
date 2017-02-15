function [ rls_data] = RLS_FUNC(y, u, rls_data)

%-- rls_data. --

%complexity = Matrix dimensions, should be even numbers. Always start with 2
%RlsOut     = output value of rls approximation funciton
%weights    = vector, deriving tuning rules
%fi         = vector with previous in and outputs [y(k-1 u(k-1)]'
%error      = output error of RLS
%V          = matrix
%K          = matrix

%NOTE: You only need to run the function, NOT assign any values to rls_data
%      However, remeber to assign rls_data to its inpus as well as its
%      output when you use it: rls_data = RLS_FUNC(y, u, rls_data)

% --- Init values ---

if isempty(rls_data.weights) || isempty(rls_data.fi)
    
    rls_data.weights = rand(1,rls_data.complexity)';
    rls_data.V = rand(complexity,rls_data.complexity);
    rls_data.fi = rand(1,rls_data.complexity)';     
    rls_data.K = rand(1,rls_data.complexity)';  
    rls_data.error = 0; 
    
end

% -- RLS  --- 

b = 1 + rls_data.fi'*rls_data.V*rls_data.fi;
rls_data.weights = rls_data.weights + rls_data.K*rls_data.error;
rls_data.K = rls_data.V*rls_data.fi;
rls_data.error = rls_data.y - rls_data.fi'*rls_data.weights;
rls_data.V = rls_data.V - inv(b)*rls_data.V*rls_data.fi*rls_data.fi'*rls_data.V;

%-- Update fi values ---
y_in = circshift(rls_data.fi(1:(length(rls_data.fi))/2),1)';
u_in = circshift(rls_data.fi(((length(rls_data.fi))/2) + 1:end),1)';

y_in(1) = y;
u_in(1) = u;

rls_data.fi = [y_in u_in]';

%-- Update outputs ---

rls_data.RlsOut = fi'*weights;

end

