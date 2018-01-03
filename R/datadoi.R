#' knb <- "https://doi.org/10.5063/f1bz63z8"
#' dryad <- "https://doi.org/10.5061/dryad.2k462"
#' zenodo <- "https://doi.org/10.5281/zenodo.1048319"
#' figshare <- 
#' 
get_data <- function(doi){
  ## Work with raw dois
  raw_doi <- gsub("https?://(dx\\.)?doi.org/(.*)", "\\2", doi)
  
  
  ## Download zenodo; stupid method
  if(grepl("zenodo", raw_doi)){
    
    #https://zenodo.org/record/1048320/files/ropensci/codemetar-0.1.2.zip
  }
    
  ## Download figshare
  
  ## See if DOI is in DataONE
  query <- paste0("http://cn.dataone.org/cn/v2/query/solr/?q=id:", 
         "*", raw_doi, "*")
  resp <- httr::GET(query)
  xml <- httr::content(resp)
  n <- as.integer(xml2::xml_attr(xml2::xml_find_first(xml, "//result"), "numFound"))
  if(n > 0)
    download_urls <- xml2::xml_text( xml2::xml_find_all(xml, "//str[@name='dataUrl']") )
  
  #FIXME download and name files?
  download_urls
}

  
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