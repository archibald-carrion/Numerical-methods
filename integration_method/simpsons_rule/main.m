% main.m
%
% This script demonstrates Simpson's 1/3 Rule for numerical integration
% using a sample function. It also visualizes the points used in the calculation.
%
% NOTE: Make sure 'n' is an even integer for Simpson's 1/3 Rule.

clear;  % Clear workspace variables
clc;    % Clear command window

% --- 1. Define the integral parameters ---
a = 0;             % Lower limit of integration
b = 2;             % Upper limit of integration
n = 10;            % Number of subintervals (MUST BE EVEN)

% --- 2. Define the function to integrate ---
% Using the function handle for 'my_function.m'
f_to_integrate = @my_function;

% Analytical solution for f(x) = x^2 + 2x + 1 from 0 to 2:
% Integral(x^2 + 2x + 1) dx = x^3/3 + x^2 + x
% At x=2: (2^3)/3 + 2^2 + 2 = 8/3 + 4 + 2 = 8/3 + 18/3 = 26/3
% At x=0: 0
% Analytical result = 26/3 = 8.6666...
analytical_result = 26/3;

disp("--- Simpson's 1/3 Rule Demonstration ---");
disp(["Function: f(x) = x^2 + 2x + 1"]);
disp(["Integration interval: [", num2str(a), ", ", num2str(b), "]"]);
disp(["Number of subintervals (n): ", num2str(n), " (MUST BE EVEN)"]);
disp(["Analytical Result: ", num2str(analytical_result)]);

% --- 3. Calculate the approximate integral using Simpsons Rule ---
approx_result = simpsons_rule(f_to_integrate, a, b, n);

disp(["Approximate Result (Simpsons 1/3 Rule): ", num2str(approx_result)]);
disp(["Absolute Error: ", num2str(abs(analytical_result - approx_result))]);

% --- 4. Visualization ---
% Create a finer grid for plotting the actual function curve
x_plot = linspace(a, b, 500);
y_plot = f_to_integrate(x_plot);

figure; % Create a new figure window
hold on; % Allow multiple plots on the same axes

% Plot the actual function
plot(x_plot, y_plot, 'b-', 'LineWidth', 2, 'DisplayName', 'f(x) = x^2 + 2x + 1');

% Get the x-coordinates of the points used in the rule
x_points = linspace(a, b, n + 1);
y_points = f_to_integrate(x_points);

% Plot the points used for the approximation
plot(x_points, y_points, 'ro', 'MarkerSize', 8, 'DisplayName', 'Evaluation Points');

% Add lines to show the subintervals
for i = 1:(n+1)
    plot([x_points(i), x_points(i)], [0, y_points(i)], 'k--');
end

% Set plot properties
title("Numerical Integration using Simpson's 1/3 Rule");
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

% Important Note: Since the function 'f(x) = x^2 + 2x + 1' is a quadratic
% polynomial, Simpson's Rule will give the exact answer regardless of 'n'
% (as long as n >= 2). This is because Simpson's Rule approximates the
% function with a quadratic, which is exact in this case.