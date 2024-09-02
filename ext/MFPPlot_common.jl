# common include of both MFPPyPlot.jl and MFPPythonPlot.jl
# For MFPPythonPlot.jl, `const plt = pyplot`.

using MicroFloatingPoints
using MicroFloatingPoints.MFPUtils: vertical_popcount
import MicroFloatingPoints.MFPPlot: real_line, bits_histogram

export real_line
export bits_histogram

function real_line(::Val{@__MODULE__}, T::Vector{Floatmu{szE,szf}};
                   ticks = true, fpcolorsub = "purple", fpcolornorm = "blue",
                   fpcolorinf="orange") where {szE,szf}
    all(isfinite,T) || throw(ArgumentError("parameters must be finite"))
    (lmost, rmost) = extrema(T)
    normal_height = 0.04*(convert(Float64,rmost)-convert(Float64,lmost))
    subnormal_height = .8*normal_height
    plt.axis("off")
    fig=plot([lmost,rmost],[0,0],"k-")
    for v in T
        if issubnormal(v)
            if ticks
                plot([v,v],[-subnormal_height,subnormal_height],"-",color=fpcolorsub)
                text(v,-normal_height,string(v),fontsize=8,ha="center",va="top",
                     rotation=90,color=fpcolorsub)
            else
                plot(v,0,marker=".",color=fpcolorsub)
            end
        else
            if ticks
                plot([v,v],[-normal_height,normal_height],"-",color=fpcolornorm)
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


function real_line(::Val{@__MODULE__}, start::Floatmu{szE,szf}, stop::Floatmu{szE,szf};
                   ticks = true, fpcolorsub = "purple", fpcolornorm = "blue") where {szE,szf}
    # This version could be rewritten as:
    # `real_line(collect(FloatmuIterator(start,stop)))`
    # but is not to benefit from the on-demand generation of floats with
    # the FloatmuIterator, which avoids creating a potentially large vector.
    (isfinite(start) && isfinite(stop)) || throw(ArgumentError("parameters must be finite"))

    normal_height = 0.04*(convert(Float64,stop)-convert(Float64,start))
    subnormal_height = .8*normal_height
    plt.axis("off")
    fig=plot([start,stop],[0,0],"k-")
    for v in FloatmuIterator(start,stop)
        if issubnormal(v)
            if ticks
                plot([v,v],[-subnormal_height,subnormal_height],"-",color=fpcolorsub)
                text(v,-normal_height,string(v),fontsize=8,ha="center",va="top",
                     rotation=90,color=fpcolorsub)
            else
                plot(v,0,marker=".",color=fpcolorsub)
            end
        else
            if ticks
                plot([v,v],[-normal_height,normal_height],"-",color=fpcolornorm)
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


function real_line(::Val{@__MODULE__}, ::Type{Floatmu{szE,szf}};
                   ticks = true, fpcolorsub = "purple", fpcolornorm = "blue",
                   fpcolorinf="orange") where {szE,szf}
    posInf = nextfloat(Floatmu{szE+1,szf}(floatmax(Floatmu{szE,szf})))
    negInf = prevfloat(Floatmu{szE+1,szf}(-floatmax(Floatmu{szE,szf})))
    fig = real_line(-floatmax(Floatmu{szE,szf}),floatmax(Floatmu{szE,szf}),ticks=ticks,fpcolorsub=fpcolorsub,fpcolornorm=fpcolornorm)
    plot([negInf,posInf],[0,0],"-",color="black")
    plot(negInf,0,marker="o",color=fpcolorinf)
    text(negInf,.02,L"-\infty",ha="center",va="bottom",fontsize=8,color=fpcolorinf)
    plot(posInf,0,marker="o",color=fpcolorinf)
    text(posInf,.02,L"\infty",ha="center",va="bottom",fontsize=8,color=fpcolorinf)
    return fig
end


function bits_histogram(::Val{@__MODULE__}, T::Vector{Floatmu{szE,szf}};
                        signcolor = "magenta",
                        expcolor = "darkolivegreen",
                        fraccolor = "blue") where {szE,szf}
    occurs = vertical_popcount(T)
    floatsz = length(occurs)
    occurs = 100*(occurs ./ length(T))
    plt.bar(0,occurs[floatsz],color=signcolor)
    plt.bar(1:szE,occurs[(floatsz-1):-1:(floatsz-szE)],color=expcolor)
    plt.bar((szE+1):(floatsz-1),occurs[(floatsz-szE-1):-1:1],color=fraccolor)
    plt.yticks(0:10:100,[string(i) for i in 0.0:0.1:1.0])
    ticks = [collect(0:10:(floatsz-1));floatsz-1]
#    plt.gca().invert_xaxis()
    plt.xticks((floatsz-1) .- ticks, map((x)->string(x),ticks))
    plt.xlabel("Binary representation",fontdict=Dict("size"=>20))
    plt.ylabel("Probability to be 1",fontdict=Dict("size"=>20))
    return nothing
end

function __init__()
    MicroFloatingPoints.MFPPlot.register_backend(@__MODULE__)
end
