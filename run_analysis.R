#Getting and Cleaning Data - Course project

## Part One - Merging the datasets

test_data <- read.table('X_test.txt', sep="", head=F)
test_subjects <- read.table('subject_test.txt', head=F)
test_activities <- read.table('y_test.txt', head=F)

test_data <- cbind(test_data, test_subjects, test_activities)


training_data <- read.table('X_train.txt', sep="", head=F)
training_subjects <- read.table('subject_train.txt', head=F)
training_activities <- read.table('y_train.txt', head=F)

training_data <- cbind(training_data, training_subjects, training_activities)

#Merging the test and training data
data <- rbind(test_data, training_data)

#Labeling the columns (core)
column_labels <- read.table('features.txt', head=F)$V2
colnames(data) <- column_labels

#Labeling the columns (added)
names(data)[562] <- 'activity'
names(data)[563] <- 'subject'

## Part Two

data_means_and_devations <- data[, grepl('mean\\(\\)|std\\(\\)', names(data))]

## Part Three and Four

data_labelled <- data
activity_labels <- read.table('activity_labels.txt', head=F)$V2

for(i in 1:6){data_labelled$activity <- gsub(i, activity_labels[i], data_labelled$activity)}

## Part Five

#Data table being splitted according to subjects and activities, yielding 180 subsets
data_splitted <- split(data, list(data$activity, data$subject))
new_data_table = NULL

#Calculating the means for every column in each subset
for(i in 1:length(data_splitted)){
  new_data_table <- rbind(new_data_table, sapply(data.frame(data_splitted[i]), mean))
}
new_data_table <- data.frame(new_data_table)

#Assigning column names to the new table
colnames(new_data_table) <- column_labels
names(new_data_table)[562] <- 'subject'
names(new_data_table)[563] <- 'activity'

#Replacing the activity codes to descriptive names
for(i in 1:6){new_data_table$activity <- gsub(i, activity_labels[i], new_data_table$activity)}

#Setting activities and subjects to factors
new_data_table <- transform(new_data_table, activity=factor(activity))
new_data_table <- transform(new_data_table, subject=factor(subject))

write.csv(new_data_table, file='tidy.csv')
