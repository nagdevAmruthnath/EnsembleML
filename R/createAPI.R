#' Create an API for trained ensemble model
#' @param host  your device host address
#' @param port address of you post to host app on
#' @return starts an API app to run your predictive model
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



createAPI  = function(host, port){

      # look for pakages and install them as necessery
      tryCatch({requireNamespace("jug")
                requireNamespace("infuser")
                },
               error = function(e){
                 print("Installing packages now")
                 devtools::install_github("Bart6114/jug",force = TRUE)
                 devtools::install_github("Bart6114/infuser",force = TRUE)
      })

      # predict function
      predict_api = function(data){
        model = readModel(fromJSON(data)$model)
        test_Df = jsonlite::fromJSON((fromJSON(data)$test))
        return(predictEnsemble(model, test_Df))
      }

      # start the API
      jug::jug() %>%
        jug::post("/predict", jug::decorate(predict_api)) %>%
        jug::simple_error_handler_json() %>%
        jug::serve_it(host=host, port = port, verbose = T)
}
