% main.m
%
% This script demonstrates the Trapezoidal Rule for numerical integration
% using a sample function. It also visualizes the approximation.

clear;  % Clear workspace variables
clc;    % Clear command window

% --- 1. Define the integral parameters ---
a = 0;             % Lower limit of integration
b = 2;             % Upper limit of integration
n = 10;            % Number of subintervals (trapezoids)

% --- 2. Define the function to integrate ---
% Using the function handle for 'my_function.m'
f_to_integrate = @my_function;

% Analytical solution for f(x) = x^2 + 2x + 1 from 0 to 2:
% Integral(x^2 + 2x + 1) dx = x^3/3 + x^2 + x
% At x=2: (2^3)/3 + 2^2 + 2 = 8/3 + 4 + 2 = 8/3 + 18/3 = 26/3
% At x=0: 0
% Analytical result = 26/3 = 8.6666...
analytical_result = 26/3;

disp("--- Trapezoidal Rule Demonstration ---");
disp(["Function: f(x) = x^2 + 2x + 1"]);
disp(["Integration interval: [", num2str(a), ", ", num2str(b), "]"]);
disp(["Number of subintervals (n): ", num2str(n)]);
disp(["Analytical Result: ", num2str(analytical_result)]);

% --- 3. Calculate the approximate integral using the Trapezoidal Rule ---
approx_result = trapezoidal_rule(f_to_integrate, a, b, n);

disp(["Approximate Result (Trapezoidal Rule): ", num2str(approx_result)]);
disp(["Absolute Error: ", num2str(abs(analytical_result - approx_result))]);


% --- 4. Visualization ---
% Create a finer grid for plotting the actual function curve
x_plot = linspace(a, b, 500);
y_plot = f_to_integrate(x_plot);

figure; % Create a new figure window
hold on; % Allow multiple plots on the same axes

% Plot the actual function
plot(x_plot, y_plot, 'b-', 'LineWidth', 2, 'DisplayName', 'f(x) = x^2 + 2x + 1');

% Calculate points for drawing trapezoids
dx = (b - a) / n;
for i = 0:(n-1)
    x_i = a + i * dx;
    x_i_plus_1 = x_i + dx;

    % Draw the trapezoid
    % Vertices: (x_i, 0), (x_i, f(x_i)), (x_{i+1}, f(x_{i+1})), (x_{i+1}, 0)
    trapezoid_x = [x_i, x_i, x_i_plus_1, x_i_plus_1, x_i];
    trapezoid_y = [0, f_to_integrate(x_i), f_to_integrate(x_i_plus_1), 0, 0];
    plot(trapezoid_x, trapezoid_y, 'r--', 'LineWidth', 1);

    % Add fill to the trapezoids for better visualization
    patch(trapezoid_x, trapezoid_y, 'r', 'FaceAlpha', 0.2, 'EdgeColor', 'none');
end

% Set plot properties
title('Numerical Integration using Trapezoidal Rule');
xlabel('x');
ylabel('f(x)');
grid on;
legend('show', 'Location', 'northwest');
axis([a b min(0, min(y_plot)) max(y_plot)*1.1]); % Adjust y-axis limits

hold off;
disp("Plot generated. Close the plot window to finish the script.");
% export the plot to a file if it does not already exist
if ~exist('integration_plot.png', 'file')
    saveas(gcf, 'integration_plot.png');
    disp("Plot saved as 'integration_plot.png'.");
else
    disp("Plot already exists. Skipping save.");
end

% You can experiment by changing 'n' (number of subintervals) and observe
% how the approximation improves. You will find that for a given 'n',
% the Trapezoidal Rule is often more accurate than the Rectangular Rule.