---
title: "CodeBook.md"
author: "mtaniguchi0615"
date: "Jan 31, 2016"
---

This document describes following:

- The variables in "tidyData.csv" and "meanByActivityBySubject.csv"
- The process of tidying up the data, which is done by "run_analysis.R"

##Obtaining and Preprocessing the Data
For descriptions on the process of recording and preprocessing the original data,
see "UCI HAR Dataset/README.txt".


##Variables
* subject
    - Each row identifies the subject who performed the activity for each record.
* activity
    - Activity labels of the record. One of the following:
        + WALKING
        + WALKING_UPSTAIRS
        + WALKING_DOWNSTAIRS
        + SITTING
        + STANDING
        + LAYING
* trainOrTest
    - Indicates whether the record is from the training data set ("train") 
    or the test data set. ("test")
* timeDomainBodyAccXMean, timeDomainBodyGyroJerkMagStd, etc.
    - Variables on acceralation and angular velocity named in the following format:
    `[domain][Body_or_Gravity][Acc_or_Gyro][Jerk_or_nothing][X_Y_Z_or_Mag][Mean_or_Std]`
        + `domain`: Indicates the domain of the variable. ("timeDomain" or "freqDomain")
        + `Body_or_Gravity`: "Body" indicates the variable is on the body motion component of 
          the acceralation or the angular velocity, 
          while "Gravity" indicates the gravitational component.
        + `Acc_or_Gyro`: "Acc" indicates the variable shows the acceralation (accelometer output),
                         while "Gyro" indicates the angular velocity (gyrometer output).
        + `Jerk_or_nothing`: "Jerk" indicates the variable shows the jerk signal obtained by
          deriving the time domain signal. Otherwise this field is absent.
        + `X_Y_Z_or_Mag`: "X", "Y", and "Z" indicate the variable shows the X, Y, and Z-components, 
          respectively. 
          "Mag" indicates that the variable is on the magnitude of the signal.
        + `Mean_or_Std`: "Mean" indicates the variable shows the mean of the signal, 
          while "Std" indicates the standard deviation.

##Data Summarization
The original data set stored in the directory "UCI HAR Dataset" is cleaned up and summarized
using the R script "run_analysis.R".
In the script, following processing is performed:

- Step 1: Merge the sensor signal data ("UCI HAR Dataset/train/X_train.txt" and "UCI HAR Dataset/test/X_test.txt") into one data set.
- Step 2: The variable names for the sensor signals are modified into the form described in the previous section (**Variables**).
    + Remove parentheses and hyphens
    + Replace "t" and "f" at the start of the variable names 
      with "timeDomain" and "freqDomain," respectively.
    + Capitalize "Mean" and "Std"
    + Replace "MeanX" with "XMean" for the consistency with "MagMean". Similarly for Y, Z and Std.
      (We can do this because the mean of the X-component equals the X-component of the mean.)
    + As some variable names contains "BodyBody", replace it with "Body" to meet the naming convention.
- Step 3: Extract only the measurements on the mean and standard deviation from sensor signals.
- Step 4: Similarly to the sensor signals, 
  the activity label data ("Y_train.txt" and "Y_test.txt") are merged into one variable named "activity".
- Step 5: Replace the activity label shown in integer into string according to the table in "UCI HAR Dataset/activity_labels.txt"
- Step 6: Subject data sets ("subject_train.txt" and "subject_test.txt") are merged into one variable named "subject".
- Step 7: Make new variable "trainOrTest" which shows whether 
  the record is from the training data set ("train") or the test data set ("test").
- Step 8: Join the data sets obtained in Steps 3, 4, 6, and 7 into a single data set,
  and output as a csv file named "tidyData.csv".
- Step 9: From the data set in step 4, create another data set 
  with the average of each variable for each activity and each subject,
  irrespective of the records are from the training or test data set.
  Output the result as a csv file named "meanByActivityBySubject.csv".

