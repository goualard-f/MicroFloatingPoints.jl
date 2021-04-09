push!(LOAD_PATH,"../src")
using Documenter, MicroFloatingPoints

makedocs(
    sitename="The MicroFloatingPoints Documentation",
    authors = "Frédéric Goualard",
    #modules = [MicroFloatingPoints],
    format = Documenter.HTML(prettyurls = get(ENV, "CI", nothing) == "true"),
    pages = ["Home" => "index.md"
             "A Guided Tour" => "guided-tour.md"
             "Manual" => "manual.md"
             "Developer Documentation" => "developer.md"
             ],
    #assets = ["assets/favicon.ico"]
)
