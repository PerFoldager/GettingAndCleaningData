## Course Project in Coursera Getting and Cleaning Data
## The run_analysis function produces a tidy file from the UCI HAR files containing all data with DataType, Subject_ID, ActivityType and all columns having experessions ".mean." and ".std. 
## The function has hardcoded URL to the zip file conatining the different data files 
## URL="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
##
## The result of the procesing is a tidy file "data/UCIHAR_allData_Subset_Tidy_Table.txt" placed in data folder under working directory.

run_analysis <- function() {
  library(dplyr)

  ## Step 1 Downloading zip file containing the UCI HAR (Human Activity Recognition) files
  message("Step 1 - Download zip file if not done already: ", "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip")
  zipfileName <- as.character("UCIHarFiles.zip")
  destpath <- as.character("data/")
  zipfileDestination <- as.character(paste(destpath,zipfileName, sep = ""))
  dataURL <- as.character("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip") 
  returncode <- downloadUCIHARData(dataURL, zipfileDestination)

  ## Step 2 extract data files from zip file
  message("Step 2 - extracting data files from zip file: ", "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip")
  filelist <- vector()
  if (returncode == 0) {
    message("zipfileDestination: ", zipfileDestination)
    message("destpath: ", destpath)
    filelist <- extractUCIHARFiles(zipfileDestination, destpath)
  }
  if (length(filelist) > 0) {
    returncode <- 0
  }
  else {
    return <- -1
  }

  ## Step 3 read the required files into data frames

  message("Step 3 - reading the required files into data frames. Files in sub-folder 'Inertial Signals' are not read.")
  ## Name data variables that will be used
  df_activity_labels <- data.frame()
  df_features <- data.frame()
  ## test data
  df_subject_test <- data.frame()
  df_X_test <- data.frame()
  df_y_test <- data.frame()
  ## Combined test data columns
  df_test_combined <- data.frame()
  ## train data
  df_subject_train <- data.frame()
  df_X_train <- data.frame()
  df_y_train <- data.frame()
  ## Combined train data columns
  df_train_combined <- data.frame()
  ## Combined train data columns
  df_UCIHAR_allData <- data.frame()
  ## variable to translate labels in features.txt to more readable names
  better_col_names <- vector()
  subject_col_name <- vector()
  subject_col_name <- c("Subject_ID")
  activityType_col_names <- c("ActivityType_ID", "ActivityType")
  dataType_col_name <- vector()
  dataType_col_name <- c("DataType")
  
    
  if (returncode == 0) {
    for (i in 1:nrow(filelist)) {
      ## Read the describing files
      if (grepl("activity_labels.txt",as.character(filelist[i,1]))) {
        df_activity_labels <- readUCIHARdatafile(as.character(filelist[i,1]))
      }
      if (grepl("features.txt",as.character(filelist[i,1]))) {
        df_features <- readUCIHARdatafile(as.character((filelist[i,1])))
        # Convert variable names in feature.txt to valid column names using make.name to remove parenthesis()
        better_col_names <- make.names(names =  df_features$V2, unique = T, allow_ = T)
      }
      ## Read the test files. We will not read the Inertial Signal files, because are not to be used in this exercise.
      if (grepl("/subject_test.txt",as.character(filelist[i,1]))) {
        df_subject_test <- readUCIHARdatafile(as.character(filelist[i,1]))
        names(df_subject_test) <- subject_col_name
      }
      if (grepl("/X_test.txt",as.character(filelist[i,1]))) {
        df_X_test <- readUCIHARdatafile(as.character(filelist[i,1]))
        names(df_X_test) <- better_col_names
      }
      if (grepl("/y_test.txt",as.character(filelist[i,1]))) {
        df_y_test <- readUCIHARdatafile(as.character(filelist[i,1]))
        for (i in 1:nrow(df_y_test)) {
          activity_selected <- subset(df_activity_labels, V1 == df_y_test[i,1])
          activity_label <- activity_selected[1,2]
          df_y_test[i, 2] <- activity_label
        }
        names(df_y_test) <- activityType_col_names
      }
      ## Read the training files. We will not read the Inertial Signal files, because are not to be used in this exercise.
      if (grepl("/subject_train.txt",as.character(filelist[i,1]))) {
        df_subject_train <- readUCIHARdatafile(as.character(filelist[i,1]))
        names(df_subject_train) <- subject_col_name
      }
      if (grepl("/X_train.txt",as.character(filelist[i,1]))) {
        df_X_train <- readUCIHARdatafile(as.character(filelist[i,1]))
        names(df_X_train) <- better_col_names
      }
      if (grepl("/y_train.txt",as.character(filelist[i,1]))) {
        df_y_train <- readUCIHARdatafile(as.character(filelist[i,1]))
        for (i in 1:nrow(df_y_train)) {
          activity_selected <- subset(df_activity_labels, V1 == df_y_train[i,1])
          activity_label <- activity_selected[1,2]
          df_y_train[i, 2] <- activity_label
        }
        names(df_y_train) <- activityType_col_names
      }
    }
  }
  
  ## Step 4 create combined test data frame consisting of columns of subjects, activity labels and test data 
  message("Step 4 - creating combined test data frame consisting of columns of subjects, activity labels and test data")
  
  ## Create one column to indicate type of data = test
  df_test <- data.frame(DataType = "test")
  ## replicate row to get same number of rows as in df_X_test
  df_test <- as.data.frame(df_test[rep(1:nrow(df_test),each=nrow(df_X_test)),])
  names(df_test) <- dataType_col_name

  df_test_combined <- cbind(df_test, df_subject_test, df_y_test, df_X_test)

  ## Step 5 create combined training data frame consisting of columns of subjects, activity labels and train data 
  message("Step 5 - creating combined training data frame consisting of columns of subjects, activity labels and train data")
  
  ## Create one column to indicate type of data = training
  df_train <- data.frame(DataType = "training")
  ## replicate row to get same number of rows as in df_X_train
  df_train <- as.data.frame(df_train[rep(1:nrow(df_train),each=nrow(df_X_train)),])
  names(df_train) <- dataType_col_name

  df_train_combined <- cbind(df_train, df_subject_train, df_y_train, df_X_train)

  ## Step 6 combine rows from test and training into a combined training data frame consisting of columns of subjects, activity labels and train data 
  message("Step 6 - combining rows from test and training into create combined training data frame consisting of columns of subjects, activity labels and train data")
  
  df_UCIHAR_allData <- rbind(df_test_combined, df_train_combined) 
  
  message("Number of columns in df_UCIHAR_allData: ", ncol(df_UCIHAR_allData))

  ## Step 7 Produce the tidy dataset, that only provides average values of each variable for each activity and subject 
  message("Step 7 - Producing the tidy dataset, that only provides average values of each variable for each activity and subject.")
  
  ## Create a subset of all data with DataType, Subject_ID, ActivityType and all columns having expressions ".mean." and ".std."
  df_UCIHAR_allData_Subset <- select(df_UCIHAR_allData, DataType, Subject_ID, ActivityType, contains(".mean."), contains(".std.") )

  ## Create the required tidy data set with the average of each variable for each activity and each subject.
  df_UCIHAR_allData_SubsetTidy <- group_by(df_UCIHAR_allData_Subset, Subject_ID, ActivityType, DataType) %>%
    summarise_each(funs(mean))
  
  ## Make the column names nice to read 
  output_colnames <- as.data.frame(colnames(df_UCIHAR_allData_SubsetTidy))
  output_colnames <- as.data.frame(gsub("\\.","",as.character(output_colnames[,1])))
  output_colnames <- as.data.frame(gsub("mean","Mean",as.character(output_colnames[,1])))
  output_colnames <- as.data.frame(gsub("std","Std",as.character(output_colnames[,1])))
  names(df_UCIHAR_allData_SubsetTidy) <- output_colnames[,1]
  names(output_colnames) <- c("OutputColumnNames")
  browser()
  ## Output the column names to file so they can be used in code book
  write.table(output_colnames, file = "data/output_colnames.txt", row.names = F, sep  = "\t")  

  # Store the df_UCIHAR_allData_SubsetTidy tidy data in a text file with the same name in the data folder under working dir
  write.table(df_UCIHAR_allData_SubsetTidy, file = "data/UCIHAR_allData_Subset_Tidy_Table.txt", row.names = F, sep  = "\t")  
  message("Output file: data/UCIHAR_allData_Subset_Tidy_Table.txt")
  message("Number of columns in UCIHAR_allData_Subset_Tidy_Table.txt: ", ncol(df_UCIHAR_allData_SubsetTidy))
  
  ## browser()
  return(returncode)
  
}

## Downloads the zip containing the training data
downloadUCIHARData <- function(dataURL, destination) {
  returnCode <- as.numeric(0)
  if (!file.exists(destination)) {
    returnCode <- download.file(dataURL, destfile=destination)
  }
  return(returnCode)
}

## Extract all files for processing
extractUCIHARFiles <- function(zipfileName, destination) {
  ## unzip to destination
  message("zipfileName: ", zipfileName)
  message("destination: ", destination)
  fileList <- unzip(zipfile = zipfileName, list = TRUE)
  ## returncode <- unzip(zipfile = zipfileName, exdir=destination)
  ## returncode <- unzip(zipfile = as.character(zipfileName), exdir= as.character(destination))
  if (!file.exists(as.character(fileList[1,1]))) {
    fileList <- unzip(zipfile = zipfileName)
  }  
  return(fileList)
}

## load file into data frame
readUCIHARdatafile <- function(filename) {
  ## read the file
  ## browser()
  message("fileName: ", filename)
  dataframe <- read.table(as.character(filename), stringsAsFactors = FALSE)
  ## browser()
  return(dataframe)
}

