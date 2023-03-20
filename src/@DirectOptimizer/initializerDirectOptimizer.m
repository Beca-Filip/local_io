function initializerDirectOptimizer(obj)
%INITIALIZERDIRECTOPTIMIZER initializes all object properties (to empty most of the time).

% The DO cost function vector (cell array)
obj.costfunctionvector = [];
% The DO equality constraint function vector (cell array)
obj.eqconstraintvector = [];
% The DO inequality constraint function vector (cell array)
obj.ineqconstraintvector = [];

% The casadi DO cost function vector
obj.cas_costfunctionvector = [];
% The casadi DO cost function vector jacobian
obj.cas_costfunctionvectorjacobian = [];
% The casadi DO stacked cost function vector hessians
obj.cas_costfunctionvectorstackedhessians = [];
% The casadi DO equality constraint function vector
obj.cas_eqconstraintvector = [];
% The casadi DO equality constraint function vector jacobian
obj.cas_eqconstraintvectorjacobian = [];
% The casadi DO stacked equality constraint function vector hessians
obj.cas_eqconstraintvectorstackedhessians = [];
% The casadi DO inequality constraint function vector
obj.cas_ineqconstraintvector = [];
% The casadi DO inequality constraint function vector jacobian
obj.cas_ineqconstraintvectorjacobian = [];
% The casadi DO stacked inequality constraint function vector hessians
obj.cas_stackedineqconstraintvectorhessians = [];

% The casadi DO cost function parameters
obj.cas_costfunctionparameters = [];  

end