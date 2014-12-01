#load the required packages,rm,RWeka y data.table.
suppressPackageStartupMessages(library("tm"))
suppressPackageStartupMessages(library("RWeka"))
suppressPackageStartupMessages(library("data.table"))
#load the clean text and already processed
load("./cache/SClean.RData")

# generate three functions needed to calculate an n-gram model directly using data.tables
except_last_word <- function (phrase) {
  words <- split_on_space (phrase)
  paste (words [1:length (words)-1], collapse = " ")
}

split_on_space <- function (x) {
  result <- unlist (strsplit (x, split = "[ ]+"))
  result [nchar (result) > 0]
}

last_word <- function (phrase) {
  words <- split_on_space (phrase)
  words [length (words)]
}
# generate a function that calculates n-grams according to a number of input parameters

create_ngram <- function (sentences, n) {
  stopifnot (is.character (sentences))
  stopifnot (length (sentences) > 0)
  # split the sentences into n-grams
  token <- function(x) RWeka::NGramTokenizer(x, RWeka::Weka_control(min = n,max = n,delimiters = ' \r\n\t.,;:\\"()?!'))
  ngrams <- data.table (phrase = unlist (lapply (sentences, token)))
  # remove duplicate ngrams and count the number of each
  ngrams <- ngrams [, list (phrase_count = .N), by = phrase]
  ngrams [, n := n]
  # extract the context and the next word for each ngram
  ngrams [, `:=` (
    context = except_last_word (phrase),
    word    = last_word (phrase)
  ), by = phrase]
  setcolorder (ngrams, c("phrase", "context", "word", "n", "phrase_count"))
  return (ngrams)
}

#perform the calculation of each n-gram of 2-5 grams

Bigram<-create_ngram(SClean,2)
save(Bigram, file="./cache/2gram.RData")
rm(Bigram)
#############
Trigram<-create_ngram(SClean,3)
save(Trigram, file="./cache/3gram.RData")
rm(Trigram)
#############
Quagram<-create_ngram(SClean,4)
save(Quagram, file="./cache/4gram.RData")
rm(Quagram)
############
Quingram<-create_ngram(SClean,5)
save(Quingram, file="./cache/5gram.RData")
rm(Quingram)

rm(list = ls())