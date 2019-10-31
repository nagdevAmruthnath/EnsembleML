#' predict for ensemble
#' @param ensembleModel trained ensemble model
#' @param test  a test dataframe to do predictions
#' @return a dataframe with response variables
#' @examples
#' # data("iris")
#' # mm = multipleModels(train = iris, test = iris, y = "Species", models = c("C5.0", "parRF"))
#' # ensembleModel = ensembleTrain(mm,
#' #                               train = iris,
#' #                               test = iris,
#' #                               y = "Species",
#' #                               emsembleModelTrain = "C5.0")
#' # predictEnsemble(ensembleModel, iris)
#' @export

predictEnsemble = function(ensembleModel, test){
  # create test data from multiple models
  x = do.call("cbind", lapply(ensembleModel$mm$models, function(x) caret::predict.train(x, test)))

  #do predictions
  predictions = data.frame(preds = stats::predict(ensembleModel$model, x))
  colnames(predictions) = "prediction"

  #return predictions
  return(predictions)
}
