% Define DO dimension
n = 2;
% Create unconstrained IO object with DO dimension 2
io = InverseOptimizer("equalityconstrained", n);

% Define two cost functions for the DO
f1 = @(x) x.' * x + 1;
f2 = @(x) (x - ones(length(x), 1)).' * (x - ones(length(x), 1)) + 1;

% Add those cost functions to the IO object
io.adderCostFunction(f1);
io.adderCostFunction(f2);

% Define one constraint function for the DO
a1 = [-1; 3];
h1 = @(x) (a1.' * x - 1);

% Add this equality constraint function to the IO object
io.adderEqualityConstraintFunction(h1);

% Defined output
y1 = [0.75; 1];
y2 = [1.2; 1];

% Solve for output 1
% Define the loss function with DO variables and IO variables (DO
% parameters) as inputs
lossfun1 = @(x, w, nu) (x - y1).' * (x - y1);
io.setterLossFunction(lossfun1);
% Casadify the IO
io.casadifyInverseOptimizer();
% Define the solver for the IO Casadi Opti object
io.opti.solver('ipopt');
% Solve
sol_io1 = io.opti.solve();
% Retrieve
w1 = sol_io1.value(io.cas_do_costfunctionparameters);
x1 = sol_io1.value(io.cas_do_variables);

% Solve for output 2
% Define the loss function with DO variables and IO variables (DO
% parameters) as inputs
lossfun2 = @(x, w, nu) (x - y2).' * (x - y2);
io.setterLossFunction(lossfun2);
% Casadify the IO
io.casadifyInverseOptimizer();
% Define the solver for the IO Casadi Opti object
io.opti.solver('ipopt');
% Solve
sol_io2 = io.opti.solve();
% Retrieve
w2 = sol_io2.value(io.cas_do_costfunctionparameters);
x2 = sol_io2.value(io.cas_do_variables);

%%

x1_grid = -0.2:0.01:1.4;
x2_grid = -0.2:0.01:1.4;

hx_grid = zeros(length(x1_grid), length(x2_grid));
f1x_grid = zeros(length(x1_grid), length(x2_grid));
f2x_grid = zeros(length(x1_grid), length(x2_grid));
omega1_grid = linspace(0, 1, 20);
omega2_grid = 1 - omega1_grid;
f_grid = zeros(length(x1_grid), length(x2_grid), length(omega1_grid));

for ii = 1 : length(x1_grid)
    for jj = 1 : length(x2_grid)
        xcurr = [x1_grid(ii); x2_grid(jj)];
        hx_grid(ii, jj) = h1(xcurr);
        f1x_grid(ii, jj) = f1(xcurr);
        f2x_grid(ii, jj) = f2(xcurr);
        % If constraint is not satisfied
        if (abs(hx_grid(ii, jj)) >= 1e-8)
            % The value of the constrained objective is inf
            f_grid(ii, jj, :) = inf;
        else
            % Otherwise calculate it
            for kk = 1 : length(omega1_grid)
                f_grid(ii, jj, kk) = omega1_grid(kk) * f1x_grid(ii, jj) + ...
                                     omega2_grid(kk) * f2x_grid(ii, jj);
            end
        end
    end
end

% Find minima of f_Grid
[mins, argmins] = min(f_grid, [], [1, 2], "linear");
% Get indices of minima
[I, J, K] = ind2sub([length(x1_grid), length(x2_grid), length(omega1_grid)], argmins);
% Minima
xmingrid = [x1_grid(I); x2_grid(J)];

figure;
hold on;
contour(x1_grid, x2_grid, hx_grid.', [0, 0]);
plot(xmingrid(1, :), xmingrid(2, :), 'k', 'LineWidth', 2);
contour(x1_grid, x2_grid, f1x_grid.', [1.1, 1.2, 1.3]);
contour(x1_grid, x2_grid, f2x_grid.', [1.1, 1.2, 1.3]);
plot(y1(1), y1(2), 's', 'MarkerSize', 12, 'Color', [0, 0, 1], 'MarkerFaceColor', [0, 0, 1]);
plot(x1(1), x1(2), '^', 'MarkerSize', 12, 'Color', [0, 0, 1], 'MarkerFaceColor', [0, 0, 1]);
plot(y2(1), y2(2), 's', 'MarkerSize', 12, 'Color', [0, 1, 1], 'MarkerFaceColor', [0, 1, 1]);
plot(x2(1), x2(2), '^', 'MarkerSize', 12, 'Color', [0, 1, 1], 'MarkerFaceColor', [0, 1, 1]);