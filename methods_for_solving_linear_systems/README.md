# 🧮 Numerical Analysis — Linear System Solvers with Interactive Visualizations

Welcome to this repository dedicated to **Numerical Methods for Solving Linear Systems**, built with the goal of **understanding the logic and behavior** of classical algorithms through **interactive visualizations**.

> 📌 This project is educational and exploratory. It focuses on helping users *learn and visualize* the methods rather than serving as a production-grade solver tool.

---

## 📚 Table of Contents

- [🧮 Numerical Analysis — Linear System Solvers with Interactive Visualizations](#-numerical-analysis--linear-system-solvers-with-interactive-visualizations)
  - [📚 Table of Contents](#-table-of-contents)
  - [📖 Overview](#-overview)
  - [📌 Implemented Methods](#-implemented-methods)
  - [📌 Methods to Implement](#-methods-to-implement)
  - [🖼️ Screenshots](#️-screenshots)
  - [TODO](#todo)

---

## 📖 Overview

In numerical analysis, solving linear systems of the form:

```math
Ax = b
```

where A is an n×n matrix, x is the solution vector, and b is the right-hand side vector, is a fundamental problem. This repository implements several classical algorithms that solve such systems. The main focus is to **visualize** each step and provide **interactive tools** for learning how and why these methods work.

This repo does not use one particular stack or language. Some example use Python, Matlab, and other Julia. The goal is to provide a variety of implementations to demonstrate the concepts behind each method.

The project aims to provide an educational tool for understanding the behavior of these algorithms rather than a full-fledged production solver. Each implementation demonstrates the iterative process visually to help users grasp the underlying concepts.

---

## 📌 Implemented Methods
<!-- 
- 🔍 [**Gaussian Elimination**](https://github.com/username/Linear-System-Solvers/tree/main/gaussian_elimination)
  - Direct method with forward elimination and back substitution.
  
- 🔄 [**Jacobi Method**](https://github.com/username/Linear-System-Solvers/tree/main/jacobi_method)
  - Iterative method with parallel updates.

Each method includes:
- Step-by-step visualization of iterations
- Convergence analysis
- Error tracking
- Interactive parameter adjustment -->

## 📌 Methods to Implement

- 🔄 **Jacobi Method**
  - Iterative method with parallel updates.

- 🔍**Gaussian Elimination**
  - Direct method with forward elimination and back substitution.

- 🔁 **Gauss-Seidel Method**
  - Iterative method with sequential updates for faster convergence.

- 🧮 **LU Decomposition**
  - Factorizes A into L (lower triangular) and U (upper triangular) matrices.

- 🔢 **Cholesky Decomposition**
  - Specialized for symmetric positive-definite matrices.

- 🔄 **Successive Over-Relaxation (SOR)**
  - Enhanced Gauss-Seidel with relaxation parameter.

- 📊 **Conjugate Gradient Method**
  - Iterative method for sparse, symmetric, positive-definite systems.

---

## 🖼️ Screenshots

> *Screenshots of the GUI visualizations will be added here as methods are implemented*

---

## TODO
- [ ] Add more methods (Gauss-Seidel, LU Decomposition, etc.)
- [ ] Implement sparse matrix support for large systems
- [ ] Add feature to export iteration results to CSV
- [ ] Add feature to export plots as images
- [ ] Add requirements.txt for each method
- [ ] Add a README for each method with algorithm description and usage
- [ ] Implement 3D visualizations for systems with 3 variables
- [ ] Add performance benchmarks comparing different methods