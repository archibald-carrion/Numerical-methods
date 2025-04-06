# 🧮 Numerical Analysis — Non-Linear Equation Solvers with Interactive Visualizations

Welcome to this repository dedicated to **Numerical Methods for Solving Non-Linear Equations**, built with the goal of **understanding the logic and behavior** of classical algorithms through **interactive visualizations**.

> 📌 This project is educational and exploratory. It focuses on helping users *learn and visualize* the methods rather than serving as a production-grade solver tool.

---

## 📚 Table of Contents

- [🧮 Numerical Analysis — Non-Linear Equation Solvers with Interactive Visualizations](#-numerical-analysis--non-linear-equation-solvers-with-interactive-visualizations)
  - [📚 Table of Contents](#-table-of-contents)
  - [📖 Overview](#-overview)
  - [📌 Implemented Methods](#-implemented-methods)
  - [📌 Method to implement](#-method-to-implement)
  - [🧪 Installation \& Usage](#-installation--usage)
  - [🖼️ Screenshots](#️-screenshots)
  - [TODO](#todo)

---

## 📖 Overview

In numerical analysis, solving non-linear equations of the form:

```math
f(x) = 0
```

is a central topic. This repository implements several classical algorithms that approximate the solution or root of such equations. The main focus is to **visualize** each step and provide **interactive tools** for learning how and why these methods work.

The methods are implemented in Python using CustomTkinter for the GUI, in addition, most method also have a very basic [mathlab](https://la.mathworks.com/products/matlab.html) implementation.

For the moment the project does not provide a full-fledged toolbox for solving non-linear equations, as in multiple example we use an hardcoded polynomial function. It would be great in the future to propose a functional tool like my [linear programming solver](https://github.com/archibald-carrion/Linear-programming-solver), where the user can input any function and the solver will find the roots.

---

## 📌 Implemented Methods

- 🔁 [**Bisection Method**](https://github.com/archibald-carrion/Numerical-methods-for-solving-nonlinear-equations/tree/main/bisection_method) 
  - Guaranteed convergence under sign-change condition.

Each method includes:
- Step-by-step plot of iterations  
- Convergence analysis  
- Error tracking
## 📌 Method to implement
- 🧮 **Newton-Raphson Method**  
  - Fast convergence with derivative; sensitive to initial guess.
- 🧠 **Secant Method**  
  - Derivative-free alternative to Newton-Raphson.
- 🔀 **False Position (Regula Falsi)**  
  - Like bisection but adjusts more intelligently.
- 🌀 **Fixed Point Iteration**  
  - Transforms equation into `x = g(x)` and iterates.


---

## 🧪 Installation & Usage

Clone the repo:

```bash
git clone https://github.com/archibald-carrion/Numerical-methods-for-solving-nonlinear-equations.git
```

Install dependenciesc (each method has its own requirements):

```bash
pip install -r requirements.txt
```

---

## 🖼️ Screenshots

> *Add screenshots here of your GUI or notebook plots*

---

## TODO
- [ ] Add more methods (Newton-Raphson, Secant, etc.)
- [ ] Add feature to export to csv the results of the iterations
- [ ] Add feature to export the plot as an image
- [ ] Add requirements.txt for each method
- [ ] Add a README for each method with a description of the algorithm and how to use it