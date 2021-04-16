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
    real_line(start::Floatmu{szE,szf}, stop::Floatmu{szE,szf};
              ticks = true, 
              fpcolorsub = "purple", fpcolornorm = "blue") where {szE,szf}
    real_line(::Type{Floatmu{szE,szf}};
              ticks = true, 
              fpcolorsub = "purple", fpcolornorm = "blue",
              fpcolorinf="orange") where {szE,szf}

The first version draws the real line between `start` and `stop` and displays all floating-point
numbers with `sze` bits exponent and `szf` bits fractional part. The second version draws all finite 
floating-point for the format `Floatmu{szE,szf}` and adds the infinities where the next/previous 
float would be with the format `Floatmu{szE+1,szf}`.


Both parameters `start` and `stop` must be finite. An `ArgumentError` exception
is raised otherwise.

Both versions return the figure used for the plot.

The figure may be customized through the named parameters:
- `ticks`: if `true`, draws a vertical line for each float and adds the value below. If
    `false`, represent each float by a dot on the real line, without its value;
- `fpcolorsub`: color of the line or dot used to represent subnormals;
- `fpcolornorm`: color of the line or dot used to represent normal values;
- `fpcolorinf` [for the second version only]: color of the line or dot used to represent infinite values.

# Examples of calls

```@repl
real_line(-floatmax(Floatmu{2,2}),floatmax(Floatmu{2,2}));
real_line(Floatmu{2,2});
```
"""
function real_line end

function real_line(start::Floatmu{szE,szf}, stop::Floatmu{szE,szf};
                   ticks = true, fpcolorsub = "purple", fpcolornorm = "blue") where {szE,szf}
    (isfinite(start) && isfinite(stop)) || throw(ArgumentError("parameters must be finite"))

    normal_height = 0.04*(convert(Float64,stop)-convert(Float64,start))
    subnormal_height = .8*normal_height
    plt.axis("off")
    fig=plot([start,stop],[0,0],"k-",color="black")
    for v in FloatmuIterator(start,stop)
        if issubnormal(v)
            if ticks
                plot([v,v],[-subnormal_height,subnormal_height],"k-",color=fpcolorsub)
                text(v,-normal_height,string(v),fontsize=8,ha="center",va="top",
                     rotation=90,color=fpcolorsub)
            else
                plot(v,0,marker=".",color=fpcolorsub)
            end
        else
            if ticks
                plot([v,v],[-normal_height,normal_height],"k-",color=fpcolornorm)
                if v == 0.0
                    text(0,-1.1*normal_height,L"\pm 0",fontsize=8,ha="center",va="top",
                         rotation=90,color=fpcolornorm)
                else
                    text(v,-1.1*normal_height,string(v),fontsize=8,ha="center",va="top",
                         rotation=90,color=fpcolornorm)
                end
            else
                plot(v,0,marker=".",color=fpcolornorm)
            end
        end
    end
    return fig
end 

function real_line(::Type{Floatmu{szE,szf}};
                   ticks = true, fpcolorsub = "purple", fpcolornorm = "blue",
                   fpcolorinf="orange") where {szE,szf}
    posInf = nextfloat(Floatmu{szE+1,szf}(floatmax(Floatmu{szE,szf})))
    negInf = prevfloat(Floatmu{szE+1,szf}(-floatmax(Floatmu{szE,szf})))
    fig = real_line(-floatmax(Floatmu{szE,szf}),floatmax(Floatmu{szE,szf}),ticks=ticks,fpcolorsub=fpcolorsub,fpcolornorm=fpcolornorm)
    plot([negInf,posInf],[0,0],"k-",color="black")
    plot(negInf,0,marker="o",color=fpcolorinf)
    text(negInf,.02,L"-\infty",ha="center",va="bottom",fontsize=8,color=fpcolorinf)
    plot(posInf,0,marker="o",color=fpcolorinf)
    text(posInf,.02,L"\infty",ha="center",va="bottom",fontsize=8,color=fpcolorinf)
    return fig
end

end # Module
