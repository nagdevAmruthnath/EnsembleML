#' Transforms to freqency using FFT and extracts statistical features
#' @param data A vector of length greater than 2
#' @return Returns a list of 22 statistical features for data
#' @examples
#' data = rnorm(50)
#' featureCreationF(data)
#' @export

# extract frequency features
featureCreationF = function(data){
  # do fast fourier transforms
  b1.x.fft = stats::fft(data)
  amplitude = Mod(b1.x.fft[1:(length(b1.x.fft)/2)])
  fData = data.frame(data.frame(psych::describe(amplitude))[,3:13]
                     , iqr = stats::IQR(amplitude)
                     , nZero = length(which(amplitude ==0))
                     , nUnique = length(unique(amplitude))
                     , lowerBound = stats::quantile(amplitude,0.25,na.rm=TRUE)-(1.5*stats::IQR(amplitude))
                     , upperBound = stats::quantile(amplitude,0.75,na.rm=TRUE)+(1.5*stats::IQR(amplitude))
                     , data.frame(t(stats::quantile(amplitude, c(.01,.05,.25,.5,.75,.95, .99),na.rm=TRUE)))
  )

  # change column names
  colnames(fData) = paste("F", colnames(fData), sep = "_")

  # return frequency features
  return(fData)
}



