---
title: "CodeBook"
author: "David Seibel"
date: "November 13, 2014"
output: html_document
---

#Introduction
This code book describes the raw data, study design, data transformations, tidy datasets produced and describes each output variable.  Two files are produced: "all.data" is an R dataframe that is not saved on disk.  "tidy2.txt" is a summary of all.data by sub-category which was saved and uploaded to complete the coursera project.  Both datasets can be reproduced following the instructions in "README.txt".

#Raw Data
The raw data was downloaded from the following URL on the date indicated:    
    * RAW Data Web URL: (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)  
    * Download date: Wednesday, November 5, 2014 at 3:21 PM (EST)
    * The files were unzipped and placed into a folder for analysis without alteration.
    * The unziped file contains data and metadata in various files and folders.
    
#Study Design

The raw data represents measurements taken while 60 subjects performed 6 different activities (e.g walking).  There are thousands of rows of observations because many measurements were taken during the period that each subject performed each activity.  In addition to the two category values (subject.ID and activity.code), there were 561 numeric value metrics for each observation.  The data was recorded by a cell phone (Samsung Galaxy S II) carried by the subject at waist level and originated from the accelerometer and the gyroscope within the cell phone.  Although there were only 6 metrics originally recorded in each observation, the raw data study team used time window sampling and sosphisticated data analysis to create a total of 561 feature value metrics for each observation.  In addition, the observations were divided into two separate files, one for training and the other for testing. 

To understand the technical meaning of the raw data columns, please consult the raw data meta data which is located in this github branch, in the folder "RAW-Metadata".  It provides technical descriptions of the 561 feature meanings and the methods or concepts used by the raw data team.  Further technical understanding is outside the scope of this project.

This project study extracts the existing (86) mean and standard deviation columns, from the raw data.  Then it combines the "training"" observations with the "test" observations into one dataset called "all.data".  The resulting dataset also contains three category columns which are the student ID and the activity name and the activity code.   There are  10299 observations and 89 columns.

Within "all.data" there are 180 sub-categories (30*6=180) since there are 30 student ID's (1:30) and 6 activities: 1) WALKING, 2) WALKING UPSTAIRS, 3) WALKING DOWNSTAIRS, 4) SITTING, 5) STANDING and, 6) LAYING.  This complete tidy dataset (all.data) is input to a summarization routine that calculates the mean of each column for each sub-category.  

The summary dataset is "tidy2.txt" and it contains 180 observations, one for each sub-category and 88 columns.  The first two columns are for Activity and Student ID.  The values in the next 86 columns are the means of the corresponding raw data variable for observations within that sub-category.  Thus the values are either "means of means" or "means of standard deviations".  

The 86 numeric "feature"" column names in "all.data"" and "tidy2.txt"" data are exactly the same as in the raw data.  This is intentional to facilitate accurate look-up of the technical meanings in the raw meta-data that was obtained from the raw zip file and can be found in this github branch at: "/RAW-Metadata/ (README.txt and "features_info.txt").  The column names indicate whether the original feature was a mean or standard deviation by incorporating a string (either "mean" or "std") into the column name. 


# Transformations
The "RAW" dataset for this project it has 561 features and thousands of observations.  It was split into two parts "train" and "test" in respective folders.  These observations were combined into one dataset. 

The course project instructions specify that only the "mean and standard deviation" values are required for analysis, therefore only a small subset of the 561 data columns needed to be read.  The raw data was divided into two parts: training data and testing data, possibly for use in machine learning.  Per instructions, these separate data would have to be merged together.  The training data was further divided into three separate files, one for the activity codes, one for the subject ID's and a very large file for the 561 feature value numeric columns.  All three files had exactly the same number of rows (7,352), so I deduced that they were in the same sequential order, and needed to be merged together column-wise and in-order.  The testing data was structured in the same manner as the training data.

Before processing the actual data it was necessary to process two meta data files.  First the activity meta data which provided a unique english label for each of the six activity codes (e.g 1="walking"). Second the 561 column headings/labels for the 561 feature value metrics, because the feature value files did not have any column headings.    

After all the meta data and data are are read and merged together, a tidy categorical mean summary needs to be created and uploaded for grading.

