#!/usr/bin/env julia

# Forward and Backward Substitution GUI Application
# This application demonstrates the forward and backward substitution methods
# for solving triangular linear systems

using Gtk
using Gtk.ShortNames  # Import all Gtk widgets including Notebook
using LinearAlgebra
using Printf

"""
    forward_substitution(L, b)

Solves a lower triangular system Lx = b using forward substitution.
Returns the solution vector x and the steps of computation.
"""
function forward_substitution(L, b)
    n = size(L, 1)
    x = zeros(Float64, n)
    steps = []
    
    for i in 1:n
        sum_val = 0.0
        for j in 1:(i-1)
            sum_val += L[i, j] * x[j]
            push!(steps, (i=i, j=j, sum=sum_val, x_j=x[j], product=L[i, j] * x[j]))
        end
        x[i] = (b[i] - sum_val) / L[i, i]
        push!(steps, (i=i, x_i=x[i], b_i=b[i], sum=sum_val, diag=L[i, i]))
    end
    
    return x, steps
end

"""
    backward_substitution(U, b)

Solves an upper triangular system Ux = b using backward substitution.
Returns the solution vector x and the steps of computation.
"""
function backward_substitution(U, b)
    n = size(U, 1)
    x = zeros(Float64, n)
    steps = []
    
    for i in n:-1:1
        sum_val = 0.0
        for j in (i+1):n
            sum_val += U[i, j] * x[j]
            push!(steps, (i=i, j=j, sum=sum_val, x_j=x[j], product=U[i, j] * x[j]))
        end
        x[i] = (b[i] - sum_val) / U[i, i]
        push!(steps, (i=i, x_i=x[i], b_i=b[i], sum=sum_val, diag=U[i, i]))
    end
    
    return x, steps
end

"""
    create_matrix_input_grid(rows, cols, default_values=nothing)

Creates a grid of entry widgets for inputting a matrix.
"""
function create_matrix_input_grid(rows, cols, default_values=nothing)
    grid = Grid()
    
    entries = Matrix{GtkEntry}(undef, rows, cols)
    
    for i in 1:rows
        for j in 1:cols
            entry = Entry()
            if default_values !== nothing && i >= j  # For lower triangular
                set_gtk_property!(entry, :text, string(default_values[i, j]))
            elseif default_values !== nothing && i <= j  # For upper triangular
                set_gtk_property!(entry, :text, string(default_values[i, j]))
            else
                set_gtk_property!(entry, :text, "0.0")
            end
            
            if (default_values !== nothing && 
                ((j > i && typeof(default_values) <: LowerTriangular) || 
                 (j < i && typeof(default_values) <: UpperTriangular)))
                set_gtk_property!(entry, :sensitive, false)
                set_gtk_property!(entry, :text, "0.0")
            end
            
            grid[j, i] = entry  # Note: Gtk coordinates are column, row
            entries[i, j] = entry
        end
    end
    
    return grid, entries
end

"""
    create_vector_input_grid(rows)

Creates a grid of entry widgets for inputting a vector.
"""
function create_vector_input_grid(rows)
    grid = Grid()
    
    entries = Vector{GtkEntry}(undef, rows)
    
    for i in 1:rows
        entry = Entry()
        set_gtk_property!(entry, :text, "0.0")
        grid[1, i] = entry
        entries[i] = entry
    end
    
    return grid, entries
end

"""
    get_matrix_from_entries(entries)

Extracts matrix values from entry widgets.
"""
function get_matrix_from_entries(entries)
    rows, cols = size(entries)
    matrix = zeros(Float64, rows, cols)
    
    for i in 1:rows
        for j in 1:cols
            matrix[i, j] = parse(Float64, get_gtk_property(entries[i, j], :text, String))
        end
    end
    
    return matrix
end

"""
    get_vector_from_entries(entries)

Extracts vector values from entry widgets.
"""
function get_vector_from_entries(entries)
    vector = zeros(Float64, length(entries))
    
    for i in 1:length(entries)
        vector[i] = parse(Float64, get_gtk_property(entries[i], :text, String))
    end
    
    return vector
end

"""
    format_matrix_for_display(matrix)

Formats a matrix for display in a text view.
"""
function format_matrix_for_display(matrix)
    rows, cols = size(matrix)
    result = ""
    
    for i in 1:rows
        result *= "["
        for j in 1:cols
            result *= @sprintf("%.4f", matrix[i, j])
            if j < cols
                result *= "  "
            end
        end
        result *= "]\n"
    end
    
    return result
