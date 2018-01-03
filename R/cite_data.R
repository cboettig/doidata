#' cite_data
#' 
#' @param doi a doi (fully resolvable, i.e. include the https://doi.org/)
#' @return a bibentry R object
#' @importFrom httr add_headers GET content
#' @importFrom utils person bibentry
#' @export
#' 
#' @examples 
#' cite_data("https://doi.org/10.5061/dryad.2k462")
#' 
cite_data <- function(doi){
  header <- httr::add_headers(Accept="application/vnd.schemaorg.ld+json")
  resp <- httr::GET(doi, header)
  meta <- httr::content(resp, type = "application/json")
  authors <- 
    do.call(c, lapply(meta$author, 
                      function(author) 
                        person(given = author$given, 
                               family = author$family, 
                               email = author$email,
                               role = "aut")))
  year <- meta$datePublished
  if(is.null(year)) 
    year <- format(Sys.Date(), "%Y")
  bibitem <- 
    bibentry(
      bibtype = "Manual",
      title = meta$name,
      author = authors,
      year = year,
      note = paste0("R package version ", meta$version),
      publisher = meta$publisher$name,
      url = meta$url,
      doi = meta$`@id`,
      key = meta$identifier
    )
  bibitem
}