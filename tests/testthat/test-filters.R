make_req <- function(verb, path){
  req <- new.env()
  req$REQUEST_METHOD <- toupper(verb)
  req$PATH_INFO <- path
  req$rook.input <- list(read_lines = function(){ "" })
  req
}

test_that("Filters work", {
  r <- RapierRouter$new("files/filters.R")
  expect_equal(length(r$filters), 2+2) #2 for post and query string filters

  expect_equal(r$filters[[3]]$name, "something")
  expect_equal(r$filters[[4]]$name, "nospace")
})

test_that("Filters can update req$args", {
  r <- RapierRouter$new("files/filters.R")

  req <- make_req("GET", "/")
  res <- RapierResponse$new()
  expect_equal(r$serve(req, res)$body, jsonlite::toJSON(23))
})

test_that("Redundant filters fail", {
  expect_error(RapierRouter$new("files/filter-redundant.R"), regexp="Multiple @filters")
})

test_that("Empty filters fail", {
  expect_error(RapierRouter$new("files/filter-empty.R"), regexp="No @filter name specified")
})

test_that("Filter and path fails", {
  expect_error(RapierRouter$new("files/filterpath.R"), regexp="both a filter and an API endpoint")
})

test_that("Terminal filters indeed terminate", {
  res <- RapierResponse$new()
  r <- RapierRouter$new("files/terminal-filter.R")
  expect_equal(r$route(make_req("GET", "/"), res), 1)
})
