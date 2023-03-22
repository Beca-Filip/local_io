function casadifyInverseOptimizer(obj)
%CASADIFYINVERSEOPTIMIZER transforms the stored DO information to the
%casadi framework.

% Construct the casadi cost functions
obj.casadifyCostFunctionVector();

% Unconstrained casadifying
if strcmpi(obj.do_type, obj.DO_TYPE_UNCONSTRAINED)
    % Construct the casadi cost function parameters
    obj.casadifyInverseVariablesUnconstrained();
    % Casadify loss function
    obj.casadifyLossFunctionUnconstrained();
    % Construct the inverse constraints
    obj.casadifyInverseConstraintsUnconstrained();
    % Construct the inverse optimizer problem
    obj.constructProblemUnconstrained();
    return
end

% Equality constrained casadifying
if strcmpi(obj.do_type, obj.DO_TYPE_EQUALITYCONSTRAINED)
    % Construct the casadi equality constraint functions
    obj.casadifyEqualityConstraintFunction()
    % Construct the casadi cost function parameters and lagrangian
    % multipliers
    obj.casadifyInverseVariablesEqualityConstrained();
    % Casadify the loss function
    obj.casadifyLossFunctionEqualityConstrained();
    % Construct the inverse constraints
    obj.casadifyInverseConstraintsUnconstrained();
    % Construct the inverse optimizer problem
    obj.constructProblemEqualityConstrained();
    return
end

if strcmpi(obj.do_type, obj.DO_TYPE_INEQUALITYCONSTRAINED)
    obj.casadifyInverseOptimizerInequalityConstrained();
    return
end
if strcmpi(obj.do_type, obj.DO_TYPE_CONSTRAINED)
    obj.casadifyInverseOptimizerConstrained();
    return
end

end