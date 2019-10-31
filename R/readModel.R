#' load ensemble model
#' @param location  entire path and filename for the model
#' @return On success a success message else a failure message
#' @examples
#' # data("iris")
#' # mm = multipleModels(train = iris, test = iris, y = "Species", models = c("C5.0", "parRF"))
#' # ensembleModel = ensembleTrain(mm,
#' #                               train = iris,
#' #                               test = iris,
#' #                               y = "Species",
#' #                               emsembleModelTrain = "C5.0")
#' # predictEnsemble(ensembleModel, iris)
#' # saveRDS(ensembleModel, "C:/Documents/savedEnsembleModel.RDS")
#' # readRDS("C:/Documents/savedEnsembleModel.RDS")
#' @export

readModel = function(location){
  tryCatch({
    model = readRDS(location)
    print(paste0("Model was successfully loaded"))
    return(model)
  }, error = function(e){
    print("There was an error while loading model")
  }
  )
}

