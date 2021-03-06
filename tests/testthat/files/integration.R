
library(stringi)

#' @preempt auth
#' @use /
function(a=1){
  list(msg=paste0("Welcome to the root URL! a = ", a))
}

#' @filter auth
function(req, res){
  if (!stri_startswith_fixed(req$QUERY_STRING, "?user=")){
    # Don't continue
    res$status <- 401
    return(list(err="Not authorized"))
  }

  user <- substr(req$QUERY_STRING, 7, nchar(req$QUERY_STRING))
  req$username <- user

  forward()
}

#' @get /me
function(req, res){
  list(name=req$username)
}

#' @get /error
#' @preempt auth
function(req, res){
  stop("I throw an error!")
}
