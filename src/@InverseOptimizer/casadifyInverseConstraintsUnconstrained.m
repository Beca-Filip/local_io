function casadifyInverseConstraintsUnconstrained(obj)
%CASADIFYINVERSECONSTRAINTSUNCONSTRAINED casadifies the constraints upon
%the inverse variables

obj.cas_io_constraints = [-obj.cas_do_costfunctionparameters;
                          obj.cas_do_costfunctionparameters - 100;
                          -sum(obj.cas_do_costfunctionparameters) + 1];

end