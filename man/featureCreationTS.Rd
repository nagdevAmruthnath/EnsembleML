% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/featureCreationTS.R
\name{featureCreationTS}
\alias{featureCreationTS}
\title{Extracts statistical features for a vector.}
\usage{
featureCreationTS(data)
}
\arguments{
\item{data}{A vector of length greater than 2}
}
\value{
Returns a list of 22 statistical features for data
}
\description{
Extracts statistical features for a vector.
}
\examples{
data = rnorm(50)
featureCreationTS(data)
}
