function [ rls_data] = RLS_FUNC_Simple(y, u, rls_data)

%-- rls_data. --

%complexity = Matrix dimensions, should be even numbers. Always start with 2
%RlsOut     = output value of rls approximation funciton
%weights    = vector, deriving tuning rules
%fi         = vector with previous in and outputs [y(k-1 u(k-1)]'
%error      = output error of RLS
%V          = matrix
%K          = matrix

% -- RLS  --- 

rls_data.RlsOut = rls_data.fi*rls_data.weights;

my = 0.995;


rls_data.error = y - rls_data.fi*rls_data.weights;

b = my + rls_data.fi*rls_data.V*rls_data.fi;

rls_data.V = (1/my)*rls_data.V - (1/b)*rls_data.V*rls_data.fi*rls_data.fi*rls_data.V;

K = rls_data.V*rls_data.fi;

rls_data.weights = rls_data.weights + K*rls_data.error;

rls_data.fi = u;




end


