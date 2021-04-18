```@meta
DocTestSetup = quote
	using Distributions, Random
    using MicroFloatingPoints
	using MicroFloatingPoints.MFPPlot, MicroFloatingPoints.MFPRandom
end
CurrentModule = MicroFloatingPoints
```

# Manual

## The `MicroFloatingPoints` module

The central element of the `MicroFloatingPoints` package is the floating-point type `Floatmu`; it is parameterized by the sizes of the exponent field and the fractional part field.


```@docs
Floatmu{szE,szf}
```

### Creating a `Floatmu`

A `Floatmu` object may be created from a float from an existing floating-point type (`Float16`, `Float32`, `Float64`).

```@setup constructor-examples
push!(LOAD_PATH,pwd()*"/../../src") # hide
using MicroFloatingPoints
```

```jldoctest constructor-examples
julia> Floatmu{8,23}(Float16(0.1))
0.099975586
julia> Floatmu{8,23}(0.1f0)
0.1
julia> Floatmu{8,23}(0.1)
0.1
```

Note that, depending on the value and the size of the `Floatmu` type, some rounding may occur. 

```jldoctest constructor-examples
julia> Floatmu{2,2}(0.1f0)
0.0
julia> Floatmu{8,7}(0.1f0)
0.1
```

Each `Floatmu` object retains the sign of the error due to rounding the value used to create it. That sign may be obtained with the method `errorsign`. If one is only interested in obtaining a boolean to know whether some rounding took place or not, one can use the `isinexact` method instead.

```@docs
errorsign(x::Floatmu{szE,szf}) where {szE,szf}
isinexact(x::Floatmu{szE,szf}) where {szE,szf}
```

!!! warning "Rounding information"
    Be wary of the fact that a `Floatmu` object is completely oblivious to rounding 
    that may have occurred *before* the call of its constructor. 
	
    ```julia
    julia> isinexact(Floatmu{8,23}(Float16(0.1)))
    false
    ```
	
    In the preceding example, no rounding is reported even though `0.1` is not 
    representable in binary because the `Floatmu` is created from a `Float16` 
    approximation of it and a `Floatmu{8,23}` object has more precision than 
    a `Float16`. The rounding that took place when creating the `Float16` in the
    first place goes unreported.


It is also possible to create a `Floatmu` float from an integer of the type `Int64`:

```jldoctest constructor-examples
julia> Floatmu{8,7}(10)
10.0
```

Due to the limited range of the `Floatmu` type, some rounding may still occur:
```jldoctest constructor-examples
julia> Floatmu{8,7}(303)
304.0
```

