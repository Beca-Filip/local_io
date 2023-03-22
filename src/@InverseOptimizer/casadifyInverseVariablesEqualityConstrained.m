function casadifyInverseVariablesEqualityConstrained(obj)
%CASADIFYINVERSEVARIABLESEQUALITYCONSTRAINED creates casadi instances of the 
%inverse variables for equality constrained DO models.

% Get number of cost functions
m = obj.numCostFunctions();

% Create the cost function parameter variables
obj.cas_do_costfunctionparameters = obj.opti.variable(m, 1);

% Get number of equality constraint functions
m = obj.numEqualityConstraints();

% Create the equality constraint function multipliers
obj.cas_do_eqconstraintmultipliers = obj.opti.variable(m, 1);
return
end