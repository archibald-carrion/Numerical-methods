import tkinter as tk
import customtkinter as ctk
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
import time
import threading

# Set appearance mode and default color theme
ctk.set_appearance_mode("System")
ctk.set_default_color_theme("blue")

class BisectionMethodApp(ctk.CTk):
    def __init__(self):
        super().__init__()
        
        # Configure window
        self.title("Bisection Method Visualizer")
        self.geometry("1200x700")
        
        # Create main frames
        self.grid_columnconfigure(0, weight=7)
        self.grid_columnconfigure(1, weight=3)
        self.grid_rowconfigure(0, weight=1)
        
        self.plot_frame = ctk.CTkFrame(self)
        self.plot_frame.grid(row=0, column=0, padx=10, pady=10, sticky="nsew")
        
        self.control_frame = ctk.CTkFrame(self)
        self.control_frame.grid(row=0, column=1, padx=10, pady=10, sticky="nsew")
        
        # Initialize attributes
        self.a = 0
        self.b = 3
        self.max_iterations = 10
        self.step_by_step = False
        self.animation_running = False
        self.animation_paused = False
        self.animation_thread = None
        self.current_iteration = 0
        self.delay = 1.0  # seconds between iterations
        
        # Initialize plotting
        self.setup_plot()
        
        # Setup control panel
        self.setup_control_panel()

    def setup_plot(self):
        self.fig, self.ax = plt.subplots(figsize=(8, 6))
        self.canvas = FigureCanvasTkAgg(self.fig, master=self.plot_frame)
        self.canvas.get_tk_widget().pack(fill=tk.BOTH, expand=True)
        self.plot_initial_function()
        
    def setup_control_panel(self):
        # Title
        title_label = ctk.CTkLabel(self.control_frame, text="Bisection Method Controls", 
                                  font=ctk.CTkFont(size=20, weight="bold"))
        title_label.pack(pady=(20, 30))
        
        # Input parameters
        param_frame = ctk.CTkFrame(self.control_frame)
        param_frame.pack(fill="x", padx=20, pady=10)
        
        # Point A
        a_frame = ctk.CTkFrame(param_frame)
        a_frame.pack(fill="x", pady=5)
        a_label = ctk.CTkLabel(a_frame, text="Point A:")
        a_label.pack(side="left", padx=10)
        self.a_entry = ctk.CTkEntry(a_frame)
        self.a_entry.pack(side="right", padx=10)
        self.a_entry.insert(0, str(self.a))
        
        # Point B
        b_frame = ctk.CTkFrame(param_frame)
        b_frame.pack(fill="x", pady=5)
        b_label = ctk.CTkLabel(b_frame, text="Point B:")
        b_label.pack(side="left", padx=10)
        self.b_entry = ctk.CTkEntry(b_frame)
        self.b_entry.pack(side="right", padx=10)
        self.b_entry.insert(0, str(self.b))
        
        # Max iterations
        iter_frame = ctk.CTkFrame(param_frame)
        iter_frame.pack(fill="x", pady=5)
        iter_label = ctk.CTkLabel(iter_frame, text="Max Iterations:")
        iter_label.pack(side="left", padx=10)
        self.iter_entry = ctk.CTkEntry(iter_frame)
        self.iter_entry.pack(side="right", padx=10)
        self.iter_entry.insert(0, str(self.max_iterations))
        
        # Delay
        delay_frame = ctk.CTkFrame(param_frame)
        delay_frame.pack(fill="x", pady=5)
        delay_label = ctk.CTkLabel(delay_frame, text="Delay (seconds):")
        delay_label.pack(side="left", padx=10)
        self.delay_entry = ctk.CTkEntry(delay_frame)
        self.delay_entry.pack(side="right", padx=10)
        self.delay_entry.insert(0, str(self.delay))
        
        # Step by step toggle
        toggle_frame = ctk.CTkFrame(self.control_frame)
        toggle_frame.pack(fill="x", padx=20, pady=10)
        self.step_toggle = ctk.CTkSwitch(toggle_frame, text="Step by Step Mode", 
                                         command=self.toggle_step_mode)
        self.step_toggle.pack(pady=10)
        
        # Control buttons
        button_frame = ctk.CTkFrame(self.control_frame)
        button_frame.pack(fill="x", padx=20, pady=10)
        
        self.start_button = ctk.CTkButton(button_frame, text="Start Simulation", 
                                         command=self.start_simulation)
        self.start_button.pack(pady=5, fill="x")
        
        self.step_button = ctk.CTkButton(button_frame, text="Next Step", 
                                        command=self.next_step, state="disabled")
        self.step_button.pack(pady=5, fill="x")
        
        self.reset_button = ctk.CTkButton(button_frame, text="Reset", 
                                         command=self.reset_simulation)
        self.reset_button.pack(pady=5, fill="x")
        
        # Results section
        results_frame = ctk.CTkFrame(self.control_frame)
        results_frame.pack(fill="x", padx=20, pady=10, expand=True)
        
        results_label = ctk.CTkLabel(results_frame, text="Results", 
                                    font=ctk.CTkFont(size=16, weight="bold"))
        results_label.pack(pady=5)
        
        self.iteration_label = ctk.CTkLabel(results_frame, text="Iteration: 0")
        self.iteration_label.pack(pady=2)
        
        self.interval_label = ctk.CTkLabel(results_frame, text="Current Interval: [-]")
        self.interval_label.pack(pady=2)
        
        self.midpoint_label = ctk.CTkLabel(results_frame, text="Midpoint: -")
        self.midpoint_label.pack(pady=2)
        
        self.root_label = ctk.CTkLabel(results_frame, text="Approximate Root: -")
        self.root_label.pack(pady=2)
        
        self.error_label = ctk.CTkLabel(results_frame, text="Error: -")
        self.error_label.pack(pady=2)
        
    def toggle_step_mode(self):
        self.step_by_step = self.step_toggle.get()
        if self.step_by_step:
            self.step_button.configure(state="normal")
        else:
            self.step_button.configure(state="disabled")
    
    def polynomial_function(self, x):
        # Example: f(x) = x^2 - 4 (roots at x = ±2)
        return x**2 - 4
    
    def plot_initial_function(self):
        self.ax.clear()
        x = np.linspace(-5, 5, 1000)
        y = self.polynomial_function(x)
        
        # Plot the function
        self.ax.plot(x, y, 'b-', linewidth=2, label='f(x) = x² - 4')
        
        # Plot x-axis
        self.ax.axhline(y=0, color='k', linestyle='-', alpha=0.3)
        
        # Set labels and title
        self.ax.set_xlabel('x')
        self.ax.set_ylabel('f(x)')
        self.ax.set_title('Bisection Method Visualization')
        self.ax.grid(True, linestyle='--', alpha=0.7)
        self.ax.legend()
        
        self.canvas.draw()
    
    def update_plot(self, a, b, c, fa, fb, fc):
        self.ax.clear()
        
        # Plot the function
        x = np.linspace(-5, 5, 1000)
        y = self.polynomial_function(x)
        self.ax.plot(x, y, 'b-', linewidth=2, label='f(x) = x² - 4')
        
        # Plot x-axis
        self.ax.axhline(y=0, color='k', linestyle='-', alpha=0.3)
        
        # Highlight the current interval
        x_interval = np.linspace(a, b, 100)
        y_interval = self.polynomial_function(x_interval)
        self.ax.plot(x_interval, y_interval, 'g-', linewidth=4, alpha=0.5)
        
        # Plot the endpoints and midpoint
        self.ax.plot(a, fa, 'ro', markersize=8, label=f'a = {a:.4f}')
        self.ax.plot(b, fb, 'go', markersize=8, label=f'b = {b:.4f}')
        self.ax.plot(c, fc, 'mo', markersize=10, label=f'c = {c:.4f}')
        
        # Plot vertical lines from points to x-axis
        self.ax.plot([a, a], [0, fa], 'r--', alpha=0.5)
        self.ax.plot([b, b], [0, fb], 'g--', alpha=0.5)
        self.ax.plot([c, c], [0, fc], 'm--', alpha=0.5)
        
        # Set labels and title
        self.ax.set_xlabel('x')
        self.ax.set_ylabel('f(x)')
        self.ax.set_title(f'Bisection Method - Iteration {self.current_iteration}')
        self.ax.grid(True, linestyle='--', alpha=0.7)
        self.ax.legend()
        
        # Adjust view to focus on the relevant part
        x_margin = (b - a) * 0.5
        self.ax.set_xlim(a - x_margin, b + x_margin)
        
        y_values = [fa, fb, fc]
        y_min, y_max = min(y_values), max(y_values)
        y_margin = (y_max - y_min) * 0.5
        self.ax.set_ylim(min(y_min - y_margin, -1), max(y_max + y_margin, 1))
        
        self.canvas.draw()
    
    def bisection_step(self, a, b):
        fa = self.polynomial_function(a)
        fb = self.polynomial_function(b)
        
        # Calculate midpoint
        c = (a + b) / 2
        fc = self.polynomial_function(c)
        
        # Determine new interval
        if fa * fc < 0:
            new_a, new_b = a, c
        else:
            new_a, new_b = c, b
            
        # Update plot and labels
        self.update_plot(a, b, c, fa, fb, fc)
        self.iteration_label.configure(text=f"Iteration: {self.current_iteration}")
        self.interval_label.configure(text=f"Current Interval: [{a:.6f}, {b:.6f}]")
        self.midpoint_label.configure(text=f"Midpoint: {c:.6f}")
        self.root_label.configure(text=f"Approximate Root: {c:.6f}")
        self.error_label.configure(text=f"Error: {abs(b - a) / 2:.6f}")
        
        return new_a, new_b
    
    def validate_inputs(self):
        try:
            a = float(self.a_entry.get())
            b = float(self.b_entry.get())
            max_iter = int(self.iter_entry.get())
            delay = float(self.delay_entry.get())
            
            fa = self.polynomial_function(a)
            fb = self.polynomial_function(b)
            
            if fa * fb >= 0:
                tk.messagebox.showerror("Invalid Interval", 
                                       "Function must have opposite signs at interval endpoints!")
                return False
                
            if a >= b:
                tk.messagebox.showerror("Invalid Interval", "Point A must be less than Point B!")
                return False
                
            if max_iter <= 0:
                tk.messagebox.showerror("Invalid Input", "Max iterations must be positive!")
                return False
                
            if delay <= 0:
                tk.messagebox.showerror("Invalid Input", "Delay must be positive!")
                return False
                
            self.a = a
            self.b = b
            self.max_iterations = max_iter
            self.delay = delay
            return True
            
        except ValueError:
            tk.messagebox.showerror("Invalid Input", "Please enter valid numbers!")
            return False
    
    def update_ui_states(self, running=False):
        state = "disabled" if running else "normal"
        self.a_entry.configure(state=state)
        self.b_entry.configure(state=state)
        self.iter_entry.configure(state=state)
        self.delay_entry.configure(state=state)
        self.step_toggle.configure(state=state)
        
        if running:
            self.start_button.configure(text="Stop", command=self.stop_simulation)
            if self.step_by_step:
                self.step_button.configure(state="normal")
            else:
                self.step_button.configure(state="disabled")
        else:
            self.start_button.configure(text="Start Simulation", command=self.start_simulation)
            self.step_button.configure(state="disabled")
    
    def start_simulation(self):
        if self.animation_running:
            self.stop_simulation()
            return
            
        if not self.validate_inputs():
            return
            
        self.reset_simulation(update_plot=False)
        self.animation_running = True
        self.update_ui_states(running=True)
        
        if self.step_by_step:
            # Just prepare for step-by-step execution
            self.next_step()
        else:
            # Start automatic animation in a separate thread
            self.animation_thread = threading.Thread(target=self.run_animation)
            self.animation_thread.daemon = True
            self.animation_thread.start()
    
    def stop_simulation(self):
        self.animation_running = False
        if self.animation_thread:
            self.animation_thread.join(timeout=0.5)
        self.update_ui_states(running=False)
    
    def next_step(self):
        if self.current_iteration < self.max_iterations and self.animation_running:
            self.current_iteration += 1
            self.a, self.b = self.bisection_step(self.a, self.b)
            
            # Check for convergence
            error = abs(self.b - self.a) / 2
            if error < 1e-6:
                self.animation_running = False
                self.update_ui_states(running=False)
                tk.messagebox.showinfo("Convergence", f"Method converged to root: {(self.a + self.b)/2:.6f} with error < 1e-6")
        
        elif self.current_iteration >= self.max_iterations:
            self.animation_running = False
            self.update_ui_states(running=False)
            tk.messagebox.showinfo("Max Iterations", f"Reached maximum iterations ({self.max_iterations}).\nApproximate root: {(self.a + self.b)/2:.6f}")
    
    def run_animation(self):
        while self.animation_running and self.current_iteration < self.max_iterations:
            self.current_iteration += 1
            
            # We need to use after() to safely update the UI from a thread
            self.after(0, lambda a=self.a, b=self.b: self.update_animation_step(a, b))
            
            # Check for convergence
            error = abs(self.b - self.a) / 2
            if error < 1e-6:
                self.after(0, lambda: self.show_convergence_message((self.a + self.b)/2))
                break
                
            time.sleep(self.delay)
        
        if self.current_iteration >= self.max_iterations and self.animation_running:
            self.after(0, lambda: self.show_max_iterations_message((self.a + self.b)/2))
    
    def update_animation_step(self, a, b):
        self.a, self.b = self.bisection_step(a, b)
    
    def show_convergence_message(self, root):
        self.animation_running = False
        self.update_ui_states(running=False)
        tk.messagebox.showinfo("Convergence", f"Method converged to root: {root:.6f} with error < 1e-6")
    
    def show_max_iterations_message(self, root):
        self.animation_running = False
        self.update_ui_states(running=False)
        tk.messagebox.showinfo("Max Iterations", f"Reached maximum iterations ({self.max_iterations}).\nApproximate root: {root:.6f}")
    
    def reset_simulation(self, update_plot=True):
        self.animation_running = False
        self.current_iteration = 0
        
        if update_plot:
            self.a = float(self.a_entry.get())
            self.b = float(self.b_entry.get())
            self.plot_initial_function()
        
        self.iteration_label.configure(text="Iteration: 0")
        self.interval_label.configure(text="Current Interval: [-]")
        self.midpoint_label.configure(text="Midpoint: -")
        self.root_label.configure(text="Approximate Root: -")
        self.error_label.configure(text="Error: -")
        self.update_ui_states(running=False)

if __name__ == "__main__":
    app = BisectionMethodApp()
    app.mainloop()