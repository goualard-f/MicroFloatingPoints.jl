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

import Random.rand
using MicroFloatingPoints

"""
    irandint(rng,n)

Draw a n bits integer at **random**.

First, compute a 64 bits integer, then discard the lowest `(64-n)` bits, which 
are usually the less *random* ones.
"""
function irandint(n)
    return rand(UInt64) >> (64-n)
end


function rand(::Type{Floatmu{szE,szf}}) where {szE,szf}
    f = irandint(szf)
    v = UInt32((UInt32(MicroFloatingPoints.bias(Floatmu{szE,szf})) << szf) | f)
    return Floatmu{szE,szf}(v,nothing) - Floatmu{szE,szf}(1.0)
end

end # Module
