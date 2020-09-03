library(readxl)
review <- read_excel("Desktop/review.xlsx")                                                                                               
View(review)
library(qdap)
library(dplyr)
library(tm)
library(wordcloud)
library(plotrix)
library(dendextend)
library(ggplot2)
library(ggthemes)
library(RWeka)
library(reshape2)
library(quanteda)
review = Corpus(VectorSource(review$Review))
review = tm_map(review, tolower)
review = tm_map(review, removePunctuation)
review = tm_map(review, removeWords, stopwords("english"))
review = tm_map(review, removeWords, c("i", "it", "can", "im", "just", "its", "was", "were", "also", "lot", "youre", "'s", "able", "as","always","one","get","take","day"))
review = tm_map(review, stemDocument)
term_count <- freq_terms(review, 30)
plot(term_count)
review_dtm <- DocumentTermMatrix(review)
review_tdm <- TermDocumentMatrix(review)
review_m <- as.matrix(review_tdm)
review_term_freq <- rowSums(review_m)
review_term_freq <- sort(review_term_freq, decreasing = T)
review_term_freq[1:50]
barplot(review_term_freq[1:50], col = "steel blue", las = 2)
review_word_freq <- data.frame(term = names(review_term_freq), num = review_term_freq)
wordcloud(review_word_freq$term, review_word_freq$num, max.words = 50, colors = c("aquamarine","darkgoldenrod","tomato"))
library(sentimentr)
sentiment = sentiment_by(review$content)
summary(sentiment$ave_sentiment) 
library(ggplot2)
qplot(sentiment$ave_sentiment, geom="histogram",binwidth=0.1,main="Review Sentiment Histogram",fill="pink")
library(stminsights)
library(topicmodels)
library(caret)
library(readtext)
mycorpus <- corpus(review)
docvars(mycorpus, "Textno") <- sprintf("%02d", 1:ndoc(mycorpus))
mycorpus.stats <- summary(mycorpus)
head(mycorpus.stats, n = 10)
token <-
     tokens(
         mycorpus,
         remove_numbers = TRUE,
         remove_punct = TRUE,
         remove_symbols = TRUE,
         what = "word“,
         remove_url = TRUE,
         split_hyphens,
         include_docvars = TRUE
     )
token_ungd <- tokens_select(
     token,
     c("[\\d-]", "[[:punct:]]", "^.{1,2}$"),
     selection = "remove",
     valuetype = "regex",
     verbose = TRUE)
mydfm <- dfm(token_ungd,
              tolower = TRUE,
              stem = TRUE,
              remove = stopwords("english"))
mydfm.trim <-
     dfm_trim(
         mydfm,
         min_docfreq = 0.075,
         max_docfreq = 0.90,
         docfreq_type = "prop")
head(dfm_sort(mydfm.trim, decreasing = TRUE, margin = "both"),
      n = 10,
      nf = 10) 
topic.count <- 10
library(stm)
dfm2stm <- convert(mydfm.trim, to = "stm")
model.stm <- stm(
     dfm2stm$documents,
     dfm2stm$vocab,
     K = topic.count,
     data = dfm2stm$meta,
     init.type = "Spectral")
plot(
     model.stm,
     type = "summary",
     text.cex = 0.5,
     main = "STM topic shares",
     xlab = "Share estimation")
model.stm.corr <- topicCorr(model.stm)
plot.topicCorr(model.stm.corr, method = "huge")
plot(model.stm,
      type = "perspectives",
      topics = c(1, 2),
      main = "Putting two different topics in perspective")
plot(model.stm,
      type = "perspectives",
      topics = c(3, 4),
      main = "Putting two different topics in perspective")
plot(model.stm,
      type = "perspectives",
      topics = c(5, 6),
      main = "Putting two different topics in perspective")
plot(model.stm,
      type = "perspectives",
      topics = c(7, 8),
      main = "Putting two different topics in perspective")
plot(model.stm,
      type = "perspectives",
      topics = c(9, 10),
      main = "Putting two different topics in perspective")
