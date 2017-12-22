library(dplyr)
library(magrittr)

setwd ("C:/Users/taman/Documents/Anniversary/")


################################################
##################### Poem 1 ###################
##### Aedh Wishes for the CLoths of Heaven #####
########## By : W. B. Yeats ####################
################################################

poem1 = "Had I the heavens' embroidered cloths,   
Enwrought with golden and silver light,   
The blue and the dim and the dark cloths   
Of night and light and the half light,   
I would spread the cloths under your feet:
But I, being poor, have only my dreams;   
I have spread my dreams under your feet;   
Tread softly because you tread on my dreams." %>%
     
     charToRaw() %>% 
          rawToBits() %>% 
               as.character

################################################
##################### Poem 2###################
############# Counting the Beats ###############
########## By :: Robert Graves #################
################################################
poem2 = "You, love, and I,
(He whispers) you and I,
And if no more than only you and I,
What care you or I? 
Counting the beats,
Couting the slow heart beats,
The bleeding to death of time in slow heart beats,
Wakeful they lie. 
Cloudless day,
Night, and a cloudless day,
Yet the huge storm will burst upon their heads one day
From a bitter sky. 
Where shall we be,
(She whispers) where shall we be,
When death strikes home, O where then shall we be
Who were you and I? 
Not there but here,
(He whispers) only here,
As we are, here, together, now and here,
Always you and I. 
Counting the beats,
Counting the slow heart beats,
The bleeding to death of time in slow heart beats,
Wakeful they lie."  %>%
     
     charToRaw() %>% 
     rawToBits() %>% 
     as.character


################################################
##################### Poem 3 ###################
##### She Tells Her Love While Half Asleep #####
########## By :: Robert Graves #################
################################################
poem3 = "She tells her love while half asleep, 
In the dark hours, 
With half-words whispered low: 
As Earth stirs in her winter sleep 
And puts out grass and flowers 
Despite the snow, 
Despite the falling snow. "  %>%
     
     charToRaw() %>% 
     rawToBits() %>% 
     as.character

###########################################################
###################### CONSOLIDATE ######################## 
###########################################################
poem = c (poem1, poem2, poem3)

poem_bits = NULL

for (i in 1:length(poem)) {
     
     
     poem_bits =   c (  poem_bits,
                            substring ( poem[i] ,1,1) ,
                            substring ( poem[i] ,2,2) )
     
}

######################################################
############## ENCODE IN IMAGE #######################
######################################################
load ("photo_decomposed.rda")

img_df %<>% mutate ( sparse_y = ifelse( frame == 0 |  y%%10 ==0  ,y, NA ) ,
                     sparse_x = ifelse( frame == 0  , x , 
                                ifelse (sparse_y%%20==0 & x%%15==0, x,
                                ifelse (x%%10 == 0 , x, NA))) )

##
snip = img_df %>% filter (!is.na(sparse_x) & !is.na(sparse_y))

##
rep = nrow (snip) %/% length(poem_bits) 
remainder = nrow (snip) %% length(poem_bits)

poem_rep=NULL

for (i in 1:rep) {
poem_rep =c (poem_rep,poem_bits)
}

poem_chunk = poem_bits[1:remainder]

poem_rep = c(poem_rep, poem_chunk)

## Join to Image
snip$poem = poem_rep
snip %<>% dplyr::select (x,y,poem)

img_df %<>% left_join(snip, by =c("x","y"))


## Save
write.csv(img_df, file = "photo_decomposed.csv")
