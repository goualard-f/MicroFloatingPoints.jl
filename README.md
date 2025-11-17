# MicroFloatingPoints

*The MicroFloatingPoints package defines the `Floatmu` parametric type to manipulate [IEEE 754 standard](https://en.wikipedia.org/wiki/IEEE_754)-compliant floating-point numbers with a very small size (from 5 bits up to 32 bits).*

### Example of use

Adding `0.25` and `2.0` in a floating-point format with 1 bit for the sign (implied), 2 bits for the exponent, and 2 bits for the fractional part (3 bits for the whole significand with the *hidden bit*), and testing whether the result had to be rounded:

``` julia
julia> using MicroFloatingPoints

julia> Floatmu{2,2}(0.25)+Floatmu{2,2}(2.0)
2.0

julia> inexact()
true
```


## Installation

The package can be installed with the Julia package manager. From the Julia REPL, type `]` to enter the Pkg REPL mode and run:

```julia
pkg> add MicroFloatingPoints
```

Or, equivalently, via the Pkg API:

```julia
julia> import Pkg; Pkg.add("MicroFloatingPoints")
```

Optionally, to enable plotting, install either one of PyPlot.jl or PythonPlot.jl as follows.

```julia-repl
julia> import Pkg; Pkg.add("PyPlot")
```

OR

```julia-repl
julia> import Pkg; Pkg.add("PythonPlot")
```

Note that the `matplotlib` Python package must be available through `PyCall` or `PythonCall`.
This is usually setup when installing [PyPlot.jl](https://github.com/JuliaPy/PyPlot.jl)
or [PythonPlot.jl](https://github.com/JuliaPy/PythonPlot.jl), which are optional (weak) dependencies
that provide plotting backends via package extensions.


## Documentation

[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://goualard-f.github.io/MicroFloatingPoints.jl/stable)
[![](https://img.shields.io/badge/docs-dev-blue.svg)](https://goualard-f.github.io/MicroFloatingPoints.jl/dev)

## Project status

The package is developed and has been tested on Julia 1.6 through 1.12.

