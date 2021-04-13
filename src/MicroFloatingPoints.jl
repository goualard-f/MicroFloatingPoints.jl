# MicroFloatingPoints --
#
#	Copyright 2019--2021 University of Nantes, France.
#
#	This file is part of the MicroFloatingPoints library.
#
#	The MicroFloatingPoints library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation; either version 3 of the License, or (at your
#	option) any later version.
#	
#	The MicroFloatingPoints library is distributed in the hope that it will be useful,
# but	WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
#	or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
#	for more details.
#	
#	You should have received copies of the GNU General Public License and the
#	GNU Lesser General Public License along with the MicroFloatingPoints Library.
# If not,	see https://www.gnu.org/licenses/.

module MicroFloatingPoints

import Base.convert, Base.show, Base.Float16, Base.Float32, Base.Float64
import Base.sign, Base.signbit, Base.bitstring
import Base.typemin, Base.typemax, Base.maxintfloat, Base.eps
import Base.floatmax, Base.floatmin, Base.maxintfloat, Base.precision
import Base.isinf, Base.isfinite, Base.isnan, Base.issubnormal
import Base: exponent_max, exponent_raw_max
import Base.round, Base.trunc
import Base.parse, Base.tryparse
import Base.prevfloat, Base.nextfloat
import Base.promote_rule
import Base: +, -, *, /
import Base: ==, !=, <, <=, >, >=
import Base: cos, sin, tan, exp, log, sqrt, log2
import Base.iterate, Base.length, Base.eltype
import Base.prevfloat, Base.nextfloat
import Base.decompose

export Floatmu
export μ, λ, NaNμ, Infμ
export FloatmuIterator
export isinexact, errorsign, reset_inexact, inexact


"""
    inexact_flag

Flag set to `true` if the latest computation led to some rounding. This is a sticky flag, which must be
explictly reset.

See [`reset_inexact()`](@ref)
"""
inexact_flag = false


@doc raw"""
    Floatmu{szE,szf} <: AbstractFloat

IEEE 754-compliant floating-point number with `szE` bits for the exponent 
and `szf` bits for the fractional part.

A `Floatmu` object must always have a precision smaller or equal to that of a single precision float. As a consequence, the following constraints hold:

```math
\left\{\begin{array}{l}
\text{szE}\in[2,8]\\
\text{szf}\in[2,23]
\end{array}\right.
```

# Examples
Creating a `Floatmu` type equivalent to `Float32`:
```jldoctest
julia> MyFloat32 = Floatmu{8,23}
Floatmu{8,23}

julia> a=MyFloat32(0.1)
0.10000000149011612

julia> a == 0.1f0
true
```
"""
struct Floatmu{szE,szf} <: AbstractFloat
    # Representation of the Floatmu as a 32 bits unsigned integer.
    # The various fields (s,e,f) are aligned to the right of the integer.
    v::UInt32
    # Is the value an approximation by default (-1), excess (+1) or the exact value (0)
    inexact::Int32
    function Floatmu{szE,szf}(x::Float64) where {szE,szf}
        @assert szE isa Integer "Exponent size must be an integer!"
        @assert szf isa Integer "Fractional part size must be an integer!"
        @assert szE >= 2 && szE <= 8 && szf >= 2 && szf <= 23 "Exponent size must be in [2,8] and fractional part size in [2,23]!"
        (val,rnd) = float64_to_uint32mu(x, szE, szf)
        global inexact_flag = inexact_flag || (rnd != 0)
        return new{szE,szf}(val,rnd)
    end
    function Floatmu{szE,szf}(x::Int64) where {szE,szf}
        @assert szE isa Integer "Exponent size must be an integer!"
        @assert szf isa Integer "Fractional part size must be an integer!"
        @assert szE >= 2 && szE <= 8 && szf >= 2 && szf <= 23 "Exponent size must be in [2,8] and fractional part size in [2,23]!"
        (val,rnd) = float64_to_uint32mu(Float64(x), szE, szf)
        global inexact_flag = inexact_flag || (rnd != 0)
        return new{szE,szf}(val,rnd)
    end
    function Floatmu{szE,szf}(x::Floatmu{szEb,szfb}) where {szE,szf,szEb,szfb}
        @assert szE isa Integer "Exponent size must be an integer!"
        @assert szf isa Integer "Fractional part size must be an integer!"
        @assert szE >= 2 && szE <= 8 && szf >= 2 && szf <= 23 "Exponent size must be in [2,8] and fractional part size in [2,23]!"
        (val,rnd) = float64_to_uint32mu(convert(Float64,x),szE,szf)
        global inexact_flag = inexact_flag || (rnd != 0)
        return new{szE,szf}(val, rnd)
    end
    """
        Constructor for internal use only, when `x` is known to be 
        already compliant with the requirements of the `Floatmu{szE,szf} type.
        The `dummy` parameter serves only to differentiate this constructor
        from the others. Use `nothing` to signal its uselessness.
    """
    function Floatmu{szE,szf}(x::UInt32, dummy) where {szE,szf}
        @assert szE isa Integer "Exponent size must be an integer!"
        @assert szf isa Integer "Fractional part size must be an integer!"
        @assert szE >= 2 && szE <= 8 && szf >= 2 && szf <= 23 "Exponent size must be in [2,8] and fractional part size in [2,23]!"
        return new{szE,szf}(x,0)
    end
    function Floatmu{szE,szf}(x::Tuple{UInt32,Int64}, dummy) where {szE,szf}
        @assert szE isa Integer "Exponent size must be an integer!"
        @assert szf isa Integer "Fractional part size must be an integer!"
        @assert szE >= 2 && szE <= 8 && szf >= 2 && szf <= 23 "Exponent size must be in [2,8] and fractional part size in [2,23]!"
        (val,rnd) = x
        global inexact_flag = inexact_flag || (rnd != 0)
        return new{szE,szf}(val,rnd)
    end
