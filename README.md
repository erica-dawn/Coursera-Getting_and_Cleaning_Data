# Coursera-Getting_and_Cleaning_Data
Final Project for Coursera's Getting and Cleaning Data course

The run_analysis script was written to accomplish the following:

* Merges the training and the test sets to create one data set.
    1. Check whether file already exists
    2. If file does not exist, download and unzip file
    3. Read train and test tables, features, and activity labels
    4. Assign variable names with colnames() function
    5. Merge train and test tables with cbind() function
    6. Merge train and test data with rbind()
* Extracts only the measurements on the mean and standard deviation for each 
  measurement.
    1. Use regular expressions to subset data with desired variables
* Uses descriptive activity names to name the activities in the data set
    1. Convert activity variable to factor
    2. Rename levels
* Appropriately labels the data set with descriptive variable names.
    1. Use regular expressions with colnames() to rename variables
* From the data set in step 4, creates a second, independent tidy data set with
  the average of each variable for each activity and each subject.
    1. Use group_by() from dplyr package to group observations by activity and
       subject
    2. Use summarize_all() from dplyr package to apply mean() function
    3. Write new data set to .txt file
