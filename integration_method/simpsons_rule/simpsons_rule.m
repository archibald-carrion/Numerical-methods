% simpsons_rule.m
%
% This function implements Simpson 1/3 Rule for numerical integration
% of a definite integral.
%
% NOTE: The number of subintervals 'n' must be an even integer.
%
% Syntax:
%   approx_integral = simpsons_rule(func, a, b, n)
%
% Inputs:
%   func: A function handle to the function to be integrated.
%         Example: @(x) x.^2 or @my_function
%   a:    The lower limit of integration.
%   b:    The upper limit of integration.
%   n:    The number of subintervals (MUST BE AN EVEN INTEGER).
%
% Output:
%   approx_integral: The approximate value of the definite integral.
%
% Example Usage:
%   % Integrate f(x) = x^2 from 0 to 1 with 100 subintervals
%   f = @(x) x.^2;
%   result = simpsons_rule(f, 0, 1, 100);
%   disp(["Approximate integral: ", num2str(result)]);

function approx_integral = simpsons_rule(func, a, b, n)

    % Check for valid input
    if n <= 0 || !isscalar(n) || n != round(n) || mod(n, 2) != 0
        error("Number of subintervals 'n' must be a positive, even integer.");
    end
    if b < a
        error("Upper limit 'b' must be greater than or equal to lower limit 'a'.");
    end

    % Calculate the width of each subinterval (delta x)
    dx = (b - a) / n;

    % Initialize the sum with the first and last function values
    % f(x_0) + f(x_n)
    sum_terms = func(a) + func(b);

    % Loop through the interior points and apply weights
    % Add terms with weight 4 (odd indices)
    for i = 1:2:(n-1)
        x_i = a + i * dx;
        sum_terms = sum_terms + 4 * func(x_i);
    end

    % Add terms with weight 2 (even indices, starting from 2)
    for i = 2:2:(n-2)
        x_i = a + i * dx;
        sum_terms = sum_terms + 2 * func(x_i);
    end

    % Multiply the sum by dx/3 to get the final approximation
    approx_integral = (dx / 3) * sum_terms;

end