end


promote_rule(::Type{T},::Type{Floatmu{szE, szf}}) where {T<:Integer,szE,szf} = Float64
promote_rule(::Type{Float64},::Type{Floatmu{szE, szf}}) where {szE,szf} = Float64
promote_rule(::Type{Float32},::Type{Floatmu{szE, szf}}) where {szE,szf} = Float32
promote_rule(::Type{Float16},::Type{Floatmu{szE, szf}}) where {szE,szf} = Floatmu{max(5,szE),max(10,szf)}
promote_rule(::Type{Floatmu{szEa, szfa}},::Type{Floatmu{szEb, szfb}}) where {szEa,szfa, szEb, szfb} = Floatmu{max(szEa,szEb),max(szfa,szfb)}

# Mask to retrieve the fractional part (internal use)
significand_mask(::Type{Floatmu{szE,szf}}) where {szE, szf}  = UInt32((UInt32(1) << szf) - 1)
# Mask to retrieve the exponent part (internal use)
exponent_mask(::Type{Floatmu{szE,szf}}) where {szE, szf} = UInt32((UInt32(1) << UInt32(szE))-1) << UInt32(szf)
# Mask to retrieve the sign part (internal use)
sign_mask(::Type{Floatmu{szE,szf}}) where {szE, szf} = UInt32(1) << (UInt32(szE)+UInt32(szf))


precision(::Type{Floatmu{szE,szf}}) where {szE,szf} = UInt32(szf+1)

"""
    Emax(::Type{Floatmu{szE,szf}}) where {szE, szf}

Maximum unbiased exponent for a `Floatmu{szE,szf}` (**internal use**)
"""
Emax(::Type{Floatmu{szE,szf}}) where {szE, szf} = UInt32(2^(UInt32(szE)-1)-1)

exponent_max(::Type{Floatmu{szE,szf}}) where {szE, szf} = Emax(Floatmu{szE,szf})
exponent_raw_max(::Type{Floatmu{szE,szf}}) where {szE, szf} = exponent_mask(Floatmu{szE,szf}) >> szf

"""
    Emin(::Type{Floatmu{szE,szf}}) where {szE, szf}

Minimum unbiased exponent for a `Floatmu{szE,szf}` (**internal use**)
"""
Emin(::Type{Floatmu{szE,szf}}) where {szE, szf} = Int32(1 - Emax(Floatmu{szE,szf}))

"""
    bias(::Type{Floatmu{szE,szf}}) where {szE, szf}

Bias of the exponent for a `Floatmu{szE,szf}` (**internal use**)
"""
bias(::Type{Floatmu{szE,szf}}) where {szE, szf} = Emax(Floatmu{szE,szf})

"""
    Infμ(::Type{Floatmu{szE,szf}}) where {szE,szf}

Positive infinite value in the format `Floatmu{szE,szf}`

# Examples
```jldoctest
julia> Infμ(Floatmu{8,23}) == Inf32
true
```
"""
Infμ(::Type{Floatmu{szE,szf}}) where {szE, szf} = Floatmu{szE,szf}(exponent_mask(Floatmu{szE,szf}),nothing)

"""
    NaNμ(::Type{Floatmu{szE,szf}}) where {szE, szf}

NaN in the format `Floatmu{szE,szf}`

The canonical NaN value has a sign bit set ot zero and all bits of the fractional part set to zero, except
for the leftmost one.

# Examples
```jldoctest
julia> isnan(NaNμ(Floatmu{2,2}))
true
julia> NaNμ(Floatmu{2,2})
NaNμ{2,2}
```
"""
NaNμ(::Type{Floatmu{szE,szf}}) where {szE, szf} = Floatmu{szE,szf}(exponent_mask(Floatmu{szE,szf}) | (UInt32(1) << (UInt32(szf)-1)),nothing)

"""
    eps(::Type{Floatmu{szE,szf}})  where {szE,szf}

Return the *epsilon* of the type `Floatmu{szE,szf}`, which is the 
difference between 1.0 and the next float.

# Examples
```jldoctest
julia> eps(Floatmu{2,2})
0.25

julia> eps(Floatmu{3,5})
0.03125

julia> eps(Floatmu{8,23})==eps(Float32)
true
```
"""
function eps(::Type{Floatmu{szE,szf}})  where {szE,szf}
    # The epsilon is equal to 2^-szf
    # We do not create the bit representation directly to avoid
    # complications when the epsilon is subnormal (e.g., with Floatmu{2,2})
    v = 2.0^-Int32(szf)
    return Floatmu{szE,szf}(v)
end

"""
    λ(::Type{Floatmu{szE,szf}})  where {szE,szf}

Return λ, the smallest positive *normal* number of the type `Floatmu{szE,szf}`.

# Examples 
```jldoctest
julia> λ(Floatmu{2,2})
1.0

julia> λ(Floatmu{8,23})==floatmin(Float32)
true
```
"""
λ(::Type{Floatmu{szE,szf}})  where {szE,szf} = floatmin(Floatmu{szE,szf})