end

"""
    format_vector_for_display(vector)

Formats a vector for display in a text view.
"""
function format_vector_for_display(vector)
    result = ""
    
    for i in 1:length(vector)
        result *= @sprintf("[%.4f]\n", vector[i])
    end
    
    return result
end

"""
    format_steps_for_display(steps, method_type)

Formats computation steps for display in a text view.
"""
function format_steps_for_display(steps, method_type)
    result = "Step-by-step $method_type:\n\n"
    step_count = 1
    
    for step in steps
        if haskey(step, :j)  # This is a multiplication step
            result *= "Step $step_count: Computing element for equation $(step.i)\n"
            result *= @sprintf("  Adding L[%d,%d] * x[%d] = %.4f * %.4f = %.4f\n", 
                           step.i, step.j, step.j, step.product/step.x_j, step.x_j, step.product)
        else  # This is a solution step for x[i]
            result *= "Step $step_count: Solving for x[$(step.i)]\n"
            result *= @sprintf("  x[%d] = (b[%d] - sum) / L[%d,%d]\n", 
                           step.i, step.i, step.i, step.i)
            result *= @sprintf("  x[%d] = (%.4f - %.4f) / %.4f = %.4f\n", 
                           step.i, step.b_i, step.sum, step.diag, step.x_i)
            result *= "\n"
        end
        step_count += 1
    end
    
    return result
end

"""
    create_example_matrix(size, type)

Creates an example matrix for demonstration purposes.
"""
function create_example_matrix(size, type)
    if type == "lower"
        # Create a well-conditioned lower triangular matrix
        L = zeros(Float64, size, size)
        for i in 1:size
            L[i, i] = rand(2:5)  # Random diagonal elements
            for j in 1:(i-1)
                L[i, j] = rand(-3:3)  # Random lower triangular elements
            end
        end
        return LowerTriangular(L)
    else
        # Create a well-conditioned upper triangular matrix
        U = zeros(Float64, size, size)
        for i in 1:size
            U[i, i] = rand(2:5)  # Random diagonal elements
            for j in (i+1):size
                U[i, j] = rand(-3:3)  # Random upper triangular elements
            end
        end
        return UpperTriangular(U)
    end
end

"""
    create_example_vector(size)

Creates an example vector for demonstration purposes.
"""
function create_example_vector(size)
    return rand(-5:5, size)
end

