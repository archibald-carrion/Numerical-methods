# Gauss-Legendre Quadrature Nodes and Weights

![Julia](https://img.shields.io/badge/Julia-9558B2?style=for-the-badge&logo=julia&logoColor=white)

A simple Julia implementation for computing and displaying Gauss-Legendre quadrature nodes and weights.

## Mathematical Background

Gauss-Legendre quadrature approximates definite integrals using the formula:

$$\int_{-1}^{1} f(x) dx \approx \sum_{i=1}^{n} w_i f(x_i)$$

Where:
- $x_i$ are the **nodes** (roots of the nth Legendre polynomial)
- $w_i$ are the **weights** computed from the Legendre polynomial derivatives
- $n$ is the number of quadrature points

## Accuracy

For polynomials of degree $2n-1$ or less, Gauss-Legendre quadrature is **exact**.

## Dependencies

- `FastGaussQuadrature.jl` - High-performance Gaussian quadrature
- `Printf.jl` - Formatted output (built-in)

## Installation

```julia
import Pkg; Pkg.add("FastGaussQuadrature")
```

## Integration Interval

To integrate over $[a,b]$ instead of $[-1,1]$, use the transformation:

$$\int_{a}^{b} f(x) dx = \frac{b-a}{2} \int_{-1}^{1} f\left(\frac{b-a}{2}t + \frac{a+b}{2}\right) dt$$