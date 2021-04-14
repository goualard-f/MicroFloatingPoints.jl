```@meta
DocTestSetup = quote
    using MicroFloatingPoints, MFPPlot, MFPRandom
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

A `Floatmu` object may be created from a float from an existing floating-point type (`Float64`, `Float32`, `Float16`).

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

It is possible to know the largest positive integer such that all smaller integers are representation without rounding using the [`Base.maxintfloat`](https://docs.julialang.org/en/v1/base/base/#Base.maxintfloat) method:

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

It is possible to obtain some characteristics of a `Floatmu` type by using standard Julia methods. Most of them are usually undocumented, being internal to the `Base` package. The intended audience for the `MicroFloatingPoints` package being probably more interested in these methods than the general public, we document them here.

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

A `Floatmu` may converted from and to any of the standard floating-point type (`Float16`, `Float32`, `Float64`).

```@docs
convert(::Type{Float16}, x::Floatmu{szE,szf}) where {szE, szf}
convert(::Type{Float32}, x::Floatmu{szE,szf}) where {szE, szf}
convert(::Type{Float64}, x::Floatmu{szE,szf}) where {szE, szf}
convert(::Type{Floatmu{szE,szf}}, x::Float16)  where {szE,szf}
convert(::Type{Floatmu{szE,szf}}, x::Float32)  where {szE,szf}
convert(::Type{Floatmu{szE,szf}}, x::Float64)  where {szE,szf}
```

A `Floatmu` may also be created from a string:

```@docs
parse(::Type{Floatmu{szE,szf}}, str::AbstractString) where {szE, szf}
tryparse(::Type{Floatmu{szE,szf}}, str::AbstractString) where {szE, szf}
```

### Display

Contrary to a `Float16`, which is displayed by default with an indication of its type, a
`Floatmu` is displayed as a number alone with no indication of its type (much like a `Float64`).

```jldoctest
julia> Floatmu{2,2}(0.25)
0.25
```

It is also possible to display the internal representation of a `Floatmu{szE,szf}` as an ``1+\text{szE}+\text{szf}`` integer:

```@docs
bitstring(x::Floatmu{szE,szf}) where {szE,szf}
```

### Iterating through floats

As for the standard floating-point types, it is possible to go from one `Floatmu` to the next using `nextfloat` and `prevfloat`.

```@docs
prevfloat(x::Floatmu{szE,szf}) where {szE,szf}
nextfloat(x::Floatmu{szE,szf}) where {szE,szf}
```

```@docs
FloatmuIterator{szE,szf}
```


<!--- ############################################### --->


```@docs
nb_fp_numbers(a::Floatmu{szE,szf}, b::Floatmu{szE,szf}) where {szE,szf}
inexact()
reset_inexact()
```

## The `MFPRandom` module

```@meta
CurrentModule = MFPRandom
```

```@docs
rand(::Type{Floatmu{szE,szf}}) where {szE,szf}
```

## The `MFPPlot` module

```@meta
CurrentModule = MFPPlot
```


```@docs
real_line(start::Floatmu{szE,szf}, stop::Floatmu{szE,szf}) where {szE,szf}
real_line(::Type{Floatmu{szE,szf}}) where {szE,szf}
```
