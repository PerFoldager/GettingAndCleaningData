---
title: "CodeBook for Tidy UCI HAR Dataset"
author: "Per Foldager"
date: "20. aug. 2015"
output: html_document
---
## What is it?

This CodeBook describes the data in the file "UCIHAR_allData_Subset_Tidy_Table.txt" that is the output of the `run_analysis.R` script contained in this repository. The text file can be read using `data.table` to create a data table for further analysis.
```R
tidyData <- data.table("data/UCIHAR_allData_Subset_Tidy_Table.txt")
```
`run_analysis.R` also outputs "output_colnames.txt" that provides the columns names in "UCIHAR_allData_Subset_Tidy_Table.txt".  

The script creates a tidy, condensed version of the University of California Irvine's (UCI's) dataset for Human Activity Recognition (HAR) using smartphones that can be used for further research and analysis. The original UCI HAR Dataset is a public domain dataset built from the recordings of subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensor (see http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

As described in the above referenced document, the original data comes from experiments that were carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (walking, walking_upstairs, walking_downstairs, sitting, standing, and laying) wearing a Samsung Galaxy S II smartphone on the waist. Using its embedded accelerometer and gyroscope, 3-axial linear acceleration and 3-axial angular velocity were captured at a constant rate of 50Hz. The experiments were video-recorded to label the data manually.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force was assumed to have only low frequency components, so a filter with a 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

## The process

The script first generates a combined data.frame for test followed by a seperate one for training data. DataType is added as a special column. For test all 2947 rows are populated with "test" and for training all 7352 rows are populated with "training". The test data.frame contains all test data and is a combination of the following data:

1. DataType - new column added to reflect type of data, which in this case is "test"
2. Subject_ID - created from test/subject_test.txt
3. ActivityType_ID - created from test/y_test.txt
4. ActivityType - created by lookup of ActivityType_ID in data.frame constructed from activity_labels.txt
5. 561 feature variables with oberservation data that is read into data.frame from test/X_test.txt.

The training data.frame contains all training data and is a combination of the following data:

  1. DataType - new column added to reflect type of data, which in this case is "training"
  2. Subject_ID - created from test/subject_test.txt
  3. ActivityType_ID - created from ttraining/y_test.txt
  4. ActivityType - created by lookup of ActivityType_ID in data.frame constructed from activity_labels.txt
  5. 561 feature variables with oberservation data that is read into data.frame from test/X_test.txt.

The complete test and training data.frames are then combined into one data.frame with all 561 feature variables. Next step is then to create a subset that only contains the mean and std feature variables. This reduces the number of feature variables to 66 and with a total of 10299 observations (2947 from test and 7352 from training). 

The data.frame with the reduced number of feature variables the following data:

  1. DataType - new column added to reflect type of data, which in this case is "training"
  2. Subject_ID - created from test/subject_test.txt
  4. ActivityType

    Clear text from the activity_labels.txt as one of the below:
    
    1. WALKING
    2. WALKING_UPSTAIRS
    3. WALKING_DOWNSTAIRS
    4. SITTING
    5. STANDING
    6. LAYING
 
  5. 66 mean and std feature variables


The data.frame with the reduced set of feature variables is then ordered by 
ActivityType and Subject_ID and the mean of each of the 66 feature variable is calculated. This reduces the number of observations to 180.

Finally the column names for the 66 feature variables is made more readable by removing "()" and ".". On top of this "mean" is replaced with "Mean" and "std" replaced with "Std".

## Output

The script outputs two datasets. They are both placed in data folder under working directory:

1. UCIHAR_allData_Subset_Tidy_Table.txt
2. output_colnames.txt

## Column names in UCIHAR_allData_Subset_Tidy_Table.txt

ID variables:

* Subject_ID - ID of the person that particated
  
* ActivityType - The type of activity the person performed. It is translated to clear text from activity_labels.txt
  
* DataType - The type of data collected. It is either "test or "training"

The feature variables containing the mean values for the combination of ActivityType and Subject_ID. The meaning of each variable is described in the original UCI HAR information. Look in Readme.txt and features_info.txt    

* tBodyAccMeanX
* tBodyAccMeanY
* tBodyAccMeanZ
* tGravityAccMeanX
* tGravityAccMeanY
* tGravityAccMeanZ
* tBodyAccJerkMeanX
* tBodyAccJerkMeanY
* tBodyAccJerkMeanZ
* tBodyGyroMeanX
* tBodyGyroMeanY
* tBodyGyroMeanZ
* tBodyGyroJerkMeanX
* tBodyGyroJerkMeanY
* tBodyGyroJerkMeanZ
* tBodyAccMagMean
* tGravityAccMagMean
* tBodyAccJerkMagMean
* tBodyGyroMagMean
* tBodyGyroJerkMagMean
* fBodyAccMeanX
* fBodyAccMeanY
* fBodyAccMeanZ
* fBodyAccJerkMeanX
* fBodyAccJerkMeanY
* fBodyAccJerkMeanZ
* fBodyGyroMeanX
* fBodyGyroMeanY
* fBodyGyroMeanZ
* fBodyAccMagMean
* fBodyBodyAccJerkMagMean
* fBodyBodyGyroMagMean
* fBodyBodyGyroJerkMagMean
* tBodyAccStdX
* tBodyAccStdY
* tBodyAccStdZ
* tGravityAccStdX
* tGravityAccStdY
* tGravityAccStdZ
* tBodyAccJerkStdX
* tBodyAccJerkStdY
* tBodyAccJerkStdZ
* tBodyGyroStdX
* tBodyGyroStdY
* tBodyGyroStdZ
* tBodyGyroJerkStdX
* tBodyGyroJerkStdY
* tBodyGyroJerkStdZ
* tBodyAccMagStd
* tGravityAccMagStd
* tBodyAccJerkMagStd
* tBodyGyroMagStd
* tBodyGyroJerkMagStd
* fBodyAccStdX
* fBodyAccStdY
* fBodyAccStdZ
* fBodyAccJerkStdX
* fBodyAccJerkStdY
* fBodyAccJerkStdZ
* fBodyGyroStdX
* fBodyGyroStdY
* fBodyGyroStdZ
* fBodyAccMagStd
* fBodyBodyAccJerkMagStd
* fBodyBodyGyroMagStd
* fBodyBodyGyroJerkMagStd
