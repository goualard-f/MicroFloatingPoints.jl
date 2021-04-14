push!(LOAD_PATH,"../src")
using Documenter, MicroFloatingPoints, MFPRandom, MFPPlot

DocMeta.setdocmeta!(MicroFloatingPoints,
                    :DocTestSetup, :(using MicroFloatingPoints, MFPRandom, MFPPlot);
                    recursive=true)

makedocs(
    sitename="The MicroFloatingPoints Documentation",
    authors = "Frédéric Goualard",
    modules = [MicroFloatingPoints, MFPRandom, MFPPlot],
    format = Documenter.HTML(prettyurls = get(ENV, "CI", nothing) == "true"),
    pages = ["Home" => "index.md"
             "A Guided Tour" => "guided-tour.md"
             "Manual" => "manual.md"
             "Installation" => "installation.md"
             "Developer Documentation" => "developer.md"
             ],
    #assets = ["assets/favicon.ico"]
)
