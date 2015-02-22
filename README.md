---
title: "README.md"

date: "February 22, 2015"
output: html_document
---

### Goal
* Project involves running a script to aggregate separate data files and transform this data set into 
  "tidy data". 

* Tidy data will include mean and standard deviation of the observed measurements.

### Files

1. run_analysis.R - single script to read all files into data frame, convert/transform data set, and
   compute descriptive statistics for measured values.
2. README.txt     - describes the content of the project and method of the run_analysis.R script.
3. tidy_data_results.txt - end-results of the data set with computed values - mean() and std() of the
   measured quantities.
4. CodeBook.md    - gives description of variables, and methods to the data gathering and 
   calculations.

### Method
Run_analysis.R script performs the data concatenation, transformation and computational summary by the following steps.

1. Set Directory to Project Directory
2. Read in Files

        a.  [X|y]_test.txt - test files related to subject's purpose;
            File: X_test.txt lists subjects.
            File: y_test.txt contains measurement data.

            "test_X" <- data.table containing X_test.txt observable measurements, regarding subject's
            purpose "test".

	          "test_Y"" <- vector containing  y_test.txt values, regarding which subjects. Subjects are
            given numeric value from the set [1..21]

        b. [X|y]_train.txt - train files related to subject's purpose; 
           File: X_train.txt lists subjects.
           File: y_test.txt contains measurement data. 
           
           "train_X" <- data.table containing X_train.txt observable measurements, regarding subject's
           purpose "test"
	         
           "train_Y"" <- vector containing  y_train.txt values, regarding which subjects. Subjects are
           given numeric value from the set [1..21]

        c. activity_labels.txt - labels for activities. These string names will substitute the
           numeric value given in both test_Y and train_Y. There are six numeric values for 
           activities, which translate to WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING,
           STANDING, LAYING
          
           "activities_label" <- vector containing string names of activities

        d. features.txt - labels for the different measurement observations
           
           "features" <- vector of measurement labels.

3. Filter measurement variables listed in features

        a. Grep for mean() and std() measurements and filter out the rest. These measurements are
           listed in features.txt, and stored in vector "features".

        b. Subsetting for mean() and std() measurements early will make data merging easier and less
           cumbersome (less memory).

        c. These measurements are acceleration and mean() and std() is given for X-Y-Z directions.

4. Rename Column Names in "Test" and "Train" Dataframes and Subsetting Columns from Features

        a. Gather complete list of columns for measurement observations, which includes mean() and
           std(). 

        b. Modify column names of individual vectors in the respective data.tables for test and train.
           Both should have intersecting column names to assist in the merge of these two datasets.
           Identify the fixed column variables: purpose, subject, activity

        c. Create additional column to identify the subject's purpose - distinguish "test" 
           from "train". Do this separately for "test" data.table and "train" data.table
           "purpose" <- vector containing either "test" or "train" identifier for the respective data  
           sets.

        d. Subset from "test_X" dataset with only the relevant chosen (measurement) columns
           "complete_col" <- vector of chosen measurement columns for mean() and std().

        e. Subset from "train_X" dataset with only the relevant chosen (measurement) columns

5. Bind Columns of Test and Train Data Sets from the Data Tables/Vectors Read In

        a. Bind columns of the test data sets for subject, activity, and purpose. 
          "test" <- complete data table for the test group.

        b. Bind columns of the train data sets for subject, activity, and purpose.
          "train" <- complete data table for the test group.

6. Merge Test and Train Data Sets into Single Data Table.

        a. "all_data" <- data.table rbind of train and test data sets.

7. Rename Activity Descriptions

        a. Replace (gsub) activity numeric values columns for activity labels given by 
           "activity_labels" vector.

8. Sort Data Table and Group By Purpose, Subject and Activity

        a. Sort "all_data" by purpose, subject and activity - in that order

        b. Group all_data by purpose, subject, activity

9. Transform Data Table into Tidy Data

        a. Transpose (melt) measurement observations into one column with values in another column.
           This will put all measurement values under one variable called "measurements".
           "tidy_data" <- data table in tidy data format.

        b. Rename the last two numbers for measurement type and value

10. Summarize Results and Save Output to File

        a. Calculate mean() and std() of all measurement quantities with ddply

        b. Write out new data omitting "purpose" column into file.
           "tidy_data_results" <- final data table containing calculated mean() and std() of
           measurements.

