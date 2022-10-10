# MicroFloatingPoints --
#
#	Copyright 2019--2022 University of Nantes, France.
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

export Floatmu
export μ, λ, NaNμ, Infμ
export FloatmuIterator
export isinexact, errorsign, reset_inexact, inexact
export Emax, Emin, nb_fp_numbers, bias
export eligible_step
export fractional_even

include("Floatmu.jl")

# Submodule MFPUtils
include("MFPUtils.jl")

# Submodule MFPPlot
include("MFPPlot.jl")

# Submodule MFPRandom
include("MFPRandom.jl")


end # module
