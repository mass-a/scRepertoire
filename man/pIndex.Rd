% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/startrac.R
\name{pIndex}
\alias{pIndex}
\alias{Startrac.pIndex}
\alias{pIndex,Startrac-method}
\title{Calculate pairwise indices}
\usage{
Startrac.pIndex(object, cores, n.perm)

\S4method{pIndex}{Startrac}(object, cores = NULL, n.perm = NULL)
}
\arguments{
\item{object}{A Startrac object}

\item{cores}{number of core to be used. Passed to doParallel registerDoParallel. default: NULL.}

\item{n.perm}{integer number of permutation will be performed. If NULL, no permutation. (default: NULL)}
}
\value{
an object of class \code{Startrac}
}
\description{
Calculate pairwise indices
}
\keyword{internal}
