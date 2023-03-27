function constructDirectProblemEqualityConstrained(obj)
%CONSTRUCTDIRECTPROBLEMEQUALITYCONSTRAINED constructs the DO problem with
%equality constraints.

% Set the cost function of the DO in the Opti object
obj.opti.minimize(obj.cas_costfunctionparameters.' * obj.cas_costfunctionvector);

% Set the equality constraint functions of the DO Opti object
obj.opti.subject_to(obj.cas_eqconstraintvector == 0);
return
end