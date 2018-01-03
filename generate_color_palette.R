###################################
############ LIBRARIES ############
###################################

library(raster)
library(colorspace)
library(dplyr)

setwd ("C:/Users/taman/Documents/Anniversary/")

######################################
########### TAGS #####################
######################################
head = "<?xml version='1.0'?> 
          <workbook>
               <preferences>
                    <color-palette name=\"th_hex\" type = \"ordered-sequential\"> 
                              "

tail = "
     </color-palette>
          </preferences>
               </workbook>" 

#########################################
########## GENERATE PALETTE #############
#########################################

## Generate red, blue, green channels 
#(each binned by 3 to commemorate anniversary and also to limit size of palette while also covering entire spectrum)
r = seq(0,255,3 )
g = seq(0,256,3 )
b = seq(0,255,3 )

colors = expand.grid(r,g,b) 

#Get hex codes
hex = rgb(colors$Var1, colors$Var2, colors$Var3, maxColorValue=255)

#Create tags for hex codes
body = hex %>%
          paste0 ("<color>", ., "</color>") %>% 
          toString %>% gsub ("," ,"\n" ,.)


############################################
############ CREATE TPS FILE ###############
############################################

tps <- rbind (head, body, tail) %>%
               toString %>% gsub ("," ,"\n" ,.)

#Write text file
connection = file("Preferences.tps")
writeLines( tps, connection)
close(connection)

## REPLACE Preferences file in Tableay Respository with new one
file.rename(from = "C:/Users/taman/Documents/Anniversary/Preferences.tps",
               to = "C:/Users/taman/Documents/My Tableau Repository/Preferences.tps")

#############################################################################
#################### Position Look Up Table #################################
#############################################################################
 hex_df <- as.data.frame (hex)
 hex_df$position = 1:nrow(hex_df)

 save (hex_df, file = "hex_position_lookup.rda")
 
