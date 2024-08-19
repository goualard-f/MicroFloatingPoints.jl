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
date: 19 August 2024
bibliography: paper.bib
---

# Summary

The IEEE 754 standard defines the representation and the properties of the floating-point numbers used as surrogates for reals in most applications. Usually, programming languages only support the two formats ---corresponding to different ranges and precisions--- implemented in most hardware: `Float32` on 32 bits, and `Float64` on 64 bits (aka, respectively, `float` and `double` in programming languages of  the C family). Machine learning, Computer Graphics, and numerical algorithms analysis all have a need for smaller formats ([minifloats](https://en.wikipedia.org/wiki/Minifloat)), which are often neither supported in hardware, nor are they available as established types in programming languages. The [`MicroFloatingPoints.jl`](https://github.com/goualard-f/MicroFloatingPoints.jl) Julia library offers a parametric type that can be instantiated to compute with IEEE 754-compliant floating-point numbers with varying ranges and precisions (up to and including `Float32`). It also provides the programmer with various means to visualize what is computed.

# Statement of need

Proving the properties of numerical algorithms involving floating-point numbers can be a very challenging task. Insight can often be gained by executing systematically the algorithm under study for all possible inputs. There are, however, too many values to consider with the classically available types `Float32` and `Float64`. Hence the need for libraries that offer smaller IEEE 754-compliant types to play with. SIPE [@lefevreSIPESmallInteger2013], FloatX [@flegarFloatXLibraryCustomized2019], and CPFloat [@fasiCPFloatLibrarySimulating2023], to name a few, are such libraries. However, being written in languages such as C or C++, they lack the interactivity and tight integration with graphical facilities that can be obtained from using script languages such as Julia. `MicroFloatingPoints.jl` is a Julia library that fills this gap by offering a parametric type `Floatmu` that can be instantiated to simulate in software small floating-point types: `Floatmu{8,23}` is a type using 8 bits to represent the exponent and 23 bits for the fractional part, which is equivalent to `Float32`; `Floatmu{8,7}` is equivalent to the Google Brain `bfloat16` format, ... `MicroFloatingPoints.jl` was, for example, instrumental in our understanding of the flaws of the algorithms computing random floating-point numbers by dividing a random integer by a constant [@goualardGeneratingRandomFloatingPoint2020]: being able to execute the algorithms for all possible inputs and to quickly display the results graphically in an interactive and integrated environment such as the one provided by [Jupyter](https://jupyterbook.org/en/stable/intro.html) gave us the impetus to demonstrate rigorously that such procedures cannot ensure an even distribution of the bits in the fractional parts of the random floats, rendering them useless for applications such as *differential privacy* [@dworkDifferentialPrivacy2006; @mironovSignificanceLeastSignificant2012]. Figure \ref{fig:random} exemplifies the kind of result easily obtainable with `MicroFloatingPoints.jl`: using the type `Floatmu{7,16}`, we systematically divide *all* integers in $[0,2^{17}-1]$ by $2^{17}$ to obtain floating-point numbers in $[0,1)$. The picture shows the probability of being `1` for each bit of the fractional part of the result. 

![Probability of being 1 for each bit of the fractional part of a `Floatmu{7,16}` when dividing each integer in $[0,2^{17}-1]$ by $2^{17}$.\label{fig:random}](random.7.16.svg){width="10cm"}

Small floating-point formats are also increasingly used in machine learning algorithms, where the precision and range are less important than the capability to store and manipulate as many values as possible. There are already some established formats implemented in hardware (e.g., IEEE 754 `Float16` ---available natively in Julia--- and Google Brain [`bfloat16`](https://en.wikipedia.org/wiki/Bfloat16_floating-point_format) ---provided by the Julia Package [`BFloat16s.jl`](https://github.com/JuliaMath/BFloat16s.jl)). There is, however, still a need for more flexibility to test the behavior of well-known and new algorithms with varying precisions and ranges. The parametric type of `MicroFloatingPoints.jl` can be put to good use there too, and has already been for the study of training neural networks [@arthurScalableImplementationRecursive2023a]. However, since it represents all floating-point formats by a pair of 32 bit integers, it cannot compete with more specialized packages for applications that require storing and manipulating massive amounts of numbers. For such use cases, it should therefore be confined to preliminary investigations with more limited amounts of data. 

# References

