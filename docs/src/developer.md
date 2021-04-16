```@meta
DocTestSetup = quote
    using MicroFloatingPoints, Random, MFPPlot, MFPRandom
end
CurrentModule = MicroFloatingPoints
```

# Developer Documentation

This part is intended for developers who intend to extend or maintain the package.

!!! warning "Work In Progress"
    This part is a *work in progress* and should be expanded in the next revisions.

## Construction of a `Floatmu`

The `Floatmu` type has two constructors that create a float directly from its integer representation.

```julia
Floatmu{szE,szf}(x::UInt32, dummy) where {szE,szf}
Floatmu{szE,szf}(x::Tuple{UInt32,Int64}, dummy) where {szE,szf}
```

The first constructor uses `x` as the internal representation of the float, assuming no rounding occurred; the second constructor uses the `UInt32` element of the tuple as the internal representation , while the `Int64` element correspond to the sign of the error if some rounding took place to generate the float.

For both constructors, `dummy` may be anything and serves only to avoid ambiguities when calling a constructor. It is customary to use `nothing` for this parameter and the code of the package always does.

```@docs
nb_fp_numbers(a::Floatmu{szE,szf}, b::Floatmu{szE,szf}) where {szE,szf}
MicroFloatingPoints.inexact_flag
MicroFloatingPoints.double_fields(x::Float64)
MicroFloatingPoints.roundfrac(f,szf)
MicroFloatingPoints.float64_to_uint32mu(x::Float64,szE,szf)
```

## The `MFPRandom` module

```@meta
CurrentModule = MFPRandom
```

```@setup devel-rand
using Random
```

```@docs
MFPRandom.irandint(rng::Random.AbstractRNG, n::Int64)
```

### Examples

```jldoctest devel-rand
julia> MFPRandom.irandint(Random.MersenneTwister(42),23)
0x000000000026cb47

julia> MFPRandom.irandint(MersenneTwister(42),65)
ERROR: ArgumentError: the second argument must be smaller or equal to 64
```
