function casadifyDirectParameters(obj)
%CASADIFYDIRECTPARAMETERS creates the parameters for the DO.

% Get the number of cost functions
m = obj.numCostFunctions();
% Construct the casadi parameters
obj.cas_costfunctionparameters = obj.opti.parameter(m, 1);
return
end