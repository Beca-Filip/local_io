classdef InverseOptimizer < handle
    %INVERSEOPTIMIZER solves an Inverse Optimal (IO) problem formulated as
    %a bilevel problem by performing a local search. Uses CASADI interfaced
    %with IPOPT to solve this problem.
    %The Direct Optimal (DO) problem variables are referred to with prefix
    %do.
    %
    %   INVERSEOPTIMIZER(do_type) creates an IO object, given the type of
    %   the DO as a string.
    %   Values for do_type are "unconstrained", "equalityconstrained", 
    %   "inequalityconstrained", and "constrained".
    
    properties (Constant, GetAccess = private)
        % DO types
        DO_TYPE_UNCONSTRAINED = "unconstrained";
        DO_TYPE_EQUALITYCONSTRAINED = "equalityconstrained";
        DO_TYPE_INEQUALITYCONSTRAINED = "inequalityconstrained";
        DO_TYPE_CONSTRAINED = "constrained";
        DO_TYPES = [InverseOptimizer.DO_TYPE_UNCONSTRAINED,...
                    InverseOptimizer.DO_TYPE_EQUALITYCONSTRAINED,...
                    InverseOptimizer.DO_TYPE_INEQUALITYCONSTRAINED,...
                    InverseOptimizer.DO_TYPE_CONSTRAINED];
    end
    
    % Read-only properties
    properties (SetAccess = private)
        % DO type
        do_type         string
        % The DO input size
        do_inputsize(1, 1)        
    end
    
    % Accessible properties
    properties
        % The CASADI opti object for IO
        opti(1, 1)          casadi.Opti
        
        %%% IO inputs
        % The IO loss function (callable function)
        io_lossfunction(:, 1)
        
        %%% DO inputs
        % The DO cost function vector (cell array)
        do_costfunctionvector(:, 1)
        % The DO equality constraint function vector (cell array)
        do_eqconstraintvector(:, 1)
        % The DO inequality constraint function vector (cell array)
        do_ineqconstraintvector(:, 1)
        
        %%% DO casadi quantities
        % The casadi DO optimization variables
        cas_do_variables(:, 1)
        % The casadi DO cost function vector
        cas_do_costfunctionvector(:, 1)
        % The casadi DO cost function vector jacobian
        cas_do_costfunctionvectorjacobian(:, :)
        % The casadi DO stacked cost function vector hessians
        cas_do_costfunctionvectorstackedhessians(:, :)
        % The casadi DO equality constraint function vector
        cas_do_eqconstraintvector(:, 1)
        % The casadi DO equality constraint function vector jacobian
        cas_do_eqconstraintvectorjacobian(:, :)
        % The casadi DO stacked equality constraint function vector hessians
        cas_do_eqconstraintvectorstackedhessians(:, :)
        % The casadi DO inequality constraint function vector
        cas_do_ineqconstraintvector(:, 1)
        % The casadi DO inequality constraint function vector jacobian
        cas_do_ineqconstraintvectorjacobian(:, :)
        % The casadi DO stacked inequality constraint function vector hessians
        cas_do_ineqconstraintvectorstackedhessians(:, :)
        
        %%% IO casadi varaibles
        % The casadi DO cost function parameters
        cas_do_costfunctionparameters(:, 1)
        % The casadi DO equality constraint multipliers
        cas_do_eqconstraintmultipliers(:, 1)
        % The casadi DO inequality constraint multipliers
        cas_do_ineqconstraintmultipliers(:, 1)        
        
        %%% IO functions
        % The casadi IO loss function
        cas_io_lossfunction(:, 1)
        % The casadi IO constraint functions
        cas_io_constraints(:, 1)
        % The casadi DO optimality conditions
        cas_io_dooptimality(:, 1)
    end

    methods
        function obj = InverseOptimizer(do_type, do_inputsize)
            %INVERSEOPTIMIZER Construct an instance of this class.
            
            % If is a sequence of chars convert to string
            if ischar(do_type)
                do_type = string(do_type);
            end
            % If the type of DOtype isnt string throw error
            if ~isstring(do_type)
                error("Argument do_type must be a string or character sequence.");
            end            
            % Check if DO type is ok
            if ~any(contains(InverseOptimizer.DO_TYPES, do_type, 'IgnoreCase', true))
                error("Invalid do_type.");                
            end
            
            % Check if inputsize is ok
            if ~isnumeric(do_inputsize)
                error("The do_inputsize must be numeric.");
            end
            % Check if inputsize is positive
            if do_inputsize <= 0
                error("The do_inputsize must be positive.");
            end
            
            % Set DO type, and transform to lowercase
            obj.do_type = lower(do_type);
            
            % Set DO inputsize
            obj.do_inputsize = do_inputsize;
            
            % Initialize casadi opti
            obj.opti = casadi.Opti();
            
            % Initialize casadi variables
            obj.cas_do_variables = obj.opti.variable(obj.do_inputsize, 1);
            
            % Initialize other variables
            obj.initializerInverseOptimizer();
        end
    end
    
    methods
        % Information retrievers
        m = numCostFunctions(obj);
        m = numEqualityConstraints(obj);
        
        % Initializer
        initializerInverseOptimizer(obj);
        
        % Adders
        adderCostFunction(obj, callableFun);
        adderEqualityConstraintFunction(obj, callableFun);
        
        % Setters
        setterLossFunction(obj, callableFun);        
        
        % Casadi-related functions
        casadifyInverseOptimizer(obj);
    end
    methods (Access = private)
        % Casadi-related functions
        % General function
        casadifyCostFunctionVector(obj);
        % Unconstrained functions
        casadifyInverseVariablesUnconstrained(obj);
        casadifyLossFunctionUnconstrained(obj);
        constructProblemUnconstrained(obj);
        casadifyInverseConstraintsUnconstrained(obj);
        casadifyDirectOptimalityUnconstrained(obj);
        % Equality constrained functions
        casadifyEqualityConstraintFunction(obj);
        casadifyInverseVariablesEqualityConstrained(obj);
        casadifyLossFunctionEqualityConstrained(obj);
        constructProblemEqualityConstrained(obj);
        casadifyDirectOptimalityEqualityConstrained(obj);
    end
end