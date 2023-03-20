function constructDirectProblemUnconstrained(obj)
%CONSTRUCTDIRECTPROBLEMUNCONSTRAINED constructs the DO problem.

% Set the loss function of the IO in the Opti object
obj.opti.minimize(obj.cas_costfunctionparameters.' * obj.cas_costfunctionvector);
return
end