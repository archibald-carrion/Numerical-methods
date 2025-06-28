# GNU Octave Installation and Command Line Usage

GNU Octave is a high-level programming language primarily intended for scientific computing and numerical analysis. It's largely compatible with MATLAB and provides a powerful command-line interface for mathematical computations.

## Installation

### Windows

1. Visit the [GNU Octave website](https://www.gnu.org/software/octave/)
2. Download the Windows installer (.exe file)
3. Run the installer and follow the setup wizard
4. Choose installation directory (default is usually fine)
5. Add Octave to PATH

### Linux

TODO: Add instructions for main distributions (Ubuntu, etc.)

## Verifying Installation

After installation, verify Octave is properly installed and accessible from the command line:

```bash
octave --version
```

This should display the Octave version information.
You can also try executing the `example.m` script provided below to ensure everything is working correctly.

## Command Line Usage

```bash
octave # Start Octave in command line mode

octave script.m # Execute a script file
```

## Basic Octave Commands

Once in the Octave command line interface:

```octave
% Basic arithmetic
2 + 3
5 * 7
sqrt(16)

% Create vectors and matrices
v = [1, 2, 3, 4]
m = [1, 2; 3, 4]

% Plot (if graphics are available)
x = 0:0.1:10;
y = sin(x);
plot(x, y)

% Get help
help plot
doc matrix

% Exit Octave
exit
% or
quit
```

## Troubleshooting

### Common Issues

**Octave not found in PATH**
- Ensure Octave's bin directory is added to your system PATH, on windows my path is `C:\Program Files\GNU Octave\Octave-10.2.0\mingw64\bin`
- Try using the full path to the Octave executable

## Useful Resources

- [Official GNU Octave Documentation](https://docs.octave.org/)
- [Octave Wiki](https://wiki.octave.org/)
- [MATLAB to Octave Porting Guide](https://en.wikibooks.org/wiki/MATLAB_Programming/Differences_between_Octave_and_MATLAB)

## Example Script Usage

Create a file called `example.m`:
```octave
% example.m
x = linspace(0, 2*pi, 100);
y = sin(x);
plot(x, y);
title('Sine Wave');
xlabel('x');
ylabel('sin(x)');
print('sine_wave.png');
```

Run it from command line:
```bash
octave --no-gui example.m
```

This will generate a sine wave plot and save it as 'sine_wave.png'.