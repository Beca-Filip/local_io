% Define DO dimension
n = 2;
% Create unconstrained IO object with DO dimension 2
io = InverseOptimizer("unconstrained", n);

% Defined output
y = [0.75; 1];

% Define the loss function with DO variables and IO variables (DO
% parameters) as inputs
lossfun = @(x, w) (x - y).' * (x - y);
io.setterLossFunction(lossfun);

% Define two cost functions for the DO
f1 = @(x) x.' * x + 1;
f2 = @(x) (x - ones(length(x), 1)).' * (x - ones(length(x), 1)) + 1;

% Add those cost functions to the IO object
io.adderCostFunction(f1);
io.adderCostFunction(f2);

% Casadify the IO
io.casadifyInverseOptimizer();

% Define the solver for the IO Casadi Opti object
io.opti.solver('ipopt');

% Solve
sol_io = io.opti.solve();

% Retrieve
w = sol_io.value(io.cas_do_costfunctionparameters);