"""
    μ(::Type{Floatmu{szE,szf}})  where {szE,szf}

Return μ, the smallest positive subnormal number of type `Floatmu{szE,szf}`.

# Examples
```jldoctest
julia> μ(Floatmu{2,2})
0.25
```
"""
function μ(::Type{Floatmu{szE,szf}})  where {szE,szf}
    # μ has the form: 0 000...00 000...001
    return Floatmu{szE,szf}(UInt32(1),nothing)
end


"""
    sign(x::Floatmu{szE,szf}) where {szE, szf}


Return `x` if `x` is zero, 1.0 if `x` is strictly positive and
-1.0 if `x` is strictly negative. Return `NaN` if x is a *Not a Number*.

# Examples
```jldoctest
julia> sign(Floatmu{2,3}(-1.6))
-1.0

julia> sign(Floatmu{2,3}(1.6))
1.0

julia> sign(Floatmu{2,3}(NaN))
NaNμ{2,3}

julia> sign(Floatmu{2,3}(-0.0))
-0.0
```
"""
function sign(x::Floatmu{szE,szf}) where {szE, szf}
    if isnan(x)
        return NaNμ(Floatmu{szE,szf})
    end
    if (x.v & ~sign_mask(Floatmu{szE,szf})) == 0
        return x
    else
        # Return ±Floatmu{szE,szf}(1.0)
        return Floatmu{szE,szf}((x.v & sign_mask(Floatmu{szE,szf})) | (bias(Floatmu{szE,szf}) << UInt32(szf)), nothing)
    end
end


"""
    signbit(x::Floatmu{szE,szf}) where {szE, szf}

Return `true` if `x` is signed and `false` otherwise. The result for a NaN may vary, depending
on the value of its sign bit.

# Examples
```jldoctest
julia> signbit(Floatmu{2,3}(1.5))
false
julia> signbit(Floatmu{2,3}(-1.5))
true
```

The function differentiates between ``-0.0`` and ``+0.0`` even though both
values test equal.
```jldoctest
julia> signbit(Floatmu{2,3}(-0.0))
true
```
"""
function signbit(x::Floatmu{szE,szf}) where {szE, szf}
    return (x.v & sign_mask(Floatmu{szE,szf})) != 0
end


"""
    isnan(x::Floatmu{szE,szf}) where {szE,szf}


Return `true` if `x` is a *Not an Number* and `false` otherwise.

# Examples
```jldoctest
julia> isnan(Floatmu{2,3}(1.5))
false

julia> isnan(Floatmu{2,3}(NaN))
true
```
"""
function isnan(x::Floatmu{szE,szf}) where {szE,szf}
    # A `Floatmu` is an NaN if its exponent has only ones and
    # the fractional part is not entirely made of zeroes
    return ((x.v & exponent_mask(Floatmu{szE,szf})) == exponent_mask(Floatmu{szE,szf})) &&
        ((x.v & significand_mask(Floatmu{szE,szf})) != 0)
end

"""
    isinf(x::Floatmu{szE,szf}) where {szE,szf}

Return `true` if `x` is an infinity and `false` otherwise.

# Examples
```jldoctest
julia> isinf(Floatmu{2,2}(1.5))
false

julia> isinf(Floatmu{2,2}(-Inf))
true

julia> isinf(Floatmu{2,2}(9.8))
true
```
"""
function isinf(x::Floatmu{szE,szf}) where {szE,szf}
    # A `Floatmu` is infinite if its exponent has only ones and
    # the fractional part is made only of zeroes
    return ((x.v & exponent_mask(Floatmu{szE,szf})) == exponent_mask(Floatmu{szE,szf})) &&
        ((x.v & significand_mask(Floatmu{szE,szf})) == 0)    
end

"""
    isfinite(x::Floatmu{szE,szf}) where {szE,szf}

Return `true` if `x` is finite and `false` otherwise. An NaN is not finite.

# Examples
```jldoctest
julia> isfinite(Floatmu{2,2}(1.5))
true

julia> isfinite(Floatmu{2,2}(3.8))
false

julia> isfinite(Floatmu{2,2}(NaN))
false
```
"""
function isfinite(x::Floatmu{szE,szf}) where {szE,szf}
    # A `Floatmu` is finite if its exponent is not entirely made of ones
    return x.v & exponent_mask(Floatmu{szE,szf}) != exponent_mask(Floatmu{szE,szf})
end

"""
    issubnormal(x::Floatmu{szE,szf}) where {szE,szf}

Return `true` if `x` is a [subnormal number](https://en.wikipedia.org/wiki/Denormal_number) and `false` otherwise. According to the definition, ±0.0 is not a subnormal number.

# Examples
```jldoctest
julia> issubnormal(Floatmu{2,2}(1.0))
false

julia> issubnormal(Floatmu{2,2}(0.25))
true

julia> issubnormal(Floatmu{2,2}(0.0))
false
```
"""
function issubnormal(x::Floatmu{szE,szf}) where {szE,szf}
    # A `Floatmu` is subnormal if its biased exponent is
    # zero and its fractional part is not zero.
    return ((x.v & exponent_mask(Floatmu{szE,szf})) == 0) &&
        ((x.v & significand_mask(Floatmu{szE,szf})) != 0)
end




"""
    floatmax(::Type{Floatmu{szE,szf}})  where {szE,szf}

Return the largest positive *normal* number of the type `Floatmu{szE,szf}`.

# Examples
```jldoctest
julia> floatmax(Floatmu{2,2})
3.5

julia> floatmax(Floatmu{8,23})==floatmax(Float32)
true
```
"""
function floatmax(::Type{Floatmu{szE,szf}})  where {szE,szf}
    # The largest normal `Floatmu` is of the form:
    # 0 111...110 11111...111
    # where the exponent is one less than 2^szE-1
    e = Emax(Floatmu{szE,szf}) + bias(Floatmu{szE,szf})
    f = significand_mask(Floatmu{szE,szf})
    return  Floatmu{szE,szf}((e << UInt32(szf)) | f, nothing)
