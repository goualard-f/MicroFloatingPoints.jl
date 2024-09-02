module MFPPlot

using ..MicroFloatingPoints

export real_line
export bits_histogram

# Backend plotting registry
const backends = Vector{Module}()

# register_backend is called by extension package __init__ methods
function register_backend(m::Module)
    push!(backends, m)
end

# set_backend! provides a method to choose which backend to use in case
# multiple backends are loaded
function set_backend!(m::Module)
    pushfirst!(backends, m)
end

function set_backend!(s::Symbol)
    if s == :PyPlot
        s = :MFPPyPlot
    elseif s == :PythonPlot
        s = :MFPPythonPlot
    end
    m = Base.get_extension(MicroFloatingPoints, s)
    set_backend!(m)
end

# called by real_line and bits_histogram
function select_backend()
    if isempty(backends)
        error("One of PyPlot.jl or PythonPlot.jl must be loaded for plotting via MFPPlot. For example, run `using PythonPlot`.")
    end
    return first(backends)
end



"""
    real_line(start::Floatmu{szE,szf}, stop::Floatmu{szE,szf};
              ticks = true, 
              fpcolorsub = "purple", fpcolornorm = "blue") where {szE,szf}
    real_line(::Type{Floatmu{szE,szf}};
              ticks = true, 
              fpcolorsub = "purple", fpcolornorm = "blue",
              fpcolorinf="orange") where {szE,szf}
    real_line(T::Vector{Floatmu{szE,szf}};
                   ticks = true, fpcolorsub = "purple", fpcolornorm = "blue",
                   fpcolorinf="orange") where {szE,szf}

Draw floats on the real line.

The first version draws the real line between `start` and `stop` and displays all floating-point
numbers with `sze` bits exponent and `szf` bits fractional part. The second version draws all finite 
floating-point for the format `Floatmu{szE,szf}` and adds the infinities where the next/previous 
float would be with the format `Floatmu{szE+1,szf}`. The third version draws all floats in the 
vector `T`.

In the first version, both parameters `start` and `stop` must be finite. An `ArgumentError` exception
is raised otherwise. The same goes for all values in `T` for the third version.

All versions return the figure used for the plot.

The figure may be customized through the named parameters:
- `ticks`: if `true`, draws a vertical line for each float and adds the value below. If
    `false`, represent each float by a dot on the real line, without its value;
- `fpcolorsub`: color of the line or dot used to represent subnormals;
- `fpcolornorm`: color of the line or dot used to represent normal values;
- `fpcolorinf` [for the second version only]: color of the line or dot used to represent infinite values.

# Examples of calls

```@repl
real_line(-floatmax(Floatmu{2,2}),floatmax(Floatmu{2,2}));
real_line(Floatmu{2,2});
real_line(Floatmu{2,2}[-3.5,0.25,1.5,2.0])
```
"""
function real_line end

function real_line(args...; kwargs...)
    backend_val = Val(select_backend())
    real_line(backend_val, args...; kwargs...)
end

"""
    bits_histogram(T::Vector{Floatmu{szE,szf}};
                   signcolor = "magenta",
                   expcolor = "darkolivegreen",
                   fraccolor = "blue") where {szE,szf}

Draw an histogram of the probability of each bit of the representation of a float
to be `1` in the sample `T`.
"""
function bits_histogram end

function bits_histogram(args...; kwargs...)
    backend_val = Val(select_backend())
    bits_histogram(backend_val, args...; kwargs...)
end

end
