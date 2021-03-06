 ##set working directory where you want out files to be saved
##ftp ghcnd FILE AND EXTRACTS ELEMENTS YOU REQUIRE AND FLAGS INTO COLLUMNS THEN you NEED TO MANUALLY MERGE INTO ON FILE
###change station id "USW00003820" as needed and var as needed see GHCNd read  file for details
###requires rnoaa package
###set {date_min} earliast date of data needed 

library("rnoaa")
PRCP_out<-ghcnd_search("USW00003820", var = "PRCP", date_min = "1800-01-01")
TMIN_out<-ghcnd_search("USW00003820", var = "TMIN", date_min = "1800-01-01")
TMAX_out<-ghcnd_search("USW00003820", var = "TMAX", date_min = "1800-01-01")
TAVG_out<-ghcnd_search("USW00003820", var = "TAVG", date_min = "1800-01-01")
SNOW_out<-ghcnd_search("USW00003820", var = "SNOW", date_min = "1800-01-01")
SNWD_out<-ghcnd_search("USW00003820", var = "SNWD", date_min = "1800-01-01")
write.csv(PRCP_out,"USW00003820_PRCP_out.csv")###write out csv file of inventory
write.csv(TMIN_out,"USW00003820_TMIN_out.csv")###write out csv file of inventory
write.csv(TMAX_out,"USW00003820_TMAX_out.csv")###write out csv file of inventory
write.csv(TAVG_out,"USW00003820_TAVG_out.csv")###write out csv file of inventory
write.csv(SNOW_out,"USW00003820_SNOW_out.csv")###write out csv file of inventory
write.csv(SNWD_out,"USW00003820_SNWD_out.csv")###write out csv file of inventory

###############################################################################