# generate a function for cleaning phrases

clean<-function(text){
  #load the required packages,rm,RWeka y data.table.
  suppressPackageStartupMessages(library("tm"))
  suppressPackageStartupMessages(library("stringi"))
  suppressPackageStartupMessages(library("RWeka"))
  suppressPackageStartupMessages(library("qdap"))
  mydata.corpus<-Corpus(VectorSource(text))
  mydata.corpus<-tm_map(mydata.corpus,content_transformer(function(x) iconv(x, to='ASCII', sub=' ')))
  # Change text to lowercase
  mydata.corpus<-tm_map(mydata.corpus,content_transformer(tolower))
  # Eliminate numbers
  mydata.corpus <- tm_map(mydata.corpus, content_transformer(removeNumbers))
  # Remove punctuation marks
  mydata.corpus <- tm_map(mydata.corpus, content_transformer(removePunctuation))
  bad <- rbind(read.table("./data/bad.csv", quote="\""),data.frame(V1=cbind(stopwords("english"))))
  mydata.corpus <- tm_map(mydata.corpus, removeWords, bad) 
  #spaces are removed extra blank
  mydata.corpus <- tm_map(mydata.corpus, content_transformer(stripWhitespace))
  mydata.corpus <- tm_map(mydata.corpus, PlainTextDocument)
  mydata.corpus <- tm_map(mydata.corpus, content_transformer(function(x) stri_trans_tolower(x)))
  mydata.corpus <- tm_map(mydata.corpus, content_transformer(function(x) stri_trans_general(x, "en_US")))
  text2<-unlist(mydata.corpus[[1]]$content)
  return(text2)
}
