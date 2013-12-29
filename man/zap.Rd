\name{zap}
\alias{zap}
\title{simple color extraction in a loop, invoking locator aka \code{\link{click}}.}
\usage{
zap(path = system.file(package = "colorZapper", "sample"), N = 3)
}
\arguments{
  \item{string}{directory containing images}

  \item{N}{number of points per image to extract}
}
\value{
\code{data.frame} containing the file path and the RGB
}
\description{
simple color extraction in a loop, invoking locator aka
\code{\link{click}}.
}
\examples{
\dontrun{
zap()


}
}

