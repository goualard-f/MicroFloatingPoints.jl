# MicroFloatingPoint

`MicroFloatingPoint` is a Julia library to manipulate small [IEEE-754](https://en.wikipedia.org/wiki/IEEE_754)-compliant floating-point numbers that are smaller or equal to the `Float32` format mandated by the standard.

The library may serve to exemplify the behavior of IEEE 754 floating-point numbers in a systematic way through the use of very small formats.

## A guided tour

```@meta
DocTestSetup = quote
    using MicroFloatingPoint
end
```

```jldoctest
julia> a = Floatmu{8,23}(2.7)
2.700000047683716
```

```@meta
CurrentModule = MicroFloatingPoint
```

```@docs
Floatmu{szE,szf}
```

```@docs
convert(::Type{Float64}, x::Floatmu{szE,szf} where {szE, szf})
convert(::Type{Float32}, x::Floatmu{szE,szf} where {szE, szf})
```

```@docs
parse(::Type{Floatmu{szE,szf}}, str::AbstractString) where {szE, szf}
```

```@docs
signbit(x::Floatmu{szE,szf}) where {szE, szf}
```

# Developer Documentation

Internals.