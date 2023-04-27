using EHTImaging
using Documenter

DocMeta.setdocmeta!(EHTImaging, :DocTestSetup, :(using EHTImaging); recursive=true)

makedocs(;
    modules=[EHTImaging],
    authors="Paul Tiede <ptiede91@gmail.com> and contributors",
    repo="https://github.com/ptiede/EHTImaging.jl/blob/{commit}{path}#{line}",
    sitename="EHTImaging.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://ptiede.github.io/EHTImaging.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/ptiede/EHTImaging.jl",
    devbranch="main",
)
