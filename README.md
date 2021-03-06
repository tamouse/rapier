![rapier logo](http://rapier.trestletech.com/components/images/rapier-med.png)

# rapier

> WARNING: rapier is under active development and function names, parameter names, and behavior are all subject to change. So don't go crazy...

rapier allows you to create a REST API by merely decorating your existing R source code with special comments. Take a look at an example.

```r
# myfile.R

#' @get /mean
normalMean <- function(samples=10){
  data <- rnorm(samples)
  mean(data)
}

#' @post /sum
addTwo <- function(a, b){
  as.numeric(a) + as.numeric(b)
}
```

These comments allow rapier to make your R functions available as API endpoints. 

```r
> library(rapier)
> r <- rapier("myfile.R")  # Where 'myfile.R' is the location of the file shown above
> r$run(port=8000)
```

You can visit this URL using a browser or a terminal to run your R function and get the results. Here we're using `curl` via a Mac/Linux terminal.

```
$ curl "http://localhost:8000/mean"
 [-0.254]
$ curl "http://localhost:8000/mean?samples=10000"
 [-0.0038]
```  

As you might have guessed, the request's query string parameters are forwarded to the R function as arguments (as character strings).

```
$ curl --data "a=4&b=3" "http://localhost:8000/sum"
 [7]
```

## Installation

Currently rapier is not available on CRAN, so you'll need to install it from GitHub. The easiest way to do that is by using `devtools`.

```r
library(devtools)
install_github("trestletech/rapier")
library(rapier)
```
