% rectangular_rule.m
%
% This function implements the Rectangular Rule (also known as the Midpoint Rule)
% for numerical integration of a definite integral.
%
% Syntax:
%   approx_integral = rectangular_rule(func, a, b, n)
%
% Inputs:
%   func: A function handle to the function to be integrated.
%         Example: @(x) x.^2 or @my_function
%   a:    The lower limit of integration.
%   b:    The upper limit of integration.
%   n:    The number of subintervals (rectangles) to use. A higher 'n'
%         generally leads to a more accurate approximation.
%
% Output:
%   approx_integral: The approximate value of the definite integral.
%
% Example Usage:
%   % Integrate f(x) = x^2 from 0 to 1 with 100 subintervals
%   f = @(x) x.^2;
%   result = rectangular_rule(f, 0, 1, 100);
%   disp(["Approximate integral: ", num2str(result)]);

function approx_integral = rectangular_rule(func, a, b, n)

    % Check for valid input
    if n <= 0 || !isscalar(n) || n != round(n)
        error("Number of subintervals 'n' must be a positive integer.");
    end
    if b < a
        error("Upper limit 'b' must be greater than or equal to lower limit 'a'.");
    end

    % Calculate the width of each subinterval (delta x)
    dx = (b - a) / n;

    % Initialize the sum of areas
    sum_area = 0;

    % Loop through each subinterval
    for i = 0:(n-1)
        % Calculate the left endpoint of the current subinterval
        x_left = a + i * dx;

        % Calculate the midpoint of the current subinterval
        x_mid = x_left + dx / 2;

        % Evaluate the function at the midpoint
        f_mid = func(x_mid);

        % Add the area of the current rectangle to the total sum
        sum_area = sum_area + (f_mid * dx);
    end

    % The total sum is the approximate integral
    approx_integral = sum_area;

end