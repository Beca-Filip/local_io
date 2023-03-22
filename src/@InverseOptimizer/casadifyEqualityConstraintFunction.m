function obj = casadifyEqualityConstraintFunction(obj)
%CASADIFYEQUALITYCONSTRAINTFUNCTION transforms the equality constraint 
%function vector into casadi functions using the callable equality constraint
%functions with casadi variables.

% Number of variables
n = obj.do_inputsize;
% Number of equality constraints
m = obj.numEqualityConstraints();

% Allocate the casadi equality constraint vector
obj.cas_do_eqconstraintvector = casadi.MX.zeros(m, 1);
% For each equality constraint function
for numEqConstraint = 1 : m
    % Compute the equality constraint function by using the callable
    % constraint function with casadi variables as inputs
    obj.cas_do_eqconstraintvector(numEqConstraint) = ...
    obj.do_eqconstraintvector{numEqConstraint}(obj.cas_do_variables);
end

% Allocate the jacobian of the equality constraint function vector
obj.cas_do_eqconstraintvectorjacobian = casadi.MX.zeros(m, n);
% Allocate the stacked casadi equality constraint function hessians
obj.cas_do_eqconstraintvectorstackedhessians = casadi.MX.zeros(n, n*m);
% For each equality constraint function
for numEqConstraint = 1 : m
    % Use casadi to compute the hessians and the gradients of the
    % individual equality constraint functions from the vector
    [H, g] = hessian(obj.cas_do_eqconstraintvector(numEqConstraint), obj.cas_do_variables);
    % Store the gradient as a row in the cost function vector jacobian
    obj.cas_do_eqconstraintvectorjacobian(numEqConstraint, :) = g.';
    % Store the hessian as a submatrix among the stacked cost function 
    % vector hessians
    obj.cas_do_eqconstraintvectorstackedhessians(:, (numEqConstraint-1) * n + 1 : numEqConstraint*n) = H;
end

end