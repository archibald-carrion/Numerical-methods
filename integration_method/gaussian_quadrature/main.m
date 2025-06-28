% main.m
%
% This script demonstrates Gaussian Quadrature for numerical integration
% using a sample function. It also visualizes the evaluation points.

clear;  % Clear workspace variables
clc;    % Clear command window

% --- 1. Define the integral parameters ---
a = 0;             % Lower limit of integration
b = 2;             % Upper limit of integration
n = 3;             % Number of quadrature points (try n=2, 3, 4, or 5)

% --- 2. Define the function to integrate ---
% Using the function handle for 'my_function.m'
f_to_integrate = @my_function;

% Analytical solution for f(x) = x^2 + 2x + 1 from 0 to 2:
% Integral(x^2 + 2x + 1) dx = x^3/3 + x^2 + x
% At x=2: (2^3)/3 + 2^2 + 2 = 8/3 + 4 + 2 = 8/3 + 18/3 = 26/3
% At x=0: 0
% Analytical result = 26/3 = 8.666666666...
analytical_result = 26/3;

disp("--- Gaussian Quadrature Demonstration ---");
disp(["Function: f(x) = x^2 + 2x + 1"]);
disp(["Integration interval: [", num2str(a), ", ", num2str(b), "]"]);
disp(["Number of quadrature points (n): ", num2str(n)]);
disp(["Analytical Result: ", num2str(analytical_result, '%.12f')]);

% --- 3. Calculate the approximate integral using Gaussian Quadrature ---
approx_result = gaussian_quadrature(f_to_integrate, a, b, n);

disp(["Approximate Result (Gaussian Quadrature): ", num2str(approx_result, '%.12f')]);
disp(["Absolute Error: ", num2str(abs(analytical_result - approx_result), '%.12e')]);


% --- 4. Visualization ---
% Create a finer grid for plotting the actual function curve
x_plot = linspace(a, b, 500);
y_plot = f_to_integrate(x_plot);

figure; % Create a new figure window
hold on; % Allow multiple plots on the same axes

% Plot the actual function
plot(x_plot, y_plot, 'b-', 'LineWidth', 2, 'DisplayName', 'f(x) = x^2 + 2x + 1');


% Get the nodes for the chosen 'n' (directly, matching gaussian_quadrature)
switch n
    case 2
        nodes_t = [-1/sqrt(3), 1/sqrt(3)];
    case 3
        nodes_t = [-sqrt(3/5), 0.0, sqrt(3/5)];
    case 4
        nodes_t = [-0.8611363115940526, -0.3399810435848563, 0.3399810435848563, 0.8611363115940526];
    case 5
        nodes_t = [-0.906179845938664, -0.538469310105683, 0.0, 0.538469310105683, 0.906179845938664];
    otherwise
        error('n must be 2, 3, 4, or 5');
end

% Transform the nodes from the standard interval [-1, 1] to [a, b]
x_nodes = (b - a) / 2 * nodes_t + (b + a) / 2;
y_nodes = f_to_integrate(x_nodes);

% Plot the evaluation points (nodes)
plot(x_nodes, y_nodes, 'ro', 'MarkerSize', 10, 'LineWidth', 2, 'DisplayName', 'Evaluation Points (Nodes)');
for i = 1:length(x_nodes)
    plot([x_nodes(i), x_nodes(i)], [0, y_nodes(i)], 'k--');
end

% Set plot properties
title('Numerical Integration using Gaussian Quadrature');
xlabel('x');
ylabel('f(x)');
grid on;
legend('show', 'Location', 'northwest');
axis([a b min(0, min(y_plot)) max(y_plot)*1.1]); % Adjust y-axis limits

hold off;
disp("Plot generated. Close the plot window to finish the script.");
% Export the plot to a file if it does not already exist
if ~exist('integration_plot.png', 'file')
    saveas(gcf, 'integration_plot.png');
    disp("Plot saved as 'integration_plot.png'.");
else
    disp("Plot already exists. Skipping save.");
end

% Important Note: A Gaussian quadrature rule with 'n' points is exact for
% polynomials of degree up to 2n - 1. Since our function f(x) is a
% polynomial of degree 2, even a 2-point rule (n=2) will give the exact
% analytical result (within floating-point precision).