# Getting And Cleaning Data
Course project in Coursera Getting and Cleaning Data
The purpose of the project is to make a tidy dataset out of the Human Activity Recognition data generated from smartphones. The data is split inyto two sets:
1. Training Data (70% of the volunteers)
2. Test data (30% of the volunteers)

The functions in the R code is described below.

You activate the script by executing the command *run_analysis()*.

## Download data
This is handled by function *downloadUCIHARData*
Data is downloaded as a zip file from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
The URL is hardoded in the function.

## Unzip files
This is handled by function *extractUCIHARFiles*
Data is unzipped to folder in working directory. The folder is the foldername in the path for each file in the zip file.

## Read datasets into data.frames
The list of files in the zip is checked in order to find path to the required files.
Each required file is read into a data.frame by calling the function *readUCIHARdatafile*

The following files are required
1. UCI HAR Dataset/activity_labels.txt
2. UCI HAR Dataset/features.txt
3. UCI HAR Dataset/test/subject_test.txt
3. UCI HAR Dataset/test/X_test.txt
5. UCI HAR Dataset/test/y_test.txt
6. UCI HAR Dataset/train/subject_train.txt
7. UCI HAR Dataset/train/X_train.txt
8. UCI HAR Dataset/train/y_train.txt

Special processing is done for data frames created from y_test.txt and y_train.txt in order to translate activity_id to an activity_labels and add as new column in df_y_test and df.y_train

The data frames is given correct column names. The features.txt contains the labels to be used for the X_test.txt and X_train.txt columns. If you in R Studio study the data.frames that are the result of a read.table("UCI HAR Dataset/test/X_test.txt") / read.table("UCI HAR Dataset/train/X_train.txt") R Studio will only show the first 100 columns even though there in reality is 561 columns in each.   

## Create combined test data frame consisting of columns of subjects, activity labels and test data
A new data.frame indicating whether it is test or training data is created for each type.
Test data: DataType, Subject_ID (subject_test), AvtivityType (Modified y_test) and UCI HAR data (X_train)
Training data: DataType, Subject_ID (subject_train), AvtivityType (Modified y_train) and UCI HAR data (X_train)

## Produce tidy output file
Combines rows from test and training into a combined training data frame consisting of columns of subjects, activity labels and train data.

Creates a subset of all data with DataType, Subject_ID, ActivityType and all columns having experessions ".mean." and ".std."

Writes tidy data to file "UCIHAR_allData_Subset_Tidy_Table.txt" in folder "data"" under Working Directory.

Column names are written in file "output_colnames.txt" in folder "data"" under Working Directory.
