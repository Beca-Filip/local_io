function casadifyDirectOptimizer(obj)
%CASADIFYDIRECTOPTIMIZER transforms the stored DO information to the
%casadi framework.

% Construct the casadi cost functions
obj.casadifyCostFunctionVector();
% Construct the cst function parameters
obj.casadifyDirectParameters();

% Unconstrained casadifying
if strcmpi(obj.type, obj.TYPE_UNCONSTRAINED)
    % Construct the direct optimizer problem
    obj.constructDirectProblemUnconstrained();
    return
end

% Equality constrained casadifying
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