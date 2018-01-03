

#' dataone_download_urls
#' 
#' @inheritParams get_data
#' @examples 
#' dataone <- "https://doi.org/10.5063/f1bz63z8" # fails to resolve 
#' dryad <- "https://doi.org/10.5061/dryad.2k462"
#' urls <- dataone_download_urls(dataone)  # No URLS
#' urls <- dataone_download_urls(dryad)  # gives urls, but 500 errors from Dryad on attempting download
#' 
dataone_download_urls <- function(doi){
  ## NOTE: this whole function could just use the 'dataone' R package,
  ## but that introduces some heavy dependencies when downloading a file
  ## should be possible with base methods, or at least with httr alone
  raw_doi <- gsub("https?://(dx\\.)?doi.org/(.*)", "\\2", doi)
  
  ## See if DOI is in DataONE
  query <- paste0("http://cn.dataone.org/cn/v2/query/solr/?q=id:", 
         "*", raw_doi, "*&wt=json")
  resp <- httr::GET(query)
  json <- httr::content(resp)
  n <- json$response$numFound
  if(n == 0){
    ## no results found, probably try next protocol
    return(NULL)
    
  }
  
  dataUrl <- vapply(json$response$docs, 
                    `[[`,  character(1),
                    "dataUrl")
  formatId <- vapply(json$response$docs, 
                     `[[`,  character(1),
                     "formatId")
  
  ## Drop resource maps and various other types that are not data(??)
  drop <- (grepl(foreign_types, formatId) | grepl("^https?://.*", formatId))
  download_urls <- dataUrl[!drop]

  ## We should also get sensible names for the download files, but I can't figure out where
  download_urls
}
foreign_types <- "application/octet-stream"  






  
