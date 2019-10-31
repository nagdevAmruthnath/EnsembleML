#' Extracts statistical features for a vector.
#' @param data A vector of length greater than 2
#' @return Returns a list of 22 statistical features for data
#' @examples
#' data = rnorm(50)
#' featureCreationTS(data)
#' @export

# extract time series features
featureCreationTS = function(data){
  # describe data
  tsData = data.frame(psych::describe(data)[,3:13]
                      , iqr = stats::IQR(data)
                      , nZero = length(which(data ==0))
                      , nUnique = length(unique(data))
                      , lowerBound = stats::quantile(data,0.25,na.rm=TRUE)-(1.5*stats::IQR(data))
                      , upperBound = stats::quantile(data,0.75,na.rm=TRUE)+(1.5*stats::IQR(data))
                      , data.frame(t(stats::quantile(data, c(.01,.05,.25,.5,.75,.95, .99),na.rm=TRUE)))
  )

  # change column names for your data
  colnames(tsData) = paste("TS", colnames(tsData), sep = "_")

  # return statistical features
  return(tsData)
}

