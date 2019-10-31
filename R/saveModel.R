#' Save trained model to host device
#' @param ensembleModel trained ensemble model
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

saveModel = function(ensembleModel,location){
  tryCatch({
    saveRDS(ensembleModel,location)
    print(paste0("Model successfully saved in", location))
  }, error = function(e){
    print("There was an error while saving model")
    }
  )
}

