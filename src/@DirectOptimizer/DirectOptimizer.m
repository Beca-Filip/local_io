classdef DirectOptimizer < handle
    %DIRECTOPTIMIZER solves a the Direct Optimal (DO) problem.
    %
    %   DIRECTOPTIMIZER(type) creates a DirectOptimizer object, given 
    %   the type of the direct optimization as a string.
    %   Values for type are "unconstrained", "equalityconstrained", 
    %   "inequalityconstrained", and "constrained".
    
    properties (Constant, GetAccess = private)
        % DO types
        TYPE_UNCONSTRAINED = "unconstrained";
        TYPE_EQUALITYCONSTRAINED = "equalityconstrained";
        TYPE_INEQUALITYCONSTRAINED = "inequalityconstrained";
        TYPE_CONSTRAINED = "constrained";
        TYPES = [DirectOptimizer.TYPE_UNCONSTRAINED,...
                     DirectOptimizer.TYPE_EQUALITYCONSTRAINED,...
                     DirectOptimizer.TYPE_INEQUALITYCONSTRAINED,...
                     DirectOptimizer.TYPE_CONSTRAINED];
    end
    
    % Read-only properties
    properties (SetAccess = private)
        % DO type
        type         string
        % The DO input size
        inputsize(1, 1)        
    end
    
    % Accessible properties
    properties
        % The CASADI opti object.
        opti(1, 1)          casadi.Opti
        % The DO cost function vector (cell array)
        costfunctionvector(:, 1)
        % The DO equality constraint function vector (cell array)
        eqconstraintvector(:, 1)
        % The DO inequality constraint function vector (cell array)
        ineqconstraintvector(:, 1)
        
        % The casadi DO optimization variables
        cas_variables(:, 1)
        % The casadi DO cost function vector
        cas_costfunctionvector(:, 1)
        % The casadi DO cost function vector jacobian
        cas_costfunctionvectorjacobian(:, :)
        % The casadi DO stacked cost function vector hessians
        cas_costfunctionvectorstackedhessians(:, :)
        % The casadi DO equality constraint function vector
        cas_eqconstraintvector(:, 1)
        % The casadi DO equality constraint function vector jacobian
        cas_eqconstraintvectorjacobian(:, :)
        % The casadi DO stacked equality constraint function vector hessians
        cas_eqconstraintvectorstackedhessians(:, :)
        % The casadi DO inequality constraint function vector
        cas_ineqconstraintvector(:, 1)
        % The casadi DO inequality constraint function vector jacobian
        cas_ineqconstraintvectorjacobian(:, :)
        % The casadi DO stacked inequality constraint function vector hessians
        cas_stackedineqconstraintvectorhessians(:, :)
        
        % The casadi DO cost function parameters
        cas_costfunctionparameters(:, 1)  
    end

    methods
        function obj = DirectOptimizer(type, inputsize)
            %DIRECTOPTIMIZER Construct an instance of this class.
            
            % If is a sequence of chars convert to string
            if ischar(type)
                type = string(type);
            end
            % If the type of doctype isnt string throw error
            if ~isstring(type)
                error("Argument type must be a string or character sequence.");
            end            
            % Check if doc type is ok
            if ~any(contains(DirectOptimizer.TYPES, type, 'IgnoreCase', true))
                error("Invalid type.");                
            end
            
            % Check if inputsize is ok
            if ~isnumeric(inputsize)
                error("The inputsize must be numeric.");
            end
            % Check if inputsize is positive
            if inputsize <= 0
                error("The inputsize must be positive.");
            end
            
            % Set doc type, and transform to lowercase
            obj.type = lower(type);
            
            % Set doc inputsize
            obj.inputsize = inputsize;
            
            % Initialize casadi opti
            obj.opti = casadi.Opti();
            
            % Initialize casadi variables
            obj.cas_variables = obj.opti.variable(obj.inputsize, 1);
            
            % Initialize other variables
            obj.initializerDirectOptimizer();
        end
    end
    
    methods
        % Information retrievers
        m = numCostFunctions(obj)
        
        % Initializer
        initializerDirectOptimizer(obj);
        
        % Adders
        adderCostFunction(obj, callableFun);
        
        % Casadi-related functions
        casadifyDirectOptimizer(obj);
        
        % Casadi setter
        casadiSetCostFunctionParameterValue(obj, values);
    end
    
    methods (Access = private)
        % Casadi-related functions
        constructDirectProblemUnconstrained(obj);
    end
end