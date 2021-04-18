using Documenter, Random
using MicroFloatingPoints
using MicroFloatingPoints.MFPRandom
using MicroFloatingPoints.MFPPlot

DocMeta.setdocmeta!(MicroFloatingPoints, :DocTestSetup, :(using MicroFloatingPoints, MicroFloatingPoints.MFPRandom, MicroFloatingPoints.MFPPlot); recursive=true)

makedocs(
    sitename="The MicroFloatingPoints Documentation",
    authors = "Frédéric Goualard",
    modules = [MicroFloatingPoints, MicroFloatingPoints.MFPRandom, MicroFloatingPoints.MFPPlot],
    format = Documenter.HTML(prettyurls = get(ENV, "CI", nothing) == "true"),
    pages = ["Home" => "index.md"
             "Installation" => "installation.md"
             "A Guided Tour" => "guided-tour.md"
             "Manual" => "manual.md"
             "Developer Documentation" => "developer.md"
             ],
)

deploydocs(
    repo = "github.com/goualard-f/MicroFloatingPoints.jl.git",
)
