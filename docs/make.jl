push!(LOAD_PATH,"../src")
using Documenter, MicroFloatingPoint

makedocs(
    sitename="The MicroFloatingPoint Documentation",
    authors = "Frédéric Goualard"
#    modules = [MicroFloatingPoint],
)
