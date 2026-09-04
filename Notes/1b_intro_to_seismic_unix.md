# Introduction to Seismic Unix (SU)
## Getting Started with Unix and SU
In Unix, a program can be executed directly from the command line if it has executable permission and its location is included in the user's `PATH`. You can check the current `PATH` using:

```bash
echo $PATH
```

If SU is set up correctly, we can run a simple example:

```bash
suplane | suxwigb &
```

Here, two important symbols are used:

- `|` is called a **pipe**. It connects the output of one command directly to the input of another command.
- `&` is the **ampersand**, which tells the shell to run the command in the background.

### Understanding the Command Line
The command line is an interactive prompt provided by the shell, where we can enter commands or run programs. The command itself is usually an executable program, either a compiled program or a Unix shell script.

Basically, when the shell shows the prompt, it is saying:

> "Type the program you want to run here."

### Running SU with and without `&`
Try running:

```bash
suplane | suxwigb
```

The seismic plot will appear, but the terminal remains occupied by the running process. To get the command line back, you need to close or terminate the plotting window.

If we add `&`:

```bash
suplane | suxwigb &
```

the plotting program runs in the background. This means we can keep the plot open while still using the command line for other commands.

So, in short:

```text
without &:  terminal → waits for the program to finish
with &:     terminal → available while the program runs in background
```

### Pipe (|), redirect in (<), redirect out (>), and run in background (&)
