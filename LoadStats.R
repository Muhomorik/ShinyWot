# Get vehicle stats by account_id

CreateUrlVehicleStats <- function(server, application_id, 
                                  fields = NULL, 
                                  extra = NULL, 
                                  account_id = NULL, 
                                  in_garage = NULL){
  # Create URL to Encyclopedia/Vvehicles API:
  # Api: api.worldoftanks.eu/wot/tanks/stats
  # 
  # Args:
  #   server: string, ru/eu.
  #   application_id: string, Application ID.
  #   fields: string, list. Response field. The fields are separated with commas.
  #   tank_id: string, list. Vehicle ID.
  #   nation: string, list. Nation.
  #   tier: string, list. Tier.
  #   server: string, ru/eu.
  #
  # Returns:
  #   URL with rquested parameters.  
  
  message(paste("Creating api uri for server: ", server, 
                ", accoun_id: ", account_id,
                ", inGarage: ", in_garage, "."))

  # Build url.
  url <- "https://api.worldoftanks."
  url <- paste0(url, server)
  url <- paste0(url, "/wot/tanks/stats/?application_id=", application_id)

  # Warning for demo id.
  if(application_id == "demo"){
    message("CreateUrlVehicleStats - demo id")    
  }

  # %2C - encoded comma: ','  
  
  # fields
  if(!is.null(fields)){
    cField <- paste(fields, collapse = '%2C')    
    url <- paste0(url, "&fields=", cField)
  }
  # extra
  if(!is.null(extra)){
    pExtra <- paste(extra, collapse = '%2C')     
    url <- paste0(url, "&extra=", pExtra)
  }  
  # account_id
  if(!is.null(account_id)){
    url <- paste0(url, "&account_id=", account_id)
  } else {
    warning("CreateUrlVehicleStats: account_id is null")    
  }  
  # in_garage
  if(!is.null(in_garage)){
    # Must fix T/F to 1/0 taken by API.
    if(isTRUE(in_garage)){
      inGarage = 1
    } else {
      inGarage = 0
    }    
    
    url <- paste0(url, "&in_garage=", inGarage)
  }  

  # "https://api.worldoftanks.eu/wot/tanks/stats/?application_id=demo&fields=tank_id%2Crandom&extra=random&account_id=500362266&in_garage=1"
  url
}

# fileName.VehicleStats <- "VehiclesStats.csv"

LoadPlayerStats <- function(url){
  # Get vehicle statistacs for player from url API:
  # Api: api.worldoftanks.eu/wot/tanks/stats
  # 
  # Args:
  #   url: REST api string to call.
  #
  # Returns:
  #   Vehicle df with tanks tier, type, name and tank_id.  
  
  message("Downloading vehicle stats from API...")

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

