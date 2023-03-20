function constructProblemUnconstrained(obj)
%CONSTRUCTPROBLEMUNCONSTRAINED constructs the IO problem.

% Set the loss function of the IO in the Opti object
obj.opti.minimize(obj.cas_io_lossfunction);

% Set the optimality constraint of DO
obj.opti.subject_to(obj.cas_do_costfunctionvectorjacobian.' * obj.cas_do_costfunctionparameters == 0);

% Set the constraints on the parameters
obj.opti.subject_to(obj.cas_io_constraints <= 0);
return
end