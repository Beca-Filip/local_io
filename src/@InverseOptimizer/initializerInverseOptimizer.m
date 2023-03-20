function initializerInverseOptimizer(obj)
%INITIALIZERINVERSEOPTIMIZER initializes all object properties (to empty most of the time).

% The IO loss function (callable function)
obj.io_lossfunction = [];

% The DO cost function vector
obj.do_costfunctionvector = [];
% The DO equality constraint function vector
obj.do_eqconstraintvector = [];
% The DO inequality constraint function vector
obj.do_ineqconstraintvector = [];

% The casadi DO cost function vector
obj.cas_do_costfunctionvector = [];
% The casadi DO cost function vector jacobian
obj.cas_do_costfunctionvectorjacobian = [];
% The casadi DO stacked cost function vector hessians
obj.cas_do_costfunctionvectorstackedhessians = [];
% The casadi DO equality constraint function vector
obj.cas_do_eqconstraintvector = [];
% The casadi DO equality constraint function vector jacobian
obj.cas_do_eqconstraintvectorjacobian = [];
% The casadi DO stacked equality constraint function vector hessians
obj.cas_do_eqconstraintvectorstackedhessians = [];
% The casadi DO inequality constraint function vector
obj.cas_do_ineqconstraintvector = [];
% The casadi DO inequality constraint function vector jacobian
obj.cas_do_ineqconstraintvectorjacobian = [];
% The casadi DO stacked inequality constraint function vector hessians
obj.cas_do_ineqconstraintvectorstackedhessians = [];

% The casadi DO cost function parameters
obj.cas_do_costfunctionparameters = [];
% The casadi DO equality constraint multipliers
obj.cas_do_eqconstraintmultipliers = [];
% The casadi DO inequality constraint multipliers
obj.cas_do_ineqconstraintmultipliers = [];

% The casadi IO loss function
obj.cas_io_lossfunction = [];
% The casadi IO loss function
obj.cas_io_constraints = [];
end