#' Training ensemble model
#' @param mm A trained object from mm function
#' @param train A training data frame
#' @param test A testing data frame
#' @param y Response variable
#' @param emsembleModelTrain An ensemble model to train from caret model list
#' @param metric A minimization metric for training. If not mentioned, for regression RMSE and for classification Kappa value will be used.
#' @param nfolds Number of kfolds for cross validation. By default, 5 will be used.
#' @param repeats Number of repeats for cross validation. By default, 5 will be used.
#' @return confusion matrix of ensemble model and returns ensemble model
#' @examples
#' # data("iris")
#' # ensembleTrain(mm, train = iris, test = iris, y = "Species"
#' #                , emsembleModelTrain = "C5.0")
#' @export

ensembleTrain =  function(mm, train, test, y, emsembleModelTrain, metric, nfolds, repeats){

  y1 = train[,c(y)]

  getx = function(data){
    x = do.call("cbind", lapply(mm$models, function(x) caret::predict.train(x, data)))
    return(x)
  }

  # check to see if metric is specified. Else use default metric
  chkMetric = function(){
    d = train[,c(y)]
    return(ifelse(is.factor(d), "Kappa", "RMSE"))
  }

  # create parallel compute
  numCores = parallel::detectCores()
  cl = parallel::makeCluster(numCores)
  doParallel::registerDoParallel(cl)

  #set training partameters
  fitControl = caret::trainControl(## 10-fold CV
                                    method = "repeatedcv",
                                    number = ifelse(missing(nfolds), 10, nfolds),
                                    ## repeated ten times
                                    repeats = ifelse(missing(repeats), 10, repeats)
    )

  ensembleModel = caret::train(x = getx(train)
                               , y1,
                               method =emsembleModelTrain,
                               allowParallel = TRUE,
                               metric = ifelse(missing(metric), chkMetric(), metric),
                               trControl = fitControl,
                               verbose = FALSE,
                               allowParallel = TRUE
                      )

  if(is.factor(test[,c(y)])){
        sl = caret::confusionMatrix(caret::predict.train(ensembleModel,getx(test)), test[,c(y)])
  }
  else{
    actual = test[,c(y)]
    predicted = caret::predict.train(ensembleModel,getx(test))
    sl = data.frame(RMSE = Metrics::rmse(actual, predicted),
                    MSE = Metrics::mse(actual, predicted),
                    MAE = Metrics::mae(actual, predicted),
                    MAPE = Metrics::mape(actual, predicted),
                    MSLE = Metrics::msle(actual, predicted)
    )
  }
  #close all clusters
  parallel::stopCluster(cl)

  return(list(summary = sl, model = list(ensembleModel), mm = mm))
}

