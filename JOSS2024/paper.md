---
title: 'MicroFloatingPoints.jl: providing very small IEEE 754-compliant floating-point types'
tags:
  - Julia
  - floating-point arithmetic
  - visualization
  - minifloats
authors:
  - name: Frédéric Goualard
    orcid: 0000-0002-1798-1568
    affiliation: 1
affiliations:
 - name: Nantes Université, École Centrale Nantes, CNRS, LS2N, UMR 6004, Nantes, France
   index: 1
date: 5 September 2024
bibliography: paper.bib
---

# Summary

The IEEE 754 standard defines the representation and the properties of the floating-point numbers used as surrogates for reals in computer programs. Most programming languages only support the 32-bit (`Float32`) and 64-bit (`Float64`) formats implemented in hardware. Machine learning, Computer Graphics, and numerical algorithms analysis all have a need for smaller formats, which are often neither supported in hardware, nor are they available as established types in programming languages. The [`MicroFloatingPoints.jl`](https://github.com/goualard-f/MicroFloatingPoints.jl) Julia library offers a parametric type that can be instantiated to compute with IEEE 754-compliant floating-point numbers with varying ranges and precisions (up to and including `Float32`). It also provides the programmer with various means to visualize what is computed.

# Statement of need

Proving the properties of numerical algorithms involving floating-point numbers can be a very challenging task. Insight can often be gained by executing systematically the algorithm under study for all possible inputs. There are, however, too many values to consider with the classically available types `Float32` and `Float64`. Hence the need for libraries that offer many smaller IEEE 754-compliant types to play with. SIPE [@lefevreSIPESmallInteger2013], FloatX [@flegarFloatXLibraryCustomized2019], and CPFloat [@fasiCPFloatLibrarySimulating2023], to name a few, are such libraries. However, being written in languages such as C or C++, they lack the interactivity and tight integration with graphical facilities that can be obtained from using script languages such as Julia. `MicroFloatingPoints.jl` is a Julia library that fills this need by offering a parametric type `Floatmu` that can be instantiated to simulate in software small floating-point types: `Floatmu{8,23}` is a type using 8 bits to represent the exponent and 23 bits for the fractional part, which is equivalent to `Float32`; `Floatmu{8,7}` is equivalent to the Google Brain `bfloat16` format, ... 

## A quick tour

To obtain a (pseudo-)random float in the domain $[0,1)$ for a floating-point format with a $p$-bit significand, many libraries simply divide a pseudo-random integer taken from $[0, 2^p-1]$ by $2^p$ [@goualardGeneratingRandomFloatingPoint2020]. Does it ensure an even distribution of the bits in the fractional parts of the random floats, as required by applications such as *differential privacy* [@dworkDifferentialPrivacy2006; @mironovSignificanceLeastSignificant2012]? This can be systematically and quickly checked for a small floating-point format. We start by loading `MicroFloatingPoints` and `PyPlot` (alternatively, `PythonPlot` could also be used) for the graphics:

```julia
using MicroFloatingPoints, PyPlot
```
and we define a new IEEE 754-compliant floating-point type, say, with 7 bits for the exponent and 9 bits for the significand (i.e., 8 bits for the fractional part):
```julia
E = 7 # Size of the exponent part
f = 8 # Size of the fractional part
p = f+1 # Size of the significand
MuFP = Floatmu{E,f} # The new format
```
We now divide all integers in $[0,2^p-1]$ by $2^p$ to obtain a `MuFP` float, for which we record the value of each bit of its fractional part. An array `T` with `f` cells will accumulate the number of occurrences of a '`1`' over all floats produced (specifically, `T[i]` will contain the number of times the `(f-i)`-th bit of the fractional part was a `1` so far ---with the 0-th bit being the rightmost one, as usual).
```julia
T = zeros(f)
for v in 0:(2^p-1)
    d = MuFP(v)/2^p
    fpart = bitstring(d)[2+E:end] # Isolating the fractional part
    for j in 1:f
        global T[j] += Int(fpart[j] == '1')
    end
end
```
We now normalize to $[0,1]$ the number of occurrences, and display the results with a bar plot (Figure \ref{fig:random8}).
```julia
nT = map(x -> x/2^p,T)
plt.bar(1:f,nT)
plt.xticks(1:f,reverse(map((x)->string(Int(x-1)),1:f)))
plt.yticks(0:0.1:1)
plt.show()
```

![Probability of being 1 for each bit of the fractional part of a `Floatmu{7,8}` when dividing each integer in $[0,2^{9}-1]$ by $2^{9}$.\label{fig:random8}](random.7.8.svg){width="10cm"}


We were expecting a probability of $0.5$ for each bit of the fractional part to be `1`. The actual plot shows that it is not the case and that the probability decreases for the lowest bits. It is very easy to check that behavior for a larger type by, e.g., changing the value of `f` to `16` in our previous code:
```julia
f = 16
```

The result in Figure \ref{fig:random16} shows the same behavior for the larger type `Floatmu{7,16}`.

![Probability of being 1 for each bit of the fractional part of a `Floatmu{7,16}` when dividing each integer in $[0,2^{17}-1]$ by $2^{17}$.\label{fig:random16}](random.7.16.svg){width="10cm"}

## Limitations

At present, all computations are performed in double precision (`Float64` type), then correctly rounded to the `Floatmu{}` format chosen. As long as the precision of the `Floatmu{}` type is at most half the one of `Float64`, there is no *double rounding* issue [@martin-dorelIssuesRelatedDouble2013], and any final result obtained in that way is exactly the same as the one we would obtain by computing directly with the `Floatmu{}` precision [@rumpIEEE754PrecisionBase2016].

Small floating-point formats are increasingly used in machine learning algorithms, where the precision and range are less important than the capability to store and manipulate as many values as possible. There are already some established formats implemented in hardware (e.g., IEEE 754 `Float16` ---available natively in Julia--- and Google Brain [`bfloat16`](https://en.wikipedia.org/wiki/Bfloat16_floating-point_format) ---provided by the Julia Package [`BFloat16s.jl`](https://github.com/JuliaMath/BFloat16s.jl)). There is, however, still a need for more flexibility to test the behavior of algorithms with varying precisions and ranges. The parametric type of `MicroFloatingPoints.jl` can be put to good use there too, and has already been for the study of training neural networks [@arthurScalableImplementationRecursive2023a]. However, since it represents all floating-point formats by a pair of 32 bit integers, it cannot compete with more specialized packages for applications that require storing and manipulating massive amounts of numbers. For such use cases, it should therefore be confined to preliminary investigations with more limited amounts of data. 

# References

