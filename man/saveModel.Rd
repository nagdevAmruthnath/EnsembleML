% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/saveModel.R
\name{saveModel}
\alias{saveModel}
\title{Save trained model to host device}
\usage{
saveModel(ensembleModel, location)
}
\arguments{
\item{ensembleModel}{trained ensemble model}

\item{location}{entire path and filename for the model}
}
\value{
On success a success message else a failure message
}
\description{
Save trained model to host device
}
\examples{
# data("iris")
# mm = multipleModels(train = iris, test = iris, y = "Species", models = c("C5.0", "parRF"))
# ensembleModel = ensembleTrain(mm,
#                               train = iris,
#                               test = iris,
#                               y = "Species",
#                               emsembleModelTrain = "C5.0")
# predictEnsemble(ensembleModel, iris)
# saveRDS(ensembleModel, "C:/Documents/savedEnsembleModel.RDS")
# readRDS("C:/Documents/savedEnsembleModel.RDS")
}
