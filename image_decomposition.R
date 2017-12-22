###################################
############ LIBRARIES ############
###################################
library(raster)
library(colorspace)
library(dplyr)
library(jpeg)
library(magrittr)
library(png)
library(bmp)

setwd ("C:/Users/taman/Documents/Anniversary/")

##########################################################
################## DECOMPOSE FRAME #######################
##########################################################
#Read Image

frame = read.bmp("splice_frame.bmp")
### Reshape ###
x <- 1:nrow(frame)
y <- 1:ncol(frame)

frame_df <- expand.grid(x,y)
colnames(frame_df) = c("x","y")

#frame_df$frame = ifelse ( c(frame[,,1]) == 0 & c(frame[,,2]) == 0 & c(frame[,,3]) == 0,1, 0) 

frame_df$frame = ifelse ( c(frame)  == 0 , 1, 0 ) 

###########################################################
######################### PHOTOS  ########################
###########################################################
img = readJPEG ("photo.jpg")

x <- 1:nrow(img)
y <- 1:ncol(img)

img_df <- expand.grid(x,y)
colnames(img_df) = c("x","y")

#Convert RGB channels to [0,255] scale from [0,1]
img_df$r = c(img[,,1])   * 255
img_df$g <- c(img[,,2]) * 255
img_df$b <- c(img[,,3]) *255

## Get frame flags location
img_df %<>% left_join (frame_df, by = c("x", "y") )


#Necessary Rounding for rounded color palette
img_df %<>% mutate_at ( .funs = function (x) 3*round(x/3) , .vars = c("r","g","b") ) 
img_df$hex <- rgb(img_df$r,img_df$g,img_df$b, maxColorValue=255)

#Load Hex Order
load("hex_position_lookup.rda")

img_df %<>% left_join (hex_df, by = "hex")

################################################
#################### Add Note ##################
################################################
#note = read.bmp("note.bmp")
### Reshape ###
#x <- 1:nrow(note)
#y <- 1:ncol(note)

#note_df <- expand.grid(x,y)
#colnames(note_df) = c("x","y")

#note_df$note = ifelse ( c(note[,,1]) == 0 & c(note[,,2]) == 0 & c(note[,,3]) == 0,1, 0) 

#img_df %<>% left_join (note_df, by = c("x","y"))
#img_df %<>% mutate (position = ifelse (note == 1, 42, position ))
#Change color oh photo

######################################
############## WRITE  ################
######################################
write.csv(frame_df, file = "photo_decomposed.csv")
save (img_df, file = "photo_decomposed.rda")