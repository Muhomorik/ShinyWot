
# Create WG API Url.
createUrlVehicleStats <- function(fields1, extra, account_id, in_garage,  server){
  
  pField <- paste(fields1, collapse = '%2C') # %2C - encoded comma: ','
  pExtra <- paste(extra, collapse = '%2C')  
  
  if(isTRUE(in_garage)){
    inGarage = 1
  } else {
    inGarage = 0
  }
  
  
  url.start = "https://api.worldoftanks."
  url.path = "/wot/tanks/stats/?application_id=demo&fields="
  
  
  url.extra <- "&extra="
  url.accountId <- "&account_id="
  url.inGarage <- "&in_garage="
  
  url <- paste0(
    url.start, 
    server, 
    url.path, 
    pField, 
    url.extra, pExtra,
    url.accountId, account_id, 
    url.inGarage, inGarage                   
    )

  url
}

# fileName.VehicleStats <- "VehiclesStats.csv"

# Load stats from WG API.
loadPlayerStats <- function(url){
  #message("Downloading vehicle stats from API...")

  # Correct url from web, just in case:
  # "https://api.worldoftanks.eu/wot/tanks/stats/?application_id=demo&fields=tank_id%2Crandom&extra=random&account_id=500362266&in_garage=1"
  
  response <- fromJSON(url, flatten = TRUE) # Flatten nested data frames
  
  if(response$status != "ok") {
    warning("Error reading Vehicle stats from Wargaming API.")
  }
  
  VehicleStats <- response$data[[1]] # Hopefully exists :D, fix it.

  # Fix df data types.
  VehicleStats$tank_id <- as.character(VehicleStats$tank_id)
  
  VehicleStats
}

