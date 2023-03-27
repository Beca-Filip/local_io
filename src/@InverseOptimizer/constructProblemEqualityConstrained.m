function constructProblemEqualityConstrained(obj)
%CONSTRUCTPROBLEMEQUALITYCONSTRAINED constructs the IO problem when the DO 
%problem contains equality constraints.

% Set the loss function of the IO in the Opti object
obj.opti.minimize(obj.cas_io_lossfunction);

% Set the optimality constraint of the DO (Lagrangian is stationary)
obj.opti.subject_to(obj.cas_io_dooptimality == 0);
% Set the optimality constraint of the DO (Primal feasibility)
if ~isempty(obj.do_eqconstraintvector)
    obj.opti.subject_to(obj.cas_do_eqconstraintvector == 0);
end

% Set the constraints on the parameters
obj.opti.subject_to(obj.cas_io_constraints <= 0);
return
end