# Get Vehicle data from API.

library(jsonlite)

fileName.Tanks <- "TankopediaVehicles.csv"

CreateUrl_EncyclopediaVehicles <- function(server, application_id, 
                                           fields = NULL, 
                                           tank_id = NULL, 
                                           nation = NULL, 
                                           tier = NULL ){
  # Create URL to Encyclopedia/Vvehicles API:
  # Api: api.worldoftanks.eu/wot/encyclopedia/vehicles
  # 
  # Args:
  #   server: string, ru/eu.
  #   application_id: string, Application ID.
  #   fields: string, list. Response field. The fields are separated with commas.
  #   tank_id: string, list. Vehicle ID.
  #   nation: string, list. Nation.
  #   tier: string, list. Tier.
  #
  # Returns:
  #   Vehicle df with tanks tier, type, name and tank_id.  
  
  message(paste("CreateUrl_EncyclopediaVehicles: ", server))
  
  # Build url.
  url <- "https://api.worldoftanks."
  url <- paste0(url, server)
  url <- paste0(url, "/wot/encyclopedia/vehicles/?application_id=", application_id)

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
  # tank_id
  if(!is.null(tank_id)){
    cTankId <- paste(tank_id, collapse = '%2C')  
    url <- paste0(url, "&tank_id=", cTankId)
  }
  # nation
  if(!is.null(nation)){
    cNation <- paste(nation, collapse = '%2C')  
    url <- paste0(url, "&nation=", cNation)
  }
  # tier
  if(!is.null(tier)){
    cTier <- paste(tier, collapse = '%2C')  
    url <- paste0(url, "&tier=", cTier)
  }  
  
  url
}

LoadTankList <- function(application_id) {
  # Reads ALL Vehicles from TankodediaVehicles.csv.
  # Field: tank_id, name, tier, type.
  # Downloads data (all tanks) from WG api and saves if the file is missing.
  # Api: api.worldoftanks.eu/wot/encyclopedia/vehicles
  #
  # Args:
  #   application_id: string, Application ID.
  #
  # Returns:
  #   Vehicle df with tanks tier, type, name and tank_id.
  
  if (!file.exists(fileName.Tanks)) {
    message("Vehicle data is missing, downloading...")
    
    # TODO(Muhomorik): custom id for each server (can't use ru-id on eu). 
    urlAllTiers <- CreateUrl_EncyclopediaVehicles("eu", "demo", c("tier", "type", "tank_id", "name"))
    #urlAllTiers <- CreateUrl_EncyclopediaVehicles("ru", application_id, c("tier", "type", "tank_id", "name"))
        
    # Download list of available vehicles..
    # Parse json.
    Vehicles <- fromJSON(urlAllTiers, flatten = TRUE)
    
    if(Vehicles$status != "ok") {
      errText <- paste("Error reading Vehicle List from Wargaming API: ", 
                       Vehicles$error$message, ".", sep = " ")
      warning(errText)
    }
    
    # Convert array to df.
    Vehicles <- bind_rows(Vehicles$data)
    
    # save to file.
    write.table(Vehicles, fileName.Tanks, sep = ",", row.names = F)
  } else {
    message("Loading Vehicles from file...")
    
    # Read to global.
    Vehicles <-
      read.table(fileName.Tanks, sep = ",", header = T) #[c("tier","type","name","tank_id")]
  }
  
  # fix types.
  Vehicles$tier <- as.factor(Vehicles$tier)
  Vehicles$type <- as.factor(Vehicles$type)
  Vehicles$name <- as.factor(Vehicles$name)
  Vehicles$tank_id <- as.character(Vehicles$tank_id)
  
  Vehicles
}
