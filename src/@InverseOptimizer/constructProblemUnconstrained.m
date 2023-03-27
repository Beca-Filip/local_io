function constructProblemUnconstrained(obj)
%CONSTRUCTPROBLEMUNCONSTRAINED constructs the IO problem.

% Set the loss function of the IO in the Opti object
obj.opti.minimize(obj.cas_io_lossfunction);

% Set the optimality of DO
obj.opti.subject_to(obj.cas_io_dooptimality == 0);

% Set the constraints on the parameters
obj.opti.subject_to(obj.cas_io_constraints <= 0);
return
end