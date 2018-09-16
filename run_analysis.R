library(dplyr)

filename <- "dataset.zip"

# Download and unzip the dataset:
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(fileURL, filename, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

# Load activity labels and the features
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
activity_labels[,2] <- as.character(activity_labels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

# Extract only the measurements on mean and standard deviation
featuresSelected <- grep(".*mean.*|.*std.*", features[,2])
featuresSelected_names <- features[featuresSelected,2]
featuresSelected_names <- gsub('-mean', 'Mean', featuresSelected_names)
featuresSelected_names <- gsub('-std', 'Std', featuresSelected_names)
featuresSelected_names <- gsub('[-()]', '', featuresSelected_names)


# Read the datasets
train <- read.table("UCI HAR Dataset/train/X_train.txt")[featuresSelected]
train_activities <- read.table("UCI HAR Dataset/train/Y_train.txt")
train_subjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(train_subjects, train_activities, train)

test <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresSelected]
test_activities <- read.table("UCI HAR Dataset/test/Y_test.txt")
test_subjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(test_subjects, test_activities, test)

# merge both the datasets and add labels
mergedData <- rbind(train, test)
colnames(mergedData) <- c("subject", "activity", featuresSelected_names)

# turn activities & subjects into factors
mergedData$activity <- factor(mergedData$activity, levels = activity_labels[,1], labels = activity_labels[,2])
mergedData$subject <- as.factor(mergedData$subject)

# creating a tidy data set with the average of each variable for each activity and each subject

mergedDataTibble <- tbl_df(mergedData)
mergedDataGroup <- group_by(mergedDataTibble,subject,activity)
mergedDataSummary <- summarise_all(mergedDataGroup,mean)

write.table(mergedDataSummary, "tidy.txt", row.names = FALSE, quote = FALSE)