function [ rls_data] = RLS_FUNC(y, u, rls_data)

%-- rls_data. --

%complexity = Matrix dimensions, should be even numbers. Always start with 2
%RlsOut     = output value of rls approximation funciton
%weights    = vector, deriving tuning rules
%fi         = vector with previous in and outputs [y(k-1 u(k-1)]'
%error      = output error of RLS
%V          = matrix
%K          = matrix

% -- RLS  --- 

b = 1 + rls_data.fi'*rls_data.V*rls_data.fi;
rls_data.weights = rls_data.weights + rls_data.K*rls_data.error;
rls_data.K = rls_data.V*rls_data.fi;
rls_data.error = y - rls_data.fi'*rls_data.weights;
rls_data.V = rls_data.V - inv(b)*rls_data.V*rls_data.fi*rls_data.fi'*rls_data.V;

%-- Update fi values ---
y_in = circshift(rls_data.fi(1:(length(rls_data.fi))/2),1)';
u_in = circshift(rls_data.fi(((length(rls_data.fi))/2) + 1:end),1)';

y_in(1) = y;
u_in(1) = u;

rls_data.fi = [y_in u_in]';

%-- Update outputs ---

rls_data.RlsOut = rls_data.fi'*rls_data.weights;



end

