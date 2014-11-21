---
title: "Course Project for getdata-009"
author: "David Seibel"
date: "November 13, 2014"
output: html_document
---
Course Project for: Johns Hopkins - Getting and Cleaning Data  
instructors: by Jeff Leek, PhD, Roger D. Peng, PhD, Brian Caffo, PhD  
Course Dates: November, 2014  
Student email: seibeldb@gmail.com  

#README
This repo is for a course project and contains the items required to complete the project.  Project instructions are at the end of this file.  The items to turn in on github include this "README" file, a single R script and a Code Book.


1. The code book **"CodeBook.md"** 
    a. Describes the raw data, study design, data transformations, tidy datasets produced and each output variable.  
    b. Two files are produced: "all.data" and "tidy2.txt".
    c. Both datasets can be reproduced following the instructions below.

2. Software used for this study.
    a. Rstudio Version 0.98.1028
    b. MAC OSX 10.9.5
    c. R version 3.1.1 GUI 1.65 Mavericks build (6784)
    d. Github.app version Medium Hefson (192)
    
3. The raw data exists as a zip file at the following URL and should be downloaded manually, placed into the same directory as the R script and then uncompressed in that location.
    * RAW Data Web URL: (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)  
    * Study download date: Wednesday, November 5, 2014 at 3:21 PM (EST)

4. This R script **"run_analysis.R"** can be used to recreate the tidy data files.  It does the follwoing:   
    a. can be modified to set the working directory to the location of the raw data (if needed),
    b. reads metadata files (activity_labels.txt and "features.txt") from the working directory
    c. reads just the raw data columnes that are required from data sub-folders: "test" and "train",
    d. merges and makes the raw data tidy,
    e. summarizes the tidy data,
    f. can be modified to set the working directory to a different output directory (if needed),
    g. writes the summarized data to a text file named **"tidy2.txt"**.

5. A **"RAW-Metadata"**" folder containing the original meta data files that were provided with the raw data.
    a. activity_labels.txt
    b. features.txt
    c. README.txt
    d. features_info.txt
    
    


#Project Instructions 
(copied from course materials)

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit:  
 
1.  A **tidy** data set as described below  
2.  A link to a **Github repository** with your script for performing the analysis, and   
3.  A code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called **"CodeBook.md"**.   
4.  You should also include a **"README.md"** in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.   
 
You should create one R script called **"run_analysis.R"**" that does the following.  

1. Merges the training and the test sets to create one data set.  
2. Extracts only the measurements on the mean and standard deviation for each measurement.  
3. Uses descriptive activity names to name the activities in the data set.  
4. Appropriately labels the data set with descriptive variable names.  
5. From the data set in step 4, creates a second, independent **tidy** data set with the average of each variable for each activity and each subject.


Please **upload the tidy data set** created in step 5 of the instructions. Please upload your data set **as a txt file** created with write.table() using row.name=FALSE (do not cut and paste a dataset directly into the text box, as this may cause errors saving your submission).

RAW Data Web URL: (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)  
  