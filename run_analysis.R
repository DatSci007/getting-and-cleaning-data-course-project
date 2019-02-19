


# PreProcessing

set.seed(272)

### clear workspace
rm(list=ls(all=TRUE)); gc()

### for RTools (readxls)
Sys.setenv(R_ZIPCMD= "C:/Rtools/bin/zip") 

### surpress scientific notation
options(scipen=999)


### load and install (if neccessary) multiple packages at once
fct.package <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg)) 
    install.packages(new.pkg, dependencies = TRUE)
  sapply(pkg, require, character.only = TRUE)
}

# usage
List.packages <- c("tidyverse", "readxl", "plyr", "reshape2", "PerformanceAnalytics", "data.table", "gridExtra", "lubridate","forecast", "xtable", "magrittr",
                   "stringr", "lubridate", "scales", "ggthemes", "smooth", "zoo", "lme4", "foreign", "XLConnect", "openxlsx", 
                   "stargazer", "caret",  # library(stargazer) for beautiful tables, caret for confusion martix
                   "explor", "FactoMineR", "haven", "wCorr",
                   "timetk", # for tk_augment_timeseries --> get day, monath, year, quarter from date-variable
                   "swirl" # The swirl package turns the R console into an interactive learning environment
)
fct.package(List.packages)


### several select commands, by default seelct = select from dplyr package
select <- dplyr::select
summarize <- dplyr::summarize
filter <- dplyr::filter
mutate <- dplyr::mutate


# Review criteriaweniger
# 1) The submitted data set is tidy.
# 2) The Github repo contains the required scripts.
# 3) GitHub contains a code book that modifies and updates the available codebooks with the data to indicate all the variables and summaries calculated, along with units, and any other relevant information.
# 4) The README that explains the analysis files is clear and understandable.
# 5) The work submitted for this project is the work of the student who submitted it.
# 
# Getting and Cleaning Data Course Projectweniger
# 
# The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.
# 
# One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:
#   
#   http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
# 
# Here are the data for the project:
#   
#   https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# 
# You should create one R script called run_analysis.R that does the following.
# 
# 1) Merges the training and the test sets to create one data set.
# 2) Extracts only the measurements on the mean and standard deviation for each measurement.
# 3) Uses descriptive activity names to name the activities in the data set
# 4) Appropriately labels the data set with descriptive variable names.
# 5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


# 1) Merges the training and the test sets to create one data set.

rm(list = ls())
setwd("Y:/4_Team_Insights/02_Insights/Xchange/Trinh/09_Einarbeitung/00_Cousera/02_Getting and Cleaning Data/")

### get data
Data_train <-  read.csv("UCI HAR Dataset/train/X_train.txt", sep="", header=FALSE) # x
Data_train[,562] <-  read.csv("UCI HAR Dataset/train/Y_train.txt", sep="", header=FALSE) # y
Data_train[,563] <-  read.csv("UCI HAR Dataset/train/subject_train.txt", sep="", header=FALSE) # 

Data_test <-  read.csv("UCI HAR Dataset/test/X_test.txt", sep="", header=FALSE)
Data_test[,562] <-  read.csv("UCI HAR Dataset/test/Y_test.txt", sep="", header=FALSE)
Data_test[,563] <-  read.csv("UCI HAR Dataset/test/subject_test.txt", sep="", header=FALSE)

Data_train$Key <- "Train"
Data_test$Key <- "Test"

### label
Lables_activity <-  read.csv("UCI HAR Dataset/activity_labels.txt", sep="", header=FALSE)

# Get features, the namses (=rows) are equavalent to the colums in train and test
Data_features <-  read.csv("UCI HAR Dataset/features.txt", sep="", header=FALSE)
head(Data_features)
### replace
Data_features[,2] <-  gsub('-mean', 'Mean', Data_features[,2])
Data_features[,2] <-  gsub('-std', 'Std', Data_features[,2])
Data_features[,2] <-  gsub('[-()]', '', Data_features[,2])
head(Data_features)

### merge data
Data_merge <- rbind(Data_train, Data_test)
table(Data_merge$Key)


# 2) Extracts only the measurements on the mean and standard deviation for each measurement.


### whichs rows contain Mean and Std?
List_MeanDev <- grepl(".*Mean.*|.*Std.*", Data_features[,2])

### change names of data_merge
colnames(Data_merge) <- gsub("V", "", colnames(Data_merge))

### reduce dataset
Data_merge1 <- Data_merge[, List_MeanDev]

### add back key, 562 and 563
# Data_merge1 <- cbind(Data_merge1, Data_merge[, 562:564])

### what are the names of features we kept?
Names_MeanDev <- Data_features[List_MeanDev, 2]

# Add the column names (features) to allData
colnames(Data_merge1) <- c(Names_MeanDev, "Activity", "Subject", "Key")
colnames(Data_merge1) <- tolower(colnames(Data_merge1))


# 3) Uses descriptive activity names to name the activities in the data set
copy <- Data_merge1


currentActivity <-  1
for (currentActivityLabel in Lables_activity$V2) { # run for axctivitoes 1-6
  Data_merge1$activity <- gsub(currentActivity, currentActivityLabel, Data_merge1$activity) # replace number with name
  currentActivity <- currentActivity + 1
}

# 4) Appropriately labels the data set with descriptive variable names.
Data_merge1$activity <- as.factor(Data_merge1$activity)
Data_merge1$subject <- as.factor(Data_merge1$subject)


# 5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidy <-  Data_merge1 %>%
  select(-key) %>%
  group_by(activity, subject) %>%
  summarise_at(vars(-c(activity, subject)), funs(mean(., na.rm=TRUE)))

### save
write.table(tidy, "tidy.txt", sep="\t")