It is possible to know the largest positive integer such that all smaller integers are represented without rounding using the [`Base.maxintfloat`](https://docs.julialang.org/en/v1/base/base/#Base.maxintfloat) method:

```jldoctest constructor-examples
julia> maxintfloat(Floatmu{8,7})
256.0
julia> Floatmu{8,7}(257)
256.0
```

Lastly, a `Floatmu` may be created from another `Floatmu` with the same or a different precision and range.

```jldoctest
julia> Floatmu{5,10}(0.1)==Floatmu{8,7}(Floatmu{5,10}(0.1))
false
```

### Characteristics of a `Floatmu`

It is possible to obtain some characteristics of a `Floatmu` type by using standard Julia methods. Most of them are usually undocumented, being internal to the `Base` package. Since the intended audience for the `MicroFloatingPoints` package is probably more interested in these methods than the general public, we document them here.

The [`Base.precision()`](https://docs.julialang.org/en/v1/base/numbers/#Base.precision) method returns the number of bits in the significand:

```jldoctest
julia> Base.precision(Floatmu{8,23})
24
```

The `Base.exponent_max` and `Base.exponent_raw_max` return, respectively, the maximum unbiased exponent and the maximum biased exponent. 

```jldoctest
julia> Base.exponent_max(Floatmu{8,23})
127
julia> Base.exponent_raw_max(Floatmu{8,23})
255
```

Some other methods in the `MicroFloatingPoints` package are related to the exponent of a `Floatmu`:

```@docs
Emax(::Type{Floatmu{szE,szf}}) where {szE, szf}
Emin(::Type{Floatmu{szE,szf}}) where {szE, szf}
bias(::Type{Floatmu{szE,szf}}) where {szE, szf}
```

Other methods return remarkable values for the type:

```@docs
Infμ(::Type{Floatmu{szE,szf}}) where {szE,szf}
NaNμ(::Type{Floatmu{szE,szf}}) where {szE, szf}
eps(::Type{Floatmu{szE,szf}})  where {szE,szf}
λ(::Type{Floatmu{szE,szf}})  where {szE,szf}
μ(::Type{Floatmu{szE,szf}})  where {szE,szf}
sign(x::Floatmu{szE,szf}) where {szE, szf}
floatmax(::Type{Floatmu{szE,szf}})  where {szE,szf}
floatmin(::Type{Floatmu{szE,szf}})  where {szE,szf}
typemin(::Type{Floatmu{szE,szf}})  where {szE,szf}
typemax(::Type{Floatmu{szE,szf}})  where {szE,szf}
maxintfloat(::Type{Floatmu{szE,szf}})  where {szE,szf}

```

### Tests 

```@docs
signbit(x::Floatmu{szE,szf}) where {szE, szf}
isnan(x::Floatmu{szE,szf}) where {szE,szf}
isinf(x::Floatmu{szE,szf}) where {szE,szf}
isfinite(x::Floatmu{szE,szf}) where {szE,szf}
issubnormal(x::Floatmu{szE,szf}) where {szE,szf}
```

### Conversions

A `Floatmu` may be converted from and to any of the standard floating-point type (`Float16`, `Float32`, `Float64`).

```@docs
convert
```

A `Floatmu` may also be created from a string:

```@docs
parse(::Type{Floatmu{szE,szf}}, str::AbstractString) where {szE, szf}
tryparse(::Type{Floatmu{szE,szf}}, str::AbstractString) where {szE, szf}
```

### Display

Contrary to a `Float16` or a `Float32`, which are displayed by default with an indication of their type, a `Floatmu` is displayed as a number alone with no indication of its type (much like a `Float64`).

```jldoctest
julia> Floatmu{2,2}(0.25)
0.25
```

It is also possible to display the internal representation of a `Floatmu{szE,szf}` as an ``1+\text{szE}+\text{szf}`` bit string:

```@docs
bitstring(x::Floatmu{szE,szf}) where {szE,szf}
```

### Iterating through floats

As for the standard floating-point types, it is possible to go from one `Floatmu` to the next using `nextfloat` and `prevfloat`.

```@docs
prevfloat(x::Floatmu{szE,szf}, n::UInt32 = 1) where {szE,szf}
nextfloat(x::Floatmu{szE,szf}, n::UInt32 = 1) where {szE,szf}
```

A `FloatmuIterator` allows to iterate on a range of `Floatmu` in a more systematic way:

```@docs
FloatmuIterator{szE,szf}
```

!!! warning "Effect of rounding on iterations"
    Keep in mind that the bounds of the iterator may need rounding when converted
    to a `Floatmu`, so that the number of iterations may not be the one expected. 
    Additionnally, the step chosen may induce more rounding at each iteration.
	
    #### Example
    
    ```julia
    julia> [x for x in FloatmuIterator(Floatmu{2,2},-1.2,-0.2,0.3)]
    4-element Vector{Floatmu{2,2}}:
    -1.25
    -1.0
    -0.75
    -0.5
    
    julia> FloatmuIterator(Floatmu{2,2},-1.2,-0.2,0.3)
    FloatmuIterator{2,2}(-1.25, -0.25, 0.25)
    ```
	
### Rounding

We have seen in section [Creating a `Floatmu`](@ref) that each `Floatmu` retains the information whether the value it was created from required rounding or not.

In addition to that mechanism, the `MicroFloatingPoints` module keeps a global variable that is set to `true` every time a `Floatmu` is created and rounding takes place. That variable is *sticky* (once true, it stays true until reset explictly to `false`). It can be checked with the `inexact()` method and reset with the `reset_inexact()` method.

```@docs
inexact()
reset_inexact()
```

With these methods, one can check whether some computation needed rounding at some point:

```jldoctest
julia> reset_inexact()

julia> inexact()
false

julia> Floatmu{2,2}(2.0)+Floatmu{2,2}(0.25)
2.0

julia> inexact()
true

julia> reset_inexact()

julia> Floatmu{2,2}(2.0)+Floatmu{2,2}(0.25)+Floatmu{2,2}(0.25)
2.0

julia> inexact()
true
```

Note that, in the first example, the result of the computation needed rounding, while in the second example, the output is representable but one of the intermediary computation needed rounding. 


## The `MicroFloatingPoints.MFPRandom` module

```@meta
CurrentModule = MicroFloatingPoints.MFPRandom
```
The `MicroFloatingPoints.MFPRandom` module overloads [`rand`](https://docs.julialang.org/en/v1/stdlib/Random/#Base.rand) to offer `Floatmu` floating-point numbers drawn at random in ``[0,1)``. The method uses `Random.rand` under the hood. It is then affected in the same way by 
`Random.seed!`.


```repl random
julia> Random.seed!(42);

julia> rand(Floatmu{2,2})

julia> rand(Floatmu{2,2})
```

It is possible to draw `Floatmu` values at random in the same way as with other floating-point types:

```repl random
julia> rand(Floatmu{2,2},5)
```

Using the [`Distributions`](https://juliastats.org/Distributions.jl/stable/) package, one can also draw `Floatmu` numbers with other distributions:

```repl random
julia> rand(Uniform(Floatmu{2,2}(-1.0),Floatmu{2,2}(1.0)))
```

!!! warning "Using custom distributions"
    One must be wary of very small `Floatmu` types when using other distributions than
    ``U[0,1)`` as the computation necessary to compute another distribution may 
    easily involve larger numbers than can be represented with the type. Consider, for
    example, the type `Floatmu{2,2}` whose largest positive finite value is `3.0`. 
    If we decide to draw numbers in the domain ``[-2,2)``, we will call:
    ```julia
    rand(Uniform(Floatmu{2,2}(-2.0),Floatmu{2,2}(2.0)))
    ```
    To translate the distribution from ``[0,1)`` to ``[-2,2)``, the `Uniform` method
    will draw a value ``x`` in ``[0,1)`` and apply the formula ``a+(b-a)x``, with
    ``a=-2`` and ``b=2``. Unfortunately, ``b-a`` will then be 
    ``\text{Floatmu\{2,2\}}(2.0)-\text{Floatmu}\{2,2\}(-2.0)``, which is rounded to 
    `Infμ{2,2}`. Consequently, we will always draw the same infinite value:

    ```julia
    julia> rand(Uniform(Floatmu{2,2}(-2.0),Floatmu{2,2}(2.0)))
    Infμ{2, 2}
    
    julia> rand(Uniform(Floatmu{2,2}(-2.0),Floatmu{2,2}(2.0)))
    Infμ{2, 2}
    
    ```
	
## The `MicroFloatingPoints.MFPPlot` module

```@meta
CurrentModule = MicroFloatingPoints.MFPPlot
```
The `MicroFloatingPoints.MFPPlot` module offers some methods to easily represent floating-point numbers.

```@docs
real_line
```

### Examples

```@setup realline-example
push!(LOAD_PATH,pwd()*"/../../src")
using MicroFloatingPoints, MicroFloatingPoints.MFPPlot, PyPlot
plt.figure()
```

```@repl realline-example
real_line(Floatmu{2,3}(-2.5),Floatmu{2,3}(1.0));
savefig("realline_Floatmu23a.svg"); nothing # hide
```

```@raw html
<div style="text-align: center">
<img src="./realline_Floatmu23a.svg" alt="Floatmu{2,3} values in [-2.5, 1.0]" />
</div>
```

```@setup realline-example
plt.figure()
```

```@repl realline-example
real_line(Floatmu{2,3});
savefig("realline_Floatmu23b.svg"); nothing # hide
```

```@raw html
<div style="text-align: center">
<img src="./realline_Floatmu23b.svg" alt="Floatmu{2,3} finite and infinite values" />
</div>
```
