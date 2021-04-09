# MFPPlot --
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

module MFPPlot

using PyPlot
using MicroFloatingPoints

export real_line

"""
    real_line(start = -floatmax(Floatmu{szE,szf}),
              stop = floatmax(Floatmu{szE,szf})) where {szE,szf}

    Draw the real line between `start` and `stop` and display all floating-point
    numbers with `sze` bits exponent and `szf` bits fractional part.

    Both parameters `start` and `stop` must be finite. An `ArgumentError` exception
    is raised otherwise.
"""
function real_line(start = -floatmax(Floatmu{szE,szf}),
                   stop = floatmax(Floatmu{szE,szf})) where {szE,szf}
    if !isfinite(start) || !isfinite(stop)
        throw(ArgumentError("parameters must be finite"))
    end
    plt.axis("off")
    fig=plot([start,stop],[0,0],"k-",color="black")
    for v in FloatmuIterator(start,stop)
        if issubnormal(v)
            plot([v,v],[-.4,.4],"k-",color="purple")
            if v != 0
                text(v,-.5,string(v),fontsize=8,ha="center",va="top",
                     rotation=90,color="purple")
            else
                text(0,-.5,L"\pm 0",fontsize=8,ha="center",va="top",
                     rotation=90,color="purple")
            end
        else
            plot([v,v],[-.5,.5],"k-",color="blue")
            text(v,-.6,string(v),fontsize=8,ha="center",va="top",
                 rotation=90,color="blue")
        end
    end
    return fig
end 

end # Module
