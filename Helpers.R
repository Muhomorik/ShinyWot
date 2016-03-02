library(dplyr)

filterDf <- function(df, tierMin, tierMax){
  # Helper that calculates new rows and filters df based on tier. Filters based
  # on distribution as well.
  # 
  # Args:
  #   df: merged df to filter/add rows.
  #   tierMin: min tier
  #   tierMax: max tier
  #
  # Returns:
  #   Filtered data.frame.
  
  df <- df %>%
    mutate(winRate = round(df$random.wins/df$random.battles*100, 2)) %>%  
    mutate(avg.Spotted = round(df$random.spotted/df$random.battles, 2)) %>% 
    mutate(avg.Hits = round(df$random.hits/df$random.battles*100, 2)) %>% 
    mutate(avg.CapturePoints = round(df$random.capture_points/df$random.battles, 2)) %>%   
    
    mutate(avg.DamageDealt = round(df$random.damage_dealt/df$random.battles, 2)) %>%
    mutate(avg.DamageRecvt = round(df$random.damage_received/df$random.battles, 2)) %>%  
    
    mutate(avg.Frags = round(df$random.frags/df$random.battles, 2)) %>%
    mutate(avg.SurvivedBattles = round(df$random.survived_battles/df$random.battles*100, 2)) %>% 
    mutate(avg.DroppedCapPoints = round(df$random.dropped_capture_points/df$random.battles, 2)) #%>% 
  
  
  winRate.sd = sd(df$winRate, na.rm = TRUE)
  winRate.mean = mean(df$winRate, na.rm = TRUE)    
  
  # https://en.wikipedia.org/wiki/Standard_deviation
  # 1.644 - 90%%
  # 2 - 95.449%
  sigma = 2 # 80% 	
  mu_max = winRate.mean +sigma*winRate.sd
  mu_min = winRate.mean -sigma*winRate.sd
  
  # small valus
  df <- df %>%
    filter(winRate<= mu_max, winRate >= mu_min) %>%
    filter(tier %in% seq(tierMin, tierMax, 1))
  
  df
}
