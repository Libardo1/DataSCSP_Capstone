
source('./code/cleantext.R')
suppressPackageStartupMessages(library("data.table"))
suppressPackageStartupMessages(library("RJSONIO"))

Bigram <- readRDS("./cache/Bigram.rds")
Trigram <- readRDS("./cache/Trigram.rds")
Quagram <- readRDS("./cache/Quagram.rds")
Quingram <- readRDS("./cache/Quingram.rds")

pred<-function(frase){
  prev <- unlist (strsplit (frase, split = " ", fixed = TRUE))
  len<-length(prev)
  fra2 <- paste(tail (prev, 1), collapse = " ")
  fra3 <- paste(tail (prev, 2), collapse = " ")
  fra4 <- paste(tail (prev, 3), collapse = " ")
  fra5 <- paste(tail (prev, 3), collapse = " ")
  
  predict<-NULL
  try(pred5 <- Quingram [context == fra5, .SD [which.max (p), word]])
  try(pred4 <- Quagram [context == fra4, .SD [which.max (p), word]])
  try(pred3 <- Trigram [context == fra3, .SD [which.max (p), word]])
  try(pred2 <- Bigram [context == fra2, .SD [which.max (p), word]])
  if(length(head(pred5))==0){  
    if(length(head(pred4))==0){  
      if(length(head(pred3))==0){    
        if(length(head(pred2))!=0){predict<-pred2
        }else{
          predict<-"Next word, not predicted, out of vocabulary sequence"
        }
      }else{predict<-pred3}
    }else{predict<-pred4}
  }else{predict<-pred5}
  return(predict)
}

frase<-clean("Hey sunshine, can you follow me and make me the")
prediction <- pred(frase) 

cat("Next Word Prediction:", prediction)