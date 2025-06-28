% gaussian_quadrature.m
%
% This function implements Gaussian Quadrature for numerical integration.
% It uses pre-computed nodes and weights for the standard interval [-1, 1]
% and performs a change of variables to integrate over a general interval [a, b].
%
% The function supports a number of points 'n' from 2 to 5.
%
% Syntax:
%   approx_integral = gaussian_quadrature(func, a, b, n)
%
% Inputs:
%   func: A function handle to the function to be integrated.
%         Example: @(x) x.^2 or @my_function
%   a:    The lower limit of integration.
%   b:    The upper limit of integration.
%   n:    The number of quadrature points (nodes) to use.
%         Supported values are 2, 3, 4, and 5.
%
% Output:
%   approx_integral: The approximate value of the definite integral.
%
% Example Usage:
%   % Integrate f(x) = exp(x) from 0 to 1 with 3 points
%   f = @(x) exp(x);
%   result = gaussian_quadrature(f, 0, 1, 3);
%   disp(["Approximate integral: ", num2str(result)]);

function approx_integral = gaussian_quadrature(func, a, b, n)

    % Check for supported number of points
    if n < 2 || n > 5 || n != round(n)
        error("Number of points 'n' must be an integer between 2 and 5 for this implementation.");
    end

    % --- 1. Define nodes (t_i) and weights (w_i) for the standard interval [-1, 1] ---
    % These values are from standard tables for Gaussian-Legendre quadrature.
    switch n
        case 2
            % 2-point rule (exact for polynomials up to degree 3)
            nodes = [-1/sqrt(3), 1/sqrt(3)];
            weights = [1.0, 1.0];
        case 3
            % 3-point rule (exact for polynomials up to degree 5)
            nodes = [-sqrt(3/5), 0.0, sqrt(3/5)];
            weights = [5/9, 8/9, 5/9];
        case 4
            % 4-point rule (exact for polynomials up to degree 7)
            nodes = [-0.8611363115940526, -0.3399810435848563, 0.3399810435848563, 0.8611363115940526];
            weights = [0.3478548451374538, 0.6521451548625461, 0.6521451548625461, 0.3478548451374538];
        case 5
            % 5-point rule (exact for polynomials up to degree 9)
            nodes = [-0.906179845938664, -0.538469310105683, 0.0, 0.538469310105683, 0.906179845938664];
            weights = [0.236926885056189, 0.478628670499366, 0.568888888888889, 0.478628670499366, 0.236926885056189];
    end

    % --- 2. Change of Variables (from interval [a, b] to [-1, 1]) ---
    % We need to transform the variable x from [a, b] to t from [-1, 1].
    % The transformation is: x = (b-a)/2 * t + (b+a)/2
    % And the differential dx becomes: dx = (b-a)/2 * dt
    c1 = (b - a) / 2;
    c2 = (b + a) / 2;

    % --- 3. Apply the Quadrature Formula ---
    % The formula is: Integral(f(x) dx) ~ c1 * sum(w_i * f(c1*t_i + c2))
    sum_terms = 0;
    for i = 1:n
        % Transform the node from t_i to x_i
        x_i = c1 * nodes(i) + c2;

        % Evaluate the function at the transformed node
        f_x_i = func(x_i);

        % Add the weighted term to the sum
        sum_terms = sum_terms + weights(i) * f_x_i;
    end

    % --- 4. Final Calculation ---
    approx_integral = c1 * sum_terms;

end