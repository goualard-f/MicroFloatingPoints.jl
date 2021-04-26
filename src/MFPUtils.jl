# MFPUtils --
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

module MFPUtils

import ..MicroFloatingPoints: Floatmu

export vertical_popcount

"""
    vertical_popcount(T::Vector{Floatmu{szE,szf}}) where {szE,szf}

Return a vector `R` of size `1+szE+szf` where `R[i]` is the number of times
the `i`-th bit of the values in `T` was equal to `1`. 

For this function, the rightmost bit of the binary representation of a `Floatmu` has index `1` and not `0` as usual.

# Examples

```jldoctest
julia> join(string.(reverse(vertical_popcount(Floatmu{2,2}[1.5])))) == bitstring(Floatmu{2,2}(1.5))
true
```
Note that, in the preceding example, we have to revert the array obtained from `vertical_popcount` because the number of times bit `i` is `1` is saved at position `i`. As a consequence, the value for the rightmost bit of a `Floatmu` appears at the leftmost position of the counting array.

```jldoctest
julia> println(vertical_popcount(Floatmu{2,2}[0.25,1.5,3.0]))
[1, 2, 1, 1, 0]
```
"""
function vertical_popcount(T::Vector{Floatmu{szE,szf}}) where {szE,szf}
    count = zeros(Int,1 + szE + szf)
    for x in T
        v = x.v
        pos = 1
        while v != 0
            count[pos] += Int(v & 1)
            v >>= 1
            pos += 1
        end
    end
    return count
end


end # Module
