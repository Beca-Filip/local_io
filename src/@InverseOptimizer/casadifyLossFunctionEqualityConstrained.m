function casadifyLossFunctionEqualityConstrained(obj)
%CASADIFYLOSSFUNCTIONEQUALITYCONSTRAINED transforms the stored IO loss 
%function to the casadi framework assuming the DO is equality constrained.

% Check emptyness of loss function
if isempty(obj.io_lossfunction)
    error("You must define an IO loss function before casadifying.");
end

% Call the IO loss function with DO variables, DO cost parameters and DO
% equality constraint multipliers
obj.cas_io_lossfunction = ...
obj.io_lossfunction(obj.cas_do_variables, ...
                    obj.cas_do_costfunctionparameters, ...
                    obj.cas_do_eqconstraintmultipliers);
end