There is one R script ("run_analysis.R") which performs these all these tasks as follows:

##Meta Data Transformations

The "activity_lables.txt" file, contained the six activity codes (1:6) and their corresponding english descriptions (e.g. "walking").  The descriptions were ready into an R vector in order corresponding to their integer codes.  An R function ("act.lab") was created that would quickly translate any activity code into its corresponding label.  This function was used later in the script to add activity labels to the dataset.

The "features.txt" file contains 561 lines, one for each of the 561 feature value numeric columns provided in the RAW data.  Each line contains the column number and the corresponding feature label (inferred conclusion).  For example the first three lines were:  

     1 tBodyAcc-mean()-X
     2 tBodyAcc-mean()-Y
     3 tBodyAcc-mean()-Z

The programer carefully inspected the features.txt file to find the column numbers that were either means or standard deviations ("mean" or "std").  A vector "mean.sds" was hard coded that containing just the required column numbers.  It was used to create a column subsetting vector "the.cc" and a column names vector "the.col.names" that are used later in the R script.  

A vector named "the.cc"" was created containing 561 "NULL" values, to represent each of the 561 data columns. The vector of required column numbers was used to update the corresponding items within "the.cc" vector from "NULL" to "numeric".  This vector was used later in the R script as a parameter for "read.table" (e.g. colClasses=the.cc).  The "NULL" values caused unneeded columns to be skipped and the "numeric" values caused required columns to be read as numeric values. 

Another vector named "the.col.names" was created that contained only the required "feature"" column names, in-order.  This vector is used later in the program to add meaningfull (and identical) column labels to the data frames.

##RAW data transformations

The "subject-train.txt" file was read into the "tr.student" data frame; it had one column, the subject ID with values from 1 to 60.  

The "y_train_txt" file was read into an "tr.activity" data frame; it had one column, the activity code with values from 1 to 6.  A second column was added using the "act.lab" function (above) which contained  the corresponding english activity label (e.g. 1="walking").

The training feature data ("X_train.txt") was read into an R data frame called "tr.metrics" using "colClasses=the.cc" (described above) to select only the required columns.  Then the "the.col.names" vector (defined above) was used add meaningful labels/headings.

The tr.subject, tr.activity and tr.metrics data frames were all merged with cbind, column-wise, in-order to form "train.data"

The test data were processed with the same methods to produce "test.data".  Then "test.data" and "train.data" were merged together row-wise using rbind to form "all.data".

## Summarization transformations
The aggregate R function was used to calculate means of each numberic feature data column in all.data with a categatory index vector that included both "activity" and "subject.ID" forming a data frame called "tidy2".  Tidy2 was written to a text file for upload and grading.

#Code Book

###UNITS (unchanged from RAW data)

This study has not changed the units provided by the RAW data, as described below.  These lines were copied exactly from the first few lines of the (included) Raw Metadata files "README.txt" and "features_info.txt".  Both files contain additional information that may be useful.

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

......

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

... see the included raw meta data files for more detail... 



###Variable Names and Descriptions

Category Variables
  "subject.ID"         Values: 1 to 30 (30 students)
  "activity.code"      Values: 1 to 6  (this variable is found only in "all.data"", not in "tidy2"")                      
  "activity"           Values: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING
 
Numeric Variable names are identical to those in the raw data.
In all.data the values are identical to the raw data values.
In tidy2.txt the values are summarized for each sub-category using the R aggregate mean method.
                          
 [4] "tBodyAcc-mean()-X"                   
 [5] "tBodyAcc-mean()-Y"                   
 [6] "tBodyAcc-mean()-Z"                   
 [7] "tBodyAcc-std()-X"                    
 [8] "tBodyAcc-std()-Y"                    
 [9] "tBodyAcc-std()-Z"                    
