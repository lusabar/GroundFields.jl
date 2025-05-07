using GroundFields
using Documenter

DocMeta.setdocmeta!(GroundFields, :DocTestSetup, :(using GroundFields); recursive=true)

makedocs(;
    modules=[GroundFields],
    authors="Lucas Sales Barbosa <lucassalesb10@gmail.com> and contributors",
    sitename="GroundFields.jl",
    format=Documenter.HTML(;
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)
