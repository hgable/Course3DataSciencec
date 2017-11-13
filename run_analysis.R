##Load data into R

install.packages("readtext")
library(readtext)
get(wd)

setwd("C:/Users/hagable/Documents/Training/DataScience/test")

X_test <- readtext("X_test.txt")
View(X_test)
head(X_test)
X_test <- read.table("X_test.txt")
View("X_test.txt")

setwd("C:/Users/hagable/Documents/Training/DataScience/train")

X_train <- read.table("X_train.txt")

##Merge test and train data sets into one

alldata <- rbind(X_test, X_train)

##Extract and mean and SD for each measurement

setwd("C:/Users/hagable/Documents/Training/DataScience")

features <- read.table("features.txt")
names <- as.vector(features$V2)
colnames(alldata) <- names
View(alldata)

meanvalues<- grep("mean", names(alldata), value=TRUE)
stdvalues<- grep("std", names(alldata), value=TRUE)

allMean<- alldata[, c(meanvalues)] 
allStd<- alldata[, c(stdvalues)]
meanStd <- cbind(allMean, allStd)

##Name activities in the data set

setwd("C:/Users/hagable/Documents/Training/DataScience/test")

testLabels<- read.table("y_test.txt")
setwd("C:/Users/hagable/Documents/Training/DataScience/train")

trainLabels<- read.table("y_train.txt")

##Label the data set with descriptive variable names

setwd("C:/Users/hagable/Documents/Training/DataScience")
activityLabels<- read.table("activity_labels.txt")
allLabels <- rbind(testLabels, trainLabels)

labelledData <- cbind(allLabels, meanStd)
merged <- merge(activityLabels, labelledData, by="V1", all.y = TRUE)


names(merged)<-gsub("^t", "time", names(merged))
names(merged)<-gsub("^f", "frequency", names(merged))
names(merged)<-gsub("Acc", "Accelerometer", names(merged))
names(merged)<-gsub("Gyro", "Gyroscope", names(merged))
names(merged)<-gsub("Mag", "Magnitude", names(merged))
names(merged)<-gsub("BodyBody", "Body", names(merged))

names(merged)

## add subject to data set

setwd("C:/Users/hagable/Documents/Training/DataScience/train")

trainsub <- read.table("subject_train.txt")

setwd("C:/Users/hagable/Documents/Training/DataScience/test")

testsub <- read.table("subject_test.txt")
traintestsub <- rbind(testsub, trainsub)
names(traintestsub) <- c("subject")
merged2 <- cbind(traintestsub, merged) 

##Create independent tidy data set with the average of each variable

library(plyr)
library(dplyr)

install.packages("reshape2")
library(reshape2)


melted <- melt(merged2, id=c("subject","activity"))
tidy <- dcast(melted, subject+activity ~ variable, mean)
View(tidy)
View(merged2)

write.csv(tidy, "tidy.csv", row.names=FALSE)


