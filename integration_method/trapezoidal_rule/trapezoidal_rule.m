% trapezoidal_rule.m
%
% This function implements the Trapezoidal Rule for numerical integration
% of a definite integral.
%
% Syntax:
%   approx_integral = trapezoidal_rule(func, a, b, n)
%
% Inputs:
%   func: A function handle to the function to be integrated.
%         Example: @(x) x.^2 or @my_function
%   a:    The lower limit of integration.
%   b:    The upper limit of integration.
%   n:    The number of subintervals (trapezoids) to use. A higher 'n'
%         generally leads to a more accurate approximation.
%
% Output:
%   approx_integral: The approximate value of the definite integral.
%
% Example Usage:
%   % Integrate f(x) = x^2 from 0 to 1 with 100 subintervals
%   f = @(x) x.^2;
%   result = trapezoidal_rule(f, 0, 1, 100);
%   disp(["Approximate integral: ", num2str(result)]);

function approx_integral = trapezoidal_rule(func, a, b, n)

    % Check for valid input
    if n <= 0 || !isscalar(n) || n != round(n)
        error("Number of subintervals 'n' must be a positive integer.");
    end
    if b < a
        error("Upper limit 'b' must be greater than or equal to lower limit 'a'.");
    end

    % Calculate the width of each subinterval (delta x)
    dx = (b - a) / n;

    % Initialize the sum of areas with the first and last terms
    % These terms are not multiplied by 2 in the summation.
    sum_area = func(a) + func(b);

    % Loop through the interior points (from i=1 to n-1)
    for i = 1:(n-1)
        % Calculate the x-coordinate of the current point
        x_i = a + i * dx;

        % Add the function's value at this point, multiplied by 2
        sum_area = sum_area + 2 * func(x_i);
    end

    % Multiply the sum by dx/2 to get the final approximation
    approx_integral = (dx / 2) * sum_area;

end