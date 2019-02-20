library(dplyr)

filename <- "project.zip"
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

#Download file
if(!file.exists("project.zip")){
    download.file(fileURL, filename, method="curl")
}

#Unzip file
if(!file.exists("UCI HAR Dataset")){
    unzip(filename)
}

#Read train tables
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
trainActivities <- read.table("UCI HAR Dataset/train/y_train.txt")
trainData <- read.table("UCI HAR Dataset/train/X_train.txt")

#Read test tables
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
testActivities <- read.table("UCI HAR Dataset/test/y_test.txt")
testData <- read.table("UCI HAR Dataset/test/X_test.txt")

#Read features.txt
features <- read.table("UCI HAR Dataset/features.txt")

#Read activity labels
activities <- read.table("UCI HAR Dataset/activity_labels.txt")

#Assign column names
colnames(trainSubjects) <- "subject"
colnames(trainActivities) <- "activity"
colnames(trainData) <- features$V2

colnames(testSubjects) <- "subject"
colnames(testActivities) <- "activity"
colnames(testData) <- features$V2

colnames(activities) <- c("activityID", "activity")

#Merge tables
train <- cbind(trainSubjects, trainActivities, trainData)
test <- cbind(testSubjects, testActivities, testData)

#Merge train and test data
all <- rbind(train, test)

#Extract mean and standard deviation measurements
mean_std <- all[,grep(".*mean\\().*|.*std.*|^subject$|^activity$", names(all))]

#Add descriptive activity labels
mean_std$activity <- as.factor(mean_std$activity)
levels(mean_std$activity) <- c("walking", "walking_upstairs", "walking_downstairs", 
                               "sitting", "standing", "laying")

#Use regular expressions to rename columns
colnames(mean_std) <- sub("BodyBody", "Body", colnames(mean_std))
colnames(mean_std) <- sub("\\()", "", colnames(mean_std))
colnames(mean_std) <- gsub("-", "_", colnames(mean_std))
colnames(mean_std) <- sub("^t", "time", colnames(mean_std))
colnames(mean_std) <- sub("^f", "freq", colnames(mean_std))

#Create independent tidy data set with average of each variable for each activity
#and subject
final <- mean_std %>% group_by(subject, activity) %>%
            summarize_all(mean)

#Write new data set to file
write.table(final, "final.txt", col.names=TRUE, sep=" ", row.names = FALSE)
