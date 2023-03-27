function casadifyDirectOptimalityUnconstrained(obj)
%CASADIFYDIRECTOPTIMALITYUNCONSTRAINED casadifies the optimality conditions
%of the DO when it is unconstrained.

% Stationarity of the cost function
obj.cas_io_dooptimality = obj.cas_do_costfunctionvectorjacobian.' * obj.cas_do_costfunctionparameters;
return
end