# Main application function
function main()
    # Create the main window
    win = GtkWindow("Forward and Backward Substitution Solver", 1000, 700)
    
    # Create a notebook for tabbed interface
    notebook = Notebook()
    
    # Default matrix size
    matrix_size = 3

    # Create Forward Substitution Tab
    forward_box = Box(:v)
    
    forward_size_frame = Frame("Matrix Size")
    forward_size_box = Box(:h)
    forward_size_label = Label("Size:")
    forward_size_entry = SpinButton(3, 10, 1)
    set_gtk_property!(forward_size_entry, :value, matrix_size)
    push!(forward_size_box, forward_size_label)
    push!(forward_size_box, forward_size_entry)
    push!(forward_size_frame, forward_size_box)
    push!(forward_box, forward_size_frame)
    
    # Frame for L matrix input
    forward_matrix_frame = Frame("Lower Triangular Matrix (L)")
    forward_matrix_box = Box(:v)
    
    # Create example L matrix
    L_example = LowerTriangular(create_example_matrix(matrix_size, "lower"))
    b_example = create_example_vector(matrix_size)
    
    # Initial L matrix grid
    L_grid, L_entries = create_matrix_input_grid(matrix_size, matrix_size, L_example)
    push!(forward_matrix_box, L_grid)
    push!(forward_matrix_frame, forward_matrix_box)
    push!(forward_box, forward_matrix_frame)
    
    # Frame for b vector input
    forward_vector_frame = Frame("Right-hand Side Vector (b)")
    forward_vector_box = Box(:v)
    
    # Initial b vector grid
    b_grid, b_entries = create_vector_input_grid(matrix_size)
    for i in 1:matrix_size
        set_gtk_property!(b_entries[i], :text, string(b_example[i]))
    end
    
    push!(forward_vector_box, b_grid)
    push!(forward_vector_frame, forward_vector_box)
    push!(forward_box, forward_vector_frame)
    
    # Solve button
    forward_solve_button = Button("Solve Lx = b")
    push!(forward_box, forward_solve_button)
    
    # Results display
    forward_results_frame = Frame("Results")
    forward_results_box = Box(:v)
    
    forward_solution_label = Label("Solution Vector (x):")
    push!(forward_results_box, forward_solution_label)
    
    forward_solution_view = TextView()
    forward_solution_buffer = get_gtk_property(forward_solution_view, :buffer, GtkTextBuffer)
    set_gtk_property!(forward_solution_view, :editable, false)
    set_gtk_property!(forward_solution_view, :cursor_visible, false)
    forward_solution_scroll = ScrolledWindow()
    push!(forward_solution_scroll, forward_solution_view)
    set_gtk_property!(forward_solution_scroll, :min_content_height, 100)
    push!(forward_results_box, forward_solution_scroll)
    
    forward_steps_label = Label("Computation Steps:")
    push!(forward_results_box, forward_steps_label)
    
    forward_steps_view = TextView()
    forward_steps_buffer = get_gtk_property(forward_steps_view, :buffer, GtkTextBuffer)
    set_gtk_property!(forward_steps_view, :editable, false)
    set_gtk_property!(forward_steps_view, :cursor_visible, false)
    forward_steps_scroll = ScrolledWindow()
    push!(forward_steps_scroll, forward_steps_view)
    set_gtk_property!(forward_steps_scroll, :min_content_height, 200)
    push!(forward_results_box, forward_steps_scroll)
    
    push!(forward_results_frame, forward_results_box)
    push!(forward_box, forward_results_frame)
    
    # Create Backward Substitution Tab
    backward_box = Box(:v)
    
    backward_size_frame = Frame("Matrix Size")
    backward_size_box = Box(:h)
    backward_size_label = Label("Size:")
    backward_size_entry = SpinButton(3, 10, 1)
    set_gtk_property!(backward_size_entry, :value, matrix_size)
    push!(backward_size_box, backward_size_label)
    push!(backward_size_box, backward_size_entry)
    push!(backward_size_frame, backward_size_box)
    push!(backward_box, backward_size_frame)
    
    # Frame for U matrix input
    backward_matrix_frame = Frame("Upper Triangular Matrix (U)")
    backward_matrix_box = Box(:v)
    
    # Create example U matrix
    U_example = UpperTriangular(create_example_matrix(matrix_size, "upper"))
    
    # Initial U matrix grid
    U_grid, U_entries = create_matrix_input_grid(matrix_size, matrix_size, U_example)
    push!(backward_matrix_box, U_grid)
    push!(backward_matrix_frame, backward_matrix_box)
    push!(backward_box, backward_matrix_frame)
    
    # Frame for b vector input
    backward_vector_frame = Frame("Right-hand Side Vector (b)")
    backward_vector_box = Box(:v)
    
    # Initial b vector grid for backward substitution
    backward_b_grid, backward_b_entries = create_vector_input_grid(matrix_size)
    for i in 1:matrix_size
        set_gtk_property!(backward_b_entries[i], :text, string(b_example[i]))
    end
    
    push!(backward_vector_box, backward_b_grid)
    push!(backward_vector_frame, backward_vector_box)
    push!(backward_box, backward_vector_frame)
    
    # Solve button
    backward_solve_button = Button("Solve Ux = b")
    push!(backward_box, backward_solve_button)
    
    # Results display
    backward_results_frame = Frame("Results")
    backward_results_box = Box(:v)
    
    backward_solution_label = Label("Solution Vector (x):")
    push!(backward_results_box, backward_solution_label)
    
    backward_solution_view = TextView()
    backward_solution_buffer = get_gtk_property(backward_solution_view, :buffer, GtkTextBuffer)
    set_gtk_property!(backward_solution_view, :editable, false)
    set_gtk_property!(backward_solution_view, :cursor_visible, false)
    backward_solution_scroll = ScrolledWindow()
    push!(backward_solution_scroll, backward_solution_view)
    set_gtk_property!(backward_solution_scroll, :min_content_height, 100)
    push!(backward_results_box, backward_solution_scroll)
    
    backward_steps_label = Label("Computation Steps:")
    push!(backward_results_box, backward_steps_label)
    
    backward_steps_view = TextView()
    backward_steps_buffer = get_gtk_property(backward_steps_view, :buffer, GtkTextBuffer)
    set_gtk_property!(backward_steps_view, :editable, false)
    set_gtk_property!(backward_steps_view, :cursor_visible, false)
    backward_steps_scroll = ScrolledWindow()
    push!(backward_steps_scroll, backward_steps_view)
    set_gtk_property!(backward_steps_scroll, :min_content_height, 200)
    push!(backward_results_box, backward_steps_scroll)
    
    push!(backward_results_frame, backward_results_box)
    push!(backward_box, backward_results_frame)
    
    # Add tabs to notebook
    push!(notebook, forward_box, "Forward Substitution")
    push!(notebook, backward_box, "Backward Substitution")
    
    # Add notebook to window
    push!(win, notebook)
    
    # Define function to update matrix size for forward substitution
    function update_forward_matrix_size()
        new_size = Int(get_gtk_property(forward_size_entry, :value, Int))
        
        # Create new L matrix
        new_L = LowerTriangular(create_example_matrix(new_size, "lower"))
        new_b = create_example_vector(new_size)
        
        # Remove old grids
        if length(forward_matrix_box) > 0
            for child in forward_matrix_box
                destroy(child)
            end
        end
        if length(forward_vector_box) > 0
            for child in forward_vector_box
                destroy(child)
            end
        end
        
        # Create new grids
        L_grid, L_entries = create_matrix_input_grid(new_size, new_size, new_L)
        b_grid, b_entries = create_vector_input_grid(new_size)
        
        # Set b vector values
        for i in 1:new_size
            set_gtk_property!(b_entries[i], :text, string(new_b[i]))
        end
        
        # Add new grids
        push!(forward_matrix_box, L_grid)
        push!(forward_vector_box, b_grid)
        
        # Show all widgets
        Gtk.showall(win)
        
        return L_entries, b_entries
    end
    
    # Define function to update matrix size for backward substitution
    function update_backward_matrix_size()
        new_size = Int(get_gtk_property(backward_size_entry, :value, Int))
        
        # Create new U matrix
        new_U = UpperTriangular(create_example_matrix(new_size, "upper"))
        new_b = create_example_vector(new_size)
        
        # Remove old grids
        if length(backward_matrix_box) > 0
            for child in backward_matrix_box
                destroy(child)
            end
        end
        if length(backward_vector_box) > 0
            for child in backward_vector_box
                destroy(child)
            end
        end
        
        # Create new grids
        U_grid, U_entries = create_matrix_input_grid(new_size, new_size, new_U)
        b_grid, b_entries = create_vector_input_grid(new_size)
        
        # Set b vector values
        for i in 1:new_size
            set_gtk_property!(b_entries[i], :text, string(new_b[i]))
        end
        
        # Add new grids
        push!(backward_matrix_box, U_grid)
        push!(backward_vector_box, b_grid)
        
        # Show all widgets
        showall(win)
        
        return U_entries, b_entries
    end
    
    # Connect size change signals
    signal_connect(forward_size_entry, "value-changed") do widget
        L_entries, b_entries = update_forward_matrix_size()
    end
    
    signal_connect(backward_size_entry, "value-changed") do widget
        U_entries, b_entries = update_backward_matrix_size()
    end
    
    # Connect solve button signals
    signal_connect(forward_solve_button, "clicked") do widget
        # Get L matrix and b vector from entries
        L = get_matrix_from_entries(L_entries)
        b = get_vector_from_entries(b_entries)
        
        # Ensure L is lower triangular
        L = LowerTriangular(L)
        
        # Solve using forward substitution
        x, steps = forward_substitution(L, b)
        
        # Display results
        set_gtk_property!(forward_solution_buffer, :text, format_vector_for_display(x))
        set_gtk_property!(forward_steps_buffer, :text, format_steps_for_display(steps, "Forward Substitution"))
    end
    
    signal_connect(backward_solve_button, "clicked") do widget
        # Get U matrix and b vector from entries
        U = get_matrix_from_entries(U_entries)
        b = get_vector_from_entries(backward_b_entries)
        
        # Ensure U is upper triangular
        U = UpperTriangular(U)
        
        # Solve using backward substitution
        x, steps = backward_substitution(U, b)
        
        # Display results
        set_gtk_property!(backward_solution_buffer, :text, format_vector_for_display(x))
        set_gtk_property!(backward_steps_buffer, :text, format_steps_for_display(steps, "Backward Substitution"))
    end
    
    # Show all widgets
    Gtk.showall(win)
    
    # Connect delete window signal
    signal_connect(win, :destroy) do widget
        Gtk.gtk_quit()
    end
    
    # Start the Gtk event loop
    if !isinteractive()
        c = Condition()
        signal_connect(win, :destroy) do widget
            notify(c)
        end
        Gtk.showall(win)
        wait(c)
    else
        Gtk.showall(win)
    end
end

# Start the application
main()