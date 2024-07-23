deps <- c(
"devtools", 
"spatstat", 
"spatstat.geom", 
"spatstat.random" 
)

packages <- installed.packages()

for(pkg in deps) {
    if(!is.element(pkg, packages[,1])){
        install.packages(pkg, quiet = FALSE)
    }
}

devtools::install_github("klutchnikoff/densityLocPoly")
library(densityLocPoly)

orthonormal_polynomials <- utils::getFromNamespace("orthonormal_polynomials", "densityLocPoly")
