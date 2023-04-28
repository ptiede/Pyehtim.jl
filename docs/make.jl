using Pyehtim
using Documenter

DocMeta.setdocmeta!(Pyehtim, :DocTestSetup, :(using Pyehtim); recursive=true)

makedocs(;
    modules=[Pyehtim],
    authors="Paul Tiede <ptiede91@gmail.com> and contributors",
    repo="https://github.com/ptiede/Pyehtim.jl/blob/{commit}{path}#{line}",
    sitename="Pyehtim.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://ptiede.github.io/Pyehtim.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/ptiede/Pyehtim.jl",
    devbranch="main",
)
