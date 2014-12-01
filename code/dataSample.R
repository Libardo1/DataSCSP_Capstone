#load the required packages,rm,RWeka y data.table.
suppressPackageStartupMessages(library("stringi"))
suppressPackageStartupMessages(library("RWeka"))
suppressPackageStartupMessages(library("qdap"))
load("./cache/clean_data.RData")
mydata.corpus <- tm_map(mydata.corpus, content_transformer(function(x) stri_trans_tolower(x)))
mydata.corpus <- tm_map(mydata.corpus, content_transformer(function(x) stri_trans_general(x, "en_US")))
#convert corpus to a list document
aslines <- as.list(c(mydata.corpus[[1]]$content,mydata.corpus[[2]]$content,mydata.corpus[[3]]$content))
#convert to matrix with 1 column only
data_table <- matrix(unlist(aslines), ncol = 1, byrow = TRUE)
#remove lines that has less than 3 words
clean_data <- matrix(data_table[wc(data_table)>=2])
save(clean_data, file="./cache/clean_data2.RData")
rm(data_table,aslines,mydata.corpus)
set.seed(100)
# configure the sampling rate of the lines of text we have available
Perc<-0.15
IDPerc<-sample(1:length(clean_data),round(length(clean_data)*Perc))
SClean<-clean_data[IDPerc]
# Saved clean and sampled data processed
save(SClean, file="./cache/SClean.RData")
