% main.m
%
% This script demonstrates the Rectangular Rule (Midpoint Rule) for numerical
% integration using a sample function. It also visualizes the approximation.

clear;  % Clear workspace variables
clc;    % Clear command window

% --- 1. Define the integral parameters ---
a = 0;             % Lower limit of integration
b = 2;             % Upper limit of integration
n = 10;            % Number of subintervals (rectangles)

% --- 2. Define the function to integrate ---
% We can use an anonymous function or a function defined in a separate .m file.
% Using the function handle for 'my_function.m'
f_to_integrate = @my_function;

% Analytical solution for f(x) = x^2 + 2x + 1 from 0 to 2:
% Integral(x^2 + 2x + 1) dx = x^3/3 + x^2 + x
% At x=2: (2^3)/3 + 2^2 + 2 = 8/3 + 4 + 2 = 8/3 + 6 = 8/3 + 18/3 = 26/3
% At x=0: 0
% Analytical result = 26/3 = 8.6666...
analytical_result = 26/3;

disp("--- Rectangular Rule Demonstration ---");
disp(["Function: f(x) = x^2 + 2x + 1"]);
disp(["Integration interval: [", num2str(a), ", ", num2str(b), "]"]);
disp(["Number of subintervals (n): ", num2str(n)]);
disp(["Analytical Result: ", num2str(analytical_result)]);

% --- 3. Calculate the approximate integral using the Rectangular Rule ---
approx_result = rectangular_rule(f_to_integrate, a, b, n);

disp(["Approximate Result (Rectangular Rule): ", num2str(approx_result)]);
disp(["Absolute Error: ", num2str(abs(analytical_result - approx_result))]);


% --- 4. Visualization ---
% Create a finer grid for plotting the actual function curve
x_plot = linspace(a, b, 500);
y_plot = f_to_integrate(x_plot);

figure; % Create a new figure window
hold on; % Allow multiple plots on the same axes

% Plot the actual function
plot(x_plot, y_plot, 'b-', 'LineWidth', 2, 'DisplayName', 'f(x) = x^2 + 2x + 1');

% Calculate points for drawing rectangles
dx = (b - a) / n;
for i = 0:(n-1)
    x_left = a + i * dx;
    x_right = x_left + dx;
    x_mid = x_left + dx / 2;
    y_mid = f_to_integrate(x_mid);

    % Draw the rectangle
    % Vertices: (x_left, 0), (x_left, y_mid), (x_right, y_mid), (x_right, 0)
    rectangle_x = [x_left, x_left, x_right, x_right, x_left];
    rectangle_y = [0, y_mid, y_mid, 0, 0];
    plot(rectangle_x, rectangle_y, 'r--', 'LineWidth', 1);

    % Add fill to the rectangles for better visualization
    patch(rectangle_x, rectangle_y, 'r', 'FaceAlpha', 0.2, 'EdgeColor', 'none');
end

% Set plot properties
title('Numerical Integration using Rectangular Rule');
xlabel('x');
ylabel('f(x)');
grid on;
legend('cool-function', 'Location', 'northwest');
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

% You can experiment by changing 'n' (number of subintervals)
% and observe how the approximation improves and the rectangles
% better fit the curve.