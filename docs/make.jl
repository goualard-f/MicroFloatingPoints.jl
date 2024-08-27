using Documenter, Random
using MicroFloatingPoints
using MicroFloatingPoints.MFPRandom
using MicroFloatingPoints.MFPPlot
using MicroFloatingPoints.MFPUtils

DocMeta.setdocmeta!(MicroFloatingPoints, :DocTestSetup, :(using MicroFloatingPoints, MicroFloatingPoints.MFPRandom, MicroFloatingPoints.MFPPlot, MicroFloatingPoints.MFPUtils, PyPlot); recursive=true)

makedocs(
    sitename="The MicroFloatingPoints Documentation",
    authors = "Frédéric Goualard",
    modules = [MicroFloatingPoints, MicroFloatingPoints.MFPRandom, MicroFloatingPoints.MFPPlot, MicroFloatingPoints.MFPUtils],
    format = Documenter.HTML(prettyurls = false), # get(ENV, "CI", nothing) == "true"),
    pages = ["Home" => "index.md"
             "A Guided Tour" => "guided-tour.md"
             "Manual" => "manual.md"
             "Developer Documentation" => "developer.md"
             ],
)

deploydocs(
    repo = "github.com/goualard-f/MicroFloatingPoints.jl.git",
    devbranch = "main",
)
