function [f, varargout] = randqf(dim, trace, box)
%RANDQF randomly generates a strongly convex quadratic function.
%     The hessian is drawn from a uniform distribution of positive definite
%     matrices with constant or bounded trace. The unoncstrained minimum is 
%     drawn from a uniform distribution inside a box defined by lower and upper 
%     component-wise bounds.
%
%   f = RANDQF(dim, trace, box)
%   [f, xminf] = RANDQF(dim, trace, box)
%   [f, xminf, Hf] = RANDQF(dim, trace, box)
%
%   Inputs:
%       dim    : Function input dimension.
%       trace  : Trace of the hessian. Either a scalar for a constant trace
%                or a vector with [lb ub] for a bounded trace with
%                lb < tr(A) <= ub.
%       box    : Unconstrained minimum box bounds. A two-column matrix with
%                bounds for the minimum as columns [lb ub].
%   Outputs:
%       f      : Quadratic function handle.
%       xminf  : Unconstrained minimizer of f.
%       Hf     : hessian of f.

% Generate the hessian
Hf = randpdm(dim, trace, 1);

% Generate the unconstrained min
xminf = (box(:, 2) - box(:, 1)) .* rand(dim, 1) + box(:, 1);

% Create the function
f = @(x) .5 * (x - xminf).' * Hf * (x - xminf);

% Check outputs
if nargout > 1
    varargout{1} = xminf;
end
if nargout > 2
    varargout{2} = Hf;
end
return

end