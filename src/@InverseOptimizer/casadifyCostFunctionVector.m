function obj = casadifyCostFunctionVector(obj)
%CASADIFYCOSTFUNCTIONVECTOR transforms the cost function vector into casadi
%functions using callable functions with casadi variables.

% Number of variables
n = obj.do_inputsize;
% Number of cost function vectors
m = obj.numCostFunctions();

% Allocate the casadi cost function vectors
obj.cas_do_costfunctionvector = casadi.MX.zeros(m, 1);
% For each cost function
for numCostFunction = 1 : m
    % Compute the cost function by using the callable cost functions with 
    % casadi variables as inputs
    obj.cas_do_costfunctionvector(numCostFunction) = ...
    obj.do_costfunctionvector{numCostFunction}(obj.cas_do_variables);
end

% Allocate the jacobian of the cost function vector
obj.cas_do_costfunctionvectorjacobian = casadi.MX.zeros(m, n);
% Allocate the stacked casadi cost function hessians
obj.cas_do_costfunctionvectorstackedhessians = casadi.MX.zeros(n, n*m);
% For each cost function
for numCostFunction = 1 : m
    % Use casadi to compute the hessians and the gradients of the
    % individual cost functions from the vector
    [H, g] = hessian(obj.cas_do_costfunctionvector(numCostFunction), obj.cas_do_variables);
    % Store the gradient as a row in the cost function vector jacobian
    obj.cas_do_costfunctionvectorjacobian(numCostFunction, :) = g.';
    % Store the hessian as a submatrix among the stacked cost function 
    % vector hessians
    obj.cas_do_costfunctionvectorstackedhessians(:, (numCostFunction-1) * n + 1 : numCostFunction*n) = H;
end

end