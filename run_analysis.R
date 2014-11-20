library(dplyr)

featuresURL <- "UCI HAR Dataset/features.txt"
activityLabelsURL <- "UCI HAR Dataset/activity_labels.txt"
    
XTrainURL <- "UCI HAR Dataset/train/X_train.txt"
yTrainURL <- "UCI HAR Dataset/train/y_train.txt"
subjectTrainURL <- "UCI HAR Dataset/train/subject_train.txt"

XTestURL <- "UCI HAR Dataset/test/X_test.txt"
yTestURL <- "UCI HAR Dataset/test/y_test.txt"
subjectTestURL <- "UCI HAR Dataset/test/subject_test.txt"

features <- read.table(featuresURL, header=FALSE)
activityLabels <- read.table(activityLabelsURL, header=FALSE)
XTrain <- read.table(XTrainURL, header=FALSE)
yTrain <- read.table(yTrainURL, header=FALSE)
subjectTrain <- read.table(subjectTrainURL, header=FALSE)

XTest <- read.table(XTestURL, header=FALSE)
yTest <- read.table(yTestURL, header=FALSE)
subjectTest <- read.table(subjectTestURL, header=FALSE)

names(XTrain) <- features[,2]
names(XTest) <- features[,2]
names(activityLabels) <- c("activity", "activityLabel")
names(yTrain) <- "activity"
names(yTest) <- "activity"
names(subjectTrain) <- "subject"
names(subjectTest) <- "subject"

XCombine <- rbind(XTrain, XTest)
yCombine <- rbind(yTrain, yTest)

XCombine <- XCombine[,c(grep("mean", names(XCombine)), grep("std", names(XCombine)))]

XyCombine <- cbind(yCombine, XCombine)
XyCombine$activity <- factor(XyCombine$activity)
levels(XyCombine$activity) <- activityLabels$activityLabel

subjectCombine <- rbind(subjectTrain, subjectTest)
XyCombine <- cbind(subjectCombine, XyCombine)

aggdata <-aggregate(XyCombine, by=list(subject=XyCombine$subject, activity=XyCombine$activity), FUN=mean)
aggdata <- aggdata[,c(-3,-4)]

write.table(aggdata, "getdata-009_result.txt")