end

"""
    floatmin(::Type{Floatmu{szE,szf}})  where {szE,szf}

Return λ, the smallest positive *normal* number of the type `Floatmu{szE,szf}`.

# Examples 
```jldoctest
julia> floatmin(Floatmu{2,2})
1.0

julia> floatmin(Floatmu{8,23})==floatmin(Float32)
true
```
"""
function floatmin(::Type{Floatmu{szE,szf}})  where {szE,szf}
    # λ is of the form: 0 000...001 000...0000
    return Floatmu{szE,szf}(UInt32(UInt32(1) << UInt32(szf)), nothing)
end

"""
    typemin(::Type{Floatmu{szE,szf}})  where {szE,szf}

Return the negative infinite of the type `Floatmu{szE,szf}`.

# Examples
```jldoctest
julia> typemin(Floatmu{3,5})
-Infμ{3,5}
```
"""
function typemin(::Type{Floatmu{szE,szf}})  where {szE,szf}
    return -Infμ(Floatmu{szE,szf})
end

"""
    typemax(::Type{Floatmu{szE,szf}})  where {szE,szf}

Return the positive infinite of the type `Floatmu{szE,szf}`.

# Examples
```jldoctest
julia> typemax(Floatmu{3,5})
Infμ{3,5}
```
"""
function typemax(::Type{Floatmu{szE,szf}})  where {szE,szf}
    return Infμ(Floatmu{szE,szf})
end


"""
    maxintfloat(::Type{Floatmu{szE,szf}})  where {szE,szf}

Return the smallest positive integer ``n`` such that ``n+1`` is not representable
in the type `Floatmu{szE,szf}`. The number ``n`` is returned as a 
`Floatmu{szE,szf}`. 

The function returns an infinite value if all integers are representable in the domain
of normal values.

# Examples

```jldoctest
julia> maxintfloat(Floatmu{3,2})
8.0

julia> maxintfloat(Floatmu{2,2})
Infμ{2,2}

julia> maxintfloat(Floatmu{8,23})==maxintfloat(Float32)
true
```
"""
function maxintfloat(::Type{Floatmu{szE,szf}})  where {szE,szf}
    m = Float64(UInt32(1) << (UInt32(szf)+1))
    if m > floatmax(Floatmu{szE,szf})
        return Infμ(Floatmu{szE,szf})
    else
        return Floatmu{szE,szf}(m)
    end
end

""" 
    double_fields(x::Float64)

Return the sign, biased exponent, and fractional part of a Float64 number (**internal use**)
"""
function double_fields(x::Float64)
    v = reinterpret(UInt64,x)
    s = ((v & 0x8000000000000000) >> 63) % UInt32
    e = ((v & 0x7ff0000000000000) >> 52) % UInt32
    f=  v & 0x000fffffffffffff
    return (s,e,f)
end


"""
    roundfrac(f,szf)

Round to nearest-even a 52 bits fractional part to `szf` bits 
Return a triplet composed of the rounded fractional part, a correction to the exponent
if a bit from the fractional part spilled into the integer part, and a rounding direction
(by default: -1, by excess: 1, no rounding: 0) if some rounding had to take place. 
(**internal use**)
"""
function roundfrac(f,szf)
    # Creating the mask for the bits of `f` we cannot store
    masktrailing = UInt64(2^(52-szf)-1)
    # Integer value of the least significant bit for a `szf` bits fractional part
    lsb = UInt64(2^(52-szf))
    # Retrieving the 52-szf trailing bits to know in which direction to round
    tailbits = f & masktrailing
    # Eliminating the trailing bits
    f &= ~masktrailing
    
    if tailbits == lsb/2 # Halfway between two representable floats
        if f & lsb != 0 
            # Rounding by excess to the next float due to the "even" rule
            newf = f+lsb
            if newf == 0x0010000000000000
                return (0, 1, 1)
            else
                return (newf >> (52-szf), 0, 1)
            end
        else
            # Rounding by default due to the "even" rule
            return (f >> (52-szf), 0, -1)
        end
    end
    if tailbits < lsb/2
        # Rounding by default
        return (f >> (52-szf), 0, ifelse(tailbits == 0,0,-1))
    end
    # tailbits > lsb/2
    # Rounding by excess
    newf = f+lsb
    if newf == 0x0010000000000000
        return (0, 1, 1)
    else
        return (newf >> (52-szf), 0, 1)
    end
end

