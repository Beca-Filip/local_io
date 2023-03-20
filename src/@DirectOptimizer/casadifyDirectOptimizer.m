function casadifyDirectOptimizer(obj)
%CASADIFYDIRECTOPTIMIZER transforms the stored DO information to the
%casadi framework.

% Construct the casadi cost functions
obj.casadifyCostFunctionVector();
% Get the number of cost functions
m = obj.numCostFunctions();
% Construct the casadi parameters
obj.cas_costfunctionparameters = obj.opti.parameter(m, 1);

% Call right casadifyer
if strcmpi(obj.type, obj.TYPE_UNCONSTRAINED)
    % Construct the direct optimizer problem
    obj.constructDirectProblemUnconstrained();
    return
end
if strcmpi(obj.type, obj.TYPE_EQUALITYCONSTRAINED)
    obj.casadifyInverseOptimizerEqualityConstrained();
    return
end
if strcmpi(obj.type, obj.TYPE_INEQUALITYCONSTRAINED)
    obj.casadifyInverseOptimizerInequalityConstrained();
    return
end
if strcmpi(obj.type, obj.TYPE_CONSTRAINED)
    obj.casadifyInverseOptimizerConstrained();
    return
end

end