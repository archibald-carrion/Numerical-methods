# 🧮 Numerical Methods with Interactive Visualizations

Welcome to this comprehensive repository dedicated to **Numerical Methods with Interactive Visualizations**, built with the goal of **understanding the logic and behavior** of classical algorithms through **visual exploration**.

> 📌 This project is educational and exploratory. It focuses on helping users *learn and visualize* numerical methods rather than serving as a production-grade solver tool.

---

## 📚 Table of Contents

- [🧮 Numerical Methods with Interactive Visualizations](#-numerical-methods-with-interactive-visualizations)
  - [📚 Table of Contents](#-table-of-contents)
  - [📖 Overview](#-overview)
  - [📂 Repository Structure](#-repository-structure)
  - [📌 Implemented Methods](#-implemented-methods)
    - [Non-Linear Equation Solvers](#non-linear-equation-solvers)
    - [Linear System Solvers](#linear-system-solvers)
  - [Related Projects](#related-projects)
  - [🧪 Installation \& Usage](#-installation--usage)

---

## 📖 Overview

This repository serves as a comprehensive collection of numerical methods implementations with a strong focus on visualization and education. Each algorithm is implemented with interactive tools that demonstrate the step-by-step process, making it easier to understand the underlying concepts.

The methods are implemented primarily in Python using CustomTkinter for the GUI, with additional basic implementations in MATLAB for reference.

Rather than aiming to be a production-grade solver, this project prioritizes clarity and visual understanding to help students, educators, and enthusiasts gain intuition about these important computational techniques.

---

## 📂 Repository Structure

```
numerical-methods/
├── README.md
├── methods_for_solving_linear_systems
│   └── README.md
└── methods_for_solving_nonlinear_equations
    ├── README.md
    └── bisection_method
        └── src
            ├── __pycache__
            │   └── app.cpython-310.pyc
            ├── backend
            │   └── app.py
            ├── frontend
            │   └── bisection_app.py
            └── mathlab
                ├── bisection_method_mathlab.ipynb
                └── bisection_method_mathlab.mlx
```

---

## 📌 Implemented Methods

### Non-Linear Equation Solvers

Methods for solving equations of the form f(x) = 0:

- 🔁 **Bisection Method** 
  - Guaranteed convergence under sign-change condition.
  - [Go to implementation](/methods_for_solving_nonlinear_equations/bisection_method)

### Linear System Solvers

Methods for solving systems of the form Ax = b:
<!-- 
- 🔍 **Gaussian Elimination**
  - Direct method with forward elimination and back substitution.
  - [Go to implementation](/linear-systems/gaussian_elimination)
  
- 🔄 **Jacobi Method**
  - Iterative method with parallel updates.
  - [Go to implementation](/linear-systems/jacobi_method) -->

---

## Related Projects
- [Monte Carlo pi Estimation](https://github.com/archibald-carrion/Pi-estimation-using-Monte-Carlo-method) is a project that estimates the value of pi using the Monte Carlo method. It provides an interactive visualization of the process, allowing users to see how the estimation improves with more iterations.

---

## 🧪 Installation & Usage

Clone the repository:

```bash
git clone https://github.com/archibald-carrion/Numerical-methods.git
cd Numerical-methods
```

Once downloaded, you can navigate to the specific method's directory and run the corresponding script, note that the project use a variety of languages, so you may need to install the required dependencies for each method, each method has its own README file with instructions on how to run it.

If you wish to run GNU Octave or MATLAB scripts, ensure you have the respective software installed, you can follow the [GNU Octave installation guide](https://github.com/archibald-carrion/Numerical-methods/doc/gnu_octave_instalation.md) to do so.