"""
    float64_to_uint32mu(x::Float64,szE,szf)

Round `x` to the precision of a `Floatmu{szE,szf}` and 
return a pair composed of the bits representation right-aligned in a `UInt32` together
with a rounding direction if rounding took place (by default: -1, by excess: 1, no rounding: 0)
(**internal use**)
"""
function float64_to_uint32mu(x::Float64,szE,szf)::Tuple{UInt32,Int64}
    if isnan(x)
        # NaNμ{szE,szf}: 0 111...11 1000...00
        return (exponent_mask(Floatmu{szE,szf}) | (UInt32(1) << (UInt32(szf)-1)),0)
    else
        absx = abs(x)
        # if |x| is greater or equal to floatmax(Floatmu{szE,szf} + half the distance
        # between floatmax(Floatmu{szE,szf}) and Infμ{szE,szf}, we must
        # round to Infμ{szE,szf}
        rndpoint = (2.0-2.0^(-Int64(szf)-1))*2.0^Emax(Floatmu{szE,szf})
        if absx >= rndpoint
            s = (x < 0) ? UInt32(1) << (UInt32(szE)+UInt32(szf)) : 0
            e = exponent_mask(Floatmu{szE,szf})
            return ((s | e),ifelse(isinf(x), 0, signbit(x) ? -1 : 1)) # Infμ{szE,szf}
        else
            (s,e,f) = double_fields(x)
            # Should we round to some subnormal `Floatmu{szE,szf}`?
            # λ = 2^Emin{szE,szf}
            if absx < 2.0^Emin(Floatmu{szE,szf})
                # |x| <= μ/2?
                # This situation occurs, in particular, for all subnormal
                # double precision numbers.
                if absx <= 2.0^(-Int64(szf)-1+Emin(Floatmu{szE,szf}))
                    if signbit(x)
                        return (UInt32(1) << (UInt32(szE)+UInt32(szf)), x==0.0 ? 0 : 1)
                    else
                        return (0, x==0.0 ? 0 : -1) 
                    end
                else
                    # `x` is subnormal in the format `Floatmu{szE,szf}`
                    # (but normal in double precision, see comment above) so
                    # we shift the fractional part such that the resulting
                    # exponent is Emin(Floatmu{szE,szf})
                    shift = Emin(Floatmu{szE,szf}) - (e - 1023)
                    newf = ((f >> 1) + 2^51) >> (shift-1) # Adding hidden bit
                    (newf, addE, inexact) = roundfrac(newf,szf)
                    if addE != 0 # The rounded number is normal
                        return ((s << (UInt32(szE)+UInt32(szf))) | (UInt32(1) << UInt32(szf)) | newf,
                                x < 0 ? -inexact : inexact)
                    else
                        return ((s << (UInt32(szE)+UInt32(szf))) | newf,
                                x < 0 ? -inexact : inexact) # e==0 (subnormal)
                    end
                end
            else # Rounding to a normal float in the format `Floatmu{szE,szf}`
                newe = (e - UInt32(1023)) + bias(Floatmu{szE,szf})
                (newf, addE, inexact) = roundfrac(f,szf)
                return (s << (UInt32(szE)+UInt32(szf)) | ((newe+addE) << UInt32(szf)) | newf,
                        x < 0 ? -inexact : inexact)
            end
        end
    end        
end

"""
    convert(::Type{Float64}, x::Floatmu{szE,szf}) where {szE, szf}

Convert a `Floatmu` to a double precision float. The conversion never introduces
errors since `Float64` objects have at least twice the precision of the fractional 
part of a `Floatmu` object.

# Examples
```jldoctest
julia> convert(Float64,Floatmu{8,23}(0.1))
0.10000000149011612
"""
function convert(::Type{Float64}, x::Floatmu{szE,szf}) where {szE, szf}
    if isnan(x)
        return NaN
    elseif isinf(x)
        signx = (x.v & sign_mask(Floatmu{szE,szf})) >> (UInt32(szE)+UInt32(szf))
        return (signx == 1) ? -Inf : Inf
    else
        s = (x.v & sign_mask(Floatmu{szE,szf})) >> (UInt32(szE)+UInt32(szf))
        e = ((x.v & exponent_mask(Floatmu{szE,szf})) >> UInt32(szf))
        f = x.v & significand_mask(Floatmu{szE,szf})
        if e == 0
            if f == 0
                return (s==0 ? 1.0 : -1.0)*0.0
            else
                return (s==0 ? 1.0 : -1.0)*2.0^(Emin(Floatmu{szE,szf})-szf)*(x.v & significand_mask(Floatmu{szE,szf}))
            end
        else
            E = Int64(e) - bias(Floatmu{szE,szf})
            return (s==0 ? 1.0 : -1.0)*((2.0^UInt32(szf) + f)/2.0^UInt32(szf))*2.0^E
        end
    end
end

"""
    convert(::Type{Float32}, x::Floatmu{szE,szf}) where {szE, szf}

Convert a `Floatmu` to a single precision float.

# Examples
```jldoctest
julia> convert(Float32,Floatmu{8,23}(0.1)) == 0.1f0
true
```
"""
function convert(::Type{Float32}, x::Floatmu{szE,szf}) where {szE, szf}
    return Float32(convert(Float64,x))
end

"""
    convert(::Type{Float16}, x::Floatmu{szE,szf}) where {szE, szf}

Convert a `Floatmu` to a half precision float.

# Examples
```jldoctest
julia> convert(Float32,Floatmu{5,10}(0.1)) == Float16(0.1)
true
```
"""
function convert(::Type{Float16}, x::Floatmu{szE,szf}) where {szE, szf}
    return Float16(convert(Float64,x))
end

"""
    convert(::Type{Floatmu{szE,szf} where {szE,szf}}, x::Float64)

Convert a double precision float to a `Floatmu`. Rounding may occur.

#Examples
```jldoctest
julia> convert(Floatmu{2,4},0.1)
0.1015625
```
"""
function convert(::Type{Floatmu{szE,szf}}, x::Float64)  where {szE,szf}
    return Floatmu{szE,szf}(float64_to_uint32mu(x,szE,szf),nothing)
end


