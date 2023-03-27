function casadifyDirectOptimalityEqualityConstrained(obj)
%CASADIFYDIRECTOPTIMALITYEQUALITYCONSTRAINED casadifies the optimality 
%conditions of the DO when it is equality constrained.

% Stationarity of the Lagrangian
obj.cas_io_dooptimality = obj.cas_do_costfunctionvectorjacobian.' * obj.cas_do_costfunctionparameters ...
+ obj.cas_do_eqconstraintvectorjacobian.' * obj.cas_do_eqconstraintmultipliers;
return
end
