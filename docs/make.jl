using LocalPolynomialDensityEstimation
using Documenter

DocMeta.setdocmeta!(LocalPolynomialDensityEstimation, :DocTestSetup, :(using LocalPolynomialDensityEstimation); recursive=true)

makedocs(;
    modules=[LocalPolynomialDensityEstimation],
    authors="Pierre Navaro <pierre.navaro@math.cnrs.fr> and contributors",
    sitename="LocalPolynomialDensityEstimation.jl",
    format=Documenter.HTML(;
        canonical="https://pnavaro.github.io/LocalPolynomialDensityEstimation.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/pnavaro/LocalPolynomialDensityEstimation.jl",
    devbranch="main",
)
