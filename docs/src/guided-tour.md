```@meta
DocTestSetup = quote
    using MicroFloatingPoints
	using MicroFloatingPoints.MFPPlot, MicroFloatingPoints.MFPRandom
end
CurrentModule = MicroFloatingPoints
```

# A guided tour


The `MicroFloatingPoints` package is organized into four modules:

- `MicroFloatingPoints`: the main module containing the definition of the parameterized type `Floatmu` and the associated methods;
- `MicroFloatingPoints.MFPUtils`: a module providing miscellaneous utility functions for the `Floatmu` type;
- `MicroFloatingPoints.MFPPlot`: a module offering various graphical ways to display `Floatmu` floating-point numbers;
- `MicroFloatingPoints.MFPRandom`: the module overloading [`Random.rand`](https://docs.julialang.org/en/v1/stdlib/Random/#Base.rand) to produce `Floatmu` random values.

After having correctly installed the package (see [Installation](@ref)), we start our tour by loading the `MicroFloatingPoints` module:

```@setup realline
using PyPlot
```

```@repl realline
using MicroFloatingPoints
```

We can now define a new floating-point type `MuFP` with 2 bits for the exponent (the first parameter)  and 2 bits for the fractional part (the second parameter):

```@repl realline
MuFP = Floatmu{2,2}
```

Such a type is very limited, and a call to [`floatmax`](@ref) will give us the largest finite float representable:
```@repl realline
floatmax(MuFP)
```

Conversely, we can obtain the smallest positive float in the `MuFP` format with the [`μ`](@ref) method:
```@repl realline
μ(MuFP)
```
Note that this value is a [subnormal number](https://en.wikipedia.org/wiki/Denormal_number), which is different and smaller than the smallest normal float, obtained by calling [`floatmin`](@ref):
```@repl realline
floatmin(MuFP)
```
## Graphics with `MicroFloatingPoints.MFPPlot`

To better assess what we can do with such a small type, let us display all finite representable values on the real line. The `Plot` module has just the right method:
```@repl realline
using MicroFloatingPoints.MFPPlot
real_line(-floatmax(MuFP),floatmax(MuFP));
savefig("mufp_realline.svg"); nothing # hide
```

```@raw html
<div style="text-align: center">
<img src="./mufp_realline.svg" alt="Floatmu{2,2} representable finite values" />
</div>
```

Since the difference between any pair of `MuFP` is always greater or equal to μ(MuFP), it becomes apparent why the introduction of *subnormal numbers* (in purple in the picture above) ensures the property:

```math
\forall (a,b)\in\text{MuFP}\colon |b-a| = 0 \iff a=b
```

### Exhaustive search for rounded additions

The type `MuFP` is so small that we can easily perform exhaustive searches with it. For example, we can display graphically whether the sum of any two finite `MuFP` floats needs to be rounded or not, using the [`inexact()`](@ref) and [`reset_inexact()`](@ref) methods
to, respectively, test whether the preceding computation needed rounding and to reset the global *inexact flag:*

```@setup exhaustive-rounding
using MicroFloatingPoints
using PyPlot
MuFP = Floatmu{2,2}
```

```@example exhaustive-rounding
plt.figure()
plt.title("Exhaustive search for rounded sums in Floatmu{2,2}")
TotalIterator = FloatmuIterator(-floatmax(MuFP),floatmax(MuFP))
N = length(TotalIterator)
Z = zeros(Int,N,N)
let i = 1
    for v1 in TotalIterator
        j = 1
        for v2 in TotalIterator
            reset_inexact()
            v1+v2
            Z[i,j] = Int(inexact())
            j += 1
        end
        i += 1
    end
end
V = collect(TotalIterator)
imshow(Z,origin="lower", cmap="summer")
plt.yticks(0:(length(V)-1),[string(V[i]) for i in 1:length(V)])
plt.xticks(0:(length(V)-1),[string(V[i]) for i in 1:length(V)],rotation=90);
savefig("exhaustive-rounding.svg"); nothing #hide
```

Note the use of a [`FloatmuIterator`](@ref) to enumerate all floating-point numbers in a range.

We obtain the following matrix, where a green cell means that the sum of the values in row and column needs no rounding, while a yellow cell means that the result needs rounding to be represented by a `Floatmu{2,2}`.

```@raw html
<div style="text-align: center">
<img src="./exhaustive-rounding.svg" alt="Exhautive search for sums of Floatmu{2,2} needing rounding" />
</div>
```

## Random floats with `MicroFloatingPoints.MFPRandom`

Let us now draw some [`BFloat16`](https://en.wikipedia.org/wiki/Bfloat16_floating-point_format) floats uniformly at random in ``[0,1)``. We will use the `MicroFloatingPoints.MFPRandom` module to overload the [`rand`](https://docs.julialang.org/en/v1/stdlib/Random/#Base.rand) method for the type `Floatmu`.

```@example randfreq
using DataStructures
using PyPlot
using MicroFloatingPoints
using MicroFloatingPoints.MFPRandom

BFloat16 = Floatmu{8,7}

ndraws=1000000
plt.figure()
plt.title("Drawing $ndraws values at random in BFloat16[0,1)")
T = [rand(BFloat16) for i in 1:ndraws]
Tc = counter(T)
nothing # hide
```

We can now display the number of times each float was drawn:

```@example randfreq
for x in Tc
    (k,v) = x
    plot([k,k],[0,v],marker=".",color="blue",alpha=0.5)
end
(low,high) = extrema(collect(values(Tc)))
plt.ylim(ymin=0.99*low,ymax=1.01*high)
savefig("randfreq-bfloat16.svg"); nothing # hide
```

```@raw html
<div style="text-align: center">
<img src="./randfreq-bfloat16.svg" alt="Drawing values at random in BFloat16" />
</div>
```

## Arithmetic with various precisions

The `BFloat16` and `Float16` formats both represent floating-point numbers with 16 bits. The `BFloat16` trades precision for a larger range. Let us compare the results obtained when summing the values of a vector with both types:

```@setup mixed-precision
using MicroFloatingPoints
using Random
using Distributions
Random.seed!(42)
```

```@example mixed-precision
BFloat16 = Floatmu{8,7}
MuFloat16 = Floatmu{5,10} 
T64 = [rand() for i in 1:1000]
bfT16 = [BFloat16(x) for x in T64]
FT16 = [MuFloat16(x) for x in T64]
println(sum(T64))
println(sum(bfT16))
println(sum(FT16))
```

For small values in ``[0,1)``,  the effect of a smaller significand appears drastic. On the other hand, the small range of the type `Float16` makes it useless for computation with medium to large numbers:

```@example mixed-precision
T64 = [rand(Uniform(min(floatmin(BFloat16),floatmin(MuFloat16)),
            max(floatmax(BFloat16),floatmax(MuFloat16))/100)) for i in 1:100]
bfT16 = [BFloat16(x) for x in T64]
FT16 = [MuFloat16(x) for x in T64]
println(sum(T64))
println(sum(bfT16))
println(sum(FT16))
```