"""
    convert(::Type{Floatmu{szE,szf} where {szE,szf}}, x::Float32)

Convert a single precision float to a `Floatmu`. Rounding may occur.

#Examples
```jldoctest
julia> convert(Floatmu{2,4},0.1f0)
0.1015625
```
"""
function convert(::Type{Floatmu{szE,szf}}, x::Float32)  where {szE,szf}
    return Floatmu{szE,szf}(float64_to_uint32mu(Float64(x),szE,szf),nothing)
end

"""
    convert(::Type{Floatmu{szE,szf} where {szE,szf}}, x::Float16)

Convert a half precision float to a `Floatmu`. Rounding may occur.

#Examples
```jldoctest
julia> convert(Floatmu{2,4},Float16(0.1))
0.125

julia> Floatmu{5,10}(0.1)==Float16(0.1)
true
```
"""
function convert(::Type{Floatmu{szE,szf}}, x::Float16)  where {szE,szf}
    return Floatmu{szE,szf}(float64_to_uint32mu(Float64(x),szE,szf),nothing)
end


Float16(x::Floatmu{szE,szf}) where {szE,szf} = convert(Float16,x)
Float32(x::Floatmu{szE,szf}) where {szE,szf} = convert(Float32,x)
Float64(x::Floatmu{szE,szf}) where {szE,szf} = convert(Float64,x)

"""
    round(x::Floatmu{szE,szf},r::RoundingMode) where {szE,szf}
"""
function round(x::Floatmu{szE,szf},r::RoundingMode) where {szE,szf}
    return Floatmu{szE,szf}(round(Float64(x),r))
end

for Ty in (Int8, Int32, Int64, UInt8, UInt16, UInt32, UInt64)
    @eval begin
        trunc(::Type{$Ty}, x::Floatmu{szE,szf}) where {szE,szf} = $Ty(Float64(x))
    end
end


"""
    parse(::Type{Floatmu{szE,szf}}, str::AbstractString) where {szE, szf}

Parse the string `str` representing a floating-point number and convert it 
to a `Floatmu{szE,szf}` object.

# Examples

```jldoctest
julia> parse(Floatmu{5,7},"0.1")
0.10009765625

julia> parse(Floatmu{5,7},"1.0e10")
Infμ{5,7}
```

The string is first converted to a `Float64` and then rounded to the precision of 
the `Floatmu` object.
If the string cannot be converted to a `Float64`, the `ArgumentError` exception is
thrown.

# Examples
```jldoctest
julia> parse(Floatmu{5,7},"0.1a")
ERROR: ArgumentError: cannot parse "0.1a" as Floatmu{5,7}
```
"""
function parse(::Type{Floatmu{szE,szf}}, str::AbstractString) where {szE, szf}
    try
        return Floatmu{szE,szf}(parse(Float64,str))
    catch err
        if isa(err,ArgumentError)
            throw(ArgumentError("cannot parse \"$str\" as Floatmu{$szE,$szf}"))
        else
            rethrow(err)
        end
    end
end


"""
    tryparse(::Type{Floatmu{szE,szf}}, str::AbstractString) where {szE, szf}

Parse the string `str` representing a floating-point number and convert it 
to a `Floatmu{szE,szf}` object.



# Examples

```jldoctest
julia> tryparse(Floatmu{5,7},"0.1")
0.10009765625

julia> tryparse(Floatmu{5,7},"1.0e10")
Infμ{5,7}
```

The string is first converted to a `Float64` and then rounded to the precision of 
the `Floatmu` object.
Contrary to `parse`, if the string cannot be converted to a `Float64`, the value `nothing` is returned.

# Examples
```jldoctest
julia> tryparse(Floatmu{5,7},"0.1a")
nothing
```
"""
function tryparse(::Type{Floatmu{szE,szf}}, str::AbstractString) where {szE, szf}
    r = tryparse(Float64,str)
    if r == nothing
        return nothing
    else
        return Floatmu{szE,szf}(r)
    end
end

"""
    show(io::IO, x::Floatmu{szE,szf}) where {szE, szf}

Display a `Floatmu{szE,szf}` as a string.

# Examples
```jldoctest
julia> show(Floatmu{2,2}(0.23))
0.25
```
"""
function show(io::IO, x::Floatmu{szE,szf}) where {szE, szf}
    if isnan(x)
        print(io,"NaNμ{$(szE),$(szf)}")
    elseif isinf(x)
        print(io,(x < 0 ? "-" : "")*"Infμ{$(szE),$(szf)}")
    else
        print(io,convert(Float64,x))
    end
end

"""
    bitstring(x::Floatmu{szE,szf}) where {szE,szf}

Return the string of bits representing internally the value `x`.

# Examples
```jldoctest
julia> bitstring(Floatmu{2,2}(1.5))
"00110"

julia> bitstring(Floatmu{2,2}(0.5))
"00010"

julia> bitstring(Floatmu{8,23}(0.1))==bitstring(0.1f0)
true
```
"""
function bitstring(x::Floatmu{szE,szf}) where {szE,szf}
    return bitstring(x.v)[end-(szE+szf):end]
end



"""
    prevfloat(x::Floatmu{szE,szf}) where {szE,szf}

Return the largest `Floatmu{szE,szf}` float strictly smaller than `x`. Return `NaNμ{szE,szf}` if
`x` is *Not a Number*. Return `-Infμ{szE,szf}` if `x` is smaller or equal to `-floatmax(Floatmu{szE,szf})`.

# Examples
```jldoctest
julia> prevfloat(Floatmu{2,2}(1.0))
0.75

julia> prevfloat(Floatmu{2,2}(-0.0))
-0.25

julia> prevfloat(Floatmu{2,2}(Inf))
3.5
```

"""
function prevfloat(x::Floatmu{szE,szf}) where {szE,szf}
    if isinf(x)
        return x < 0.0 ? x : floatmax(Floatmu{szE,szf})
    end
    if isnan(x)
        return x
    end
    # x == ±0.0?
    if x.v & ~sign_mask(Floatmu{szE,szf}) == 0
        return -μ(Floatmu{szE,szf})
    end
    if signbit(x)
        return Floatmu{szE,szf}(x.v+UInt32(1),nothing)
    else
        return Floatmu{szE,szf}(x.v-UInt32(1),nothing)
    end
