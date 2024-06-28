deps <- c(
"devtools", 
"spatstat" 
)

packages <- installed.packages()

for(pkg in deps) {
    if(!is.element(pkg, packages[,1])){
        install.packages(pkg, quiet = TRUE)
    }
}

devtools::install_github("klutchnikoff/densityLocPoly")
library(densityLocPoly)

orthonormal_polynomials <- utils::getFromNamespace("orthonormal_polynomials", "densityLocPoly")
