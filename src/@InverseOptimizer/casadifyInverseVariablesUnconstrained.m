function casadifyInverseVariablesUnconstrained(obj)
%CASADIFYINVERSEVARIABLESUNCONSTRAINED creates casadi instances of the 
%inverse variables for unconstrained DO models.

% Get number of cost functions
m = obj.numCostFunctions();

% Create the cost function parameter variables
obj.cas_do_costfunctionparameters = obj.opti.variable(m, 1);
return

end