% Define DO dimension
n = 2;
% Create unconstrained IO object with DO dimension 2
do = DirectOptimizer("equalityconstrained", n);

% Define two cost functions for the DO
f1 = @(x) x.' * x + 1;
f2 = @(x) (x - ones(length(x), 1)).' * (x - ones(length(x), 1)) + 1;

% Add those cost functions to the DO object
do.adderCostFunction(f1);
do.adderCostFunction(f2);

% Define one constraint function for the DO
a1 = [-1; 3];
h1 = @(x) (a1.' * x - 1);

% Add this equality constraint function to the IO object
do.adderEqualityConstraintFunction(h1);

% Casadify the DO
do.casadifyDirectOptimizer();

% Casadify the DO
do.casadiSetCostFunctionParameterValue(ones(2, 1));

% Define the solver for the IO Casadi Opti object
do.opti.solver('ipopt');

% Solve
sol_do = do.opti.solve();

% Extract value
x = sol_do.value(do.cas_variables);