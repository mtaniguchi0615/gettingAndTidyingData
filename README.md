---
title: "README.md"
author: "mtaniguchi0615"
date: "Jan 31, 2016"
---

This document describes the content of this GitHub repository.

### README.md
This README file.

### CodeBook.md
Describes the variables in "tidyData.csv" and "meanByActivityBySubject.csv."
The process of tidying up the data (which is done by "run_analysis.R") is also described.

### tidyData.csv
Tidy data set with:  

- The training and the test sets merged to create one data set.
- Only the measurements on the mean and standard deviation for each observation.
- Column name and activity data modified for improving readability.

### meanByActivityBySubject.csv
Tidy data set with the average of each variable in "tidyData.csv"
for each activity and each subject.

### run_analysis.R
R script for generating "tidyData.csv" and "meanByActivityBySubject.csv"
from the contents of the directory "UCI HAR Dataset."
This script requires following R packages:

- data.table
- plyr
- dplyr

### UCI HAR Dataset
Directory containing the original data set, obtained from <https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip> on Jan 27, 2016.
See "UCI HAR Dataset/README.txt" for details.
