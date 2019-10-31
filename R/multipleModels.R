#' Training multiple models for benchmark comparison
#' @param train A training data frame
#' @param test A testing data frame
#' @param y Response variable
#' @param metric A minimization metric for training. If not mentioned, for regression RMSE and for classification Kappa value will be used.
#' @param nfolds Number of kfolds for cross validation. By default, 5 will be used.
#' @param repeats Number of repeats for cross validation. By default, 5 will be used.
#' @param models A character list of models to train based on caret package structure
#' @return summary of all trained models and trained models
#' @examples
#' #data("iris")
#' # multipleModels(train = iris, test = iris, y = "Species", models = c("C5.0", "parRF"))
#'
#' ## results
#' ##      Accuracy Kappa AccuracyLower AccuracyUpper AccuracyNull AccuracyPValue McnemarPValue
#' ##C5.0      1.00  1.00     0.9757074     1.0000000    0.3333333   2.702787e-72           NaN
#' ##parRF     0.96  0.94     0.9149722     0.9851815    0.3333333   2.525127e-60           NaN
#' @export


multipleModels = function(train, test, y, metric, nfolds, repeats, models){
    #requireNamespace(caret)
    #requireNamespace(doParallel)
    #requireNamespace(parallel)
    # create parallel compute
    numCores = parallel::detectCores()
    cl = parallel::makeCluster(numCores, timeout = 300)
    doParallel::registerDoParallel(cl)

    #set training partameters
    fitControl = caret::trainControl(## 10-fold CV
                  method = "repeatedcv",
                  number = ifelse(missing(nfolds), 10, nfolds),
                  ## repeated ten times
                  repeats = ifelse(missing(repeats), 10, repeats))

    # check to see if metric is specified. Else use default metric
    chkMetric = function(){
      d = train[,c(y)]
      return(ifelse(is.factor(d), "Kappa", "RMSE"))
    }

    # create train and test data
    x = train[,-grep(y,colnames(train))]
    y1 = train[,c(y)]

    # create empty list to store models
    trainedModels = list()

    # train models
    for(i in 1:length(models)){
          model = caret::train(x, y1,
                            method = models,
                            allowParallel = TRUE,
                            metric = ifelse(missing(metric), chkMetric(), metric),
                            trControl = fitControl,
                            verbose = FALSE,
                            allowParallel = TRUE
          )

          trainedModels = append(trainedModels, list(model))

    }

    # name all the models
    names(trainedModels) = models

    # list to build summary
    sumList = list()
    for(i in 1:length(models)){
      if(is.factor(test[,c(y)])){
          sl = caret::confusionMatrix(caret::predict.train(trainedModels[[i]],test), test[,c(y)])
          sumList = append(sumList, list(sl$overall))
      }
      else{
        actual = test[,c(y)]
        predicted = caret::predict.train(trainedModels[[i]],test)
        sl = data.frame(RMSE = Metrics::rmse(actual, predicted),
                        MSE = Metrics::mse(actual, predicted),
                        MAE = Metrics::mae(actual, predicted),
                        MAPE = Metrics::mape(actual, predicted),
                        MSLE = Metrics::msle(actual, predicted)
                        )
        sumList = append(sumList, list(sl))
      }

    }

    # bind all the list summary
    testSumList = do.call(rbind, sumList)
    rownames(testSumList) = models

    #close all clusters
    parallel::stopCluster(cl)

    # return summary and trained models
    return(list(summary = testSumList, models = trainedModels))
}
