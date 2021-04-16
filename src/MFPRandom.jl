# MFPRandom --
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

module MFPRandom

import Random
import MicroFloatingPoints


"""
    irandint(rng::Random.AbstractRNG, n::Int64)

Draw a `n` bits integer at *random*.

First, compute a 64 bits integer, then discard the lowest `(64-n)` bits, which 
are often the less *random* ones.

Throw an ArgumentError exception if `n` is strictly greater than 64.

"""
function irandint(rng::Random.AbstractRNG, n::Int64)
    if n > 64
        throw(ArgumentError("the second argument must be smaller or equal to 64"))
    end
    return rand(rng,UInt64) >> (64-n)
end


function Random.rand(rng::Random.AbstractRNG, ::Random.SamplerTrivial{Random.CloseOpen01{MicroFloatingPoints.Floatmu{szE,szf}}}) where {szE,szf}
    f = irandint(rng, szf)
    # As for the other floating-point types in Julia, we set the unbiased exponent to 0, and
    # we draw `sz` bits at random to constitute the fractional part of a number in ``[1,2)``.
    # We then subtract 1.0 to obtain a number in ``[0,1)``.
    v = UInt32((UInt32(MicroFloatingPoints.bias(MicroFloatingPoints.Floatmu{szE,szf})) << szf) | f)
    return MicroFloatingPoints.Floatmu{szE,szf}(v,nothing) - MicroFloatingPoints.Floatmu{szE,szf}(1.0)
end



end # Module
