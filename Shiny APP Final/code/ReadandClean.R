# we set the working folder
setwd("C:/Users/Camilo/Desktop/Proyecto Final")
# load the package tm
library("tm")
# create the corpus
mydata.corpus <- Corpus(DirSource("./data/en_US",encoding = "utf-8"), readerControl = list(language="en_US"))
# Fix problems they had with the initial coding with the following line
# remove special unicode value
mydata.corpus<-tm_map(mydata.corpus,content_transformer(function(x) iconv(x, to='ASCII', sub=' ')))
# Change text to lowercase
mydata.corpus<-tm_map(mydata.corpus,content_transformer(tolower))
# Eliminate numbers
mydata.corpus <- tm_map(mydata.corpus, content_transformer(removeNumbers))
# Remove punctuation marks
mydata.corpus <- tm_map(mydata.corpus, content_transformer(removePunctuation))
# clean unwanted words in the corpus
bad <- rbind(read.table("./data/bad.csv", quote="\""),data.frame(V1=cbind(stopwords("english"))),"the","of","a")
mydata.corpus <- tm_map(mydata.corpus, removeWords, bad) 
#spaces are removed extra blank
mydata.corpus <- tm_map(mydata.corpus, content_transformer(stripWhitespace))
mydata.corpus <- tm_map(mydata.corpus, PlainTextDocument)
#keep our body clean filter
save(mydata.corpus, file="./cache/clean_data.RData")