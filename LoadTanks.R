# Filename
library(jsonlite)

fileName.Tanks <- "TankopediaVehicles.csv"

# Loar Vehicls from WG API if mission or get from file.
loadTankList <- function() {
  
  if (!file.exists(fileName.Tanks)) {
    #message("Vehicle data is missing, downloading...")
    
    # Download list of available vehicles..
    url.Vehicles_AllTiers <-
      "https://api.worldoftanks.eu/wot/encyclopedia/vehicles/?application_id=demo&fields=tier%2Ctype%2C%20tank_id%2Cname"
    url.VehiclesTier678 <-
      "https://api.worldoftanks.eu/wot/encyclopedia/vehicles/?application_id=demo&fields=tier%2Ctype%2C%20tank_id&tier=6%2C7%2C8"
    
    # Parse json.
    Vehicles <- fromJSON(url.Vehicles_AllTiers)
    
    if(Vehicles$status != "ok") {
      warning("Error reading Vehicle List from Wargaming API.")
    }
    
    # Convert array to df.
    Vehicles <- bind_rows(Vehicles$data) #dplyr TODO: use fromJSON flatten = TRUE
    
    Vehicles$tank_id <- as.character(Vehicles$tank_id)
    Vehicles$tier <- as.factor(Vehicles$tier)
    Vehicles$type <- as.factor(Vehicles$type)
    
    # save to file.
    write.table(Vehicles, fileName.Tanks, sep = ",")
  } else {
    #message("Loading Vehicles from file...")
    
    # Read to global.
    Vehicles <-
      read.table(fileName.Tanks, sep = ",")[c("tier","type","name","tank_id")]
    
    # fix types.
    Vehicles$tier <- as.factor(Vehicles$tier)
    Vehicles$type <- as.factor(Vehicles$type)
    Vehicles$name <- as.factor(Vehicles$name)
    Vehicles$tank_id <- as.character(Vehicles$tank_id)
    
    Vehicles
  }
}