end

"""
    nextfloat(x::Floatmu{szE,szf}) where {szE,szf}

Return the smallest `Floatmu{szE,szf}` float strictly greater than `x`. Return `NaNμ{szE,szf}` if
`x` is *Not a Number*. Return `Infμ{szE,szf}` if `x` is greater or equal to `floatmax(Floatmu{szE,szf})`.

# Examples
```jldoctest
julia> nextfloat(Floatmu{2,2}(3.5))
Infμ{2,2}

julia> nextfloat(Floatmu{2,2}(0.0))
0.25

julia> nextfloat(Floatmu{2,2}(-Inf))
-3.5
```
"""
function nextfloat(x::Floatmu{szE,szf}) where {szE,szf}
    if isinf(x)
        return x > 0.0 ? x : -floatmax(Floatmu{szE,szf})
    end
    if isnan(x)
        return x
    end
    # x == ±0.0?
    if x.v & ~sign_mask(Floatmu{szE,szf}) == 0
        return μ(Floatmu{szE,szf})
    end
    if signbit(x)
        return Floatmu{szE,szf}(x.v-UInt32(1),nothing)
    else
        return Floatmu{szE,szf}(x.v+UInt32(1),nothing)
    end
end


"""
    nb_fp_numbers(a::Floatmu{szE,szf}, b::Floatmu{szE,szf}) where {szE,szf}
-
Return the number of floats in the interval ``[a,b]``. If ``a > b``, throw
an `ArgumentError` exception.

# Examples
```jldoctest
julia> nb_fp_numbers(Floatmu{2,2}(-0.0),Floatmu{2,2}(0.0))
1
julia> nb_fp_numbers(Floatmu{2,2}(3.0),Floatmu{2,2}(3.5))
2
"""
function nb_fp_numbers(a::Floatmu{szE,szf}, b::Floatmu{szE,szf}) where {szE,szf}
    if a > b
        throw(ArgumentError("first argument must be smaller or equal to the second one"))
    end
    if a == b
        return 1
    end
    if a >= 0
        # Removing the sign of `a` in case it is -0.0
        return b.v - (a.v & ~sign_mask(Floatmu{szE,szf})) + 1
    end
    if b <= 0
        # Forcing the sign of `b` in case it is +0.0
        return a.v - (b.v | sign_mask(Floatmu{szE,szf})) + 1
    end
    # 0 ∈ (a,b)
    z = Floatmu{szE,szf}(0.0)
    a = -a
    return (b.v - z.v) + (a.v - z.v) + 1
end

"""
    isinexact(x::Floatmu{szE,szf}) where {szE,szf}

Return `true` if the value `x` was rounded when created as a `Floatmu{szE,szf}` and 
`false` otherwise.

An NaN is never inexact. An infinite is inexact only if created from a finite value.

# See:
- [`errorsign(x::Floatmu{szE,szf}) where {szE,szf}`](@ref).
- [`reset_inexact()`](@ref)
- [`inexact()`](@ref)

# Examples

```jldoctest
julia> isinexact(Floatmu{2,2}(0.25)+Floatmu{2,2}(2.0))
true
julia> isinexact(Floatmu{2,2}(0.25)+Floatmu{2,2}(1.5))
false
```

"""
function isinexact(x::Floatmu{szE,szf}) where {szE,szf}
    return x.inexact != 0
end


"""
    errorsign(x::Floatmu{szE,szf}) where {szE,szf}

Return `1` if `x` was rounded by excess when created as a `Floatmu{szE,szf}`, `-1` if it
was rounded by default, and `0` if no rounding took place.

An NaN is never in error. An infinite is in error only if created from a finite value.

# See 
- [`isinexact(x::Floatmu{szE,szf}) where {szE,szf}`](@ref).
- [`reset_inexact()`](@ref)
- [`inexact()`](@ref)


# Examples

```jldoctest
julia> errorsign(Floatmu{2,2}(0.5))
0
julia> errorsign(Floatmu{2,2}(1.7))
1
julia> errorsign(Floatmu{2,2}(-2.8))
-1
"""
function errorsign(x::Floatmu{szE,szf}) where {szE,szf}
    return x.inexact
end


"""
    reset_inexact()

Reset the global inexact flag to `false`.
"""
reset_inexact() = global inexact_flag = false

"""
    inexact()

Return the value of the global inexact flag.
"""
inexact() = return inexact_flag

"""
    FloatmuIterator{szE,szf}

Iterator to generate all `Floatmu{szE,szf}` in the domain `[start,stop]`. The iterator
can be initialized with two `Floatmu{szE,szf}` or with two `Float64`.

# Examples
```jldoctest
julia> L=[x for x = FloatmuIterator(Floatmu{2,2}(0.0),Floatmu{2,2}(1.0))]
5-element Array{Floatmu{2,2},1}:
 0.0
 0.25
 0.5
 0.75
 1.0
julia> L2=[x for x = FloatmuIterator(Floatmu{2,2},0.0,1.0)]
5-element Array{Floatmu{2,2},1}:
 0.0
 0.25
 0.5
 0.75
 1.0

```
"""
struct FloatmuIterator{szE,szf}
    first::Floatmu{szE,szf}
