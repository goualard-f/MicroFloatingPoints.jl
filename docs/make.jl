push!(LOAD_PATH,"../src")
using Documenter, MicroFloatingPoints, MFPRandom, MFPPlot, Random

DocMeta.setdocmeta!(MicroFloatingPoints,
                    :DocTestSetup, :(using MicroFloatingPoints, MFPRandom, MFPPlot, Random);
                    recursive=true)

makedocs(
    sitename="The MicroFloatingPoints Documentation",
    authors = "Frédéric Goualard",
    modules = [MicroFloatingPoints, MFPRandom, MFPPlot],
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
    devbranch = "main"
)
