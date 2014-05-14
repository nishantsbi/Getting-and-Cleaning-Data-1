# Getting and Cleaning Data - Course Project

## Introduction

This is my solution for the course project in the Coursera course entitled 'Getting and Cleaning Data'.
The project consists of 5 parts:

* Merging the training and the test sets to create one data set.
* Extracting only the measurements on the mean and standard deviation for each measurement.
* Using descriptive activity names to name the activities in the data set
* Appropriately labeling the data set with descriptive activity names.
* Creating a second, independent tidy data set with the average of each variable for each activity and each subject. 

## Part One - Merging the training and the test sets

There are 6 files containing data, and 1 for labeling the columns for this assignment.
These files are:

* X_test.txt and X_train.txt = The core data files
* subject_test.txt and subject_train.txt = The subjects of the experiment
* y_test and y_train = Activity codes
* features.txt = The file containing the column names for the core data file



```r
test_data <- read.table("X_test.txt", sep = "", head = F)
test_subjects <- read.table("subject_test.txt", head = F)
test_activities <- read.table("y_test.txt", head = F)

test_data <- cbind(test_data, test_subjects, test_activities)


training_data <- read.table("X_train.txt", sep = "", head = F)
training_subjects <- read.table("subject_train.txt", head = F)
training_activities <- read.table("y_train.txt", head = F)

training_data <- cbind(training_data, training_subjects, training_activities)

# Merging the test and training data
data <- rbind(test_data, training_data)

# Labeling the columns (core)
column_labels <- read.table("features.txt", head = F)$V2
colnames(data) <- column_labels

# Labeling the columns (added)
names(data)[562] <- "activity"
names(data)[563] <- "subject"
```


## Part Two - Extracting a subset which only stores the measurements on means and standard deviations

This assignment requires the extraction of those columns from the merged dataset that are storing either means or standard deviations.
Such columns have 'mean()' or 'std()' in their names, which can be used for the subsetting, as displayed below.


```r
data_means_and_devations <- data[, grepl("mean\\(\\)|std\\(\\)", names(data))]
```


## Part Three and Four - Substituting the activity codes with more descriptive labels

Appropriate labels are found in the 'activity_labels.txt' file. These can be used instead of the activity codes.


```r
data_labelled <- data
activity_labels <- read.table("activity_labels.txt", head = F)$V2

for (i in 1:6) {
    data_labelled$activity <- gsub(i, activity_labels[i], data_labelled$activity)
}
```


## Part Five - Creating a new tidy data table

The new, tidy data table should consist of 563 columns and 180 row. These 180 rows are the combinations of subjects (1-30) and activities (1-6). In my interpretation, the last two columns (subject and activity) should be factors.


```r
# Data table being splitted according to subjects and activities, yielding
# 180 subsets
data_splitted <- split(data, list(data$activity, data$subject))
new_data_table = NULL

# Calculating the means for every column in each subset
for (i in 1:length(data_splitted)) {
    new_data_table <- rbind(new_data_table, sapply(data.frame(data_splitted[i]), 
        mean))
}
new_data_table <- data.frame(new_data_table)

# Assigning column names to the new table
colnames(new_data_table) <- column_labels
names(new_data_table)[562] <- "subject"
names(new_data_table)[563] <- "activity"

# Replacing the activity codes to descriptive names
for (i in 1:6) {
    new_data_table$activity <- gsub(i, activity_labels[i], new_data_table$activity)
}

# Setting activities and subjects to factors
new_data_table <- transform(new_data_table, activity = factor(activity))
new_data_table <- transform(new_data_table, subject = factor(subject))
```