#    step::Floatmu{szE,szf}
    last::Floatmu{szE,szf}
    function FloatmuIterator(start::Floatmu{szE,szf},stop::Floatmu{szE,szf}) where {szE,szf}
        return new{szE,szf}(start,stop)
    end
    function FloatmuIterator(::Type{Floatmu{szE,szf}},start::Float64,stop::Float64) where {szE,szf}
        return new{szE,szf}(Floatmu{szE,szf}(float64_to_uint32mu(start, szE, szf),nothing),
                            Floatmu{szE,szf}(float64_to_uint32mu(stop, szE, szf),nothing))
    end
end

function iterate(iter::FloatmuIterator{szE,szf},state=iter.first) where {szE,szf}
    if state <= iter.last
        return (state,nextfloat(state))
    else
        return nothing
    end
end

function length(iter::FloatmuIterator{szE,szf}) where {szE,szf}
    return nb_fp_numbers(iter.first,iter.last)
end

function eltype(iter::FloatmuIterator{szE,szf}) where {szE,szf}
    return Floatmu{szE,szf}
end


"""
    decompose(x::Floatmu{szE,szf}) where {szE,szf}

"""
function decompose(x::Floatmu{szE,szf}) where {szE,szf}
    isnan(x) && return 0,0,0
    isinf(x) && return ifelse(x < 0, -1, 1), 0, 0
    n = reinterpret(UInt32,x.v)
    s = (n & significand_mask(Floatmu{szE,szf})) % Int32
    e = ((n & exponent_mask(Floatmu{szE,szf})) >> szf) % Int
    s |= Int32(e != 0) << szf
    d = ifelse(signbit(x), -1, 1)
    s, e - (szf+bias(Floatmu{szE,szf})) + (e == 0), d
end


"""
    FloatmuOp1Factory
    
    Macro to generate unary operators on FloatMu numbers
"""
macro FloatmuOp1Factory(op::Symbol)
    return quote
        function $(esc(op))(x::Floatmu{szE,szf}) where {szE,szf}
            return Floatmu{szE,szf}($op(convert(Float64,x)))
        end
    end
end

@FloatmuOp1Factory(+)
@FloatmuOp1Factory(-)
@FloatmuOp1Factory(sqrt)
@FloatmuOp1Factory(cos)
@FloatmuOp1Factory(sin)
@FloatmuOp1Factory(tan)
@FloatmuOp1Factory(acos)
@FloatmuOp1Factory(asin)
@FloatmuOp1Factory(atan)
@FloatmuOp1Factory(cosh)
@FloatmuOp1Factory(sinh)
@FloatmuOp1Factory(tanh)
@FloatmuOp1Factory(acosh)
@FloatmuOp1Factory(asinh)
@FloatmuOp1Factory(atanh)
@FloatmuOp1Factory(exp)
@FloatmuOp1Factory(log)
@FloatmuOp1Factory(log2)
@FloatmuOp1Factory(log10)
@FloatmuOp1Factory(log1p)

"""
    FloatmuOp2Factory
    
    Macro to generate binary operators on Floatmu{szE,szf} numbers
"""
macro FloatmuOp2Factory(op::Symbol)
    return quote
        function $(esc(op))(x::Floatmu{szE,szf}, y::Floatmu{szE,szf}) where {szE,szf}
            return Floatmu{szE,szf}($op(convert(Float64,x),
                                        convert(Float64,y)))
        end
        function $(esc(op))(x::Floatmu{szE,szf}, y::Float64) where {szE,szf}
            return Floatmu{szE,szf}($op(convert(Float64,x), y))
        end
        function $(esc(op))(x::Float64, y::Floatmu{szE,szf}) where {szE,szf}
            return Floatmu{szE,szf}($op(x,convert(Float64,y)))
        end
    end
end

@FloatmuOp2Factory(+)
@FloatmuOp2Factory(-)
@FloatmuOp2Factory(*)
@FloatmuOp2Factory(/)

macro BoolOp2Factory(op::Symbol)
    return quote
        function $(esc(op))(x::Floatmu{szE,szf}, y::Floatmu{szE,szf}) where {szE,szf}
            return $op(convert(Float64,x),convert(Float64,y))
        end
        function $(esc(op))(x::Floatmu{szE,szf}, y::Float64) where {szE,szf}
            return $op(convert(Float64,x),y)
        end
        function $(esc(op))(x::Float64, y::Floatmu{szE,szf}) where {szE,szf}
            return $op(x, convert(Float64,y))
        end
        function $(esc(op))(x::Floatmu{szE,szf}, y::Float32) where {szE,szf}
            return $op(convert(Float32,x),y)
        end
        function $(esc(op))(x::Float32, y::Floatmu{szE,szf}) where {szE,szf}
            return $op(x, convert(Float32,y))
        end
        function $(esc(op))(x::Floatmu{szE,szf}, y::Float16) where {szE,szf}
            return $op(convert(Float16,x),y)
        end
        function $(esc(op))(x::Float16, y::Floatmu{szE,szf}) where {szE,szf}
            return $op(x, convert(Float16,y))
        end
    end
end

@BoolOp2Factory(==)
@BoolOp2Factory(!=)
@BoolOp2Factory(<)
@BoolOp2Factory(<=)
@BoolOp2Factory(>)
@BoolOp2Factory(>=)


               


               
end # module
