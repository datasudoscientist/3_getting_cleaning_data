---
title: "README"
author: "Sajid Qadri"
date: "June 13, 2016"
output: html_document
---

## run_analysis.R

This document is meant to help explain the R script run_analysis.R.

While the script is annotated to reflect the operations of the code, this document makes these operations more explicit.

First off, I want to make sure the necessary packages are installed and loaded. If either of these are missing you will need install and load them for the following code to work.

```
library(data.table)
library(dplyr)
```

With the necessary packages loaded, next I want to pull in the data from the provided url. The data will be saved in the directory "./data", and if this directory does not yet exist it will be created. Once downloaded the file is unzipped.

```
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")
unzip(zipfile="./data/Dataset.zip",exdir="./data")
```

The descriptions of variables and activity types are located in the files 'features.txt' and 'activity_labels.txt'. They are downloaded for use in naming columns later.

```
features <- read.table("./data/UCI HAR Dataset/UCI HAR Dataset/features.txt")
activities <- read.table("./data/UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")
```

Because there are rules governing proper variable names I decided on transforming these names using the function 'make.names'.

```
feature_names <- make.names(features$V2)
```

The data contains test data and training data, each dataset consists of the subjects being monitored, the sensor measurements, and the subject's activity at the time of measurement. These values were read into separate tables. 

```
subjects_test <- read.table("./data/UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")
features_test <- read.table("./data/UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")
activities_test <- read.table("./data/UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt")
subjects_train <- read.table("./data/UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")
features_train <- read.table("./data/UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")
activities_train <- read.table("./data/UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt")
```

With the individual pieces of the data available, now they are collected by variable heading.

```
activity_master <- rbind(activities_test,activities_train)
feature_master <- rbind(features_test, features_train)
subject_master <- rbind(subjects_test, subjects_train)
```

Once the master variable tables are in hand, they can be merged to produce the master data table, 'df_master'. Column names were also specified using the variable names and the transformed feature names.

```
df_master <- cbind(subject_master,activity_master,feature_master)
names(df_master) <- c("subject", "activity", feature_names)
```

I chose to decode the activity codes here and ensure the 'subject' and 'activity' variables were of stored as factors.

```
df_master$activity[df_master$activity==1] <- "Walking"
df_master$activity[df_master$activity==2] <- "Walking Upstairs"
df_master$activity[df_master$activity==3] <- "Walking Downstairs"
df_master$activity[df_master$activity==4] <- "Sitting"
df_master$activity[df_master$activity==5] <- "Standing"
df_master$activity[df_master$activity==6] <- "Laying"
df_master$activity <- as.factor(df_master$activity)
df_master$subject <- as.factor(df_master$subject)
```

Duplicate columns existed that prevented me from the next processing step so here they are removed.

```
deduped_df <- df_master[,!duplicated(colnames(df_master))]
```

With duplicates removed, columns containing a mean value or standard deviation were collected into their own dataframes. Also isolated were the variables of interest, 'subject' and 'activity'.

```
df_mean <- select(deduped_df, matches("mean"))
df_std <- select(deduped_df, matches("std"))
df_cols <- select(deduped_df, subject, activity)
```

Merging these tables yields the full table ready for analysis, 'df_analysis'.

```
df_analysis <- cbind(df_cols, df_mean, df_std)
```

Expanding on the abbreviated descriptions of the variable names gives a more intelligble table.

```
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
```

Calculating the aggregate sum by 'subject' and 'activity' yields the table requested in part 5.

```
df_avgs <- aggregate(. ~subject + activity,df_analysis, FUN = mean)
```

The resulting tables of step 4 and step 5 are written files.

```
write.table(df_analysis, "step_4_df.txt", row.name=FALSE)
write.table(df_avgs, "step_5_df.txt", row.name=FALSE)
```

And that wraps up our R script for this assignment. Thanks for reading!