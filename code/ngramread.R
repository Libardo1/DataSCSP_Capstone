#load the required packages,rm,RWeka y data.table.
suppressPackageStartupMessages(library("tm"))
suppressPackageStartupMessages(library("RWeka"))
suppressPackageStartupMessages(library("data.table"))

#read the appropriate files to the n-grams generated above

load("./cache/2gram.RData")
load("./cache/3gram.RData")
load("./cache/4gram.RData")
load("./cache/5gram.RData")

# generate a function to calculate the probabilities associated with each n-gram
ngram_probabilities <- function (ngrams) {  
  # create a data set that contains the number of times each context occurs in the text
  context <- ngrams [, sum (phrase_count), by = context]
  setnames (context, c("context", "context_count"))
  setkeyv (context, "context")
  setkeyv (ngrams, "context")
  ngrams [context, context_count := context_count, allow.cartesian=TRUE]
  # calculate the maximum likelihood estimate 
  ngrams [, p := phrase_count / context_count ]
  # storing log (p) makes calculating phrase probability easy
  ngrams [, logp := log (p) ]
  return (ngrams)
}

# calculate the probabilities associated with each n-gram
Bigram<-ngram_probabilities(Bigram)
Trigram<-ngram_probabilities(Trigram)
Quagram<-ngram_probabilities(Quagram)
Quingram<-ngram_probabilities(Quingram)

#select the n-grams found more than once in the text

Qui<-subset(Quingram,phrase_count>1)
Qua<-subset(Quagram,phrase_count>1)
Tri<-subset(Trigram,phrase_count>1)
Bi<-subset(Bigram,phrase_count>1)

# our data saved in files .rds
saveRDS(Qui, "./cache/Quingram.rds")
saveRDS(Qua, "./cache/Quagram.rds")
saveRDS(Tri, "./cache/Trigram.rds")
saveRDS(Bi, "./cache/Bigram.rds")
