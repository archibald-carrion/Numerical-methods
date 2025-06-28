% my_function.m
%
% A sample function to be used for numerical integration examples.
%
% Syntax:
%   y = my_function(x)
%
% Input:
%   x: A scalar or array of input values.
%
% Output:
%   y: The corresponding function output for the given x.

function y = my_function(x)
    y = x.^2 + 2.*x + 1;
end