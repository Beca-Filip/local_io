close all
clear all
clc

% Use seed value to get same examples
seed = 42;
rng(seed);

% Example metadatada
nexamples = 10;     % Number of examples to generate
mrange = [2, 10];   % Number of cost functions range
dim = 2;            % Dimension of examples
trace = [0, 10];    % Traces of the hessians of the functions
box = [-ones(2, 1), ones(2, 1)];    % Box in which the example minima should lie
measx = [[-1; -1], [-1; 1], [1; 1], [1; -1]];          % Observations to generate


% Define examples
examples = struct();

% Generate examples
for ex = 1 : nexamples
    
    % Make DO instance
    do = DirectOptimizer("unconstrained", dim);
    % Make IO instance
    io = InverseOptimizer("unconstrained", dim);
    
    % Random number of cost functions
    m = randi(mrange, 1, 1);
    
    % Get cost function array
    farr = cell(1, m);
    xminfarr = zeros(dim, m);
    Hfarr = zeros(dim, dim, m);
    
    for cf = 1 : m
        % Generate random quadratic function, with unconstrained minimizer
        % and hessian
        [farr{cf}, xminfarr(:, cf), Hfarr(:, :, cf)] = randqf(dim, trace, box);
        % Add cost function
        do.adderCostFunction(farr{cf});
        io.adderCostFunction(farr{cf});
    end
    
    % Casadify the DO
    do.casadifyDirectOptimizer();
    
   % Solver parameters
    sol_opt = struct();
    % Regularity checks
    sol_opt.ipopt.check_derivatives_for_naninf = 'yes';
    sol_opt.regularity_check = true;
    % Silent solver (no outputs)
    sol_opt.ipopt.print_level = 0;
    sol_opt.print_time = 0;
    sol_opt.verbose = 0;
    sol_opt.ipopt.sb ='yes';
    
    % Set the solver for DO
    do.opti.solver('ipopt', sol_opt);
        
    % Create a grid on the simplex with Ngrid = 3000 points
    omegaarr = prob_simplex_ndim(m-1, determine_simplex_grid_partition(m-1, 10000));
    % Create a solution grid with same size
    xarr = zeros(dim, size(omegaarr, 1));
    
    % Solve the DO for all those
    for nomega = 1 : size(omegaarr, 1)
        % Get parameter
        omega = omegaarr(nomega, :).';
        % Set parameter in DO
        do.casadiSetCostFunctionParameterValue(omega);
        % Solve
        sol_do = do.opti.solve();
        % Extract DO solution
        xarr(:, nomega) = sol_do.value(do.cas_variables);
    end
    
    % Create a solution grid with same size
    omegaarrio = zeros(size(measx, 2), m);
    xarrio = zeros(dim, size(measx, 2));
    
    % Solve the IO for all measured x
    for nmeas = 1 : size(measx, 2)
        % Define loss function
        loss_function = @(x, w) .5 * (x - measx(:, nmeas)).' * (x - measx(:, nmeas));
        % Set loss function for IO
        io.setterLossFunction(loss_function);
        % Casadify the IO
        io.casadifyInverseOptimizer();
        % Set the solver for IO
        io.opti.solver('ipopt');
        % Solve the io
        sol_io = io.opti.solve();
        % Extract the IO solution
        omegaarrio(nmeas, :) = reshape(sol_io.value(io.cas_do_costfunctionparameters), 1, []);
        xarrio(:, nmeas) = sol_io.value(io.cas_do_variables);
    end
    
    % Save example data
    examples(end+1).farr = farr;
    examples(end).xminfarr = xminfarr;
    examples(end).Hfarr = Hfarr;
    examples(end).do = do;
    examples(end).omegaarr = omegaarr;
    examples(end).xarr = xarr;
    examples(end).measx = measx;
    examples(end).omegaarrio = omegaarrio;
    examples(end).xarrio = xarrio;
        
    % Get the shape of the set of parametric minima
    minimizersShape = alphaShape(xarr(1, :).', xarr(2, :).', 10);
%     alphaRadius = criticalAlpha(minimizersShape, 'one-region');    
%     minimizersShape = alphaShape(xarr(1, :).', xarr(2, :).', alphaRadius);
    
    % Get colormaps
    cmap1 = linspecer(m);
    cmap2 = linspecer(size(measx, 2));
    
    % Plot the scenario
    figure;
    % Hold all plots
    hold all;
    % For each CF plot the unconstrained min
    for cf = 1 : m
        plot(xminfarr(1, cf), xminfarr(2, cf), 'o', 'Color', cmap1(cf, :), 'DisplayName', sprintf("$x^*_{%d}$", cf), 'MarkerSize', 8, 'MarkerFaceColor', cmap1(cf, :));
    end
    % Plot the minimizers shape
    plot(minimizersShape, 'FaceColor', [0, 0, 0.5], 'FaceAlpha', 0.3, 'LineStyle', 'None');
    % For each measured input
    for nmeas = 1 : size(measx, 2)
        % Plot the measured input
        plot(measx(1, nmeas), measx(2, nmeas), 's', 'Color', cmap2(nmeas, :), 'DisplayName', sprintf("$\\bar{x}_{%d}$", nmeas), 'MarkerSize', 12, 'MarkerFaceColor', cmap2(nmeas, :));
        % Plot the projection of the measured input
        plot(xarrio(1, nmeas), xarrio(2, nmeas), '^', 'Color', cmap2(nmeas, :), 'DisplayName', sprintf("$x_{%d}$", nmeas), 'MarkerSize', 12, 'MarkerFaceColor', cmap2(nmeas, :));
    end
    exportgraphics(gcf, sprintf("unconstrained-one-shot-ioc-%02d.png", ex), "ContentType", "Image", "Resolution", 300);
end