###########################################  
## Getting and Cleaning Data - Project
##
## Date: 20 February 2014
## File: run_analysis.R
###########################################
library(data.table)
library(dplyr)
library(plyr)
library(reshape)

###########################################
#### 1. Set Directory to Project Directory

setwd("~/School/coursera/GettingandCleaningData/project/")

###########################################
#### 2. Read in Files

# [X|y]_test.txt - test files related to subject's purpose; First file lists subjects, second data 
test <- NULL
test_X <- read.table("./UCI HAR Dataset/test/X_test.txt", stringsAsFactors = F, strip.white = T)
test_Y <- read.table("./UCI HAR Dataset/test/y_test.txt", stringsAsFactors = F, strip.white = T)
test_subject <- read.table("./UCI HAR Dataset/test/subject_test.txt", stringsAsFactors = F, strip.white = T)

# [X|y]_train.txt - train files related to subject's purpose; First file lists subjects, second data 
train <- NULL
train_X <- read.table("./UCI HAR Dataset/train/X_train.txt", stringsAsFactors = F, strip.white = T)
train_Y <- read.table("./UCI HAR Dataset/train/y_train.txt", stringsAsFactors = F, strip.white = T)
train_subject <- read.table("./UCI HAR Dataset/train/subject_train.txt", stringsAsFactors = F, strip.white = T)

# activity_labels.txt - labels for activities
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", stringsAsFactors = F, strip.white = T)
activity_labels <- as.vector(activity_label[,2])

# features.txt - labels for the different measurement observations
features <- read.table("./UCI HAR Dataset/features.txt", stringsAsFactors = F, strip.white = T)

###########################################
#### 3. Filter measurement variables listed in features

# Grep for mean() and std() measurements and filter out the rest.
means <- grepl("mean()", features[,2],fixed=T)
std <- grepl("std()", features[,2],fixed=T)

# Gather complete list of columns for measurement observations 
complete_col <- means|std

###########################################
#### 4. Renaming Column Names in "Test" and "Train" Dataframes and Subsetting Columns from Features

# Modify column names of individual vectors for test
colnames(test_subject) <- "subject"
colnames(test_Y)       <- "activity"
colnames(test_X)       <- features[,2]

# Modify column names of individual vectors for train
colnames(train_subject) <- "subject"
colnames(train_Y)       <- "activity"
colnames(train_X)       <-  features[,2]

# Subset from test dataset with only the relevant chosen columns
test_X <- test_X[,complete_col]

# Subset from test dataset with only the relevant chosen columns
train_X <- train_X[,complete_col]

###########################################
#### 5. Bind Columns of Test and Train Data Sets from the Data Tables/Vectors Read In

# Create additional column to identify the subject's purpose - distinguish "test" from "train"
purpose <- rep("test", dim(test_Y)[1])

# Bind columns of the test data sets 
test <- cbind(purpose, test_subject, test_Y, test_X)

# Create additional column to identify the subject's purpose - distinguish "test" from "train"
purpose <- rep("train", dim(train_Y)[1])

# Bind columns of the train data sets 
train <- cbind(purpose, train_subject, train_Y, train_X)

###########################################
#### 6. Merge Test and Train Data Sets into Single Data Table.

# Bind the train and test data sets into all_data 
all_data <- NULL
all_data <- rbind(train, test)

###########################################
#### 7. Rename Activity Descriptions

# Search and substitute activity identifier with appropriate activity label
for (x in 1:6) { all_data$activity <- gsub(as.character(x), activity_labels[x], all_data$activity)}

###########################################
#### 8. Sort Data Table and Group By Purpose, Subject and Activity

# Sort all_data by purpose, subject and activity - in that order
all_data %>% arrange(purpose, subject, activity)

###########################################
#### 9. Transform Data Table into Tidy Data

# Group all_data by purpose, subject, activity
all_data<- all_data %>% group_by(purpose, subject, activity)

# Melt measurement observations into one column with values in another column
tidy_data <-melt(as.data.frame(all_data), id=c("purpose", "subject", "activity"))

# Rename the last two numbers for measurement type and value
names(tidy_data)[4:5] <- c("measurements", "value")

###########################################
#### 10. Summarize Results and Save Output to File

# Summarize mean() and std() of all measurement quantities with ddply
tidy_data_results <- ddply(tidy_data, .(subject, activity, measurements), summarise, mean=mean(value), sd=sd(value))
#tidy_data_results_2 <- ddply(tidy_data, .(purpose, subject, activity, measurements), summarise, mean=mean(value), sd=sd(value))

# Write out new data omitting "purpose" column into file
write.table(tidy_data_results, "./tidy_data_results.txt", row.names=F, quote = FALSE)

# Write out new data with "purpose" column into file
#write.table(tidy_data_results_2, "./tidy_data_results_2.txt", row.names=F, quote = FALSE)

## Extraneous write-outs for Code Book.
write.table(colnames(tidy_data_results), file = "CodeBook.md", row.name = FALSE, quote = FALSE)
write.table(tidy_data_results$measurements, file = "CodeBook_Meas.md", row.name = FALSE, quote = FALSE)




