# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation 
#    for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, 
#    independent tidy data set with the average of each variable 
#    for each activity and each subject.

library(data.table)
library(plyr)
library(dplyr)

data.directory <- "UCI HAR Dataset"

X_rbind <- rbind(
  fread(file.path(data.directory, "train", "X_train.txt"), header=F), 
  fread(file.path(data.directory, "test",  "X_test.txt"),  header=F)
)

# read feature labels and set column names
features <- fread(file.path(data.directory, "features.txt"), header=F)
features <- features[[2]]
names(X_rbind) <- features

# remove hyphens and parentheses
names(X_rbind) <- gsub("[-\\(\\)]", "", names(X_rbind))
# t, f -> timeDomain, freqDomain
names(X_rbind) <- sub("^t", "timeDomain", names(X_rbind))
names(X_rbind) <- sub("^f", "freqDomain", names(X_rbind))
# mean, std -> Mean, Std
names(X_rbind) <- sub("mean", "Mean", names(X_rbind))
names(X_rbind) <- sub("std", "Std", names(X_rbind))
names(X_rbind) <- sub("(Mean|Std)([XYZ])", "\\2\\1", names(X_rbind))

# as some feature names contains "BodyBody", replace it with "Body"
names(X_rbind) <- sub("BodyBody", "Body", names(X_rbind))


# True if feature label contains mean() or std() 
mean.or.std <- grepl("(mean|std)\\(\\)",features)
# filter
X_rbind.meanstd <- X_rbind[,mean.or.std, with=F]

# As we want only the measurements on the mean and standard deviation,
# inertial signals are not loaded.


Y_rbind <- rbind(
  fread(file.path(data.directory, "train", "y_train.txt"), header=F),
  fread(file.path(data.directory, "test",  "y_test.txt"),  header=F)
)
names(Y_rbind) <- "activity"

# read activity labels and update Y_rbind as factor
activity_labels <- fread(file.path(data.directory, "activity_labels.txt"), header=F)
activity_labels <- factor(activity_labels[[2]])
Y_rbind[,activity:=activity_labels[activity]]


subject_train <- fread(file.path(data.directory, "train", "subject_train.txt"), header=F)
subject_test  <- fread(file.path(data.directory, "test",  "subject_test.txt"),  header=F)

subject_rbind <- rbind(subject_train, subject_test)
names(subject_rbind) <- c("subject")

train_or_test <- data.table(
  trainOrTest = c(
    rep("train", nrow(subject_train)),
    rep("test",  nrow(subject_test))
  )
)

# concatenate x, y, and subject into one data table
dt <- data.table(X_rbind.meanstd, Y_rbind, subject_rbind, train_or_test)

write.csv(dt, "tidyData.csv", row.names=F)

# average of each variable for each activity and each subject
dt_avg <- (
  dt
  %>% select(-(trainOrTest)) # as we don't need to group by trainOrTest, remove the column
  %>% group_by(activity, subject)
  %>% summarize_each(funs(mean))
)

write.csv(dt_avg, "meanByActivityBySubject.csv", row.names=F)