[10] "tGravityAcc-mean()-X"                
[11] "tGravityAcc-mean()-Y"                
[12] "tGravityAcc-mean()-Z"                
[13] "tGravityAcc-std()-X"                 
[14] "tGravityAcc-std()-Y"                 
[15] "tGravityAcc-std()-Z"                 
[16] "tBodyAccJerk-mean()-X"               
[17] "tBodyAccJerk-mean()-Y"               
[18] "tBodyAccJerk-mean()-Z"               
[19] "tBodyAccJerk-std()-X"                
[20] "tBodyAccJerk-std()-Y"                
[21] "tBodyAccJerk-std()-Z"                
[22] "tBodyGyro-mean()-X"                  
[23] "tBodyGyro-mean()-Y"                  
[24] "tBodyGyro-mean()-Z"                  
[25] "tBodyGyro-std()-X"                   
[26] "tBodyGyro-std()-Y"                   
[27] "tBodyGyro-std()-Z"                   
[28] "tBodyGyroJerk-mean()-X"              
[29] "tBodyGyroJerk-mean()-Y"              
[30] "tBodyGyroJerk-mean()-Z"              
[31] "tBodyGyroJerk-std()-X"               
[32] "tBodyGyroJerk-std()-Y"               
[33] "tBodyGyroJerk-std()-Z"               
[34] "tBodyAccMag-mean()"                  
[35] "tBodyAccMag-std()"                   
[36] "tGravityAccMag-mean()"               
[37] "tGravityAccMag-std()"                
[38] "tBodyAccJerkMag-mean()"              
[39] "tBodyAccJerkMag-std()"               
[40] "tBodyGyroMag-mean()"                 
[41] "tBodyGyroMag-std()"                  
[42] "tBodyGyroJerkMag-mean()"             
[43] "tBodyGyroJerkMag-std()"              
[44] "fBodyAcc-mean()-X"                   
[45] "fBodyAcc-mean()-Y"                   
[46] "fBodyAcc-mean()-Z"                   
[47] "fBodyAcc-std()-X"                    
[48] "fBodyAcc-std()-Y"                    
[49] "fBodyAcc-std()-Z"                    
[50] "fBodyAcc-meanFreq()-X"               
[51] "fBodyAcc-meanFreq()-Y"               
[52] "fBodyAcc-meanFreq()-Z"               
[53] "fBodyAccJerk-mean()-X"               
[54] "fBodyAccJerk-mean()-Y"               
[55] "fBodyAccJerk-mean()-Z"               
[56] "fBodyAccJerk-std()-X"                
[57] "fBodyAccJerk-std()-Y"                
[58] "fBodyAccJerk-std()-Z"                
[59] "fBodyAccJerk-meanFreq()-X"           
[60] "fBodyAccJerk-meanFreq()-Y"           
[61] "fBodyAccJerk-meanFreq()-Z"           
[62] "fBodyGyro-mean()-X"                  
[63] "fBodyGyro-mean()-Y"                  
[64] "fBodyGyro-mean()-Z"                  
[65] "fBodyGyro-std()-X"                   
[66] "fBodyGyro-std()-Y"                   
[67] "fBodyGyro-std()-Z"                   
[68] "fBodyGyro-meanFreq()-X"              
[69] "fBodyGyro-meanFreq()-Y"              
[70] "fBodyGyro-meanFreq()-Z"              
[71] "fBodyAccMag-mean()"                  
[72] "fBodyAccMag-std()"                   
[73] "fBodyAccMag-meanFreq()"              
[74] "fBodyBodyAccJerkMag-mean()"          
[75] "fBodyBodyAccJerkMag-std()"           
[76] "fBodyBodyAccJerkMag-meanFreq()"      
[77] "fBodyBodyGyroMag-mean()"             
[78] "fBodyBodyGyroMag-std()"              
[79] "fBodyBodyGyroMag-meanFreq()"         
[80] "fBodyBodyGyroJerkMag-mean()"         
[81] "fBodyBodyGyroJerkMag-std()"          
[82] "fBodyBodyGyroJerkMag-meanFreq()"     
[83] "angle(tBodyAccMean,gravity)"         
[84] "angle(tBodyAccJerkMean),gravityMean)"
[85] "angle(tBodyGyroMean,gravityMean)"    
[86] "angle(tBodyGyroJerkMean,gravityMean)"
[87] "angle(X,gravityMean)"                
[88] "angle(Y,gravityMean)"                
[89] "angle(Z,gravityMean)"  

