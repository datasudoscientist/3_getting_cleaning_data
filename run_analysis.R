# libraries used
library(data.table)
library(dplyr)

# creates directory and downloads dataset to this location
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

# Unzip dataSet to /data directory
unzip(zipfile="./data/Dataset.zip",exdir="./data")

# metadata
features <- read.table("./data/UCI HAR Dataset/UCI HAR Dataset/features.txt")
activities <- read.table("./data/UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")

# replace features with valid variable names
feature_names <- make.names(features$V2)

# read in test data
subjects_test <- read.table("./data/UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")
features_test <- read.table("./data/UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")
activities_test <- read.table("./data/UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt")

# read in training data
subjects_train <- read.table("./data/UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")
features_train <- read.table("./data/UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")
activities_train <- read.table("./data/UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt")

# merge test & training data
activity_master <- rbind(activities_test,activities_train)
feature_master <- rbind(features_test, features_train)
subject_master <- rbind(subjects_test, subjects_train)

# assemble master table
df_master <- cbind(subject_master,activity_master,feature_master)
names(df_master) <- c("subject", "activity", feature_names)

# descriptive activity lables
df_master$activity[df_master$activity==1] <- "Walking"
df_master$activity[df_master$activity==2] <- "Walking Upstairs"
df_master$activity[df_master$activity==3] <- "Walking Downstairs"
df_master$activity[df_master$activity==4] <- "Sitting"
df_master$activity[df_master$activity==5] <- "Standing"
df_master$activity[df_master$activity==6] <- "Laying"
df_master$activity <- as.factor(df_master$activity)
df_master$subject <- as.factor(df_master$subject)

# remove duplicate columns/data
deduped_df <- df_master[,!duplicated(colnames(df_master))]

# select columns containing mean, std into new df
df_mean <- select(deduped_df, matches("mean"))
df_std <- select(deduped_df, matches("std"))
df_cols <- select(deduped_df, subject, activity)

# gather filtered dataframes
df_analysis <- cbind(df_cols, df_mean, df_std)

# add descriptive variable names
names(df_analysis)<-gsub("Acc", "Accelerometer", names(df_analysis))
names(df_analysis)<-gsub("Gyro", "Gyroscope", names(df_analysis))
names(df_analysis)<-gsub("BodyBody", "Body", names(df_analysis))
names(df_analysis)<-gsub("Mag", "Magnitude", names(df_analysis))
names(df_analysis)<-gsub("^t", "Time", names(df_analysis))
names(df_analysis)<-gsub("^f", "Frequency", names(df_analysis))
names(df_analysis)<-gsub("tBody", "TimeBody", names(df_analysis))
names(df_analysis)<-gsub("mean", "Mean", names(df_analysis), ignore.case = TRUE)
names(df_analysis)<-gsub("std", "STD", names(df_analysis), ignore.case = TRUE)
names(df_analysis)<-gsub("freq", "Frequency", names(df_analysis), ignore.case = TRUE)
names(df_analysis)<-gsub("angle", "Angle", names(df_analysis))
names(df_analysis)<-gsub("gravity", "Gravity", names(df_analysis))

# average of each variable for each activity and each subject
df_avgs <- aggregate(. ~subject + activity,df_analysis, FUN = mean)

# write tables to output file
write.table(df_analysis, "step_4_df.txt", row.name=FALSE)
write.table(df_avgs, "step_5_df.txt", row.name=FALSE)
