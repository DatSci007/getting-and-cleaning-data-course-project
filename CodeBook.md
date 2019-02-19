



# CodeBook for the tidy dataset

## Data source
This dataset is derived from the "Human Activity Recognition Using Smartphones Data Set" which was originally made avaiable here: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones


## Files

One of the most exciting areas in all of data science right now is wearable computing - see for example this article. Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users.

In this project, data collected from the accelerometer and gyroscope of the Samsung Galaxy S smartphone was retrieved, worked with, and cleaned, to prepare a tidy data that can be used for later analysis.

This repository contains the following files:

+ **README.md**: this file, explains how all of the scripts work and how they are connected.
+ **tidy_data.txt**: contains the data set.
+ **CodeBook.md**: a code book that modifies and updates the available codebooks with the data to indicate all the variables and summaries calculated, along with units, and any other relevant information.
+ **run_analysis.R**: the R script that was used to create the data set (see the Creating the data set section below)


# Creating the data set in R


## Variables

### Identifiers

+ subject - The ID of the test subject
+ activity - The type of activity performed when the corresponding measurements were taken

### Activity Labels

+ WALKING (value 1): subject was walking during the test
+ WALKING_UPSTAIRS (value 2): subject was walking up a staircase during the test
+ WALKING_DOWNSTAIRS (value 3): subject was walking down a staircase during the test
+ SITTING (value 4): subject was sitting during the test
+ STANDING (value 5): subject was standing during the test
+ LAYING (value 6): subject was laying down during the test

## Transformations in R

The zip file containing the source data is located at https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip.

The R script **run_analysis.R** can be used to create the data set. It retrieves the source data set and transforms it to produce the final data set by implementing the following steps:

0. Download and unzip source data if it doesn't exist and read data.
1. Merge the training and the test sets to create one data set.
2. Extract only the measurements on the mean and standard deviation for each measurement.
3. Use descriptive activity names to name the activities in the data set.
4. Appropriately label the data set with descriptive variable names.
5. Create a second, independent tidy set with the average of each variable for each activity and each subject. Write the data set to the tidy_data.txt file.

The **tidy_data.txt** in this repository was created by running the **run_analysis.R** script using R version 3.5.1 (2019-02-19) on Windows 10.1 64-bit edition.
This script requires the dplyr package.
