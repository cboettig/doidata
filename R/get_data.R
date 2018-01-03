## NOT WORKING YET


#' get_data
#' 
#' @inheritParams cite_data
#' 
get_data <- function(doi){
  ## Download zenodo; stupid method
  if(grepl("zenodo", doi)){
    
    #https://zenodo.org/record/1048320/files/ropensci/codemetar-0.1.2.zip
  }
  
  ## Download figshare
  
  ## download DataONE (Dryad, KNB, many others)
  download_urls <- dataone_download_urls(doi)
  
  ## return download_urls
  download_urls
}  

## Some example DOIs
#' dataone <- "https://doi.org/10.5063/f1bz63z8"
#' dryad <- "https://doi.org/10.5061/dryad.2k462"
#' zenodo <- "https://doi.org/10.5281/zenodo.1048319"
#' figshare <- "https://doi.org/10.6084/m9.figshare.4490588.v1"
#'