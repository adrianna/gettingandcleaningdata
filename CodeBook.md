---
title: "Code Book: Human Activity Recognition Using Smartphones Data Set"
author: "Adrianna Galletta"
date: "February 22, 2015"
output: html_document
---


### Abstract
The experiments involved 30 volunteers wearing a smartphone around their waist and being tracked on a number of activities. Each subject performed six activities: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING. The volunteers were divided in two groups: the majority (70%) generated the training data, while the remaining 30% completed test data. The smartphone, being equipped with accelerometer and gyroscope, obtained various measurements. The measurements captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. Additionally, the subjects were assigned a numeric id, and the data was recorded manually from the video-captured experiments.


### Variables

The tidy_data_results spreadsheet contains 11880 observations and 5 variables. This dataset contains a subset of measurements and include the mean of means and mean standard deviation for each observation.
The five variables are subject, activity, measurement type, mean (means) and mean(std). 

The five variables are:

* subject
* activity
* measurements
* mean
* standard deviation (sd)

Their respective values are:

* subject  - [1:30]
* activity - 
    + WALKING
    + WALKING_UPSTAIRS
    + WALKING_DOWNSTAIRS
    + SITTING
    + STANDING
    + LAYING

* measurements
    + tBodyAcc-XYZ     - time Domain Body Acceleration: split into X-,Y-,Z- axes in data set [L/T^2^]
    + tGravityAcc-XYZ  - time Domain Gravity Acceleration: X-,Y-,Z- [L/T^2^]
    + tBodyAccJerk-XYZ - time Domain Body Acceleration Jerk: X-,Y-,Z- [L/T^2^]
    + tBodyGyro-XYZ    - time Domain Gyro: X-,Y-,Z- [rad/T^2^]
    + tBodyGyroJerk-XYZ  - time Domain Body Gyro: X-,Y-,Z- [rad/T^2^]
    + tBodyAccMag      - time Domain Body Acceleration Magnitude: X-,Y-,Z- [L/T^2^]
    + tGravityAccMag   - time Domain Gravity Acceleration Magnitude: X-,Y-,Z- [L/T^2^]
    + tBodyAccJerkMag  - time Domain Body Acceleration Jerk Magnitude: X-,Y-,Z- [L/T^2^]
    + tBodyGyroMag     - time Domain Body Gyro Magnitude: X-,Y-,Z- [rad/T^2^]
    + tBodyGyroJerkMag - time Domain Body Gyro Jerk Magnitude: X-,Y-,Z- [rad/T^2^]
    + fBodyAcc-XYZ     - freq Domain Body Acceleration: X-,Y-,Z- [L/T^2^]
    + fBodyAccJerk-XYZ - freq Domain Body Acceleration Jerk: X-,Y-,Z- [L/T^2^]
    + fBodyGyro-XYZ    - freq Domain Body Gyro: X-,Y-,Z- [rad/T^2^]
    + fBodyAccMag      - freq Domain Body Acceleration Magnitude:: X-,Y-,Z- [L/T^2^]  
    + fBodyAccJerkMag  - freq Domain Body Acceleration Jerk Magnitude: X-,Y-,Z- [L/T^2^]
    + fBodyGyroMag     - freq Domain Body Gyro Magnitude: X-,Y-,Z- [rad/T^2^]
    + fBodyGyroJerkMag - freq Domain Gyro Jerk Magnitude: X-,Y-,Z- [rad/T^2^]
* mean - average values of acceleration depending on the aforementioned measurement type.
* sd   - standard deviation of acceration depending on the aforementioned measurement type.

Data Units are defined from this web site.

http://www.techbitar.com/sensoduino.html
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

  