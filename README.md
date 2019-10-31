# EnsembleML

EnsembleML is an R package for performing feature creation in time series and frequency series, building multiple regression and classification models and combining those models to be an ensemble. You can save and read models created using this package and also deploy them as API within the same model. 

## Installation of the package
The pacakge is currently only available in Github and won't be seeing anytime in CRAN. Use devtools to install from github as follows. 

```
devtools::install_github("nagdevAmruthnath/EnsembleML")
library(EnsembleML)
```

## Feature creation
Features can be created both in time series and frequency series using this package. Use `featureCreationTS()` for time series and `featureCreationF` for frequency domain. The standard features include mean, sd, median, trimmed, mad, min, max, range, skew, kurtosis, se, iqr, nZero, nUnique, lowerBound, upperBound, and quantiles. 

```
data = rnorm(50)
featureCreationTS(data)

#     TS_mean    TS_sd TS_median TS_trimmed    TS_mad    TS_min   TS_max TS_range   TS_skew TS_kurtosis
#X1 0.2107398 1.025315 0.1822303  0.2097342 0.8026293 -2.194434 3.161181 5.355616 0.1251634   0.6376311
#       TS_se   TS_iqr TS_nZero TS_nUnique TS_lowerBound TS_upperBound    TS_X1.    TS_X5.   TS_X25.
#X1 0.1450015 1.041068        0         50     -1.850106      2.314167 -2.116863 -1.388573 -0.288504
#     TS_X50.   TS_X75.  TS_X95.  TS_X99.
#X1 0.1822303 0.7525642 1.661972 2.814687
```

## Summary of the data
`numSummary()` function can be used to generate the numerical summary of the entire data set. The example for iris data set is shown below. Rest of the documentation will include using `iris` data set. 

```
data(iris)
numSummary(iris)

#                n mean    sd max min range nunique nzeros  iqr lowerbound upperbound noutlier kurtosis
# Sepal.Length 150 5.84 0.828 7.9 4.3   3.6      35      0 1.30       3.15       8.35        0   -0.606
# Sepal.Width  150 3.06 0.436 4.4 2.0   2.4      23      0 0.50       2.05       4.05        4    0.139
# Petal.Length 150 3.76 1.765 6.9 1.0   5.9      43      0 3.55      -3.72      10.42        0   -1.417
# Petal.Width  150 1.20 0.762 2.5 0.1   2.4      22      0 1.50      -1.95       4.05        0   -1.358
#              skewness mode miss miss%   1%   5% 25%  50% 75%  95%  99%
# Sepal.Length    0.309  5.0    0     0 4.40 4.60 5.1 5.80 6.4 7.25 7.70
# Sepal.Width     0.313  3.0    0     0 2.20 2.34 2.8 3.00 3.3 3.80 4.15
# Petal.Length   -0.269  1.4    0     0 1.15 1.30 1.6 4.35 5.1 6.10 6.70
# Petal.Width    -0.101  0.2    0     0 0.10 0.20 0.3 1.30 1.8 2.30 2.50

```

## Training multiple models
For most prototyping we end up training multiple models manually. This is not only time consuming but also not very efficient. `multipleModels()` function can be used to train multiple models at once as shown below. All the models uses `caret` function models. You an read more about it here https://topepo.github.io/caret/available-models.html

```
mm = multipleModels(train = iris, test = iris, y = "Species", models = c("C5.0", "parRF"))

# $summary
#       Accuracy Kappa AccuracyLower AccuracyUpper AccuracyNull AccuracyPValue McnemarPValue
# C5.0     0.960  0.94         0.915         0.985        0.333       2.53e-60           NaN
# parRF    0.973  0.96         0.933         0.993        0.333       8.88e-64           NaN
```

The bench mark for training multiple models for iris data set is as follows

```
microbenchmark::microbenchmark(multipleModels(train = iris, test = iris, y = "Species", models = c("C5.0", "parRF")), times = 5)

# Unit: seconds
#                                                                                        expr  min   lq mean 
#  multipleModels(train = iris, test = iris, y = "Species", models = c("C5.0",      "parRF")) 22.6 22.6 22.9
#  median   uq  max neval
#    22.7 22.7 23.8     5
```

## Training an ensemble
Ensemble training is a concept of joining results from multiple models and feeding it to a different model. You can use `ensembleTrain()` function to achieve this. We use the results from multiple models `mm` and then feed it to this function as follows

```
em = ensembleTrain(mm, train = iris, test = iris, y = "Species", emsembleModelTrain = "C5.0")

# $summary
# Confusion Matrix and Statistics
# 
#             Reference
# Prediction   setosa versicolor virginica
#   setosa         50          0         0
#   versicolor      0         47         1
#   virginica       0          3        49
# 
# Overall Statistics
#                                         
#                Accuracy : 0.973         
#                  95% CI : (0.933, 0.993)
#     No Information Rate : 0.333         
#     P-Value [Acc > NIR] : <2e-16        
#                                         
#                   Kappa : 0.96          
#                                         
#  Mcnemar's Test P-Value : NA            
# 
# Statistics by Class:
# 
#                      Class: setosa Class: versicolor Class: virginica
# Sensitivity                  1.000             0.940            0.980
# Specificity                  1.000             0.990            0.970
# Pos Pred Value               1.000             0.979            0.942
# Neg Pred Value               1.000             0.971            0.990
# Prevalence                   0.333             0.333            0.333
# Detection Rate               0.333             0.313            0.327
# Detection Prevalence         0.333             0.320            0.347
# Balanced Accuracy            1.000             0.965            0.975
```

## Predicting from ensemble
`predictEnsemble()` function is used to predict from ensemble model

```
predictEnsemble(em, iris)

#     prediction
# 1       setosa
# 2       setosa
# 3       setosa
# 4       setosa
# 5       setosa
# 6       setosa
# 7       setosa
# 8       setosa
#           .
#           .
#           .
```
## Saving and reading the model
Ensemble models can be saved and read back to the memory as follows

```
saveRDS(ensembleModel, "/home/savedEnsembleModel.RDS")
readRDS("/home/savedEnsembleModel.RDS")
```

## Deploying models as API
The trained models could be deployed as API using the same package as follows. First we need to save the models and then call them as follows

```
library(dplyr)
createAPI(host = '192.168.1.1', port = 8890)
# Serving the jug at http://192.168.1.1:8890
# [1] "Model was successfully loaded"
# HTTP | /predict - POST - 200 
```

Lets curl and see what we get

```
curl -X POST \
  http://192.168.1.1:8890/predict \
  -H 'Host: 10.74.87.53:8890' \
  -H 'content-type: multipart/form-data' \
  -F 'jsondata={"model":["/home/lambdaadmin/Gits/EnsembleML/savedEnsembleModel.RDS"],"test":[{"Sepal.Length":5.1,"Sepal.Width":3.5,"Petal.Length":1.4,"Petal.Width":0.2,"Species":"setosa"}]}'
```

## Issues and Tracking
If you have any issues related to the project, please post an issue and I will try to address it. 




