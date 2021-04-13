# Manual

## The `MicroFloatingPoints` module

```@docs
floatmax(::Type{Floatmu{szE,szf}})  where {szE,szf}
floatmin(::Type{Floatmu{szE,szf}})  where {szE,szf}
μ(::Type{Floatmu{szE,szf}})  where {szE,szf}
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


```@docs
inexact()
reset_inexact()
```

## The `MFPRandom` module

## The `MFPPlot` module
