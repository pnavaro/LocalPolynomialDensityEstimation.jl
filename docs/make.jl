using LocalPolynomialDensityEstimation
using Documenter

DocMeta.setdocmeta!(
    LocalPolynomialDensityEstimation,
    :DocTestSetup,
    :(using LocalPolynomialDensityEstimation);
    recursive = true,
)

makedocs(;
    modules = [LocalPolynomialDensityEstimation],
    authors = "Pierre Navaro and Nicolas Klutchnikov",
    sitename = "LocalPolynomialDensityEstimation.jl",
    format = Documenter.HTML(;
        canonical = "https://pnavaro.github.io/LocalPolynomialDensityEstimation.jl",
        edit_link = "main",
        assets = String[],
    ),
    pages = [
        "Home" => "index.md",
        "Observation Window" => "observation_window.md",
        "Pixel Image" => "pixel_image.md",
    ],
)

deploydocs(;
    repo = "github.com/pnavaro/LocalPolynomialDensityEstimation.jl",
    devbranch = "main",
)
