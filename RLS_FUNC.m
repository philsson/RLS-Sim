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

% Forgetting factor
my = 0.999;


rls_data.error = y - rls_data.fi'*rls_data.weights;

b = my + rls_data.fi'*rls_data.V*rls_data.fi;

% TODO: inv(b) can just be 1/b. Less computational heavy. As it is a scalar
rls_data.V = (1/my)*rls_data.V - inv(b)*rls_data.V*rls_data.fi*rls_data.fi'*rls_data.V;

%rls_data.K = rls_data.V*rls_data.fi;
K = rls_data.V*rls_data.fi;

%rls_data.weights = rls_data.weights + rls_data.K*rls_data.error;
rls_data.weights = rls_data.weights + K*rls_data.error;




%-- Update fi values ---
y_in = circshift(rls_data.fi(1:(length(rls_data.fi))/2),1)';
u_in = circshift(rls_data.fi(((length(rls_data.fi))/2) + 1:end),1)';

y_in(1) = y;
u_in(1) = u;

rls_data.fi = [y_in u_in]';

%-- Update outputs ---

if (rls_data.weights(1) >= 1)
    rls_data.weights(1) = 0.9999;
end

if (rls_data.weights(2) <= 0)
    rls_data.weights(2) = 0.0001;
end

rls_data.RlsOut = rls_data.fi'*rls_data.weights;



end

